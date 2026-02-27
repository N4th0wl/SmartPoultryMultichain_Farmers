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

CREATE TABLE Peternakan (
  KodePeternakan INT PRIMARY KEY AUTO_INCREMENT,
  NamaPeternakan VARCHAR(255) NOT NULL,
  LokasiPeternakan VARCHAR(255) NOT NULL
);

CREATE TABLE Login (
  UserID INT AUTO_INCREMENT PRIMARY KEY,
  KodePeternakan INT NOT NULL,
  Email VARCHAR(255) NOT NULL UNIQUE,
  Password VARCHAR(255) NOT NULL,
  Role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
  INDEX idx_login_peternakan (KodePeternakan),
  CONSTRAINT fk_login_peternakan
   FOREIGN KEY (KodePeternakan) REFERENCES Peternakan(KodePeternakan) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Supplier (
  KodeSupplier CHAR(13) PRIMARY KEY,
  KodePeternakan INT NOT NULL,
  NamaSupplier VARCHAR(100) NOT NULL,
  KontakSupplier VARCHAR(15) NOT NULL,
  INDEX idx_supplier_peternakan (KodePeternakan),
  FOREIGN KEY (KodePeternakan)
    REFERENCES Peternakan(KodePeternakan)
    ON DELETE CASCADE
);


CREATE TABLE Orders (
  KodeOrder CHAR(13) PRIMARY KEY,
  KodePeternakan INT NOT NULL,
  KodeSupplier CHAR(13) NOT NULL,
  TanggalOrder DATE NOT NULL,
  StatusOrder ENUM('PROSES','SUDAH DITERIMA') NOT NULL,
  FOREIGN KEY (KodePeternakan)
    REFERENCES Peternakan(KodePeternakan),
  FOREIGN KEY (KodeSupplier)
    REFERENCES Supplier(KodeSupplier)
);


CREATE TABLE DetailOrder (
  KodeDetailOrder CHAR(13) PRIMARY KEY,
  KodeOrder CHAR(13) NOT NULL,
  JenisBarang ENUM('DOC','PERLENGKAPAN') NOT NULL,
  NamaBarang VARCHAR(255),
  JumlahBarang INT NOT NULL,
  HargaSatuan DECIMAL(12,2) NOT NULL,
  INDEX idx_detail_order (KodeOrder),
  FOREIGN KEY (KodeOrder)
    REFERENCES Orders(KodeOrder)
    ON DELETE CASCADE
);

CREATE TABLE NotaPenerimaan (
  KodePenerimaan CHAR(13) PRIMARY KEY,
  KodeOrder CHAR(13) NOT NULL,
  TanggalPenerimaan DATE NOT NULL,
  NamaPenerima CHAR(30) NOT NULL,
  FOREIGN KEY (KodeOrder) REFERENCES Orders (KodeOrder)
);

CREATE TABLE DetailNotaPenerimaan (
  KodeDetailNota CHAR(13) PRIMARY KEY,
  KodePenerimaan CHAR(13) NOT NULL,
  JenisBarang ENUM('DOC', 'PERLENGKAPAN') NOT NULL,
  NamaBarang VARCHAR(100) NOT NULL,
  Jumlah INT NOT NULL,
  FOREIGN KEY (KodePenerimaan) REFERENCES NotaPenerimaan(KodePenerimaan)
);

CREATE TABLE Perlengkapan (
  KodePerlengkapan CHAR(13) PRIMARY KEY,
  KodePeternakan INT NOT NULL,
  NamaPerlengkapan VARCHAR(100) NOT NULL,
  KategoriPerlengkapan ENUM('PAKAN','PERALATAN','OBAT') NOT NULL,
  Satuan VARCHAR(20),
  INDEX idx_perlengkapan_peternakan (KodePeternakan),
  FOREIGN KEY (KodePeternakan)
    REFERENCES Peternakan(KodePeternakan)
    ON DELETE CASCADE
);


CREATE TABLE Warehouse (
  KodeWarehouse CHAR(13) PRIMARY KEY,
  KodePeternakan INT NOT NULL,
  LokasiWarehouse VARCHAR(255),
  INDEX idx_warehouse_peternakan (KodePeternakan),
  FOREIGN KEY (KodePeternakan)
    REFERENCES Peternakan(KodePeternakan)
    ON DELETE RESTRICT
);


CREATE TABLE StokWarehouse (
  KodeWarehouse CHAR(13),
  KodePerlengkapan CHAR(13),
  Jumlah INT NOT NULL,
  TanggalMasukPerlengkapan DATE NOT NULL,
  PRIMARY KEY (KodeWarehouse, KodePerlengkapan),
  INDEX idx_stok_tanggal (TanggalMasukPerlengkapan),
  FOREIGN KEY (KodeWarehouse)
    REFERENCES Warehouse(KodeWarehouse),
  FOREIGN KEY (KodePerlengkapan)
    REFERENCES Perlengkapan(KodePerlengkapan)
);


CREATE TABLE MasterObat (
  KodePerlengkapan CHAR(13) PRIMARY KEY,
  KodePeternakan INT NOT NULL,
  JenisObat VARCHAR(100) NOT NULL,
  Dosis VARCHAR(100) NOT NULL,
  TanggalKadaluarsa DATE NOT NULL,
  HargaObat DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (KodePerlengkapan)
    REFERENCES Perlengkapan(KodePerlengkapan)
    ON DELETE CASCADE,
  FOREIGN KEY (KodePeternakan)
    REFERENCES Peternakan(KodePeternakan)
    ON DELETE CASCADE
);


CREATE TABLE Cycle (
  KodeCycle INT AUTO_INCREMENT PRIMARY KEY,
  TanggalMulai DATE NOT NULL,
  DurasiCycle INT NOT NULL CHECK (DurasiCycle > 0),
  SisaHariPanen INT NOT NULL CHECK (SisaHariPanen >= 0)
);

CREATE TABLE TimKerja (
  KodeTim CHAR(13) PRIMARY KEY,
  KodePeternakan INT NOT NULL,
  NamaTim VARCHAR(255),
  JumlahAnggota INT DEFAULT 0,
  FOREIGN KEY (KodePeternakan)
    REFERENCES Peternakan(KodePeternakan)
    ON DELETE CASCADE
);

CREATE TABLE Staf (
  KodeStaf CHAR(13) PRIMARY KEY,
  KodeTim CHAR(13) NOT NULL,
  NamaStaf VARCHAR(255),
  PosisiStaf VARCHAR(100),
  FOREIGN KEY (KodeTim) REFERENCES TimKerja(KodeTim)
);

CREATE TABLE Kandang (
  KodeKandang CHAR(13) PRIMARY KEY,
  KodeCycle INT NOT NULL,
  KodePeternakan INT NOT NULL,
  KodeTim CHAR(13) NOT NULL,
  PanjangKandang FLOAT,
  LebarKandang FLOAT,
  LantaiKandang VARCHAR(20),
  Kepadatan FLOAT,
  SuhuKandang FLOAT,
  INDEX idx_kandang_cycle (KodeCycle),
  INDEX idx_kandang_peternakan (KodePeternakan),
  INDEX idx_kandang_tim (KodeTim),
  FOREIGN KEY (KodeCycle) REFERENCES Cycle(KodeCycle),
  FOREIGN KEY (KodePeternakan) REFERENCES Peternakan(KodePeternakan),
  FOREIGN KEY (KodeTim) REFERENCES TimKerja(KodeTim)
);

CREATE TABLE DOC (
  KodeDOC CHAR(13) PRIMARY KEY,
  KodePenerimaan CHAR(13) NOT NULL,
  KodeKandang CHAR(13),
  BrandDOC VARCHAR(55),
  TipeAyam VARCHAR(55),
  TanggalMasukKandang DATE,
  JumlahDipesan INT NOT NULL,
  JumlahDiterima INT NOT NULL,
  JumlahMatiPraKandang INT DEFAULT 0,
  KondisiAwal VARCHAR(255), 
  FOREIGN KEY (KodePenerimaan) REFERENCES NotaPenerimaan(KodePenerimaan),
  FOREIGN KEY (KodeKandang) REFERENCES Kandang(KodeKandang)
);

CREATE TABLE StatusKandang (
  KodeStatus CHAR(13) PRIMARY KEY,
  KodeKandang CHAR(13) NOT NULL,
  UmurAyam INT, 
  Populasi INT,
  BeratRataRata FLOAT,
  TanggalPemeriksaan DATE NOT NULL,
  INDEX idx_status_kandang (KodeKandang),
  INDEX idx_status_tanggal (TanggalPemeriksaan),
  FOREIGN KEY (KodeKandang) REFERENCES Kandang(KodeKandang)
);

CREATE TABLE Performance (
  KodePerformance CHAR(13) PRIMARY KEY,
  KodeKandang CHAR(13) NOT NULL,
  TanggalPerformance DATE NOT NULL,
  ActualAverageDailyGain FLOAT,
  ActualFeedIntake FLOAT,
  ActualWaterIntake FLOAT,
  KeteranganPerformance VARCHAR(255),
  FOREIGN KEY (KodeKandang) REFERENCES Kandang(KodeKandang)
);

CREATE TABLE PengukuranAyam (
  KodePengukuran CHAR(13) PRIMARY KEY,
  KodeKandang CHAR(13) NOT NULL,
  TanggalPengukuran DATE NOT NULL,
  BeratAyam FLOAT,
  FOREIGN KEY (KodeKandang)
    REFERENCES Kandang(KodeKandang)
);

CREATE TABLE PemakaianPerlengkapan (
  KodePemakaian CHAR(13) PRIMARY KEY,
  KodePerlengkapan CHAR(13) NOT NULL,
  KodeKandang CHAR(13) NOT NULL,
  TanggalPemakaian DATE NOT NULL,
  JumlahPemakaian INT NOT NULL,
  INDEX idx_pakai_kandang (KodeKandang),
  INDEX idx_pakai_tanggal (TanggalPemakaian),
  FOREIGN KEY (KodePerlengkapan) REFERENCES Perlengkapan(KodePerlengkapan),
  FOREIGN KEY (KodeKandang) REFERENCES Kandang(KodeKandang)
);

CREATE TABLE PemakaianObat (
  KodePemakaianObat CHAR(13) PRIMARY KEY,
  KodePerlengkapan CHAR(13) NOT NULL,
  KodeKandang CHAR(13) NOT NULL,
  TanggalPenggunaan DATE NOT NULL,
  JumlahObat INT NOT NULL,
  FOREIGN KEY (KodePerlengkapan) REFERENCES Perlengkapan(KodePerlengkapan),
  FOREIGN KEY (KodeKandang) REFERENCES Kandang(KodeKandang)
);

CREATE TABLE StatusKematian (
  KodeStatusKematian CHAR(13) PRIMARY KEY,
  KodeKandang CHAR(13) NOT NULL,
  TanggalKejadian DATE NOT NULL,
  JumlahMati INT,
  JumlahReject INT,
  BuktiKematian BLOB,
  Keterangan VARCHAR(200),
  FOREIGN KEY (KodeKandang) REFERENCES Kandang(KodeKandang)
);

CREATE TABLE Panen (
  KodePanen CHAR(13) PRIMARY KEY,
  KodeKandang CHAR(13) NOT NULL,
  TanggalPanen DATE NOT NULL,
  TotalBerat FLOAT,
  TotalHarga DECIMAL(14,2),
  FOREIGN KEY (KodeKandang) REFERENCES Kandang(KodeKandang)
);

CREATE TABLE PemakaianFeed (
  KodePemakaianFeed CHAR(13) PRIMARY KEY,
  KodeKandang CHAR(13) NOT NULL,
  TanggalPemakaian DATE NOT NULL,
  INDEX idx_feed_kandang (KodeKandang),
  INDEX idx_feed_tanggal (TanggalPemakaian),
  FOREIGN KEY (KodeKandang)
    REFERENCES Kandang(KodeKandang)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE DetailFeed (
  KodeDetailFeed INT AUTO_INCREMENT PRIMARY KEY,
  KodePemakaianFeed CHAR(13) NOT NULL,
  KodePerlengkapan CHAR(13) NOT NULL,
  JumlahPakan INT NOT NULL,
  INDEX idx_detailfeed_pemakaian (KodePemakaianFeed),
  INDEX idx_detailfeed_perlengkapan (KodePerlengkapan),
  CONSTRAINT fk_detailfeed_pemakaian
    FOREIGN KEY (KodePemakaianFeed)
    REFERENCES PemakaianFeed(KodePemakaianFeed)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_detailfeed_perlengkapan
    FOREIGN KEY (KodePerlengkapan)
    REFERENCES Perlengkapan(KodePerlengkapan)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);


CREATE TABLE Pengiriman (
  KodePengiriman CHAR(13) PRIMARY KEY,
  KodePanen CHAR(13) NOT NULL,
  KodeKandang CHAR(13) NOT NULL,
  KodeStaf CHAR(13) NOT NULL,
  TanggalPengiriman DATE NOT NULL,
  NamaPerusahaanPengiriman VARCHAR(50),
  AlamatTujuan VARCHAR(255),
  INDEX idx_pengiriman_panen (KodePanen),
  INDEX idx_pengiriman_tanggal (TanggalPengiriman),
  FOREIGN KEY (KodePanen) REFERENCES Panen(KodePanen),
  FOREIGN KEY (KodeKandang) REFERENCES Kandang(KodeKandang),
  FOREIGN KEY (KodeStaf) REFERENCES Staf(KodeStaf)
);

CREATE TABLE NotaPengiriman (
  KodeNotaPengiriman CHAR(13) PRIMARY KEY,
  KodePengiriman CHAR(13) NOT NULL,
  TanggalPenerimaan DATE NOT NULL,
  FOREIGN KEY (KodePengiriman) REFERENCES Pengiriman(KodePengiriman)
);

-- Code generation is now handled by the application layer
-- See: backend/utils/codeGenerator.js

CREATE TABLE ToDos (
  IdToDo INT AUTO_INCREMENT PRIMARY KEY,
  KodePeternakan INT NOT NULL,
  Judul VARCHAR(255) NOT NULL,
  Deskripsi TEXT,
  IsCompleted BOOLEAN DEFAULT FALSE,
  Prioritas ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
  TenggatWaktu DATE,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (KodePeternakan) REFERENCES Peternakan(KodePeternakan) ON DELETE CASCADE
);

-- =====================================================
-- CODE COUNTER TABLE
-- Used by application to generate sequential codes
-- =====================================================
CREATE TABLE CodeCounter (
  EntityName VARCHAR(50) PRIMARY KEY,
  LastCounter INT NOT NULL DEFAULT 0
);

-- Initialize counters for all entities
INSERT INTO CodeCounter (EntityName, LastCounter) VALUES
('Supplier', 0),
('Orders', 0),
('DetailOrder', 0),
('NotaPenerimaan', 0),
('DetailNotaPenerimaan', 0),
('Perlengkapan', 0),
('Warehouse', 0),
('TimKerja', 0),
('Staf', 0),
('Kandang', 0),
('DOC', 0),
('StatusKandang', 0),
('Performance', 0),
('PengukuranAyam', 0),
('PemakaianPerlengkapan', 0),
('PemakaianObat', 0),
('StatusKematian', 0),
('Panen', 0),
('PemakaianFeed', 0),
('Pengiriman', 0),
('NotaPengiriman', 0);

-- =====================================================
-- CODE GENERATION PATTERNS (For Reference)
-- =====================================================
-- These patterns are now implemented in backend/utils/codeGenerator.js
-- All codes follow the pattern: PREFIX-{9 digit padded ID}
-- 
-- Table                 | Column              | Pattern
-- ----------------------|---------------------|------------------
-- Supplier              | KodeSupplier        | SUP-000000001
-- Orders                | KodeOrder           | ORD-000000001
-- DetailOrder           | KodeDetailOrder     | DOR-000000001
-- NotaPenerimaan        | KodePenerimaan      | NPR-000000001
-- DetailNotaPenerimaan  | KodeDetailNota      | DNP-000000001
-- Perlengkapan          | KodePerlengkapan    | PER-000000001
-- Warehouse             | KodeWarehouse       | WRH-000000001
-- TimKerja              | KodeTim             | TIM-000000001
-- Staf                  | KodeStaf            | STF-000000001
-- Kandang               | KodeKandang         | KDG-000000001
-- DOC                   | KodeDOC             | DOC-000000001
-- StatusKandang         | KodeStatus          | STS-000000001
-- Performance           | KodePerformance     | PFC-000000001
-- PengukuranAyam        | KodePengukuran      | PGK-000000001
-- PemakaianPerlengkapan | KodePemakaian       | PMK-000000001
-- PemakaianObat         | KodePemakaianObat   | POB-000000001
-- StatusKematian        | KodeStatusKematian  | SMT-000000001
-- Panen                 | KodePanen           | PAN-000000001
-- PemakaianFeed         | KodePemakaianFeed   | PFD-000000001
-- Pengiriman            | KodePengiriman      | PNG-000000001
-- NotaPengiriman        | KodeNotaPengiriman  | NPG-000000001
-- =====================================================