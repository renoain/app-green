# Mode Dummy (json-server)

Server REST lokal untuk testing tanpa Supabase. Struktur data sama
dengan docs/DATABASE_SCHEMA.md (file `db.json` di folder ini).

## Cara install

```bash
npm install -g json-server
```

## Cara jalankan

```bash
cd docs/dummy
json-server --watch db.json --port 3000
```

Cek di browser: http://localhost:3000/checkpoints

## Cara pakai mode dummy di aplikasi

1. Salin `.env.example` menjadi `.env` bila belum ada.
2. Isi `.env`:

```env
USE_DUMMY_API=true
DUMMY_API_URL=http://localhost:3000
```

3. Jalankan aplikasi seperti biasa (`flutter run`).
4. Provider otomatis memakai `*_dummy_datasource.dart` (dio ke json-server).

## Akun dummy (auth json-server)

Register/login di mode dummy baca/tulis tabel `profiles`
via `DummyAuthRepository` (password plain text, khusus testing):

| Email | Username | Password | Role |
|---|---|---|---|
| user@green.com | user | password123 | user |
| admin@green.com | admin | password123 | admin |
| petugas@green.com | petugas | password123 | petugas |

Login bisa pakai email atau username. Register akun baru
(`POST /profiles`) otomatis tersimpan ke `db.json` bila server
jalan dengan `--watch`. Sesi dummy hanya di memori (hilang saat
restart aplikasi); login Google tidak didukung di mode dummy.

## Edit profil di mode dummy

Halaman Edit Profile saat `USE_DUMMY_API=true` membaca dan menulis
langsung ke tabel `profiles` di json-server via
`ProfileDummyDatasource` (tanpa phone, sesuai permintaan):

- GET `http://localhost:3000/profiles/00000000-0000-0000-0000-000000000001`
- PATCH nama (username) dan email, contoh:

```bash
curl -X PATCH http://localhost:3000/profiles/00000000-0000-0000-0000-000000000001 -H "Content-Type: application/json" -d "{\"username\":\"baru\",\"email\":\"baru@green.com\"}"
```

Cek perubahan: buka ulang GET di atas atau lihat `db.json`
(json-server `--watch` menyimpan otomatis). Field telepon
disembunyikan di mode dummy; di mode Supabase telepon tetap ada dan
email baca-saja (hanya user_metadata auth).

## Cara kembali ke Supabase

```env
USE_DUMMY_API=false
```

Default adalah Supabase bila saklar tidak diisi.

## Batasan json-server

- Tanpa auth: semua request anonim, user id diisi manual oleh pemanggil.
- Tanpa RLS: policy Supabase tidak berlaku, semua operasi diizinkan.
- Tanpa storage: upload foto dilewati, `photo_url` diisi path apa adanya.
- Tanpa trigger server: status waste_logs tidak auto-verify, timestamp diisi klien.
- Tanpa realtime dan tanpa signed URL.
- ID record baru dibuat sebagai UUID oleh datasource dummy.

Jangan pakai mode dummy untuk data asli atau demo ke user.
