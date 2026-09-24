-- Migration 020: tabel admin_audit_logs (jejak aksi admin).
-- Referensi: docs/PRD_ADMIN.md prioritas fase 2 (audit log),
-- docs/DATABASE_SCHEMA.md 3.9.
-- Idempoten: aman dijalankan ulang.
--
-- Append-only: hanya policy baca + insert untuk admin (tanpa
-- update/delete) sehingga jejak tidak bisa diubah dari klien.

create table if not exists public.admin_audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references auth.users (id) on delete set null,
  action text not null,
  entity text not null,
  entity_id text,
  detail text,
  created_at timestamptz not null default timezone('utc', now())
);

comment on table public.admin_audit_logs is 'Jejak aksi admin (tambah/ubah/hapus/verifikasi).';

create index if not exists admin_audit_logs_created_at_idx
  on public.admin_audit_logs (created_at desc);

create index if not exists admin_audit_logs_actor_idx
  on public.admin_audit_logs (actor_id);

alter table public.admin_audit_logs enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policy
    where polname = 'admin_audit_logs_select_admin'
  ) then
    create policy "admin_audit_logs_select_admin"
      on public.admin_audit_logs for select
      using (public.is_admin());
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_policy
    where polname = 'admin_audit_logs_insert_admin'
  ) then
    create policy "admin_audit_logs_insert_admin"
      on public.admin_audit_logs for insert
      with check (public.is_admin());
  end if;
end $$;
