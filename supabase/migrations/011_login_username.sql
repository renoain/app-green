-- Migration 011: login dengan username + display_name di metadata.
--
-- - Memastikan unique constraint username di profiles (idempoten).
-- - RPC get_email_by_username: mencari email auth dari username untuk
--   alur login username (Supabase Auth hanya menerima email).
--   SECURITY DEFINER + grant ke anon/authenticated karena dipanggil
--   sebelum user login. Catatan: membuka enumerasi username->email;
--   dapat diterima untuk MVP, perketat dengan rate limit bila perlu.
-- - Trigger handle_new_user: username dinormalisasi lowercase;
--   display_name tetap tersimpan di user_metadata (tidak ada kolom baru,
--   tidak ada perubahan tabel/RLS).
--
-- Referensi skema: docs/DATABASE_SCHEMA.md.

-- ============ UNIQUE USERNAME (IDEMPOTEN) ============
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'profiles_username_key'
  ) then
    alter table public.profiles
      add constraint profiles_username_key unique (username);
  end if;
end $$;

-- ============ RPC: EMAIL DARI USERNAME ============
create or replace function public.get_email_by_username(p_username text)
returns text
language sql
stable
security definer
set search_path = public
as $$
  select au.email
  from auth.users au
  join public.profiles p on p.id = au.id
  where lower(p.username) = lower(p_username)
  limit 1;
$$;

comment on function public.get_email_by_username(text) is
  'Mencari email auth dari username untuk login username (MVP).';

grant execute on function public.get_email_by_username(text)
  to anon, authenticated;

-- ============ TRIGGER: NORMALISASI USERNAME ============
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, username)
  values (
    new.id,
    coalesce(new.email, ''),
    lower(coalesce(
      nullif(trim(new.raw_user_meta_data ->> 'username'), ''),
      split_part(coalesce(new.email, ''), '@', 1)
    ))
  )
  on conflict (id) do nothing;
  return new;
end;
$$;
