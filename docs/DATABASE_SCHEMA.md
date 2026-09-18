# DATABASE SCHEMA - Go Green

Sumber kebenaran untuk struktur database Supabase. Semua migration, RLS,
storage, dan seed data mengacu ke dokumen ini.

Versi: 1.0
Terakhir update: 2026-09-15
Platform: Supabase (PostgreSQL)

---

## 1. Prinsip

- Semua tabel di schema `public`.
- Primary key: uuid (default gen_random_uuid()).
- Timestamp: timestamp with time zone, default timezone('utc', now()).
- Semua tabel yang menyimpan data user WAJIB enable RLS.
- Foreign key ke auth.users pakai on delete cascade.
- Foreign key ke tabel lain pakai on delete set null (kecuali butuh cascade).
- Naming: snake_case, plural untuk tabel.
- Role: user, admin, petugas.
- Category sampah: organik, anorganik, b3, daur_ulang.
- Status waste_logs: pending, verified, rejected.
- Status redemptions: pending, approved, rejected, claimed.
- Tipe poin: earn, redeem.

---

## 2. Entity Relationship

```
auth.users (Supabase Auth)
|
| 1:1
v
profiles
|
| 1:N
+--> waste_logs ---> checkpoints
| |
| | 1:N
| v
| points
|
| 1:N
+--> redemptions ---> rewards
```

Relasi:

- `profiles.id` -> `auth.users.id` (1:1).
- `waste_logs.user_id` -> `auth.users.id`.
- `waste_logs.checkpoint_id` -> `checkpoints.id`.
- `waste_logs.verified_by` -> `auth.users.id` (nullable).
- `points.user_id` -> `auth.users.id`.
- `redemptions.user_id` -> `auth.users.id`.
- `redemptions.reward_id` -> `rewards.id`.

---

## 3. Tabel

### 3.1 profiles

Menyimpan data user + role.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | uuid | PK, FK ke auth.users, on delete cascade | Sama dengan auth.users.id |
| email | text | | Dari auth.users.email |
| username | text | unique | Username unik |
| role | text | default 'user', check in ('user','admin','petugas') | Role user |
| created_at | timestamptz | default now() | |

RLS:

- User bisa baca profil sendiri.
- Admin bisa baca semua profil.
- User bisa update profil sendiri (kecuali role).

Trigger:

- `on_auth_user_created` -> panggil `handle_new_user()` saat user baru daftar.
- `handle_new_user()` insert ke profiles dengan username dari metadata atau dari email, dinormalisasi lowercase, role default 'user'.
- `display_name` dan `phone` hanya tersimpan di user_metadata auth (tidak ada kolom baru di profiles).

RPC (migration 011):

- `get_email_by_username(p_username)` -> email auth untuk login username (SECURITY DEFINER, grant anon + authenticated, case-insensitive). Membuka enumerasi username -> email; diterima untuk MVP.
- Login username gagal dengan invalidCredentials padahal password benar hampir pasti karena `profiles.username` tidak cocok (akun lama berisi kapital/spasi/display name, trigger 007 tidak me-lower). Diagnosis: `select email, username from profiles where email = ...` lalu `select get_email_by_username('...')`.

Normalisasi username (migration 013, idempoten):

- `013_normalize_usernames.sql`: me-lower() username lama yang belum lowercase. Baris yang tabrakan unique constraint setelah di-lower() dilewati agar migrasi tidak gagal; perbaiki manual per akun.

Admin (migration 012, idempoten):

- Set role 'admin' + username 'admin' untuk admin@green.com setelah user dibuat di Authentication.

### 3.2 checkpoints

Lokasi pembuangan sampah terdaftar.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | uuid | PK | |
| name | text | not null | Nama checkpoint |
| address | text | | Alamat |
| latitude | double precision | not null | Koordinat |
| longitude | double precision | not null | Koordinat |
| radius | integer | default 100 | Radius validasi (meter) |
| qr_code | text | unique | Kode QR unik |
| created_at | timestamptz | default now() | |

RLS:

- Semua user bisa baca.
- Hanya admin yang bisa insert/update/delete.

Manajemen checkpoint (MVP):

- Untuk MVP, admin menambah/mengedit checkpoint lewat Supabase Table Editor
  atau SQL Editor.
- Web admin untuk manajemen checkpoint menyusul di fase 2.

Strategi query checkpoint terdekat:

- Untuk MVP, ambil semua checkpoint lalu hitung jarak di sisi client
  (Flutter) memakai `Geolocator.distanceBetween`.
- Jumlah checkpoint diperkirakan kecil (ratusan), jadi pendekatan
  client-side cukup dan menghindari dependency PostGIS.
- PostGIS (`earthdistance` / `ST_DWithin`) baru dipakai nanti kalau
  jumlah checkpoint sudah banyak.

### 3.3 waste_logs

Bukti pembuangan sampah.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK ke auth.users, on delete cascade, not null | User yang buang |
| checkpoint_id | uuid | FK ke checkpoints, on delete set null | Checkpoint |
| category | text | check in ('organik','anorganik','b3','daur_ulang') | Jenis sampah |
| item_type | text | | Sub-jenis/keterangan sampah |
| photo_url | text | | Path di storage |
| hash | text | | SHA-256 |
| latitude | double precision | | Koordinat user |
| longitude | double precision | | Koordinat user |
| server_timestamp | timestamptz | default now() | Waktu server |
| status | text | default 'pending', check in ('pending','verified','rejected') | Status verifikasi |
| verified_by | uuid | FK ke auth.users, on delete set null | Admin/petugas yang verifikasi |
| verified_at | timestamptz | | Waktu verifikasi |
| notes | text | | Catatan verifikator |
| source | text | default 'manual', check in ('qr_scan','manual','nfc') | Asal data: scan QR, manual, NFC |
| created_at | timestamptz | default now() | |

RLS:

- User bisa baca/insert data sendiri.
- Admin dan petugas bisa baca/update semua.

Catatan source:

- `source` dipakai untuk analytics: membedakan data dari `qr_scan` (scan
  QR di checkpoint), `manual` (pilih checkpoint manual), dan `nfc`
  (ketuk NFC, fase 2).
- Default `manual` agar insert lama yang tidak mengisi kolom tetap valid.

### 3.4 points

Riwayat poin user.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK ke auth.users, on delete cascade, not null | User |
| amount | integer | not null | Jumlah poin |
| type | text | check in ('earn','redeem') | Tipe |
| reference_id | uuid | | ID waste_log atau redemption |
| description | text | | Deskripsi |
| created_at | timestamptz | default now() | |

RLS:

- User bisa baca data sendiri.
- Admin bisa baca semua.
- User bisa insert earn/redeem sendiri (migration 015, MVP): type harus
  'earn'/'redeem', amount 1-50. Menggantikan policy 014 yang hanya
  membolehkan earn. Pengerasan fase lanjut: trigger/RPC sisi server saat
  waste_logs verified + cabut policy insert klien.

### 3.5 rewards

Katalog hadiah.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | uuid | PK | |
| name | text | not null | Nama hadiah |
| description | text | | Deskripsi |
| points_cost | integer | not null | Harga poin |
| stock | integer | default 0 | Stok |
| image_url | text | | Gambar |
| is_active | boolean | default true | Aktif/tidak |
| created_at | timestamptz | default now() | |

RLS:

- Semua user bisa baca yang aktif.
- Hanya admin yang bisa insert/update/delete.

### 3.6 redemptions

Riwayat penukaran hadiah.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK ke auth.users, on delete cascade, not null | User |
| reward_id | uuid | FK ke rewards, on delete set null | Hadiah |
| status | text | default 'pending', check in ('pending','approved','rejected','claimed') | Status |
| qr_code | text | unique | Kode QR klaim |
| created_at | timestamptz | default now() | |
| claimed_at | timestamptz | | Waktu klaim |

RLS:

- User bisa baca/insert data sendiri.
- Admin dan petugas bisa manage semua.

### 3.7 articles

Artikel edukasi lingkungan (migration 015).

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | uuid | PK | |
| title | text | not null | Judul |
| excerpt | text | | Ringkasan |
| content | text | not null | Isi artikel |
| cover_url | text | | Sampul |
| published_at | timestamptz | default now() | Waktu terbit |
| created_at | timestamptz | default now() | |

RLS:

- Semua user (anon + authenticated) bisa baca.
- Hanya admin yang bisa insert/update/delete.

Seed: 4 artikel sama dengan konten demo aplikasi (insert idempoten,
on conflict do nothing).

---

## 4. Storage Bucket

### 4.1 waste-photos

- Public: false.
- Akses: signed URL.
- Path: `<user_id>/<timestamp>_<hash>.jpg`
- Max size: 5 MB.
- Format: JPG/PNG.

RLS policy:

- User bisa upload ke folder sendiri.
- User bisa baca foto sendiri.
- Admin/petugas bisa baca semua foto.

### 4.2 avatars

- Public: true (read), private write.
- Path: `<user_id>/avatar.jpg`
- Max size: 2 MB.
- Format: JPG/PNG.

RLS policy:

- User bisa upload/update avatar sendiri.
- Semua bisa baca.

---

## 5. Seed Data (Contoh)

### 5.1 Checkpoints

```sql
insert into public.checkpoints (name, address, latitude, longitude, radius, qr_code)
values
  ('Checkpoint RW 01', 'Jl. Melati No. 10, Jakarta', -6.200000, 106.800000, 100, 'CP-001'),
  ('Checkpoint RW 02', 'Jl. Mawar No. 5, Jakarta', -6.201000, 106.801000, 100, 'CP-002'),
  ('Checkpoint RW 03', 'Jl. Anggrek No. 3, Jakarta', -6.202000, 106.802000, 100, 'CP-003');
```

### 5.2 Rewards

```sql
insert into public.rewards (name, description, points_cost, stock)
values
  ('Voucher Belanja 10.000', 'Voucher belanja senilai 10 ribu', 100, 50),
  ('Voucher Belanja 25.000', 'Voucher belanja senilai 25 ribu', 250, 30),
  ('Saldo E-Wallet 50.000', 'Saldo e-wallet senilai 50 ribu', 500, 20),
  ('Donasi Lingkungan', 'Donasi untuk program lingkungan', 100, 999),
  ('Tumbler Go Green', 'Tumbler edisi Go Green', 300, 15);
```

### 5.3 Admin

Setelah user admin dibuat di Authentication, jalankan:

```sql
update public.profiles
set role = 'admin', username = 'admin'
where email = 'admin@green.com';
```

---

## 6. Aturan Anti-Kecurangan (Ringkas)

- Foto wajib dari kamera in-app.
- Timestamp dari server (server_timestamp).
- GPS radius dicek sebelum insert.
- Hash SHA-256 disimpan di kolom hash.
- Cek duplikat hash sebelum insert.
- Rate limit: maks 5 waste_logs per user per hari.
- Status pending untuk kasus meragukan, diverifikasi admin/petugas.
- Detail di docs/SECURITY_AND_VALIDATION.md.

---

## 7. Migration & Versioning

- Setiap perubahan schema WAJIB lewat migration.
- Migration disimpan di supabase/migrations/.
- Format: <timestamp>_<nama>.sql.
- Setiap migration wajib update dokumen ini.
- Setiap migration wajib update CHANGELOG.
- Migration 010_fix_rls_recursion.sql adalah perbaikan operasional: tidak
  mengubah struktur tabel, hanya membersihkan policy RLS yang menyimpang
  dari definisi kanonik (mengatasi 42P17 infinite recursion pada profiles
  dan checkpoints) dan membuat ulang kebijakan kanonik + fungsi bantu role.
- Migration 014_points_insert_own_earn.sql menambah policy insert earn
  untuk klien (MVP langsung-dapat-poin). Sudah di-push ke remote; policy
  ini digantikan oleh 015 (lihat bawah).
- Migration 015_articles_and_points_redeem.sql membuat tabel articles +
  seed 4 artikel, dan mengganti policy 014 menjadi points_insert_own
  (earn + redeem, amount 1-50) untuk penukaran reward langsung dari
  klien. Belum di-push ke remote sampai user menjalankan
  `supabase db push` (konvensi proyek: push manual).
- Migration 016_waste_logs_item_type_source.sql menambah kolom
  item_type dan source ke waste_logs via ALTER TABLE (idempoten).
  Perbaikan atas edit langsung ke file 003 yang sudah applied sehingga
  tidak pernah sampai ke remote; file 003 dikembalikan ke versi
  applied. Belum di-push ke remote (push manual bersama 015).

---

## 8. Query Umum

### 8.1 Ambil total poin user

```sql
select
  coalesce(sum(case when type = 'earn' then amount else 0 end), 0)
  - coalesce(sum(case when type = 'redeem' then amount else 0 end), 0)
  as total_points
from public.points
where user_id = auth.uid();
```

### 8.2 Ambil semua checkpoint (hitung jarak di client)

Semua checkpoint diambil, lalu jarak tiap checkpoint ke posisi user
dihitung di Flutter memakai `Geolocator.distanceBetween`.

```sql
select id, name, address, latitude, longitude, radius, qr_code
from public.checkpoints
order by name asc;
```

Client (Dart):

```dart
final double distanceMeters = Geolocator.distanceBetween(
  userLat, userLng, checkpoint.latitude, checkpoint.longitude,
);
final bool withinRadius = distanceMeters <= checkpoint.radius;
```

### 8.3 Ambil waste_logs user dengan checkpoint

```sql
select w.*, c.name as checkpoint_name
from public.waste_logs w
left join public.checkpoints c on c.id = w.checkpoint_id
where w.user_id = auth.uid()
order by w.created_at desc;
```

### 8.4 Ambil waste_logs pending untuk admin

```sql
select w.*, p.username, c.name as checkpoint_name
from public.waste_logs w
left join public.profiles p on p.id = w.user_id
left join public.checkpoints c on c.id = w.checkpoint_id
where w.status = 'pending'
order by w.created_at asc;
```

### 8.5 Cek duplikat hash

```sql
select id, user_id, created_at
from public.waste_logs
where hash = 'hash_yang_dicek';
```

### 8.6 Rate limit: hitung waste_logs hari ini

```sql
select count(*)
from public.waste_logs
where user_id = auth.uid()
  and created_at >= current_date;
```

---

## 9. Status Dokumen

Versi: 1.3

Terakhir update: 2026-09-19

Riwayat:

- 1.0: skema awal (profiles, checkpoints, waste_logs, points, rewards,
  redemptions, storage).
- 1.1: tambah kolom item_type dan source di waste_logs, catatan strategi
  query checkpoint terdekat (client-side dulu), catatan manajemen
  checkpoint via Table Editor/SQL Editor untuk MVP, dan query contoh ambil
  semua checkpoint.
- 1.2: catatan migration 010_fix_rls_recursion.sql (perbaikan RLS
  recursion; struktur tabel tidak berubah).
- 1.3: tabel articles + policy points_insert_own (migration 015),
  kolom waste_logs item_type/source lewat migration 016 (revert edit
  langsung 003).