# Go Green

Aplikasi mobile pengelolaan sampah rumah tangga dengan sistem poin dan reward.
User membuang sampah ke checkpoint terdaftar, mendapat poin, dan menukar poin
dengan reward. Bukti pembuangan dilindungi anti-kecurangan berbasis kamera
in-app, timestamp server, GPS radius, dan hash SHA-256.

## Status Project

- Versi: v0.1.0 (MVP, dalam pengembangan)
- Status: Setup fondasi project
- Detail: lihat docs/PROJECT_OVERVIEW.md

## Tech Stack

- Framework: Flutter (Dart)
- State management: Riverpod
- Routing: go_router
- HTTP: dio
- Backend/BaaS: Supabase (PostgreSQL, Auth, Storage)
- Icon: lucide_icons + flutter_svg
- Font: Manrope + Geist
- Kamera: camera | GPS: geolocator | QR: mobile_scanner
- Hash: crypto (SHA-256) | EXIF: exif
- Local storage: shared_preferences + hive_flutter
- Logger: logger
- Testing: flutter_test + mocktail

## Struktur Folder

```
lib/
  main.dart
  core/
    theme/        -> token warna, tipografi, spacing, radius, elevation
    router/       -> go_router config
    constants/    -> konstanta aset dan string UI
    utils/        -> utility (logger)
    widgets/      -> widget reusable global
    services/     -> service global (supabase)
  features/
    auth/
    home/
    waste/
    points/
    activity/
    article/
    profile/
    splash/
    onboarding/
    scan/
    verification/
    <fitur>/data | domain | presentation/{pages,widgets,providers}
test/
  unit/
  widget/
  integration/
docs/             -> dokumentasi project
assets/
  icons/custom/
  images/
  fonts/
  splash/
  app_icon/
.opencode/        -> rules, skills, agents, commands
```

## Dokumentasi

- PROTOCOL.md - protokol kerja project
- docs/PROJECT_OVERVIEW.md - gambaran produk
- docs/ARCHITECTURE.md - arsitektur kode
- docs/DESIGN_SYSTEM.md - design token (warna, tipografi, spacing)
- docs/DESIGN_BRIEF.md - sumber desain dan status mockup
- docs/UI_PAGES.md - daftar halaman
- docs/COMPONENT_LIBRARY.md - komponen reusable
- docs/GLOSSARY.md - kamus istilah
- docs/TESTING_STRATEGY.md - strategi testing
- docs/ASSET_MANAGEMENT.md - manajemen aset
- docs/SECURITY_AND_VALIDATION.md - anti-kecurangan dan validasi
- CHANGELOG.md - catatan perubahan

## Setup Instructions

1. Salin `.env.example` menjadi `.env` dan isi nilai yang dibutuhkan.
2. `flutter pub get`
3. `flutter run`

Pengembangan:

- `flutter analyze` - cek statis kode.
- `flutter test` - jalankan unit/widget test.
- Ikuti AGENTS.md dan PROTOCOL.md sebelum menulis kode.

## Integrity & Anti-Kecurangan

- Foto bukti wajib dari kamera in-app.
- Timestamp wajib dari server.
- GPS radius checkpoint wajib dicek sebelum upload.
- Hash SHA-256 disimpan dan dicek duplikat.

## Changelog

Lihat [CHANGELOG.md](CHANGELOG.md).

## Lisensi

Proprietary. Belum dipublikasikan.