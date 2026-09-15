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

### Level Menengah (fase 2)

5. **EXIF Check**
   - Analisis metadata EXIF foto: timestamp, GPS, model kamera.
   - Cocokkan timestamp EXIF dengan timestamp server dan GPS EXIF dengan
     GPS yang dilaporkan.
   - Flag jika inkonsistensi.

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

### Level Lanjutan (fase 3+)

9. **AI Forensics**
   - Integrasi dengan API eksternal untuk analisis forensik foto:
     Hive API, Sightengine, AWS Rekognition.
   - Flag foto yang kemungkinan besar dimanipulasi.

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