# API - Go Green

Dokumentasi permukaan API yang dipakai aplikasi. Backend utama adalah
Supabase (PostgREST + Auth + Storage); tidak ada REST custom dan belum
ada Edge Function. Sumber kebenaran skema tetap
docs/DATABASE_SCHEMA.md; arsitektur data di docs/ARCHITECTURE.md
bagian 10.

Terakhir update: 2026-10-01
Status sinkron migrasi: 001-026 Local = Remote.

---

## 1. Gambaran

| Lapisan | Teknologi | Keterangan |
|---|---|---|
| Data | PostgREST (auto dari tabel) | CRUD tabel via supabase_flutter, dibatasi RLS |
| Auth | Supabase Auth | Email/password, OAuth Google, user_metadata |
| RPC | Fungsi Postgres | `get_email_by_username` (login username) |
| File | Supabase Storage | Bucket `waste-photos` (private), `avatars` (public read) |
| Wilayah | API publik read-only | `emsifa.github.io/api-wilayah-indonesia` + Nominatim reverse-geocode |
| Push | Firebase Cloud Messaging | Token disimpan di `profiles.fcm_token` |

Base URL dan anon key dibaca dari `.env` (`SUPABASE_URL`,
`SUPABASE_ANON_KEY`); dilarang hardcode di kode. Semua request
autentikasi memakai JWT user; RLS menegakkan batas akses di server.

---

## 2. Auth (Supabase Auth)

Implementasi: `lib/features/auth/data/datasources/auth_remote_datasource.dart`.

| Operasi | Mekanisme | Catatan |
|---|---|---|
| Register | `signUpWithEmail` + metadata `username`, `display_name` | Trigger `handle_new_user` membuat baris profiles (username lowercase, unik) |
| Login email/username | Username di-resolve ke email via RPC `get_email_by_username`, lalu `signInWithEmail` | Error login sengaja generik (anti-enumerasi) |
| Login Google | OAuth + `redirectTo io.supabase.gogreen://login-callback` | Deep link Android/iOS; repository menunggu sesi via `authStateChanges` maks 120 detik |
| Logout | `signOut` | Token push dibersihkan via `push_token_datasource.clearToken` |
| Sesi | `authStateChanges` (stream) | Sumber kebenaran status login di `authNotifierProvider` |
| Edit profil | `updateUserMetadata` (`display_name`, `phone`) | Email baca-saja; `display_name`/`phone` hanya di user_metadata, bukan kolom profiles |
| Cek username | Query `profiles` via `ilike` + constraint unik `profiles_username_key` | Penegak akhir di database |

---

## 3. RPC (fungsi Postgres)

### 3.1 `get_email_by_username(p_username text) -> text`

- Migration 011. `LANGUAGE sql STABLE SECURITY DEFINER`, grant ke
  `anon` + `authenticated` (dipanggil sebelum login).
- Join `auth.users` + `profiles`, case-insensitive, `limit 1`.
- Tradeoff: membuka enumerasi username ke email; diterima untuk MVP,
  perketat dengan rate limit bila disalahgunakan.

### 3.2 `generate_voucher_code() -> text`

- Migration 025. Loop acak 8 karakter heksadesimal uppercase sampai
  unik di `redemptions.voucher_code`.
- Catatan: klien saat ini membuat kode voucher sendiri
  (`Uuid().v4()` 8 karakter di `points_remote_datasource`); fungsi
  SQL tersedia sebagai pembantu sisi server.

---

## 4. Operasi tabel per fitur

Implementasi: `lib/features/*/data/datasources/*_remote_datasource.dart`.
Hak akses diringkas; detail RLS di docs/DATABASE_SCHEMA.md.

### 4.1 Checkpoints (`checkpoint_remote_datasource.dart`)

| Operasi | Akses |
|---|---|
| `getAllCheckpoints`, `getActiveCheckpoints`, `getNearbyCheckpoints`, `getCheckpointById`, `getCheckpointByQrCode` | Baca publik; klien user memfilter `is_active = true` dan menghitung jarak via `Geolocator.distanceBetween` |
| `createCheckpoint`, `updateCheckpoint`, `insertCheckpoint`, `updateCheckpointRecord`, `deleteCheckpoint` | Admin saja (RLS); hapus permanen tidak dipakai UI (pakai soft-delete) |
| `deactivateCheckpoint`, `activateCheckpoint` | Admin saja; soft-delete via `is_active` + audit log |

### 4.2 Waste logs (`waste_remote_datasource.dart`)

| Operasi | Akses |
|---|---|
| `uploadPhoto` (ke `waste-photos/<userId>/`), `insertWasteLog` (+ kolom forensik `risk_score`/`exif_ok`/`risk_detail`), `getWasteLogs(userId)`, `checkDuplicateHash`, `countTodayWasteLogs` | Pemilik data |
| `getPendingWasteLogs`, `verifyWasteLog`, `approveWasteLog` (+ insert `points` earn), `rejectWasteLog` (+ `notes`) | Admin/petugas |
| `getPhotoSignedUrl` (default 3600 detik) | Baca sesuai RLS storage |

Server-side (trigger `auto_verify_waste_trigger`, migration 024/025):
insert waste_logs otomatis `verified` + `verified_at`, atau `pending`
dengan `rejection_reason`: `duplicate_hash`, `rate_limit_exceeded`
(5/hari), `gps_out_of_range`, `checkpoint_inactive`,
`checkpoint_limit_reached` (sisa kuota 0, decrement
`remaining_uses`), `invalid_category`.

### 4.3 Points (`points_remote_datasource.dart`)

| Operasi | Akses |
|---|---|
| `getTotalPoints` (earn minus redeem), `getPointsHistory` | Pemilik data; admin baca semua |
| `addPoints` (earn), `redeemPoints` (redeem + `voucher_code`, `reference_id`) | Insert sendiri, `amount` 1-50 (migration 015); pengerasan server-side fase lanjut |

### 4.4 Rewards dan redemptions (`reward_remote_datasource.dart`)

| Operasi | Akses |
|---|---|
| `getAllRewards` (aktif saja), `getRewardById`, `getUserRedemptions` | User |
| `getAllForAdmin` (termasuk nonaktif), `createReward`, `updateReward`, `setRewardActive`, `deleteReward` | Admin saja (migration 018) |
| `redeemReward` (mengembalikan voucher code) | User (insert sendiri) |

### 4.5 Articles (`article_remote_datasource.dart`)

| Operasi | Akses |
|---|---|
| `getAllArticles`, `getArticleById` | Publik (anon + authenticated); tulis hanya admin |

### 4.6 Admin (`admin_*_datasource.dart`)

| Operasi | Akses |
|---|---|
| `admin_dashboard_datasource.getSummary` (total user/TPS/setoran hari ini/pending/poin beredar), `getWeeklyWasteTimestamps` (grafik 7 hari) | Admin/petugas baca |
| `admin_users_datasource.getUsers` (limit 50, terbaru), `updateRole` (cegah self-demote di domain) | Admin (migration 018) |
| `admin_settings_datasource.getAll` (baca publik, berlaku sebelum login), `saveAll` (upsert, admin saja) | Tabel `app_settings` (migration 019 + seed 022) |
| `admin_audit_datasource.log` (best effort, gagal insert tidak menggagalkan aksi), `getRecent` (50 terbaru) | Admin (tabel append-only, migration 020) |
| `admin_profile_datasource.getRole` | Baca role untuk routing shell |

### 4.7 Push token (`push_token_datasource.dart`)

| Operasi | Akses |
|---|---|
| `saveToken` / `clearToken` (`profiles.fcm_token`, migration 026) | Pemilik akun (policy `update_own`); admin membaca semua |

---

## 5. Storage

Migration 008. Bucket `waste-photos` (private) dan `avatars`
(public read).

| Bucket | Path | Tulis | Baca |
|---|---|---|---|
| `waste-photos` | `<userId>/<timestamp>_<hash>.jpg` | Pemilik ke folder sendiri | Pemilik + admin/petugas semua (verifikasi); akses via signed URL |
| `avatars` | `<userId>/avatar.jpg` | Pemilik ke path sendiri | Publik |

---

## 6. API eksternal (read-only, tanpa key)

Implementasi: `lib/features/regions/data/datasources/region_remote_datasource.dart`
(dio, cache memory, retry 3x daftar / 2x reverse-geocode, timeout
10/15 detik).

| Endpoint | Fungsi |
|---|---|
| `https://emsifa.github.io/api-wilayah-indonesia/api/provinces.json` | Daftar provinsi |
| `.../regencies/{provinceId}.json` | Kota/kabupaten per provinsi |
| `.../districts/{cityId}.json` | Kecamatan per kota |
| `https://nominatim.openstreetmap.org/reverse` | Reverse-geocode GPS ke kelurahan/alamat (hemat sesuai kebijakan Nominatim) |

---

## 7. Yang belum ada (rencana)

- Edge Function: validasi anti-kecurangan lanjutan, AI forensics,
  approval berjenjang (fase 2+; secret dilarang di klien).
- Rate limit dan insert poin sisi server (pengganti policy insert
  klien MVP).
- PostGIS (`ST_DWithin`) bila checkpoint sudah banyak; saat ini
  hitung jarak di klien.

---

## 8. Referensi

- Skema, RLS, storage, seed: docs/DATABASE_SCHEMA.md.
- Alur data, datasource, auth, deep link: docs/ARCHITECTURE.md
  bagian 10.
- Anti-kecurangan dan data sensitif:
  docs/SECURITY_AND_VALIDATION.md.
- Referensi REST generik Supabase ada di dashboard proyek
  (Table Editor / API docs); dokumen ini hanya merangkum yang
  dipakai aplikasi.
