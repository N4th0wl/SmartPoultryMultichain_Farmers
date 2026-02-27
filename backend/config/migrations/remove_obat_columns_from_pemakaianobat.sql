-- Migration: Remove JenisObat and Dosis columns from PemakaianObat
-- These columns are redundant since the data already exists in MasterObat
-- and is referenced via KodePerlengkapan JOIN.
-- Date: 2026-02-16

ALTER TABLE PemakaianObat DROP COLUMN IF EXISTS JenisObat;
ALTER TABLE PemakaianObat DROP COLUMN IF EXISTS Dosis;
