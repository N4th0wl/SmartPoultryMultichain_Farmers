const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const { Login, Peternakan, LedgerPeternakan, BlockchainIdentity, Cycle, Kandang, DOC } = require('../models');
const { adminMiddleware } = require('../middleware/auth');
const { Op } = require('sequelize');

// All routes require admin authentication
router.use(adminMiddleware);

// ============================================
// USER MANAGEMENT
// ============================================

// GET /api/admin/users - Get all user accounts with peternakan info
router.get('/users', async (req, res) => {
    try {
        const { search } = req.query;

        const whereClause = { Role: 'user' };

        if (search) {
            whereClause[Op.or] = [
                { Email: { [Op.like]: `%${search}%` } }
            ];
        }

        const users = await Login.findAll({
            where: whereClause,
            include: [{ model: Peternakan }],
            attributes: { exclude: ['Password'] },
            order: [['UserID', 'DESC']]
        });

        // Also search by peternakan name/location if search query
        let filteredUsers = users;
        if (search) {
            const searchLower = search.toLowerCase();
            filteredUsers = users.filter(u =>
                u.Email.toLowerCase().includes(searchLower) ||
                (u.Peternakan?.NamaPeternakan || '').toLowerCase().includes(searchLower) ||
                (u.Peternakan?.LokasiPeternakan || '').toLowerCase().includes(searchLower)
            );
        }

        const result = filteredUsers.map(user => ({
            userId: user.UserID,
            email: user.Email,
            kodePeternakan: user.KodePeternakan,
            namaPeternakan: user.Peternakan?.NamaPeternakan || '-',
            lokasiPeternakan: user.Peternakan?.LokasiPeternakan || '-',
            role: user.Role,
            createdAt: user.createdAt
        }));

        res.json(result);
    } catch (error) {
        console.error('Get users error:', error);
        res.status(500).json({ error: 'Failed to fetch users' });
    }
});

// GET /api/admin/users/:id - Get single user
router.get('/users/:id', async (req, res) => {
    try {
        const user = await Login.findByPk(req.params.id, {
            include: [{ model: Peternakan }],
            attributes: { exclude: ['Password'] }
        });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json({
            userId: user.UserID,
            email: user.Email,
            kodePeternakan: user.KodePeternakan,
            namaPeternakan: user.Peternakan?.NamaPeternakan || '-',
            lokasiPeternakan: user.Peternakan?.LokasiPeternakan || '-',
            role: user.Role,
            createdAt: user.createdAt
        });
    } catch (error) {
        console.error('Get user error:', error);
        res.status(500).json({ error: 'Failed to fetch user' });
    }
});

// PUT /api/admin/users/:id - Update user account (email, farm name, farm location)
router.put('/users/:id', async (req, res) => {
    try {
        const { email, namaPeternakan, lokasiPeternakan } = req.body;

        const user = await Login.findByPk(req.params.id, {
            include: [{ model: Peternakan }]
        });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        // Check if new email conflicts with another user
        if (email && email !== user.Email) {
            const existingUser = await Login.findOne({ where: { Email: email, UserID: { [Op.ne]: user.UserID } } });
            if (existingUser) {
                return res.status(400).json({ error: 'Email sudah digunakan oleh akun lain' });
            }
            user.Email = email;
            await user.save();
        }

        // Update peternakan info
        if (user.Peternakan) {
            if (namaPeternakan) user.Peternakan.NamaPeternakan = namaPeternakan;
            if (lokasiPeternakan) user.Peternakan.LokasiPeternakan = lokasiPeternakan;
            await user.Peternakan.save();
        }

        res.json({
            message: 'User berhasil diperbarui',
            user: {
                userId: user.UserID,
                email: user.Email,
                kodePeternakan: user.KodePeternakan,
                namaPeternakan: user.Peternakan?.NamaPeternakan,
                lokasiPeternakan: user.Peternakan?.LokasiPeternakan,
                role: user.Role
            }
        });
    } catch (error) {
        console.error('Update user error:', error);
        res.status(500).json({ error: 'Gagal memperbarui user' });
    }
});

// DELETE /api/admin/users/:id - Delete user account and associated peternakan
router.delete('/users/:id', async (req, res) => {
    try {
        const user = await Login.findByPk(req.params.id);

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        if (user.Role === 'admin') {
            return res.status(403).json({ error: 'Tidak dapat menghapus akun admin' });
        }

        await user.destroy();

        res.json({ message: 'User berhasil dihapus' });
    } catch (error) {
        console.error('Delete user error:', error);
        res.status(500).json({ error: 'Gagal menghapus user' });
    }
});

// POST /api/admin/users - Create a new user account
router.post('/users', async (req, res) => {
    try {
        const { email, password, namaPeternakan, lokasiPeternakan } = req.body;

        if (!email || !password || !namaPeternakan || !lokasiPeternakan) {
            return res.status(400).json({ error: 'Semua field wajib diisi' });
        }

        // Check if email exists
        const existingUser = await Login.findOne({ where: { Email: email } });
        if (existingUser) {
            return res.status(400).json({ error: 'Email sudah terdaftar' });
        }

        // Create Peternakan
        const peternakan = await Peternakan.create({
            NamaPeternakan: namaPeternakan,
            LokasiPeternakan: lokasiPeternakan
        });

        // Hash password
        const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS) || 10;
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        // Create user
        const user = await Login.create({
            KodePeternakan: peternakan.KodePeternakan,
            Email: email,
            Password: hashedPassword,
            Role: 'user'
        });

        res.status(201).json({
            message: 'User berhasil dibuat',
            user: {
                userId: user.UserID,
                email: user.Email,
                kodePeternakan: user.KodePeternakan,
                namaPeternakan: peternakan.NamaPeternakan,
                lokasiPeternakan: peternakan.LokasiPeternakan,
                role: user.Role
            }
        });
    } catch (error) {
        console.error('Create user error:', error);
        res.status(500).json({ error: 'Gagal membuat user' });
    }
});

// ============================================
// BLOCKCHAIN MONITORING (Admin can see ALL blockchain data across all farms)
// ============================================

// GET /api/admin/blockchain/overview - Get blockchain overview across all farms
router.get('/blockchain/overview', async (req, res) => {
    try {
        const { search } = req.query;

        const allChains = await BlockchainIdentity.findAll({
            include: [
                { model: Peternakan },
                { model: Cycle }
            ],
            order: [['CreatedAt', 'DESC']]
        });

        // Filter by search if provided
        let filteredChains = allChains;
        if (search) {
            const searchLower = search.toLowerCase();
            filteredChains = allChains.filter(c =>
                (c.KodeIdentity || '').toLowerCase().includes(searchLower) ||
                (c.Peternakan?.NamaPeternakan || '').toLowerCase().includes(searchLower) ||
                (c.StatusChain || '').toLowerCase().includes(searchLower) ||
                String(c.KodeCycle).includes(searchLower)
            );
        }

        const totalBlocks = await LedgerPeternakan.count();
        const totalChains = allChains.length;
        const activeChains = allChains.filter(c => c.StatusChain === 'ACTIVE').length;
        const completedChains = allChains.filter(c => c.StatusChain === 'COMPLETED').length;
        const transferredChains = allChains.filter(c => c.StatusChain === 'TRANSFERRED').length;

        // Enrich chains with extra info
        const chainsData = await Promise.all(filteredChains.map(async (chain) => {
            const actualBlockCount = await LedgerPeternakan.count({
                where: { KodePeternakan: chain.KodePeternakan, KodeCycle: chain.KodeCycle }
            });

            // Get kandang info
            let kandangInfo = null;
            const kandang = await Kandang.findOne({ where: { KodeCycle: chain.KodeCycle } });
            if (kandang) {
                kandangInfo = kandang.KodeKandang;
                const doc = await DOC.findOne({ where: { KodeKandang: kandang.KodeKandang } });
                if (doc) {
                    kandangInfo = {
                        kodeKandang: kandang.KodeKandang,
                        brandDOC: doc.BrandDOC,
                        tipeAyam: doc.TipeAyam
                    };
                }
            }

            return {
                KodeIdentity: chain.KodeIdentity,
                KodePeternakan: chain.KodePeternakan,
                NamaPeternakan: chain.Peternakan?.NamaPeternakan || '-',
                KodeCycle: chain.KodeCycle,
                GenesisHash: chain.GenesisHash,
                LatestBlockHash: chain.LatestBlockHash,
                TotalBlocks: chain.TotalBlocks,
                ActualBlockCount: actualBlockCount,
                StatusChain: chain.StatusChain,
                CreatedAt: chain.CreatedAt,
                CompletedAt: chain.CompletedAt,
                TanggalMulai: chain.Cycle?.TanggalMulai,
                DurasiCycle: chain.Cycle?.DurasiCycle,
                KodeKandang: typeof kandangInfo === 'object' ? kandangInfo.kodeKandang : kandangInfo,
                BrandDOC: typeof kandangInfo === 'object' ? kandangInfo.brandDOC : null,
                TipeAyam: typeof kandangInfo === 'object' ? kandangInfo.tipeAyam : null,
            };
        }));

        res.json({
            totalChains,
            activeChains,
            completedChains,
            transferredChains,
            totalBlocks,
            chains: chainsData
        });
    } catch (error) {
        console.error('Admin blockchain overview error:', error);
        res.status(500).json({ error: 'Failed to fetch blockchain overview' });
    }
});

// GET /api/admin/blockchain/blocks/:cycleId - Get blocks for a specific cycle
router.get('/blockchain/blocks/:cycleId', async (req, res) => {
    try {
        const blocks = await LedgerPeternakan.findAll({
            where: { KodeCycle: req.params.cycleId },
            order: [['BlockIndex', 'ASC']]
        });

        res.json(blocks);
    } catch (error) {
        console.error('Admin get blocks error:', error);
        res.status(500).json({ error: 'Failed to fetch blocks' });
    }
});

// GET /api/admin/blockchain/validate/:cycleId - Validate chain integrity
router.get('/blockchain/validate/:cycleId', async (req, res) => {
    try {
        const blocks = await LedgerPeternakan.findAll({
            where: { KodeCycle: req.params.cycleId },
            order: [['BlockIndex', 'ASC']]
        });

        if (blocks.length === 0) {
            return res.json({ valid: false, message: 'No blocks found', totalBlocks: 0 });
        }

        // Validate hash chain
        for (let i = 1; i < blocks.length; i++) {
            if (blocks[i].PreviousHash !== blocks[i - 1].CurrentHash) {
                return res.json({
                    valid: false,
                    message: `Hash mismatch at block #${blocks[i].BlockIndex}`,
                    totalBlocks: blocks.length,
                    brokenAt: blocks[i].BlockIndex
                });
            }
        }

        res.json({
            valid: true,
            message: 'Chain integrity verified successfully',
            totalBlocks: blocks.length
        });
    } catch (error) {
        console.error('Admin validate chain error:', error);
        res.status(500).json({ error: 'Failed to validate chain' });
    }
});

module.exports = router;
