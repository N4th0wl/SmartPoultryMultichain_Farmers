-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 17, 2026 at 12:24 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smartpoultry_peternakan`
--

-- --------------------------------------------------------

--
-- Table structure for table `blockchainidentity`
--

CREATE TABLE `blockchainidentity` (
  `IdIdentity` int(11) NOT NULL,
  `KodeIdentity` varchar(25) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `KodeCycle` int(11) NOT NULL,
  `GenesisHash` varchar(64) NOT NULL,
  `LatestBlockHash` varchar(64) DEFAULT NULL,
  `TotalBlocks` int(11) DEFAULT 1,
  `StatusChain` enum('ACTIVE','COMPLETED','FAILED','TRANSFERRED') NOT NULL DEFAULT 'ACTIVE',
  `CreatedAt` datetime DEFAULT NULL,
  `CompletedAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `blockchainidentity`
--

INSERT INTO `blockchainidentity` (`IdIdentity`, `KodeIdentity`, `KodePeternakan`, `KodeCycle`, `GenesisHash`, `LatestBlockHash`, `TotalBlocks`, `StatusChain`, `CreatedAt`, `CompletedAt`) VALUES
(1, 'CHAIN-000001', 2, 1, '146853c90b869dd0028cae86c664695fb515f0fce3ee0d96a8f6a02944762375', 'bf2d33dcd0f69043abb638159f38445305b4916456a624f02bb02faa11fc8c4b', 9, 'COMPLETED', '2026-02-16 09:44:41', '2026-02-16 10:34:25');

-- --------------------------------------------------------

--
-- Table structure for table `codecounter`
--

CREATE TABLE `codecounter` (
  `EntityName` varchar(50) NOT NULL,
  `LastCounter` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `codecounter`
--

INSERT INTO `codecounter` (`EntityName`, `LastCounter`) VALUES
('DetailNotaPenerimaan', 3),
('DetailOrder', 3),
('DOC', 1),
('Kandang', 1),
('NotaPenerimaan', 1),
('NotaPengiriman', 0),
('Orders', 1),
('Panen', 2),
('PemakaianFeed', 1),
('PemakaianObat', 3),
('PemakaianPerlengkapan', 0),
('Pengiriman', 2),
('PengukuranAyam', 0),
('Performance', 0),
('Perlengkapan', 2),
('Staf', 1),
('StatusKandang', 2),
('StatusKematian', 1),
('Supplier', 1),
('TimKerja', 1),
('Warehouse', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cycle`
--

CREATE TABLE `cycle` (
  `KodeCycle` int(11) NOT NULL,
  `TanggalMulai` date NOT NULL,
  `DurasiCycle` int(11) NOT NULL CHECK (`DurasiCycle` > 0),
  `SisaHariPanen` int(11) NOT NULL CHECK (`SisaHariPanen` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cycle`
--

INSERT INTO `cycle` (`KodeCycle`, `TanggalMulai`, `DurasiCycle`, `SisaHariPanen`) VALUES
(1, '2026-02-16', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `detailfeed`
--

CREATE TABLE `detailfeed` (
  `KodeDetailFeed` int(11) NOT NULL,
  `KodePemakaianFeed` char(13) NOT NULL,
  `KodePerlengkapan` char(13) NOT NULL,
  `JumlahPakan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `detailfeed`
--

INSERT INTO `detailfeed` (`KodeDetailFeed`, `KodePemakaianFeed`, `KodePerlengkapan`, `JumlahPakan`) VALUES
(1, 'PFD-000000001', 'PER-000000001', 10);

-- --------------------------------------------------------

--
-- Table structure for table `detailnotapenerimaan`
--

CREATE TABLE `detailnotapenerimaan` (
  `KodeDetailNota` char(13) NOT NULL,
  `KodePenerimaan` char(13) NOT NULL,
  `JenisBarang` enum('DOC','PERLENGKAPAN') NOT NULL,
  `NamaBarang` varchar(100) NOT NULL,
  `Jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `detailnotapenerimaan`
--

INSERT INTO `detailnotapenerimaan` (`KodeDetailNota`, `KodePenerimaan`, `JenisBarang`, `NamaBarang`, `Jumlah`) VALUES
('DNP-000000001', 'NPR-000000001', 'DOC', 'Ayam Broiler', 100),
('DNP-000000002', 'NPR-000000001', 'PERLENGKAPAN', 'Pakan Starter', 100),
('DNP-000000003', 'NPR-000000001', 'PERLENGKAPAN', 'Obat', 10);

-- --------------------------------------------------------

--
-- Table structure for table `detailorder`
--

CREATE TABLE `detailorder` (
  `KodeDetailOrder` char(13) NOT NULL,
  `KodeOrder` char(13) NOT NULL,
  `JenisBarang` enum('DOC','PERLENGKAPAN') NOT NULL,
  `NamaBarang` varchar(255) DEFAULT NULL,
  `JumlahBarang` int(11) NOT NULL,
  `HargaSatuan` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `detailorder`
--

INSERT INTO `detailorder` (`KodeDetailOrder`, `KodeOrder`, `JenisBarang`, `NamaBarang`, `JumlahBarang`, `HargaSatuan`) VALUES
('DOR-000000001', 'ORD-000000001', 'DOC', 'Ayam Broiler', 100, '10000.00'),
('DOR-000000002', 'ORD-000000001', 'PERLENGKAPAN', 'Pakan Starter', 100, '5000.00'),
('DOR-000000003', 'ORD-000000001', 'PERLENGKAPAN', 'Obat', 10, '11998.00');

-- --------------------------------------------------------

--
-- Table structure for table `doc`
--

CREATE TABLE `doc` (
  `KodeDOC` char(13) NOT NULL,
  `KodePenerimaan` char(13) NOT NULL,
  `KodeKandang` char(13) DEFAULT NULL,
  `BrandDOC` varchar(55) DEFAULT NULL,
  `TipeAyam` varchar(55) DEFAULT NULL,
  `TanggalMasukKandang` date DEFAULT NULL,
  `JumlahDipesan` int(11) NOT NULL,
  `JumlahDiterima` int(11) NOT NULL,
  `JumlahMatiPraKandang` int(11) DEFAULT 0,
  `KondisiAwal` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `doc`
--

INSERT INTO `doc` (`KodeDOC`, `KodePenerimaan`, `KodeKandang`, `BrandDOC`, `TipeAyam`, `TanggalMasukKandang`, `JumlahDipesan`, `JumlahDiterima`, `JumlahMatiPraKandang`, `KondisiAwal`) VALUES
('DOC-000000001', 'NPR-000000001', 'KDG-000000001', 'Ayam Broiler', 'Broiler', '2026-02-16', 100, 90, 10, 'BAIK');

-- --------------------------------------------------------

--
-- Table structure for table `kandang`
--

CREATE TABLE `kandang` (
  `KodeKandang` char(13) NOT NULL,
  `KodeCycle` int(11) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `KodeTim` char(13) NOT NULL,
  `PanjangKandang` float DEFAULT NULL,
  `LebarKandang` float DEFAULT NULL,
  `LantaiKandang` varchar(20) DEFAULT NULL,
  `Kepadatan` float DEFAULT NULL,
  `SuhuKandang` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kandang`
--

INSERT INTO `kandang` (`KodeKandang`, `KodeCycle`, `KodePeternakan`, `KodeTim`, `PanjangKandang`, `LebarKandang`, `LantaiKandang`, `Kepadatan`, `SuhuKandang`) VALUES
('KDG-000000001', 1, 2, 'TIM-000000001', 10, 10, 'Sekam', 0.9, 28);

-- --------------------------------------------------------

--
-- Table structure for table `ledger_peternakan`
--

CREATE TABLE `ledger_peternakan` (
  `IdBlock` int(11) NOT NULL,
  `KodeBlock` varchar(25) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `KodeCycle` int(11) DEFAULT NULL,
  `KodeKandang` char(13) DEFAULT NULL,
  `TipeBlock` enum('GENESIS','KANDANG_AKTIF','DOC_MASUK','LAPORAN_MORTALITY','PEMAKAIAN_OBAT','PANEN','PANEN_DINI','GAGAL_PANEN','TRANSFER_PROCESSOR') NOT NULL,
  `BlockIndex` int(11) NOT NULL DEFAULT 0,
  `PreviousHash` varchar(64) NOT NULL,
  `CurrentHash` varchar(64) NOT NULL,
  `DataPayload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`DataPayload`)),
  `Nonce` int(11) DEFAULT 0,
  `StatusBlock` enum('VALIDATED','REJECTED') NOT NULL DEFAULT 'VALIDATED',
  `CreatedAt` datetime DEFAULT NULL,
  `ValidatedAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ledger_peternakan`
--

INSERT INTO `ledger_peternakan` (`IdBlock`, `KodeBlock`, `KodePeternakan`, `KodeCycle`, `KodeKandang`, `TipeBlock`, `BlockIndex`, `PreviousHash`, `CurrentHash`, `DataPayload`, `Nonce`, `StatusBlock`, `CreatedAt`, `ValidatedAt`) VALUES
(1, 'BLK-1-0000', 2, 1, NULL, 'GENESIS', 0, '0000000000000000000000000000000000000000000000000000000000000000', '76d40faa5d9832d403bec3a9ac2bf1e4cd9b49c5fa9b34854cbb0c758bffd873', '{\"event\":\"GENESIS\",\"node\":\"NODE_PETERNAKAN\",\"cycle_id\":1,\"tanggal_mulai\":\"2026-02-16\",\"durasi_cycle\":1,\"sisa_hari_panen\":1}', 0, 'VALIDATED', '2026-02-16 09:44:41', '2026-02-16 09:44:41'),
(2, 'BLK-1-0001', 2, 1, 'KDG-000000001', 'KANDANG_AKTIF', 1, '76d40faa5d9832d403bec3a9ac2bf1e4cd9b49c5fa9b34854cbb0c758bffd873', '2b44a1c467be2741cf5b7801ff1c903f1ef7d3471ae083587ce9cbcb537ec0dc', '{\"event\":\"KANDANG_AKTIF\",\"node\":\"NODE_PETERNAKAN\",\"kode_kandang\":\"KDG-000000001\",\"kode_tim\":\"TIM-000000001\",\"panjang\":10,\"lebar\":10,\"lantai\":\"Sekam\",\"kepadatan\":0.9,\"suhu\":28}', 0, 'VALIDATED', '2026-02-16 09:44:41', '2026-02-16 09:44:41'),
(3, 'BLK-1-0002', 2, 1, 'KDG-000000001', 'DOC_MASUK', 2, '2b44a1c467be2741cf5b7801ff1c903f1ef7d3471ae083587ce9cbcb537ec0dc', '7118fb48c0fade9e01101f3ff108b92470ac15d635ae497c2a6c4ec91faf8abc', '{\"event\":\"DOC_MASUK\",\"node\":\"NODE_PETERNAKAN\",\"kode_doc\":\"DOC-000000001\",\"kode_kandang\":\"KDG-000000001\",\"brand_doc\":\"Ayam Broiler\",\"tipe_ayam\":\"Broiler\",\"tanggal_masuk\":\"2026-02-16\",\"jumlah_dipesan\":100,\"jumlah_diterima\":90,\"jumlah_mati_pra_kandang\":10,\"kondisi_awal\":\"BAIK\"}', 0, 'VALIDATED', '2026-02-16 09:44:41', '2026-02-16 09:44:41'),
(4, 'BLK-1-0003', 2, 1, 'KDG-000000001', 'PEMAKAIAN_OBAT', 3, '7118fb48c0fade9e01101f3ff108b92470ac15d635ae497c2a6c4ec91faf8abc', '4d2306b1aa37b1f775978e29c55159150d837c16d4ca07205bfbf70a638e6100', '{\"event\":\"PEMAKAIAN_OBAT\",\"node\":\"NODE_PETERNAKAN\",\"kode_pemakaian_obat\":\"POB-000000001\",\"kode_kandang\":\"KDG-000000001\",\"kode_perlengkapan\":\"PER-000000002\",\"jenis_obat\":null,\"dosis\":null,\"jumlah_obat\":2,\"tanggal_penggunaan\":\"2026-02-16\",\"mortality_rate_at_usage\":0}', 0, 'VALIDATED', '2026-02-16 09:46:18', '2026-02-16 09:46:18'),
(5, 'BLK-1-0004', 2, 1, 'KDG-000000001', 'LAPORAN_MORTALITY', 4, '4d2306b1aa37b1f775978e29c55159150d837c16d4ca07205bfbf70a638e6100', '06cba99e342c2adc5574b3bc151aa6bd83b2cc9c2319dfeda395672bf67e4a80', '{\"event\":\"LAPORAN_MORTALITY\",\"node\":\"NODE_PETERNAKAN\",\"kode_status_kematian\":\"SMT-000000001\",\"kode_kandang\":\"KDG-000000001\",\"tanggal_kejadian\":\"2026-02-16\",\"jumlah_mati\":\"5\",\"jumlah_reject\":\"5\",\"keterangan\":\"Suhu yang tidak sesuai\",\"mortality_rate_percent\":5.56,\"threshold_exceeded\":false}', 0, 'VALIDATED', '2026-02-16 09:46:45', '2026-02-16 09:46:45'),
(6, 'BLK-1-0005', 2, 1, 'KDG-000000001', 'PEMAKAIAN_OBAT', 5, '06cba99e342c2adc5574b3bc151aa6bd83b2cc9c2319dfeda395672bf67e4a80', '3d5b066ec56e433f7d497072c9ffecf176cb9f461b2a2fd24494de4859a5b809', '{\"event\":\"PEMAKAIAN_OBAT\",\"node\":\"NODE_PETERNAKAN\",\"kode_pemakaian_obat\":\"POB-000000002\",\"kode_kandang\":\"KDG-000000001\",\"kode_perlengkapan\":\"PER-000000002\",\"jenis_obat\":null,\"dosis\":null,\"jumlah_obat\":\"2\",\"tanggal_penggunaan\":\"2026-02-16\",\"mortality_rate_at_usage\":5.56}', 0, 'VALIDATED', '2026-02-16 09:54:41', '2026-02-16 09:54:41'),
(7, 'BLK-1-0006', 2, 1, 'KDG-000000001', 'PEMAKAIAN_OBAT', 6, '3d5b066ec56e433f7d497072c9ffecf176cb9f461b2a2fd24494de4859a5b809', 'b3151b3496416a639682e1aaa689638742eed4e8626fb546eb73f944372b7d19', '{\"event\":\"PEMAKAIAN_OBAT\",\"node\":\"NODE_PETERNAKAN\",\"kode_pemakaian_obat\":\"POB-000000003\",\"kode_kandang\":\"KDG-000000001\",\"kode_perlengkapan\":\"PER-000000002\",\"jenis_obat\":null,\"dosis\":null,\"jumlah_obat\":2,\"tanggal_penggunaan\":\"2026-02-16\",\"mortality_rate_at_usage\":5.56}', 0, 'VALIDATED', '2026-02-16 10:09:02', '2026-02-16 10:09:02'),
(8, 'BLK-1-0007', 2, 1, 'KDG-000000001', 'PANEN_DINI', 7, 'b3151b3496416a639682e1aaa689638742eed4e8626fb546eb73f944372b7d19', 'cdbbce18731cf47bb2493fe2f92c141e7afd2c4a8ca1a42349a88a8b1184f9ae', '{\"event\":\"PANEN_DINI\",\"node\":\"NODE_PETERNAKAN\",\"kode_panen\":\"PAN-000000001\",\"kode_kandang\":\"KDG-000000001\",\"tanggal_panen\":\"2026-02-16\",\"total_berat_kg\":\"85\",\"total_harga\":\"25000000\",\"mortality_rate_final\":5.56,\"obat_digunakan\":true,\"durasi_aktual_hari\":0,\"durasi_target_hari\":1}', 0, 'VALIDATED', '2026-02-16 10:24:08', '2026-02-16 10:24:08'),
(9, 'BLK-1-0008', 2, 1, 'KDG-000000001', 'PANEN_DINI', 8, 'cdbbce18731cf47bb2493fe2f92c141e7afd2c4a8ca1a42349a88a8b1184f9ae', 'bf2d33dcd0f69043abb638159f38445305b4916456a624f02bb02faa11fc8c4b', '{\"event\":\"PANEN_DINI\",\"node\":\"NODE_PETERNAKAN\",\"kode_panen\":\"PAN-000000002\",\"kode_kandang\":\"KDG-000000001\",\"tanggal_panen\":\"2026-02-16\",\"total_berat_kg\":\"1000\",\"total_harga\":\"25000000\",\"mortality_rate_final\":5.56,\"obat_digunakan\":true,\"durasi_aktual_hari\":0,\"durasi_target_hari\":1}', 0, 'VALIDATED', '2026-02-16 10:34:25', '2026-02-16 10:34:25');

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `UserID` int(11) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Role` enum('admin','user') NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`UserID`, `KodePeternakan`, `Email`, `Password`, `Role`) VALUES
(1, 1, 'admin@smartpoultry.id', '$2b$10$y40eOKVnOiM7W/2ySPxF6.8Giet/7ebZd4G35FMNork.kRHboBSmG', 'admin'),
(2, 2, 'ivandernathanaelk@gmail.com', '$2b$10$gssuM8XKLufEHbvJanMFr.JtwM/8DO6iEHKPJqkkUOo4.Hcp/Ng.C', 'user');

-- --------------------------------------------------------

--
-- Table structure for table `masterobat`
--

CREATE TABLE `masterobat` (
  `KodePerlengkapan` char(13) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `JenisObat` varchar(100) NOT NULL,
  `Dosis` varchar(100) NOT NULL,
  `TanggalKadaluarsa` date NOT NULL,
  `HargaObat` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `notapenerimaan`
--

CREATE TABLE `notapenerimaan` (
  `KodePenerimaan` char(13) NOT NULL,
  `KodeOrder` char(13) NOT NULL,
  `TanggalPenerimaan` date NOT NULL,
  `NamaPenerima` char(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `notapenerimaan`
--

INSERT INTO `notapenerimaan` (`KodePenerimaan`, `KodeOrder`, `TanggalPenerimaan`, `NamaPenerima`) VALUES
('NPR-000000001', 'ORD-000000001', '2026-02-16', 'Ivan');

-- --------------------------------------------------------

--
-- Table structure for table `notapengiriman`
--

CREATE TABLE `notapengiriman` (
  `KodeNotaPengiriman` char(13) NOT NULL,
  `KodePengiriman` char(13) NOT NULL,
  `TanggalPenerimaan` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `KodeOrder` char(13) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `KodeSupplier` char(13) NOT NULL,
  `TanggalOrder` date NOT NULL,
  `StatusOrder` enum('PROSES','SUDAH DITERIMA') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`KodeOrder`, `KodePeternakan`, `KodeSupplier`, `TanggalOrder`, `StatusOrder`) VALUES
('ORD-000000001', 2, 'SUP-000000001', '2026-02-16', 'SUDAH DITERIMA');

-- --------------------------------------------------------

--
-- Table structure for table `panen`
--

CREATE TABLE `panen` (
  `KodePanen` char(13) NOT NULL,
  `KodeKandang` char(13) NOT NULL,
  `TanggalPanen` date NOT NULL,
  `TotalBerat` float DEFAULT NULL,
  `TotalHarga` decimal(14,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `panen`
--

INSERT INTO `panen` (`KodePanen`, `KodeKandang`, `TanggalPanen`, `TotalBerat`, `TotalHarga`) VALUES
('PAN-000000002', 'KDG-000000001', '2026-02-16', 1000, '25000000.00');

-- --------------------------------------------------------

--
-- Table structure for table `pemakaianfeed`
--

CREATE TABLE `pemakaianfeed` (
  `KodePemakaianFeed` char(13) NOT NULL,
  `KodeKandang` char(13) NOT NULL,
  `TanggalPemakaian` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pemakaianfeed`
--

INSERT INTO `pemakaianfeed` (`KodePemakaianFeed`, `KodeKandang`, `TanggalPemakaian`) VALUES
('PFD-000000001', 'KDG-000000001', '2026-02-16');

-- --------------------------------------------------------

--
-- Table structure for table `pemakaianobat`
--

CREATE TABLE `pemakaianobat` (
  `KodePemakaianObat` char(13) NOT NULL,
  `KodePerlengkapan` char(13) NOT NULL,
  `KodeKandang` char(13) NOT NULL,
  `TanggalPenggunaan` date NOT NULL,
  `JumlahObat` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pemakaianobat`
--

INSERT INTO `pemakaianobat` (`KodePemakaianObat`, `KodePerlengkapan`, `KodeKandang`, `TanggalPenggunaan`, `JumlahObat`) VALUES
('POB-000000001', 'PER-000000002', 'KDG-000000001', '2026-02-16', 2),
('POB-000000002', 'PER-000000002', 'KDG-000000001', '2026-02-16', 2),
('POB-000000003', 'PER-000000002', 'KDG-000000001', '2026-02-16', 2);

-- --------------------------------------------------------

--
-- Table structure for table `pemakaianperlengkapan`
--

CREATE TABLE `pemakaianperlengkapan` (
  `KodePemakaian` char(13) NOT NULL,
  `KodePerlengkapan` char(13) NOT NULL,
  `KodeKandang` char(13) NOT NULL,
  `TanggalPemakaian` date NOT NULL,
  `JumlahPemakaian` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pengiriman`
--

CREATE TABLE `pengiriman` (
  `KodePengiriman` char(13) NOT NULL,
  `KodePanen` char(13) NOT NULL,
  `KodeKandang` char(13) NOT NULL,
  `KodeStaf` char(13) NOT NULL,
  `TanggalPengiriman` date NOT NULL,
  `NamaPerusahaanPengiriman` varchar(50) DEFAULT NULL,
  `AlamatTujuan` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pengiriman`
--

INSERT INTO `pengiriman` (`KodePengiriman`, `KodePanen`, `KodeKandang`, `KodeStaf`, `TanggalPengiriman`, `NamaPerusahaanPengiriman`, `AlamatTujuan`) VALUES
('PNG-000000002', 'PAN-000000002', 'KDG-000000001', 'STF-000000001', '2026-02-16', 'Japfa', 'Jakarta Barat');

-- --------------------------------------------------------

--
-- Table structure for table `pengukuranayam`
--

CREATE TABLE `pengukuranayam` (
  `KodePengukuran` char(13) NOT NULL,
  `KodeKandang` char(13) NOT NULL,
  `TanggalPengukuran` date NOT NULL,
  `BeratAyam` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `performance`
--

CREATE TABLE `performance` (
  `KodePerformance` char(13) NOT NULL,
  `KodeKandang` char(13) NOT NULL,
  `TanggalPerformance` date NOT NULL,
  `ActualAverageDailyGain` float DEFAULT NULL,
  `ActualFeedIntake` float DEFAULT NULL,
  `ActualWaterIntake` float DEFAULT NULL,
  `KeteranganPerformance` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `perlengkapan`
--

CREATE TABLE `perlengkapan` (
  `KodePerlengkapan` char(13) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `NamaPerlengkapan` varchar(100) NOT NULL,
  `KategoriPerlengkapan` enum('PAKAN','PERALATAN','OBAT') NOT NULL,
  `Satuan` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `perlengkapan`
--

INSERT INTO `perlengkapan` (`KodePerlengkapan`, `KodePeternakan`, `NamaPerlengkapan`, `KategoriPerlengkapan`, `Satuan`) VALUES
('PER-000000001', 2, 'Pakan Starter', 'PAKAN', 'kg'),
('PER-000000002', 2, 'Obat', 'OBAT', 'Piece');

-- --------------------------------------------------------

--
-- Table structure for table `peternakan`
--

CREATE TABLE `peternakan` (
  `KodePeternakan` int(11) NOT NULL,
  `NamaPeternakan` varchar(255) NOT NULL,
  `LokasiPeternakan` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `peternakan`
--

INSERT INTO `peternakan` (`KodePeternakan`, `NamaPeternakan`, `LokasiPeternakan`) VALUES
(1, 'SmartPoultry Admin', 'Bandung'),
(2, 'Peternakan Ivan', 'Gading Serpong');

-- --------------------------------------------------------

--
-- Table structure for table `staf`
--

CREATE TABLE `staf` (
  `KodeStaf` char(13) NOT NULL,
  `KodeTim` char(13) NOT NULL,
  `NamaStaf` varchar(255) DEFAULT NULL,
  `PosisiStaf` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `staf`
--

INSERT INTO `staf` (`KodeStaf`, `KodeTim`, `NamaStaf`, `PosisiStaf`) VALUES
('STF-000000001', 'TIM-000000001', 'Ivan', 'Owner');

-- --------------------------------------------------------

--
-- Table structure for table `statuskandang`
--

CREATE TABLE `statuskandang` (
  `KodeStatus` char(13) NOT NULL,
  `KodeKandang` char(13) NOT NULL,
  `UmurAyam` int(11) DEFAULT NULL,
  `Populasi` int(11) DEFAULT NULL,
  `BeratRataRata` float DEFAULT NULL,
  `TanggalPemeriksaan` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `statuskandang`
--

INSERT INTO `statuskandang` (`KodeStatus`, `KodeKandang`, `UmurAyam`, `Populasi`, `BeratRataRata`, `TanggalPemeriksaan`) VALUES
('STS-000000001', 'KDG-000000001', 0, 80, 40, '2026-02-16'),
('STS-000000002', 'KDG-000000001', 1, 85, 1000, '2026-02-17');

-- --------------------------------------------------------

--
-- Table structure for table `statuskematian`
--

CREATE TABLE `statuskematian` (
  `KodeStatusKematian` char(13) NOT NULL,
  `KodeKandang` char(13) NOT NULL,
  `TanggalKejadian` date NOT NULL,
  `JumlahMati` int(11) DEFAULT NULL,
  `JumlahReject` int(11) DEFAULT NULL,
  `BuktiKematian` blob DEFAULT NULL,
  `Keterangan` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `statuskematian`
--

INSERT INTO `statuskematian` (`KodeStatusKematian`, `KodeKandang`, `TanggalKejadian`, `JumlahMati`, `JumlahReject`, `BuktiKematian`, `Keterangan`) VALUES
('SMT-000000001', 'KDG-000000001', '2026-02-16', 5, 5, NULL, 'Suhu yang tidak sesuai');

-- --------------------------------------------------------

--
-- Table structure for table `stokwarehouse`
--

CREATE TABLE `stokwarehouse` (
  `KodeWarehouse` char(13) NOT NULL,
  `KodePerlengkapan` char(13) NOT NULL,
  `Jumlah` int(11) NOT NULL,
  `TanggalMasukPerlengkapan` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stokwarehouse`
--

INSERT INTO `stokwarehouse` (`KodeWarehouse`, `KodePerlengkapan`, `Jumlah`, `TanggalMasukPerlengkapan`) VALUES
('WRH-000000001', 'PER-000000001', 90, '2026-02-16'),
('WRH-000000001', 'PER-000000002', 4, '2026-02-16');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `KodeSupplier` char(13) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `NamaSupplier` varchar(100) NOT NULL,
  `KontakSupplier` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`KodeSupplier`, `KodePeternakan`, `NamaSupplier`, `KontakSupplier`) VALUES
('SUP-000000001', 2, 'AyamCerdas', '081111111111');

-- --------------------------------------------------------

--
-- Table structure for table `timkerja`
--

CREATE TABLE `timkerja` (
  `KodeTim` char(13) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `NamaTim` varchar(255) DEFAULT NULL,
  `JumlahAnggota` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `timkerja`
--

INSERT INTO `timkerja` (`KodeTim`, `KodePeternakan`, `NamaTim`, `JumlahAnggota`) VALUES
('TIM-000000001', 2, 'Tim Kandang A', 1);

-- --------------------------------------------------------

--
-- Table structure for table `todo`
--

CREATE TABLE `todo` (
  `IdToDo` int(11) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `Judul` varchar(255) NOT NULL,
  `Deskripsi` text DEFAULT NULL,
  `IsCompleted` tinyint(1) DEFAULT 0,
  `Prioritas` enum('Low','Medium','High') DEFAULT 'Medium',
  `TenggatWaktu` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `todos`
--

CREATE TABLE `todos` (
  `IdToDo` int(11) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `Judul` varchar(255) NOT NULL,
  `Deskripsi` text DEFAULT NULL,
  `IsCompleted` tinyint(1) DEFAULT 0,
  `Prioritas` enum('Low','Medium','High') DEFAULT 'Medium',
  `TenggatWaktu` date DEFAULT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_dashboard_summary`
-- (See below for the actual view)
--
CREATE TABLE `vw_dashboard_summary` (
`KodePeternakan` int(11)
,`TotalKandang` bigint(21)
,`TotalPopulasi` decimal(32,0)
,`AvgSuhu` double(18,1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_feed_usage_daily`
-- (See below for the actual view)
--
CREATE TABLE `vw_feed_usage_daily` (
`KodeKandang` char(13)
,`KodePeternakan` int(11)
,`TanggalPemakaian` date
,`TotalPakan` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_harvest_estimate`
-- (See below for the actual view)
--
CREATE TABLE `vw_harvest_estimate` (
`KodeKandang` char(13)
,`KodePeternakan` int(11)
,`KodeCycle` int(11)
,`TanggalMulai` date
,`DurasiCycle` int(11)
,`SisaHariPanen` int(11)
,`EstimatedHarvestDate` date
,`CurrentPopulasi` int(11)
,`EstimatedWeight` double
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_kandang_status`
-- (See below for the actual view)
--
CREATE TABLE `vw_kandang_status` (
`KodeKandang` char(13)
,`KodePeternakan` int(11)
,`KodeCycle` int(11)
,`Populasi` int(11)
,`UmurAyam` int(11)
,`BeratRataRata` double
,`TanggalPemeriksaan` date
,`SuhuKandang` float
,`Status` varchar(12)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_mortality_kpi`
-- (See below for the actual view)
--
CREATE TABLE `vw_mortality_kpi` (
`KodeKandang` char(13)
,`KodePeternakan` int(11)
,`TotalMati` decimal(32,0)
,`TotalReject` decimal(32,0)
,`LastMortalityDate` date
,`InitialPopulasi` int(11)
,`MortalityRate` decimal(38,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_performance_summary`
-- (See below for the actual view)
--
CREATE TABLE `vw_performance_summary` (
`KodeKandang` char(13)
,`KodePeternakan` int(11)
,`AvgADG` double(19,2)
,`AvgFeedIntake` double(19,2)
,`AvgWaterIntake` double(19,2)
,`LastRecordDate` date
);

-- --------------------------------------------------------

--
-- Table structure for table `warehouse`
--

CREATE TABLE `warehouse` (
  `KodeWarehouse` char(13) NOT NULL,
  `KodePeternakan` int(11) NOT NULL,
  `LokasiWarehouse` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `warehouse`
--

INSERT INTO `warehouse` (`KodeWarehouse`, `KodePeternakan`, `LokasiWarehouse`) VALUES
('WRH-000000001', 2, 'Warehouse Utama');

-- --------------------------------------------------------

--
-- Structure for view `vw_dashboard_summary`
--
DROP TABLE IF EXISTS `vw_dashboard_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_dashboard_summary`  AS SELECT `k`.`KodePeternakan` AS `KodePeternakan`, count(distinct `k`.`KodeKandang`) AS `TotalKandang`, coalesce(sum(`lateststatus`.`Populasi`),0) AS `TotalPopulasi`, round(avg(`k`.`SuhuKandang`),1) AS `AvgSuhu` FROM (`kandang` `k` left join (select `sk`.`KodeKandang` AS `KodeKandang`,`sk`.`Populasi` AS `Populasi` from (`statuskandang` `sk` join (select `statuskandang`.`KodeKandang` AS `KodeKandang`,max(`statuskandang`.`TanggalPemeriksaan`) AS `MaxDate` from `statuskandang` group by `statuskandang`.`KodeKandang`) `latest` on(`sk`.`KodeKandang` = `latest`.`KodeKandang` and `sk`.`TanggalPemeriksaan` = `latest`.`MaxDate`))) `lateststatus` on(`k`.`KodeKandang` = `lateststatus`.`KodeKandang`)) GROUP BY `k`.`KodePeternakan``KodePeternakan`  ;

-- --------------------------------------------------------

--
-- Structure for view `vw_feed_usage_daily`
--
DROP TABLE IF EXISTS `vw_feed_usage_daily`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_feed_usage_daily`  AS SELECT `pf`.`KodeKandang` AS `KodeKandang`, `k`.`KodePeternakan` AS `KodePeternakan`, `pf`.`TanggalPemakaian` AS `TanggalPemakaian`, sum(`df`.`JumlahPakan`) AS `TotalPakan` FROM ((`pemakaianfeed` `pf` join `detailfeed` `df` on(`pf`.`KodePemakaianFeed` = `df`.`KodePemakaianFeed`)) join `kandang` `k` on(`pf`.`KodeKandang` = `k`.`KodeKandang`)) GROUP BY `pf`.`KodeKandang`, `k`.`KodePeternakan`, `pf`.`TanggalPemakaian``TanggalPemakaian`  ;

-- --------------------------------------------------------

--
-- Structure for view `vw_harvest_estimate`
--
DROP TABLE IF EXISTS `vw_harvest_estimate`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_harvest_estimate`  AS SELECT `k`.`KodeKandang` AS `KodeKandang`, `k`.`KodePeternakan` AS `KodePeternakan`, `c`.`KodeCycle` AS `KodeCycle`, `c`.`TanggalMulai` AS `TanggalMulai`, `c`.`DurasiCycle` AS `DurasiCycle`, `c`.`SisaHariPanen` AS `SisaHariPanen`, `c`.`TanggalMulai`+ interval `c`.`DurasiCycle` day AS `EstimatedHarvestDate`, coalesce(`vs`.`Populasi`,0) AS `CurrentPopulasi`, coalesce(`vs`.`BeratRataRata`,0) AS `EstimatedWeight` FROM ((`kandang` `k` join `cycle` `c` on(`k`.`KodeCycle` = `c`.`KodeCycle`)) left join `vw_kandang_status` `vs` on(`k`.`KodeKandang` = `vs`.`KodeKandang`))  ;

-- --------------------------------------------------------

--
-- Structure for view `vw_kandang_status`
--
DROP TABLE IF EXISTS `vw_kandang_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_kandang_status`  AS SELECT `k`.`KodeKandang` AS `KodeKandang`, `k`.`KodePeternakan` AS `KodePeternakan`, `k`.`KodeCycle` AS `KodeCycle`, coalesce(`sk`.`Populasi`,0) AS `Populasi`, coalesce(`sk`.`UmurAyam`,0) AS `UmurAyam`, coalesce(`sk`.`BeratRataRata`,0) AS `BeratRataRata`, `sk`.`TanggalPemeriksaan` AS `TanggalPemeriksaan`, `k`.`SuhuKandang` AS `SuhuKandang`, CASE WHEN `sk`.`Populasi` is null THEN 'Persiapan' WHEN `k`.`SuhuKandang` > 32 OR `k`.`SuhuKandang` < 26 THEN 'Perlu Pantau' ELSE 'Stabil' END AS `Status` FROM (`kandang` `k` left join `statuskandang` `sk` on(`k`.`KodeKandang` = `sk`.`KodeKandang` and `sk`.`TanggalPemeriksaan` = (select max(`statuskandang`.`TanggalPemeriksaan`) from `statuskandang` where `statuskandang`.`KodeKandang` = `k`.`KodeKandang`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `vw_mortality_kpi`
--
DROP TABLE IF EXISTS `vw_mortality_kpi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mortality_kpi`  AS SELECT `sm`.`KodeKandang` AS `KodeKandang`, `k`.`KodePeternakan` AS `KodePeternakan`, sum(`sm`.`JumlahMati`) AS `TotalMati`, sum(`sm`.`JumlahReject`) AS `TotalReject`, max(`sm`.`TanggalKejadian`) AS `LastMortalityDate`, coalesce(`doc`.`JumlahDiterima`,0) AS `InitialPopulasi`, round(sum(`sm`.`JumlahMati`) / nullif(`doc`.`JumlahDiterima`,0) * 100,2) AS `MortalityRate` FROM ((`statuskematian` `sm` join `kandang` `k` on(`sm`.`KodeKandang` = `k`.`KodeKandang`)) left join `doc` on(`doc`.`KodeKandang` = `k`.`KodeKandang`)) GROUP BY `sm`.`KodeKandang`, `k`.`KodePeternakan`, `doc`.`JumlahDiterima``JumlahDiterima`  ;

-- --------------------------------------------------------

--
-- Structure for view `vw_performance_summary`
--
DROP TABLE IF EXISTS `vw_performance_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_performance_summary`  AS SELECT `p`.`KodeKandang` AS `KodeKandang`, `k`.`KodePeternakan` AS `KodePeternakan`, round(avg(`p`.`ActualAverageDailyGain`),2) AS `AvgADG`, round(avg(`p`.`ActualFeedIntake`),2) AS `AvgFeedIntake`, round(avg(`p`.`ActualWaterIntake`),2) AS `AvgWaterIntake`, max(`p`.`TanggalPerformance`) AS `LastRecordDate` FROM (`performance` `p` join `kandang` `k` on(`p`.`KodeKandang` = `k`.`KodeKandang`)) GROUP BY `p`.`KodeKandang`, `k`.`KodePeternakan``KodePeternakan`  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blockchainidentity`
--
ALTER TABLE `blockchainidentity`
  ADD PRIMARY KEY (`IdIdentity`),
  ADD UNIQUE KEY `KodeIdentity` (`KodeIdentity`),
  ADD KEY `KodePeternakan` (`KodePeternakan`),
  ADD KEY `KodeCycle` (`KodeCycle`);

--
-- Indexes for table `codecounter`
--
ALTER TABLE `codecounter`
  ADD PRIMARY KEY (`EntityName`);

--
-- Indexes for table `cycle`
--
ALTER TABLE `cycle`
  ADD PRIMARY KEY (`KodeCycle`);

--
-- Indexes for table `detailfeed`
--
ALTER TABLE `detailfeed`
  ADD PRIMARY KEY (`KodeDetailFeed`),
  ADD KEY `idx_detailfeed_pemakaian` (`KodePemakaianFeed`),
  ADD KEY `idx_detailfeed_perlengkapan` (`KodePerlengkapan`);

--
-- Indexes for table `detailnotapenerimaan`
--
ALTER TABLE `detailnotapenerimaan`
  ADD PRIMARY KEY (`KodeDetailNota`),
  ADD KEY `KodePenerimaan` (`KodePenerimaan`);

--
-- Indexes for table `detailorder`
--
ALTER TABLE `detailorder`
  ADD PRIMARY KEY (`KodeDetailOrder`),
  ADD KEY `idx_detail_order` (`KodeOrder`);

--
-- Indexes for table `doc`
--
ALTER TABLE `doc`
  ADD PRIMARY KEY (`KodeDOC`),
  ADD KEY `KodePenerimaan` (`KodePenerimaan`),
  ADD KEY `KodeKandang` (`KodeKandang`);

--
-- Indexes for table `kandang`
--
ALTER TABLE `kandang`
  ADD PRIMARY KEY (`KodeKandang`),
  ADD KEY `idx_kandang_cycle` (`KodeCycle`),
  ADD KEY `idx_kandang_peternakan` (`KodePeternakan`),
  ADD KEY `idx_kandang_tim` (`KodeTim`);

--
-- Indexes for table `ledger_peternakan`
--
ALTER TABLE `ledger_peternakan`
  ADD PRIMARY KEY (`IdBlock`),
  ADD UNIQUE KEY `KodeBlock` (`KodeBlock`),
  ADD KEY `KodePeternakan` (`KodePeternakan`),
  ADD KEY `KodeCycle` (`KodeCycle`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `idx_login_peternakan` (`KodePeternakan`);

--
-- Indexes for table `masterobat`
--
ALTER TABLE `masterobat`
  ADD PRIMARY KEY (`KodePerlengkapan`),
  ADD KEY `KodePeternakan` (`KodePeternakan`);

--
-- Indexes for table `notapenerimaan`
--
ALTER TABLE `notapenerimaan`
  ADD PRIMARY KEY (`KodePenerimaan`),
  ADD KEY `KodeOrder` (`KodeOrder`);

--
-- Indexes for table `notapengiriman`
--
ALTER TABLE `notapengiriman`
  ADD PRIMARY KEY (`KodeNotaPengiriman`),
  ADD KEY `KodePengiriman` (`KodePengiriman`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`KodeOrder`),
  ADD KEY `KodeSupplier` (`KodeSupplier`),
  ADD KEY `idx_orders_status` (`KodePeternakan`,`StatusOrder`);

--
-- Indexes for table `panen`
--
ALTER TABLE `panen`
  ADD PRIMARY KEY (`KodePanen`),
  ADD KEY `KodeKandang` (`KodeKandang`);

--
-- Indexes for table `pemakaianfeed`
--
ALTER TABLE `pemakaianfeed`
  ADD PRIMARY KEY (`KodePemakaianFeed`),
  ADD KEY `idx_feed_kandang` (`KodeKandang`),
  ADD KEY `idx_feed_tanggal` (`TanggalPemakaian`),
  ADD KEY `idx_feed_date_kandang` (`TanggalPemakaian`,`KodeKandang`);

--
-- Indexes for table `pemakaianobat`
--
ALTER TABLE `pemakaianobat`
  ADD PRIMARY KEY (`KodePemakaianObat`),
  ADD KEY `KodePerlengkapan` (`KodePerlengkapan`),
  ADD KEY `KodeKandang` (`KodeKandang`);

--
-- Indexes for table `pemakaianperlengkapan`
--
ALTER TABLE `pemakaianperlengkapan`
  ADD PRIMARY KEY (`KodePemakaian`),
  ADD KEY `idx_pakai_kandang` (`KodeKandang`),
  ADD KEY `idx_pakai_tanggal` (`TanggalPemakaian`),
  ADD KEY `KodePerlengkapan` (`KodePerlengkapan`);

--
-- Indexes for table `pengiriman`
--
ALTER TABLE `pengiriman`
  ADD PRIMARY KEY (`KodePengiriman`),
  ADD KEY `idx_pengiriman_panen` (`KodePanen`),
  ADD KEY `idx_pengiriman_tanggal` (`TanggalPengiriman`),
  ADD KEY `KodeKandang` (`KodeKandang`),
  ADD KEY `KodeStaf` (`KodeStaf`);

--
-- Indexes for table `pengukuranayam`
--
ALTER TABLE `pengukuranayam`
  ADD PRIMARY KEY (`KodePengukuran`),
  ADD KEY `KodeKandang` (`KodeKandang`);

--
-- Indexes for table `performance`
--
ALTER TABLE `performance`
  ADD PRIMARY KEY (`KodePerformance`),
  ADD KEY `KodeKandang` (`KodeKandang`),
  ADD KEY `idx_perf_date_kandang` (`TanggalPerformance`,`KodeKandang`);

--
-- Indexes for table `perlengkapan`
--
ALTER TABLE `perlengkapan`
  ADD PRIMARY KEY (`KodePerlengkapan`),
  ADD KEY `idx_perlengkapan_peternakan` (`KodePeternakan`);

--
-- Indexes for table `peternakan`
--
ALTER TABLE `peternakan`
  ADD PRIMARY KEY (`KodePeternakan`);

--
-- Indexes for table `staf`
--
ALTER TABLE `staf`
  ADD PRIMARY KEY (`KodeStaf`),
  ADD KEY `KodeTim` (`KodeTim`);

--
-- Indexes for table `statuskandang`
--
ALTER TABLE `statuskandang`
  ADD PRIMARY KEY (`KodeStatus`),
  ADD KEY `idx_status_kandang` (`KodeKandang`),
  ADD KEY `idx_status_tanggal` (`TanggalPemeriksaan`),
  ADD KEY `idx_status_kandang_date` (`KodeKandang`,`TanggalPemeriksaan`);

--
-- Indexes for table `statuskematian`
--
ALTER TABLE `statuskematian`
  ADD PRIMARY KEY (`KodeStatusKematian`),
  ADD KEY `KodeKandang` (`KodeKandang`),
  ADD KEY `idx_mortality_date` (`TanggalKejadian`,`KodeKandang`);

--
-- Indexes for table `stokwarehouse`
--
ALTER TABLE `stokwarehouse`
  ADD PRIMARY KEY (`KodeWarehouse`,`KodePerlengkapan`),
  ADD KEY `idx_stok_tanggal` (`TanggalMasukPerlengkapan`),
  ADD KEY `KodePerlengkapan` (`KodePerlengkapan`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`KodeSupplier`),
  ADD KEY `idx_supplier_peternakan` (`KodePeternakan`);

--
-- Indexes for table `timkerja`
--
ALTER TABLE `timkerja`
  ADD PRIMARY KEY (`KodeTim`),
  ADD KEY `KodePeternakan` (`KodePeternakan`);

--
-- Indexes for table `todo`
--
ALTER TABLE `todo`
  ADD PRIMARY KEY (`IdToDo`),
  ADD KEY `KodePeternakan` (`KodePeternakan`);

--
-- Indexes for table `todos`
--
ALTER TABLE `todos`
  ADD PRIMARY KEY (`IdToDo`),
  ADD KEY `KodePeternakan` (`KodePeternakan`);

--
-- Indexes for table `warehouse`
--
ALTER TABLE `warehouse`
  ADD PRIMARY KEY (`KodeWarehouse`),
  ADD KEY `idx_warehouse_peternakan` (`KodePeternakan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blockchainidentity`
--
ALTER TABLE `blockchainidentity`
  MODIFY `IdIdentity` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cycle`
--
ALTER TABLE `cycle`
  MODIFY `KodeCycle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `detailfeed`
--
ALTER TABLE `detailfeed`
  MODIFY `KodeDetailFeed` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `ledger_peternakan`
--
ALTER TABLE `ledger_peternakan`
  MODIFY `IdBlock` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `peternakan`
--
ALTER TABLE `peternakan`
  MODIFY `KodePeternakan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `todo`
--
ALTER TABLE `todo`
  MODIFY `IdToDo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `todos`
--
ALTER TABLE `todos`
  MODIFY `IdToDo` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `blockchainidentity`
--
ALTER TABLE `blockchainidentity`
  ADD CONSTRAINT `blockchainidentity_ibfk_1` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `blockchainidentity_ibfk_2` FOREIGN KEY (`KodeCycle`) REFERENCES `cycle` (`KodeCycle`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `detailfeed`
--
ALTER TABLE `detailfeed`
  ADD CONSTRAINT `fk_detailfeed_pemakaian` FOREIGN KEY (`KodePemakaianFeed`) REFERENCES `pemakaianfeed` (`KodePemakaianFeed`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detailfeed_perlengkapan` FOREIGN KEY (`KodePerlengkapan`) REFERENCES `perlengkapan` (`KodePerlengkapan`) ON UPDATE CASCADE;

--
-- Constraints for table `detailnotapenerimaan`
--
ALTER TABLE `detailnotapenerimaan`
  ADD CONSTRAINT `detailnotapenerimaan_ibfk_1` FOREIGN KEY (`KodePenerimaan`) REFERENCES `notapenerimaan` (`KodePenerimaan`);

--
-- Constraints for table `detailorder`
--
ALTER TABLE `detailorder`
  ADD CONSTRAINT `detailorder_ibfk_1` FOREIGN KEY (`KodeOrder`) REFERENCES `orders` (`KodeOrder`) ON DELETE CASCADE;

--
-- Constraints for table `doc`
--
ALTER TABLE `doc`
  ADD CONSTRAINT `doc_ibfk_1` FOREIGN KEY (`KodePenerimaan`) REFERENCES `notapenerimaan` (`KodePenerimaan`),
  ADD CONSTRAINT `doc_ibfk_2` FOREIGN KEY (`KodeKandang`) REFERENCES `kandang` (`KodeKandang`);

--
-- Constraints for table `kandang`
--
ALTER TABLE `kandang`
  ADD CONSTRAINT `kandang_ibfk_1` FOREIGN KEY (`KodeCycle`) REFERENCES `cycle` (`KodeCycle`),
  ADD CONSTRAINT `kandang_ibfk_2` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`),
  ADD CONSTRAINT `kandang_ibfk_3` FOREIGN KEY (`KodeTim`) REFERENCES `timkerja` (`KodeTim`);

--
-- Constraints for table `ledger_peternakan`
--
ALTER TABLE `ledger_peternakan`
  ADD CONSTRAINT `ledger_peternakan_ibfk_1` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `ledger_peternakan_ibfk_2` FOREIGN KEY (`KodeCycle`) REFERENCES `cycle` (`KodeCycle`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `fk_login_peternakan` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`) ON UPDATE CASCADE;

--
-- Constraints for table `masterobat`
--
ALTER TABLE `masterobat`
  ADD CONSTRAINT `masterobat_ibfk_1` FOREIGN KEY (`KodePerlengkapan`) REFERENCES `perlengkapan` (`KodePerlengkapan`) ON DELETE CASCADE,
  ADD CONSTRAINT `masterobat_ibfk_2` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`) ON DELETE CASCADE;

--
-- Constraints for table `notapenerimaan`
--
ALTER TABLE `notapenerimaan`
  ADD CONSTRAINT `notapenerimaan_ibfk_1` FOREIGN KEY (`KodeOrder`) REFERENCES `orders` (`KodeOrder`);

--
-- Constraints for table `notapengiriman`
--
ALTER TABLE `notapengiriman`
  ADD CONSTRAINT `notapengiriman_ibfk_1` FOREIGN KEY (`KodePengiriman`) REFERENCES `pengiriman` (`KodePengiriman`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`KodeSupplier`) REFERENCES `supplier` (`KodeSupplier`);

--
-- Constraints for table `panen`
--
ALTER TABLE `panen`
  ADD CONSTRAINT `panen_ibfk_1` FOREIGN KEY (`KodeKandang`) REFERENCES `kandang` (`KodeKandang`);

--
-- Constraints for table `pemakaianfeed`
--
ALTER TABLE `pemakaianfeed`
  ADD CONSTRAINT `pemakaianfeed_ibfk_1` FOREIGN KEY (`KodeKandang`) REFERENCES `kandang` (`KodeKandang`) ON UPDATE CASCADE;

--
-- Constraints for table `pemakaianobat`
--
ALTER TABLE `pemakaianobat`
  ADD CONSTRAINT `pemakaianobat_ibfk_1` FOREIGN KEY (`KodePerlengkapan`) REFERENCES `perlengkapan` (`KodePerlengkapan`),
  ADD CONSTRAINT `pemakaianobat_ibfk_2` FOREIGN KEY (`KodeKandang`) REFERENCES `kandang` (`KodeKandang`);

--
-- Constraints for table `pemakaianperlengkapan`
--
ALTER TABLE `pemakaianperlengkapan`
  ADD CONSTRAINT `pemakaianperlengkapan_ibfk_1` FOREIGN KEY (`KodePerlengkapan`) REFERENCES `perlengkapan` (`KodePerlengkapan`),
  ADD CONSTRAINT `pemakaianperlengkapan_ibfk_2` FOREIGN KEY (`KodeKandang`) REFERENCES `kandang` (`KodeKandang`);

--
-- Constraints for table `pengiriman`
--
ALTER TABLE `pengiriman`
  ADD CONSTRAINT `pengiriman_ibfk_1` FOREIGN KEY (`KodePanen`) REFERENCES `panen` (`KodePanen`),
  ADD CONSTRAINT `pengiriman_ibfk_2` FOREIGN KEY (`KodeKandang`) REFERENCES `kandang` (`KodeKandang`),
  ADD CONSTRAINT `pengiriman_ibfk_3` FOREIGN KEY (`KodeStaf`) REFERENCES `staf` (`KodeStaf`);

--
-- Constraints for table `pengukuranayam`
--
ALTER TABLE `pengukuranayam`
  ADD CONSTRAINT `pengukuranayam_ibfk_1` FOREIGN KEY (`KodeKandang`) REFERENCES `kandang` (`KodeKandang`);

--
-- Constraints for table `performance`
--
ALTER TABLE `performance`
  ADD CONSTRAINT `performance_ibfk_1` FOREIGN KEY (`KodeKandang`) REFERENCES `kandang` (`KodeKandang`);

--
-- Constraints for table `perlengkapan`
--
ALTER TABLE `perlengkapan`
  ADD CONSTRAINT `perlengkapan_ibfk_1` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`) ON DELETE CASCADE;

--
-- Constraints for table `staf`
--
ALTER TABLE `staf`
  ADD CONSTRAINT `staf_ibfk_1` FOREIGN KEY (`KodeTim`) REFERENCES `timkerja` (`KodeTim`);

--
-- Constraints for table `statuskandang`
--
ALTER TABLE `statuskandang`
  ADD CONSTRAINT `statuskandang_ibfk_1` FOREIGN KEY (`KodeKandang`) REFERENCES `kandang` (`KodeKandang`);

--
-- Constraints for table `statuskematian`
--
ALTER TABLE `statuskematian`
  ADD CONSTRAINT `statuskematian_ibfk_1` FOREIGN KEY (`KodeKandang`) REFERENCES `kandang` (`KodeKandang`);

--
-- Constraints for table `stokwarehouse`
--
ALTER TABLE `stokwarehouse`
  ADD CONSTRAINT `stokwarehouse_ibfk_1` FOREIGN KEY (`KodeWarehouse`) REFERENCES `warehouse` (`KodeWarehouse`),
  ADD CONSTRAINT `stokwarehouse_ibfk_2` FOREIGN KEY (`KodePerlengkapan`) REFERENCES `perlengkapan` (`KodePerlengkapan`);

--
-- Constraints for table `supplier`
--
ALTER TABLE `supplier`
  ADD CONSTRAINT `supplier_ibfk_1` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`) ON DELETE CASCADE;

--
-- Constraints for table `timkerja`
--
ALTER TABLE `timkerja`
  ADD CONSTRAINT `timkerja_ibfk_1` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`) ON DELETE CASCADE;

--
-- Constraints for table `todo`
--
ALTER TABLE `todo`
  ADD CONSTRAINT `todo_ibfk_1` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `todos`
--
ALTER TABLE `todos`
  ADD CONSTRAINT `todos_ibfk_1` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`) ON DELETE CASCADE;

--
-- Constraints for table `warehouse`
--
ALTER TABLE `warehouse`
  ADD CONSTRAINT `warehouse_ibfk_1` FOREIGN KEY (`KodePeternakan`) REFERENCES `peternakan` (`KodePeternakan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
