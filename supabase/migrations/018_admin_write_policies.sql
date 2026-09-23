-- Migration 018: policy tulis admin yang kurang (profiles role + baca rewards).
-- Referensi: docs/PRD_ADMIN.md bagian 6.4-6.5, docs/DATABASE_SCHEMA.md 3.1/3.5.
-- Idempoten: aman dijalankan ulang; policy dibuat hanya bila belum ada.
--
-- Masalah:
-- 1. profiles hanya punya update_own (role dikunci) sehingga admin tidak
--    bisa ubah role dari aplikasi (diblokir RLS by design sejak awal).
-- 2. rewards hanya punya read_active sehingga daftar admin (aktif +
--    nonaktif) tidak bisa membaca baris nonaktif; item yang dinonaktifkan
--    hilang dari daftar admin.

-- Admin bisa baca semua reward (aktif + nonaktif).
do $$
begin
  if not exists (
    select 1 from pg_policy
    where polname = 'rewards_select_all_admin'
  ) then
    create policy "rewards_select_all_admin"
      on public.rewards for select
      using (public.is_admin());
  end if;
end $$;

-- Admin bisa ubah profil siapa pun (termasuk kolom role).
do $$
begin
  if not exists (
    select 1 from pg_policy
    where polname = 'profiles_update_role_admin'
  ) then
    create policy "profiles_update_role_admin"
      on public.profiles for update
      using (public.is_admin())
      with check (public.is_admin());
  end if;
end $$;
