# SECURITY AND VALIDATION - Go Green

Dokumen ini menjelaskan mekanisme anti-kecurangan dan validasi data di Go Green.

## Level Validasi

### Level Dasar (MVP)

1. **Kamera In-App**
   - Foto bukti WAJIB diambil dari kamera aplikasi, bukan dari galeri.
   - Implementasi: package `camera` (camera controller di dalam app).
   - Mencegah user mengupload foto lama/editan dari galeri.

2. **Timestamp Server**
   - Timestamp foto diambil dari server (Supabase), bukan dari waktu device.
   - Device time bisa dimanipulasi; server time tidak.
   - Disimpan di metadata bukti dan ditampilkan di UI verifikasi.
   - Waktu verifikasi waste log juga dipaksa dari server: trigger
     `trg_set_verified_at` (migration 028) menimpa `verified_at` dengan `now()`
     saat status menjadi verified atau rejected. Klien tidak lagi mengirim
     nilai ini, sehingga admin dengan jam device salah tetap mencatat waktu
     verifikasi yang benar.

3. **GPS Radius**
   - Lokasi GPS user dicek sebelum upload: harus dalam radius tertentu
     (default: 100 meter) dari checkpoint yang dipilih.
   - Implementasi: package `geolocator` + hitung jarak haversine.
   - Jika di luar radius: upload ditolak.

4. **Hash SHA-256**
   - Setiap foto yang diupload dihitung hash SHA-256-nya.
   - Hash disimpan di database bersama metadata bukti.
   - Duplikasi hash dicek sebelum simpan: jika ada hash sama, foto ditolak
     (kemungkinan foto sama diupload ulang).
   - Pengecekan klien memakai query dengan `limit(1)`, bukan `maybeSingle()`,
     supaya tetap melaporkan duplikat tanpa melempar error ketika baris
     duplikat menumpuk.

4a. **Poin Hanya Server yang Mencetak**
   - Poin earn dicatat trigger `trg_credit_points_verified` (migration 029)
     saat waste log berstatus verified.
   - Klien tidak boleh membuat baris `earn` lagi. Policy lama
     `points_insert_own` mengizinkan insert tanpa batas jumlah baris sehingga
     user bisa mencetak poin tanpa buang sampah; policy itu sudah dicabut.
   - Klien hanya boleh membuat baris `redeem` (amount negatif) untuk mengurangi
     saldo sendiri, dan hanya bila stok reward tersedia serta saldo cukup
     (dicek oleh `can_redeem_reward`).
   - Satu waste log menghasilkan paling banyak satu baris poin earn.

4b. **Perlindungan Sesi**
   - Token sesi Laravel Sanctum disimpan di keystore perangkat lewat
     `flutter_secure_storage`, bukan di `SharedPreferences` polos yang bisa
     diekstrak lewat backup atau device rooted.
   - Backup Android dimatikan (`allowBackup=false` plus
     `dataExtractionRules`) supaya token dan preferensi lokal tidak ikut
     tersalin ke cloud atau pindah device.
   - Logger dimatikan di build release, dan alamat email pada pesan log
     disensor.

### Level Menengah (selesai on-device; ELA/piksel fase lanjut)

5. **EXIF Check (selesai)**
   - Analisis metadata EXIF foto saat submit via PhotoForensicsService
     (paket exif yang sudah ada, tanpa API cloud).
   - Sinyal: tanpa EXIF kamera (+35), tag Software terisi = jejak edit
     (+40). Byte rusak = tanpa EXIF (tidak pernah crash).
   - Hasil tersimpan di kolom exif_ok + tampil badge di detail admin.

6a. **Skor Risiko (selesai)**
   - AssessPhotoRiskUsecase menggabungkan EXIF + jarak GPS + frekuensi
     harian menjadi skor 0-100 (tersimpan risk_score + risk_detail).
   - Level: 0-29 rendah, 30-59 sedang, 60-100 tinggi. Ambang batas ini hanya
     ditulis di satu tempat, `PhotoRiskLevel.fromScore()`, supaya penilaian di
     domain dan label di UI admin tidak pernah berbeda.
   - Skor hanya membantu verifikator (tidak memblokir; status tetap
     pending). Tampil di detail admin dengan alasan per sinyal.

6c. **Titik Uji GPS Hanya di Debug Build**
   - `debugLocationProvider` dibuat untuk penguji agar bisa pindah lokasi
     tanpa ke lapangan.
   - Notifier menolak aktif bila bukan `kDebugMode`, sehingga GPS palsu tidak
     bisa memalsukan bukti pembuangan sampah pada build rilis.

6. **ELA (Error Level Analysis, fase lanjut)**
   - Analisis level kompresi untuk mendeteksi area yang diedit.
   - Implementasi: package `image` untuk manipulasi piksel.
   - Flag jika ada anomali signifikan.

6. **ELA (Error Level Analysis)**
   - Analisis level kompresi untuk mendeteksi area yang diedit.
   - Implementasi: package `image` untuk manipulasi piksel.
   - Flag jika ada anomali signifikan.

7. **Duplicate Detection**
   - Selain hash, bandingkan foto dengan foto sebelumnya pakai perbandingan
     piksel sederhana (structural similarity).
   - Deteksi jika foto yang sama dikirim berkali-kali dengan crop/rotate
     berbeda.

8. **Rate Limit**
   - Batasi jumlah upload per user per periode waktu.
   - Implementasi: server-side (Supabase Edge Function) atau client-side
     sebagai pertahanan pertama.

### Level Lanjutan (fase 3+; butuh API key + backend)

9. **AI Forensics (cloud, belum mulai)**
   - Integrasi dengan API eksternal untuk analisis forensik foto:
     Hive API, Sightengine, AWS Rekognition.
   - Flag foto yang kemungkinan besar dimanipulasi.
   - Prasyarat: kunci API + anggaran + Edge Function (secret dilarang
     di klien). Skor on-device di atas tetap dipakai berdampingan.

10. **Approval Manual**
    - Admin/petugas bisa meninjau foto yang diflag.
    - Poin baru diberikan setelah approval.
    - Dashboard admin untuk approval.

## Mekanisme per Lapisan

### Client (Flutter)

- Ambil foto via kamera in-app (package `camera`).
- Ambil GPS via `geolocator`.
- Hitung jarak ke checkpoint (rumus haversine).
- Hitung hash SHA-256 (package `crypto`).
- Upload semua metadata ke server.
- Tampilkan status verifikasi.

### Server (Supabase)

- Terima metadata: foto (storage), GPS, timestamp, hash.
- Simpan di tabel bukti (evidence).
- Cek duplikasi hash.
- Return timestamp server ke client.
- Rate limit (fase 2).
- Approval manual (fase 2+).
- RLS aktif pada semua tabel skema MVP (lihat
  supabase/migrations/202609150001_initial_schema.sql): user hanya akses
  data miliknya; tabel publik (checkpoint, reward, article) readable publik;
  storage foto dibatasi per-user di folder `userId/`
  (202609150002_storage_buckets.sql).

## Alur Verification

1. User pilih checkpoint.
2. User ambil foto via kamera in-app.
3. Client hitung hash SHA-256 dari foto.
4. Client cek GPS: apakah dalam radius 100m dari checkpoint?
5. Client request timestamp server.
6. Client upload: foto (storage) + metadata (tabel bukti).
7. Server cek duplikasi hash.
8. Server simpan bukti, return status.
9. Client tampilkan status: terverifikasi / ditolak / pending approval.

## Library/API Pendukung

| Fungsi       | Library         | Status MVP |
| ------------- | --------------- | ---------- |
| Kamera in-app | camera          | Ya         |
| GPS           | geolocator      | Ya         |
| Hash          | crypto          | Ya         |
| EXIF          | exif            | Ya (tuliskan utilitasnya, aktifkan di fase 2) |
| Image process | image           | Ya (untuk ELA, aktifkan di fase 2) |
| QR scan       | mobile_scanner  | Ya         |
| Permission    | permission_handler| Ya        |
| AI Forensics  | Hive/Sightengine| Belum (fase 3) |

## Data Sensitif

- Dilarang log data sensitif: token auth, password, foto bukti, lokasi GPS
  detail.
- Dilarang commit .env ke repository.
- Semua secret hanya di .env, diakses via environment variable.
- Foto bukti di Supabase Storage dengan RLS.
- User hanya bisa lihat bukti miliknya sendiri.