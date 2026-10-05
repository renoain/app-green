-- Baseline 007: seed data (dari 009+012+015). Murni data.
-- Jalankan terakhir setelah 001-006.
-- Checkpoint, artikel, dan set admin idempoten (aman diulang).
-- Seed reward mengikuti sumber 009 (tanpa klausa dedup, jalan sekali saja).
-- Referensi: docs/DATABASE_SCHEMA.md bagian 5.

-- Seed checkpoint contoh.
insert into public.checkpoints (name, address, latitude, longitude, radius, qr_code)
values
  ('Checkpoint RW 01', 'Jl. Melati No. 10, Jakarta', -6.200000, 106.800000, 100, 'CP-001'),
  ('Checkpoint RW 02', 'Jl. Mawar No. 5, Jakarta', -6.201000, 106.801000, 100, 'CP-002'),
  ('Checkpoint RW 03', 'Jl. Anggrek No. 3, Jakarta', -6.202000, 106.802000, 100, 'CP-003')
on conflict (qr_code) do nothing;

-- Seed reward contoh.
insert into public.rewards (name, description, points_cost, stock)
values
  ('Voucher Belanja 10.000', 'Voucher belanja senilai 10 ribu', 100, 50),
  ('Voucher Belanja 25.000', 'Voucher belanja senilai 25 ribu', 250, 30),
  ('Saldo E-Wallet 50.000', 'Saldo e-wallet senilai 50 ribu', 500, 20),
  ('Donasi Lingkungan', 'Donasi untuk program lingkungan', 100, 999),
  ('Tumbler Go Green', 'Tumbler edisi Go Green', 300, 15);

-- Seed 4 artikel edukasi (dari 015).
insert into public.articles (title, excerpt, content, published_at)
values
  (
    'Pilah Sampah: Mulai dari Dapur',
    'Cara sederhana memilah sampah organik dan anorganik di rumah.',
    'Memilah sampah sejak dari sumber adalah langkah paling sederhana untuk memulai gaya hidup ramah lingkungan. Siapkan wadah terpisah untuk organik, anorganik, dan residu di area dapur.' || chr(10) || chr(10) ||
    'Sampah organik dapat diolah menjadi kompos, sedangkan sampah anorganik yang bersih bisa diserahkan ke bank sampah terdekat. Pastikan membilas kemasan sebelum diserahkan agar mudah didaur ulang.' || chr(10) || chr(10) ||
    'Dengan rutin memilah, kamu berkontribusi mengurangi beban tempat pembuangan akhir dan berpeluang mendapatkan poin di aplikasi Go Green.',
    timestamptz '2026-09-10 00:00:00+00'
  ),
  (
    'Kompos Rumah Tangga Tanpa Bau',
    'Teknik kompos basah yang aman untuk rumah kecil.',
    'Sampah organik dapat diolah menjadi kompos, sedangkan sampah anorganik yang bersih bisa diserahkan ke bank sampah terdekat. Pastikan membilas kemasan sebelum diserahkan agar mudah didaur ulang.' || chr(10) || chr(10) ||
    'Memilah sampah sejak dari sumber adalah langkah paling sederhana untuk memulai gaya hidup ramah lingkungan. Siapkan wadah terpisah untuk organik, anorganik, dan residu di area dapur.' || chr(10) || chr(10) ||
    'Dengan rutin memilah, kamu berkontribusi mengurangi beban tempat pembuangan akhir dan berpeluang mendapatkan poin di aplikasi Go Green.',
    timestamptz '2026-09-05 00:00:00+00'
  ),
  (
    'Daur Ulang Plastik di Rumah',
    'Mengubah botol bekas menjadi barang yang berguna.',
    'Dengan rutin memilah, kamu berkontribusi mengurangi beban tempat pembuangan akhir dan berpeluang mendapatkan poin di aplikasi Go Green.' || chr(10) || chr(10) ||
    'Memilah sampah sejak dari sumber adalah langkah paling sederhana untuk memulai gaya hidup ramah lingkungan. Siapkan wadah terpisah untuk organik, anorganik, dan residu di area dapur.' || chr(10) || chr(10) ||
    'Sampah organik dapat diolah menjadi kompos, sedangkan sampah anorganik yang bersih bisa diserahkan ke bank sampah terdekat. Pastikan membilas kemasan sebelum diserahkan agar mudah didaur ulang.',
    timestamptz '2026-08-28 00:00:00+00'
  ),
  (
    'Kurangi Sampah Makanan',
    'Kebiasaan belanja dan memasak yang lebih cerdas.',
    'Memilah sampah sejak dari sumber adalah langkah paling sederhana untuk memulai gaya hidup ramah lingkungan. Siapkan wadah terpisah untuk organik, anorganik, dan residu di area dapur.' || chr(10) || chr(10) ||
    'Sampah organik dapat diolah menjadi kompos, sedangkan sampah anorganik yang bersih bisa diserahkan ke bank sampah terdekat. Pastikan membilas kemasan sebelum diserahkan agar mudah didaur ulang.' || chr(10) || chr(10) ||
    'Dengan rutin memilah, kamu berkontribusi mengurangi beban tempat pembuangan akhir dan berpeluang mendapatkan poin di aplikasi Go Green.',
    timestamptz '2026-08-20 00:00:00+00'
  )
on conflict do nothing;

-- Set admin operasional (dari 012, idempoten, jalan setelah user dibuat).
update public.profiles
set role = 'admin', username = 'admin'
where email = 'admin@green.com';
