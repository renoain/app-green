-- Migration 008: bucket storage waste-photos dan avatars + RLS storage.
-- Referensi skema: docs/DATABASE_SCHEMA.md bagian 4.

-- ============ BUCKETS ============
insert into storage.buckets (id, name, public)
values
  ('waste-photos', 'waste-photos', false),
  ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- ============ RLS STORAGE: WASTE-PHOTOS ============
-- Object foto bukti disimpan di path "userId/..."; hanya pemilik yang bisa
-- upload/baca, admin dan petugas boleh baca semua (verifikasi).

create policy "waste_photos_insert_own"
  on storage.objects for insert
  with check (
    bucket_id = 'waste-photos'
    and auth.uid() is not null
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "waste_photos_select_own"
  on storage.objects for select
  using (
    bucket_id = 'waste-photos'
    and auth.uid() is not null
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "waste_photos_select_all_staff"
  on storage.objects for select
  using (
    bucket_id = 'waste-photos'
    and public.is_admin_or_petugas()
  );

-- ============ RLS STORAGE: AVATARS ============
-- Bucket publik untuk baca; upload/update hanya oleh pemilik di path
-- "userId/avatar.jpg".

create policy "avatars_select_all"
  on storage.objects for select
  using (bucket_id = 'avatars');

create policy "avatars_insert_own"
  on storage.objects for insert
  with check (
    bucket_id = 'avatars'
    and auth.uid() is not null
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "avatars_update_own"
  on storage.objects for update
  using (
    bucket_id = 'avatars'
    and auth.uid() is not null
    and (storage.foldername(name))[1] = auth.uid()::text
  );