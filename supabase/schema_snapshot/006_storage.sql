-- Baseline 006: storage (salinan idempoten dari 008).
-- Jalankan setelah 004. Referensi: docs/DATABASE_SCHEMA.md bagian 4.

insert into storage.buckets (id, name, public)
values
  ('waste-photos', 'waste-photos', false),
  ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- Kebijakan waste-photos: path userId/... milik sendiri, staff boleh baca.
drop policy if exists "waste_photos_insert_own" on storage.objects;
create policy "waste_photos_insert_own"
  on storage.objects for insert
  with check (
    bucket_id = 'waste-photos'
    and auth.uid() is not null
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "waste_photos_select_own" on storage.objects;
create policy "waste_photos_select_own"
  on storage.objects for select
  using (
    bucket_id = 'waste-photos'
    and auth.uid() is not null
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "waste_photos_select_all_staff" on storage.objects;
create policy "waste_photos_select_all_staff"
  on storage.objects for select
  using (
    bucket_id = 'waste-photos'
    and public.is_admin_or_petugas()
  );

-- Kebijakan avatars: bucket publik untuk baca, tulis milik sendiri.
drop policy if exists "avatars_select_all" on storage.objects;
create policy "avatars_select_all"
  on storage.objects for select
  using (bucket_id = 'avatars');

drop policy if exists "avatars_insert_own" on storage.objects;
create policy "avatars_insert_own"
  on storage.objects for insert
  with check (
    bucket_id = 'avatars'
    and auth.uid() is not null
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "avatars_update_own" on storage.objects;
create policy "avatars_update_own"
  on storage.objects for update
  using (
    bucket_id = 'avatars'
    and auth.uid() is not null
    and (storage.foldername(name))[1] = auth.uid()::text
  );
