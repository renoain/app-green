-- Migration 012: set role admin (idempoten).
--
-- Dijalankan SETELAH user admin@green.com dibuat di Authentication
-- (dashboard atau sign-up). Idempoten, aman dijalankan ulang.
-- Menggantikan edit manual 009_seed_data.sql yang sudah terlanjur
-- ter-push (edit file migration yang sudah applied tidak jalan ulang
-- di remote).
--
-- Referensi skema: docs/DATABASE_SCHEMA.md.

update public.profiles
set role = 'admin', username = 'admin'
where email = 'admin@green.com';
