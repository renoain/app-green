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
- `handle_new_user()` insert ke profiles dengan username dari metadata atau dari email, role default 'user'.

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

### 3.3 waste_logs

Bukti pembuangan sampah.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | uuid | PK | |
| user_id | uuid | FK ke auth.users, on delete cascade, not null | User yang buang |
| checkpoint_id | uuid | FK ke checkpoints, on delete set null | Checkpoint |
| category | text | check in ('organik','anorganik','b3','daur_ulang') | Jenis sampah |
| photo_url | text | | Path di storage |
| hash | text | | SHA-256 |
| latitude | double precision | | Koordinat user |
| longitude | double precision | | Koordinat user |
| server_timestamp | timestamptz | default now() | Waktu server |
| status | text | default 'pending', check in ('pending','verified','rejected') | Status verifikasi |
| verified_by | uuid | FK ke auth.users, on delete set null | Admin/petugas yang verifikasi |
| verified_at | timestamptz | | Waktu verifikasi |
| notes | text | | Catatan verifikator |
| created_at | timestamptz | default now() | |

RLS:

- User bisa baca/insert data sendiri.
- Admin dan petugas bisa baca/update semua.

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

### 8.2 Ambil waste_logs user dengan checkpoint

```sql
select w.*, c.name as checkpoint_name
from public.waste_logs w
left join public.checkpoints c on c.id = w.checkpoint_id
where w.user_id = auth.uid()
order by w.created_at desc;
```

### 8.3 Ambil waste_logs pending untuk admin

```sql
select w.*, p.username, c.name as checkpoint_name
from public.waste_logs w
left join public.profiles p on p.id = w.user_id
left join public.checkpoints c on c.id = w.checkpoint_id
where w.status = 'pending'
order by w.created_at asc;
```

### 8.4 Cek duplikat hash

```sql
select id, user_id, created_at
from public.waste_logs
where hash = 'hash_yang_dicek';
```

### 8.5 Rate limit: hitung waste_logs hari ini

```sql
select count(*)
from public.waste_logs
where user_id = auth.uid()
  and created_at >= current_date;
```

---

## 9. Status Dokumen

Versi: 1.0

Terakhir update: 2026-09-15

Perubahan berikutnya: setelah Fase 1 final.