-- Migration 007: trigger otomatis pembuatan profiles saat user baru daftar.
-- Referensi skema: docs/DATABASE_SCHEMA.md bagian 3.1 (Trigger).

-- ============ HANDLE_NEW_USER ============
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
    coalesce(
      nullif(trim(new.raw_user_meta_data ->> 'username'), ''),
      split_part(coalesce(new.email, ''), '@', 1)
    )
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

-- ============ TRIGGER ============
create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();