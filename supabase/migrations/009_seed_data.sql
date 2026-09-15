-- Migration 009: seed data contoh (opsional).
-- Referensi skema: docs/DATABASE_SCHEMA.md bagian 5.

-- ============ SEED CHECKPOINTS ============
insert into public.checkpoints (name, address, latitude, longitude, radius, qr_code)
values
  ('Checkpoint RW 01', 'Jl. Melati No. 10, Jakarta', -6.200000, 106.800000, 100, 'CP-001'),
  ('Checkpoint RW 02', 'Jl. Mawar No. 5, Jakarta', -6.201000, 106.801000, 100, 'CP-002'),
  ('Checkpoint RW 03', 'Jl. Anggrek No. 3, Jakarta', -6.202000, 106.802000, 100, 'CP-003')
on conflict (qr_code) do nothing;

-- ============ SEED REWARDS ============
insert into public.rewards (name, description, points_cost, stock)
values
  ('Voucher Belanja 10.000', 'Voucher belanja senilai 10 ribu', 100, 50),
  ('Voucher Belanja 25.000', 'Voucher belanja senilai 25 ribu', 250, 30),
  ('Saldo E-Wallet 50.000', 'Saldo e-wallet senilai 50 ribu', 500, 20),
  ('Donasi Lingkungan', 'Donasi untuk program lingkungan', 100, 999),
  ('Tumbler Go Green', 'Tumbler edisi Go Green', 300, 15);

-- ============ SEED ADMIN ============
-- Setelah user admin dibuat di Authentication, jalankan (idempoten):
update public.profiles
set role = 'admin', username = 'admin'
where email = 'admin@green.com';