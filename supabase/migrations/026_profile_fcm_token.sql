-- Migration 026: kolom fcm_token di profiles (push notification).
-- Referensi: docs/ARCHITECTURE.md (push notification).
-- Idempoten: aman dijalankan ulang.
--
-- Token ditulis oleh pemilik akun (policy update_own sudah mencakup
-- kolom ini karena check hanya mengunci role); admin membaca semua.

alter table public.profiles
  add column if not exists fcm_token text;

comment on column public.profiles.fcm_token is 'Token FCM perangkat untuk push notification.';
