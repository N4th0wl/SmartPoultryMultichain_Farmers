-- =====================================================
-- Dashboard VIEWs for SmartPoultry
-- Run this script to create optimized VIEWs for dashboard queries
-- =====================================================

-- VIEW 1: Dashboard Summary per Peternakan
DROP VIEW IF EXISTS vw_dashboard_summary;

CREATE VIEW vw_dashboard_summary AS
SELECT 
    k.KodePeternakan,
    COUNT(DISTINCT k.KodeKandang) AS TotalKandang,
    COALESCE(SUM(latestStatus.Populasi), 0) AS TotalPopulasi,
    ROUND(AVG(k.SuhuKandang), 1) AS AvgSuhu
FROM Kandang k
LEFT JOIN (
    SELECT sk.KodeKandang, sk.Populasi
    FROM StatusKandang sk
    INNER JOIN (
        SELECT KodeKandang, MAX(TanggalPemeriksaan) AS MaxDate
        FROM StatusKandang
        GROUP BY KodeKandang
    ) latest ON sk.KodeKandang = latest.KodeKandang 
        AND sk.TanggalPemeriksaan = latest.MaxDate
) latestStatus ON k.KodeKandang = latestStatus.KodeKandang
GROUP BY k.KodePeternakan;

-- VIEW 2: Latest Kandang Status with Population and Age
DROP VIEW IF EXISTS vw_kandang_status;

CREATE VIEW vw_kandang_status AS
SELECT 
    k.KodeKandang,
    k.KodePeternakan,
    k.KodeCycle,
    COALESCE(sk.Populasi, 0) AS Populasi,
    COALESCE(sk.UmurAyam, 0) AS UmurAyam,
    COALESCE(sk.BeratRataRata, 0) AS BeratRataRata,
    sk.TanggalPemeriksaan,
    k.SuhuKandang,
    CASE 
        WHEN sk.Populasi IS NULL THEN 'Persiapan'
        WHEN k.SuhuKandang > 32 OR k.SuhuKandang < 26 THEN 'Perlu Pantau'
        ELSE 'Stabil'
    END AS Status
FROM Kandang k
LEFT JOIN StatusKandang sk ON k.KodeKandang = sk.KodeKandang
    AND sk.TanggalPemeriksaan = (
        SELECT MAX(TanggalPemeriksaan) 
        FROM StatusKandang 
        WHERE KodeKandang = k.KodeKandang
    );

-- VIEW 3: Mortality KPI per Kandang
DROP VIEW IF EXISTS vw_mortality_kpi;

CREATE VIEW vw_mortality_kpi AS
SELECT 
    sm.KodeKandang,
    k.KodePeternakan,
    SUM(sm.JumlahMati) AS TotalMati,
    SUM(sm.JumlahReject) AS TotalReject,
    MAX(sm.TanggalKejadian) AS LastMortalityDate,
    COALESCE(doc.JumlahDiterima, 0) AS InitialPopulasi,
    ROUND(
        (SUM(sm.JumlahMati) / NULLIF(doc.JumlahDiterima, 0)) * 100,
        2
    ) AS MortalityRate
FROM StatusKematian sm
JOIN Kandang k ON sm.KodeKandang = k.KodeKandang
LEFT JOIN DOC doc ON doc.KodeKandang = k.KodeKandang
GROUP BY sm.KodeKandang, k.KodePeternakan, doc.JumlahDiterima;

-- VIEW 4: Daily Feed Usage
DROP VIEW IF EXISTS vw_feed_usage_daily;

CREATE VIEW vw_feed_usage_daily AS
SELECT 
    pf.KodeKandang,
    k.KodePeternakan,
    pf.TanggalPemakaian,
    SUM(df.JumlahPakan) AS TotalPakan
FROM PemakaianFeed pf
JOIN DetailFeed df ON pf.KodePemakaianFeed = df.KodePemakaianFeed
JOIN Kandang k ON pf.KodeKandang = k.KodeKandang
GROUP BY pf.KodeKandang, k.KodePeternakan, pf.TanggalPemakaian;

-- VIEW 5: Performance Summary per Kandang
DROP VIEW IF EXISTS vw_performance_summary;

CREATE VIEW vw_performance_summary AS
SELECT 
    p.KodeKandang,
    k.KodePeternakan,
    ROUND(AVG(p.ActualAverageDailyGain), 2) AS AvgADG,
    ROUND(AVG(p.ActualFeedIntake), 2) AS AvgFeedIntake,
    ROUND(AVG(p.ActualWaterIntake), 2) AS AvgWaterIntake,
    MAX(p.TanggalPerformance) AS LastRecordDate
FROM Performance p
JOIN Kandang k ON p.KodeKandang = k.KodeKandang
GROUP BY p.KodeKandang, k.KodePeternakan;

-- VIEW 6: Harvest Estimates
DROP VIEW IF EXISTS vw_harvest_estimate;

CREATE VIEW vw_harvest_estimate AS
SELECT 
    k.KodeKandang,
    k.KodePeternakan,
    c.KodeCycle,
    c.TanggalMulai,
    c.DurasiCycle,
    c.SisaHariPanen,
    DATE_ADD(c.TanggalMulai, INTERVAL c.DurasiCycle DAY) AS EstimatedHarvestDate,
    COALESCE(vs.Populasi, 0) AS CurrentPopulasi,
    COALESCE(vs.BeratRataRata, 0) AS EstimatedWeight
FROM Kandang k
JOIN Cycle c ON k.KodeCycle = c.KodeCycle
LEFT JOIN vw_kandang_status vs ON k.KodeKandang = vs.KodeKandang;

-- =====================================================
-- Recommended Indexes for Dashboard Performance
-- =====================================================

-- Index for StatusKandang date-based queries
CREATE INDEX IF NOT EXISTS idx_status_kandang_date 
ON StatusKandang(KodeKandang, TanggalPemeriksaan DESC);

-- Index for PemakaianFeed date-based queries
CREATE INDEX IF NOT EXISTS idx_feed_date_kandang 
ON PemakaianFeed(TanggalPemakaian, KodeKandang);

-- Index for Performance date-based queries
CREATE INDEX IF NOT EXISTS idx_perf_date_kandang 
ON Performance(TanggalPerformance, KodeKandang);

-- Index for StatusKematian date-based queries
CREATE INDEX IF NOT EXISTS idx_mortality_date 
ON StatusKematian(TanggalKejadian, KodeKandang);

-- Index for Orders status filtering
CREATE INDEX IF NOT EXISTS idx_orders_status 
ON Orders(KodePeternakan, StatusOrder);

-- =====================================================
-- Note: Run these VIEWs after the main database schema
-- is created. Some VIEWs depend on tables being present.
-- =====================================================
