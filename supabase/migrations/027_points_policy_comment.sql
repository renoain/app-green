-- Migration 027: koreksi penjelasan policy insert tabel points.
-- Referensi: migration 004 (catatan usang), 014, 015, docs/DATABASE_SCHEMA.md 7.
-- Idempoten: COMMENT aman dijalankan ulang; tanpa ubah struktur/policy.
--
-- Latar: header 004 menyatakan pencatatan poin sisi server sehingga tidak
-- ada policy insert klien. Klaim itu digantikan 014 (earn) lalu 015
-- (points_insert_own: earn + redeem, amount 1-50, milik sendiri).

comment on policy "points_insert_own" on public.points is
  'MVP: klien boleh insert earn/redeem milik sendiri (amount 1-50). Pengerasan fase lanjut: approval server (docs/ARCHITECTURE.md 10.4).';
