-- Migration 023: kolom forensik foto di waste_logs.
-- Referensi: docs/SECURITY_AND_VALIDATION.md (forensik on-device),
-- docs/DATABASE_SCHEMA.md 3.3.
-- Idempoten: aman dijalankan ulang; baris lama null (belum dinilai).
--
-- Skor dihitung saat submit (EXIF + jarak + frekuensi) dan hanya
-- membantu verifikator; tidak memblokir (status tetap pending).

alter table public.waste_logs
  add column if not exists risk_score integer,
  add column if not exists exif_ok boolean,
  add column if not exists risk_detail text;

comment on column public.waste_logs.risk_score is 'Skor risiko forensik 0-100 (null = belum dinilai).';
comment on column public.waste_logs.exif_ok is 'Apakah foto punya EXIF kamera utuh.';
comment on column public.waste_logs.risk_detail is 'Kode sinyal risiko koma-dipisah (mis. no_exif,far_gps).';
