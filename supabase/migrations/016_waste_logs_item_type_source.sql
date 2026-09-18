-- Migration 016: tambah kolom item_type + source ke waste_logs.
--
-- Latar: kolom item_type (sub-jenis sampah) dan source (qr_scan/manual/nfc)
-- sebelumnya ditambahkan lewat edit langsung ke file 003 yang sudah
-- applied di remote, sehingga remote tidak pernah menerimanya. Perbaikan:
-- 003 dikembalikan ke versi applied, kolom ditambah lewat migration baru
-- ini agar bisa di-push ke remote.
-- Idempoten (IF NOT EXISTS) sehingga aman bila kolom sudah ada di local.

alter table public.waste_logs
  add column if not exists item_type text;

alter table public.waste_logs
  add column if not exists source text not null default 'manual'
    check (source in ('qr_scan', 'manual', 'nfc'));

comment on column public.waste_logs.item_type is 'Sub-jenis atau keterangan kategori sampah.';
comment on column public.waste_logs.source is 'Asal data: qr_scan (scan QR), manual (pilih manual), nfc (ketuk NFC, fase 2).';
