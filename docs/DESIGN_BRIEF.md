# DESIGN BRIEF - Go Green

Dokumen ini berisi sumber desain, status mockup, komponen awal, token awal,
dan catatan aset untuk project Go Green.

## Sumber Desain

- Belum ada file Figma/mockup eksternal. Desain berdasarkan prinsip di
  docs/DESIGN_SYSTEM.md.
- Referensi visual: material design 3 + pendekatan hijau natural.

## Status Halaman (Mockup)

| Halaman           | Status         | Catatan                 |
| ----------------- | -------------- | ----------------------- |
| Splash            | Belum ada mockup | Desain: logo + nama   |
| Onboarding        | Belum ada mockup | 3 slide pengantar      |
| Login             | Belum ada mockup | Form sederhana         |
| Register          | Belum ada mockup | Form + validasi        |
| Home              | Belum ada mockup | Ringkasan + aksi cepat |
| Buang Sampah      | Belum ada mockup | Kamera + GPS + hash    |
| Scan QR           | Belum ada mockup | Viewfinder QR          |
| Verifikasi        | Belum ada mockup | Status + detail        |
| Poin & Reward     | Belum ada mockup | Saldo + daftar reward  |
| Aktivitas         | Belum ada mockup | Daftar riwayat         |
| Artikel           | Belum ada mockup | Daftar + detail        |
| Profile           | Belum ada mockup | Statistik + menu       |

## Komponen yang Perlu Dibuat

1. PrimaryButton, SecondaryButton, TextButton
2. CustomTextField, SearchField
3. InfoCard, PointCard, RewardCard, ActivityCard, ArticleCard
4. CustomBottomNavBar, CustomAppBar
5. LoadingIndicator, EmptyState, ErrorState
6. Avatar, Badge, StatItem
7. StatusChip, ProgressBar

## Token Awal

Token sudah didefinisikan di docs/DESIGN_SYSTEM.md:
- 23 color token
- 10 typography token
- 5 spacing token
- 7 radius token
- 3 elevation token

## Catatan Aset

- File font (TTF) Manrope dan Geist sudah tersedia di assets/fonts/.
- Icon custom belum dibuat. Perlu SVG icon untuk MVP.
- Gambar onboarding belum dibuat.
- App icon belum dibuat.
- Splash image belum dibuat.

## Status

- Desain: dalam proses (prinsip sudah didefinisikan, belum ada visual mockup).
- Token: sudah final untuk MVP.
- Komponen: daftar sudah ditentukan, belum diimplementasi.