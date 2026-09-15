# ASSET MANAGEMENT - Go Green

Dokumen ini menjelaskan struktur, format, dan aturan pengelolaan aset di
Go Green.

## Struktur Folder

```
assets/
  icons/custom/      -> SVG icon custom (pelapakan nama spesifik)
  images/            -> PNG/JPEG gambar UI (logo, ilustrasi, foto placeholder)
  fonts/             -> file font TTF (Manrope, Geist)
  splash/            -> gambar splash screen
  app_icon/          -> icon aplikasi (berbagai resolusi)
```

## Format

| Kategori    | Format                | Catatan                                  |
| ----------- | --------------------- | ---------------------------------------- |
| Icon custom | SVG                   | Diakses via flutter_svg                  |
| Gambar UI   | PNG                   | Resolusi 1x/2x/3x atau adaptive          |
| Font        | TTF                   | Untuk Manrope (4 bobot) dan Geist (3 bobot) |
| Splash      | PNG/SVG               | Background splash screen                 |
| App icon    | PNG (berbagai ukuran) | Ikuti standar Android/iOS                |

## Penamaan File

- Semua file pakai snake_case.
- Icon custom diawali prefix kategori:
  - ic_ - ikon umum (ic_checkpoint, ic_camera, ic_leaf).
  - logo_ - logo (logo_go_green, logo_go_green_white).
- Gambar UI: deskriptif (onboarding_1.png, empty_state.png).
- Font: font_manrope_regular.ttf, font_geist_medium.ttf.

## Deklarasi di pubspec.yaml

Semua aset dideklarasikan di bagian flutter.assets:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/custom/
    - assets/splash/
    - assets/app_icon/
```

Font dideklarasikan di bagian flutter.fonts dengan family name Manrope
dan Geist sesuai file TTF.

## Aset yang Sudah Ada

### Font

| File                           | Family  | Weight | Status |
| ------------------------------ | ------- | ------ | ------ |
| font_manrope_regular.ttf       | Manrope | 400    | Ada    |
| font_manrope_medium.ttf        | Manrope | 500    | Ada    |
| font_manrope_semibold.ttf      | Manrope | 600    | Ada    |
| font_manrope_bold.ttf          | Manrope | 700    | Ada    |
| font_geist_regular.ttf         | Geist   | 400    | Ada    |
| font_geist_medium.ttf          | Geist   | 500    | Ada    |
| font_geist_semibold.ttf        | Geist   | 600    | Ada    |

### Icon Custom (MVP)

TBD: icon-icon yang perlu dibuat:
- Logo Go Green (logo_go_green.svg)
- Checkpoint (ic_checkpoint.svg)
- Camera (ic_camera.svg)
- Leaf / recycle (ic_leaf.svg)
- QR scan (ic_scan.svg)
- Poin (ic_point.svg)
- Reward (ic_reward.svg)
- History (ic_history.svg)
- Article (ic_article.svg)
- Profile (ic_profile.svg)
- Logout (ic_logout.svg)

### Images (MVP)

TBD: gambar yang perlu disiapkan:
- Onboarding (3 gambar)
- Empty state (1-2 gambar)
- Splash background (opsional)

Catatan: beberapa gambar referensi di `assets/images/ref/` sementara
dipakai langsung di halaman Home sebagai aset produksi (hero banner dan
thumbnail artikel) sampai aset final tersedia. Gambar yang dipakai:
- `home_promo.png` → hero banner Home
- `article_1.png`, `article_2.png` → thumbnail artikel di Home
Path konstanta ada di `AppAssets` (homeBannerHero, articleThumb1,
articleThumb2). Ganti dengan aset produksi akhir ketika tersedia.

### App Icon

TBD: icon aplikasi Android dan iOS.

## Aturan

- Tambah aset baru: buat file, letakkan di folder sesuai kategori, deklarasikan
  di pubspec.yaml jika belum tercakup, referensikan lewat
  lib/core/constants/app_assets.dart.
- Hapus aset: pastikan tidak direferensikan di kode, hapus dari
  app_assets.dart, hapus deklarasi di pubspec.yaml jika hanya satu file di
  folder, lalu hapus filenya.
- Dilarang hardcode path aset di widget. Gunakan konstanta AppAssets.