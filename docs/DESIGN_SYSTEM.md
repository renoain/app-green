# DESIGN SYSTEM - Go Green

Dokumen ini berisi seluruh design token yang dipakai di Go Green. Semua widget
wajib merujuk ke token ini, dilarang hardcode warna/spacing/radius.

## 1. Prinsip Desain

- Bersih, tenang, ramah lingkungan.
- Dominasi hijau natural, bukan hijau neon.
- Tipografi jelas, spacing rapi (kelipatan 4).
- Hierarki visual kuat tanpa dekorasi berlebih.
- Anti-AI-slop: tidak ada gradient mencolok, shadow blur besar, ikon estetik
  tanpa makna.

## 2. Color Tokens

### Primary

| Token                | Hex       | Kegunaan                          |
| -------------------- | --------- | --------------------------------- |
| color-primary        | #1E4633   | Warna utama (tombol, header)      |
| color-primary-light  | #2D6A4F   | Hover, aktif, accent              |
| color-primary-dark   | #042F1E   | Status pressed, teks gelap        |

### Secondary

| Token                   | Hex       | Kegunaan                        |
| ----------------------- | --------- | ------------------------------- |
| color-secondary         | #52B788   | Ikon, accent, badge             |
| color-secondary-light   | #74C69D   | Hover, lighter accent           |
| color-secondary-container | #92F7C3 | Latar badge, tag                 |

### Tertiary

| Token               | Hex       | Kegunaan                           |
| ------------------- | --------- | ---------------------------------- |
| color-tertiary      | #A3C9A8   | Border aktif, separator            |
| color-tertiary-light| #D8E8D5   | Latar card alternatif              |

### Background

| Token           | Hex       | Kegunaan                          |
| --------------- | --------- | --------------------------------- |
| color-bg        | #EAF4E8   | Latar utama aplikasi              |
| color-bg-alt    | #F4F8F3   | Latar alternatif, input field     |

### Surface

| Token            | Hex       | Kegunaan                          |
| ---------------- | --------- | --------------------------------- |
| color-surface    | #FFFFFF   | Card, sheet, modal                |
| color-surface-dim| #E6F8ED   | Card disabled, skeleton           |

### Text

| Token              | Hex       | Kegunaan                        |
| ------------------ | --------- | ------------------------------- |
| color-text-primary | #24332C   | Teks utama, judul               |
| color-text-secondary | #6B7F75 | Teks sekunder, deskripsi         |
| color-text-disabled| #8FA599   | Teks disabled                    |
| color-text-on-primary | #FFFFFF| Teks di atas primary             |

### Status

| Token         | Hex       | Kegunaan                           |
| ------------- | --------- | ---------------------------------- |
| color-success | #52B788   | Berhasil, poin bertambah           |
| color-warning | #F4A261   | Peringatan                         |
| color-error   | #BA1A1A   | Gagal, validasi error              |
| color-info    | #4A90E2   | Informasi                          |

### Border & Outline

| Token              | Hex       | Kegunaan                         |
| ------------------ | --------- | -------------------------------- |
| color-border       | #D4E4D3   | Border default                   |
| color-border-light | #E2EFE0   | Border ringan                    |
| color-outline      | #717973   | Outline aktif, focus             |

## 3. Typography

### Font

- Headlines: Manrope (bold, semibold)
- Body/Label: Geist (regular, medium, semibold)

### Type Scale

| Token          | Font      | Size | Weight | Line Height | Letter Spacing |
| -------------- | --------- | ---- | ------ | ----------- | -------------- |
| headline-xl    | Manrope   | 32   | 700    | 40          | -0.02em        |
| headline-lg    | Manrope   | 24   | 700    | 32          | -0.015em       |
| headline-md    | Manrope   | 20   | 600    | 28          | 0              |
| headline-sm    | Manrope   | 18   | 600    | 24          | 0              |
| body-lg        | Geist     | 16   | 400    | 24          | 0              |
| body-md        | Geist     | 14   | 400    | 20          | 0              |
| body-sm        | Geist     | 12   | 400    | 16          | 0              |
| label-lg       | Geist     | 15   | 600    | 20          | 0              |
| label-md       | Geist     | 13   | 500    | 18          | 0              |
| label-sm       | Geist     | 11   | 600    | 14          | 0.02em         |

## 4. Spacing

Semua spacing kelipatan 4.

| Token     | Value (px) |
| --------- | ---------- |
| space-xs  | 4          |
| space-sm  | 8          |
| space-md  | 16         |
| space-lg  | 24         |
| space-xl  | 32         |

## 5. Border Radius

| Token        | Value (px) |
| ------------ | ---------- |
| radius-sm    | 4          |
| radius-md    | 8          |
| radius-lg    | 12         |
| radius-xl    | 16         |
| radius-2xl   | 20         |
| radius-sheet | 32         |
| radius-full  | 9999       |

## 6. Elevation (Box Shadow)

| Token        | Value                                               |
| ------------ | --------------------------------------------------- |
| elevation-1  | 0 4px 20px rgba(30, 70, 51, 0.05)                  |
| elevation-2  | 0 8px 30px rgba(30, 70, 51, 0.12)                  |
| elevation-3  | 0 12px 24px rgba(30, 70, 51, 0.25)                 |

## 7. Komponen Standar

### Button

- Primary: bg color-primary, text color-text-on-primary.
- Secondary: bg color-surface, border color-border, text color-primary.
- Disabled: bg color-surface-dim, text color-text-disabled.
- Loading: ganti child widget dengan CircularProgressIndicator kecil.
- Height: 48px (md), 56px (lg).
- Border radius: radius-lg.

### Input

- Border: color-border. Focus: color-outline, 2px.
- Placeholder: color-text-disabled.
- Label: label-md, color-text-primary.
- Error: color-error, body-sm.
- Background: color-bg-alt (default), color-surface (outlined).
- Border radius: radius-md.

### Card

- Background: color-surface.
- Border: color-border-light, 1px.
- Elevation: elevation-1.
- Border radius: radius-lg.
- Padding: space-md.
- Horizontal padding: space-md, vertical padding: space-sm.

### Bottom Navigation

- Background: color-surface.
- Selected: color-primary. Unselected: color-text-secondary.
- Icon size: 24px.
- Elevation: elevation-2.
- Height: 64px (body + bottom safe area).

## 8. Aturan Anti-AI-Slop

- Maksimal 3 warna dominan per halaman.
- Tidak ada gradient formless atau mesh gradient.
- Tidak ada shadow blur > 30px.
- Tidak ada border radius > 20px untuk card (kecuali sheet).
- Tidak ada dekorasi estetik tanpa fungsi.
- Empty state, loading, error state wajib dipertimbangkan.

## 9. Aturan Pemakaian Token

- Gunakan AppColors, AppSpacing, AppRadius, AppTypography, AppElevation
  di lib/core/theme/.
- Dilarang pakai Color(0xFF...) langsung di widget.
- Dilarang pakai EdgeInsets.all(...) atau BorderRadius.circular(...) langsung
  di widget.
- Referensi ke .opencode/rules/03-design.md untuk detail implementasi.