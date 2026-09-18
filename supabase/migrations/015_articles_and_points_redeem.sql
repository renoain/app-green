-- Migration 015: tabel articles + policy insert redeem untuk klien (MVP).
--
-- 1) Artikel edukasi: publik bisa baca (anon + authenticated), tulis hanya
--    admin. Seed 4 artikel sama dengan konten demo aplikasi.
-- 2) Penukaran reward langsung: klien boleh insert redeem sendiri
--    (batas amount 1-50, milik sendiri). Menggantikan policy
--    points_insert_own_earn (014) yang hanya membolehkan earn.
--    Pengerasan fase lanjut: approval server + cabut insert klien
--    (lihat docs/ARCHITECTURE.md 10.4).

-- ============ ARTICLES ============
create table if not exists public.articles (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  excerpt text,
  content text not null,
  cover_url text,
  published_at timestamptz not null default timezone('utc', now()),
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.articles is 'Artikel edukasi lingkungan.';

create index if not exists articles_published_at_idx
  on public.articles (published_at desc);

alter table public.articles enable row level security;

drop policy if exists "articles_read_all" on public.articles;
create policy "articles_read_all"
  on public.articles for select
  using (true);

drop policy if exists "articles_insert_admin" on public.articles;
create policy "articles_insert_admin"
  on public.articles for insert
  with check (public.is_admin());

drop policy if exists "articles_update_admin" on public.articles;
create policy "articles_update_admin"
  on public.articles for update
  using (public.is_admin());

drop policy if exists "articles_delete_admin" on public.articles;
create policy "articles_delete_admin"
  on public.articles for delete
  using (public.is_admin());

-- ============ SEED ARTICLES ============
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
    'Dengan rutin memilah, kamu berkontribusi mengurangi beban tempat pembuangan akhir dan berpeluang mendapatkan poin di aplikasi Go Green.' || chr(10) || chr(10) ||
    'Sampah organik dapat diolah menjadi kompos, sedangkan sampah anorganik yang bersih bisa diserahkan ke bank sampah terdekat. Pastikan membilas kemasan sebelum diserahkan agar mudah didaur ulang.',
    timestamptz '2026-08-20 00:00:00+00'
  )
on conflict do nothing;

-- ============ POINTS: IZINKAN REDEEM (GGANTI POLICY 014) ============
drop policy if exists "points_insert_own_earn" on public.points;
drop policy if exists "points_insert_own" on public.points;
create policy "points_insert_own"
  on public.points for insert
  with check (
    auth.uid() = user_id
    and amount >= 1
    and amount <= 50
    and type in ('earn', 'redeem')
  );
