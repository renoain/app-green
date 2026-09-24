-- Migration 021: kolom is_active di checkpoints (soft-delete TPS).
-- Referensi: docs/PRD_ADMIN.md bagian 6.2, docs/DATABASE_SCHEMA.md 3.2.
-- Idempoten: aman dijalankan ulang; baris lama default true (tetap tampil).
--
-- Sebelumnya nonaktifkan = hapus permanen karena kolom tidak ada.
-- Setelah ini nonaktifkan = update is_active=false; daftar user hanya
-- membaca yang aktif.

alter table public.checkpoints
  add column if not exists is_active boolean not null default true;

create index if not exists checkpoints_is_active_idx
  on public.checkpoints (is_active);

comment on column public.checkpoints.is_active is 'Status aktif TPS (soft-delete admin).';
