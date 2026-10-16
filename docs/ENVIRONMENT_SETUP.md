# ENVIRONMENT_SETUP - Go Green

Panduan konfigurasi environment aplikasi Go Green.

## 1. Kenapa Tidak Pakai .env Saja

Sebelumnya `.env` didaftarkan sebagai asset di `pubspec.yaml` supaya bisa dibaca
`flutter_dotenv`. Konsekuensinya, file `.env` ikut ter-bundle ke dalam APK dan
IPA, sehingga credential yang ada di dalamnya bisa diekstrak siapa saja yang
memiliki file aplikasi.

Sejak perubahan ini `.env` sengaja tidak lagi didaftarkan sebagai asset.
Konfigurasi aplikasi dibaca lewat `--dart-define`, dan `dotenv` hanya
dipakai sebagai fallback lokal bila tersedia.

## 2. Cara Menjalankan Lokal

Isi credential lewat `--dart-define` saat menjalankan atau membangun:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<anon-key> \
  --dart-define=DATA_SOURCE=supabase
```

Untuk mode dummy (tanpa Supabase):

```bash
flutter run --dart-define=DATA_SOURCE=dummy --dart-define=DUMMY_API_URL=http://localhost:3001
```

Untuk mode Laravel:

```bash
flutter run --dart-define=DATA_SOURCE=laravel --dart-define=LARAVEL_API_URL=http://127.0.0.1:8000/api
```

## 3. Build Rilis

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<anon-key> \
  --dart-define=DATA_SOURCE=supabase
```

Ganti tanda `<...>` di CI/CD lewat secret, jangan ditulis literal di repo.

## 4. Daftar Key

| Key | Wajib | Keterangan |
| --- | --- | --- |
| `SUPABASE_URL` | Ya | URL project Supabase. |
| `SUPABASE_ANON_KEY` | Ya | Kunci publishable Supabase. Aman dipublikasikan karena RLS yang melindungi data, tapi RLS harus benar. |
| `DATA_SOURCE` | Tidak | `supabase` (default), `dummy`, atau `laravel`. |
| `LARAVEL_API_URL` | Tidak | Base URL API Laravel. Default `http://127.0.0.1:8000/api`. |
| `DUMMY_API_URL` | Tidak | Base URL json-server. Default `http://localhost:3000`. |
| `USE_DUMMY_API` | Tidak | Flag lama, dipakai hanya bila `DATA_SOURCE` kosong. |

## 5. Aturan Pengaruh Key

- Jangan menaruh API key pihak ketiga yang tidak perlu ada di sisi klien
  (kunci AI, kunci analitik, kunci Stitch) di konfigurasi aplikasi. Nilai
  seperti itu akan terbaca oleh siapa pun yang memakai aplikasi.
- `.env` tetap berguna sebagai catatan lokal, tetapi jangan di-commit.
  `.gitignore` sudah menutup `.env` dan mengizinkan `.env.example`.
- Kalau sebuah key pernah ikut ter-bundle pada build yang sudah dibagikan,
  anggap key tersebut bocor dan rotasi di sisi penyedia jasanya.

## 6. Penyimpanan Token Sesi

Token sesi Laravel Sanctum disimpan lewat `lib/core/services/token_storage.dart`
di keystore perangkat:

- Android: EncryptedSharedPreferences di Android Keystore.
- iOS: Keychain dengan aksesibilitas `first_unlock`.
- Fallback: penyimpanan in-memory, dipakai bila keystore tidak tersedia
  (web, Linux tanpa keyring, lingkungan widget test).

Nilai token lama yang masih ada di `SharedPreferences` dipindahkan ke keystore
sekali lalu dihapus dari sana.