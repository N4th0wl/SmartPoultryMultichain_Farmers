import api from './api';

export const adminService = {
    // ====== User Management ======

    // Get all users
    async getUsers(search = '') {
        const params = search ? { search } : {};
        const response = await api.get('/admin/users', { params });
        return response.data;
    },

    // Get single user
    async getUser(userId) {
        const response = await api.get(`/admin/users/${userId}`);
        return response.data;
    },

    // Create user
    async createUser(data) {
        const response = await api.post('/admin/users', data);
        return response.data;
    },

    // Update user
    async updateUser(userId, data) {
        const response = await api.put(`/admin/users/${userId}`, data);
        return response.data;
    },

    // Delete user
    async deleteUser(userId) {
        const response = await api.delete(`/admin/users/${userId}`);
        return response.data;
    },

    // ====== Blockchain Monitoring ======

    // Get blockchain overview (all farms)
    async getBlockchainOverview(search = '') {
        const params = search ? { search } : {};
        const response = await api.get('/admin/blockchain/overview', { params });
        return response.data;
    },

    // Get blocks for a cycle
    async getBlocks(cycleId) {
        const response = await api.get(`/admin/blockchain/blocks/${cycleId}`);
        return response.data;
    },

    // Validate chain
    async validateChain(cycleId) {
        const response = await api.get(`/admin/blockchain/validate/${cycleId}`);
        return response.data;
    }
};

export default adminService;
