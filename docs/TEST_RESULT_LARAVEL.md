# Test Result Laravel

Tanggal: 2026-10-07
Mode: DATA_SOURCE=laravel (simulasi API-level, endpoint sama persis dengan datasource Flutter)
Server: http://127.0.0.1:8000/api

Catatan metode: interaksi UI di device fisik tidak tersedia di environment
ini, sehingga setiap tugas diuji dengan memanggil endpoint Laravel yang
sama persis dengan yang dipakai `*_laravel_datasource.dart` (path, body,
dan query identik), lalu respons divalidasi terhadap model Flutter
(`fromJson`) dan unit test mock dio (20 test, lulus semua).

## Hasil Test

| No | Fitur | Status | Catatan |
|---|---|---|---|
| 0 | Prasyarat | OK dengan catatan | Server jalan; 7 file datasource ada; 6 provider wired `laravel`. Catatan: `.env` aktif masih `USE_DUMMY_API=true` tanpa `DATA_SOURCE`, jadi aplikasi saat ini berjalan mode dummy, bukan Laravel. |
| 1 | Auth register | OK | `POST /register` 201, token 50 char, profile UUID 36 char tersimpan. |
| 2 | Auth login + me | OK | `POST /login` 200, `GET /me` kembalikan user+profile+username. |
| 3 | Checkpoint list + detail | OK | `GET /checkpoints` 2 baris aktif; `GET /checkpoints/{id}` 200; id salah 404 (Flutter: null). |
| 4 | Waste insert + list | OK | `POST /waste-logs` 201 status pending; `GET /waste-logs?user_id=` tampil. |
| 5 | Points earn + total + history | OK | `POST /points` earn 10; `GET /points/total` earn=10 redeem=0 total=10; history 1 baris. |
| 6 | Redemption create + list | OK | `POST /redemptions` 201 + voucher_code 8 char; list tampil. |
| 7 | Points redeem (ikut redeem) | GAGAL (422) | `POST /points` dengan `reference_id` voucher 8 char ditolak: reference_id harus 36 char; amount reward 100-500 ditolak: amount maks 50. Lihat Bug 1. |
| 8 | Articles | OK | `GET /articles` 3 baris publik; format `published_at` cocok dengan `ArticleModel`. |
| 9 | Admin pending + approve | OK | Login admin OK; pending tampil; `POST /waste-logs/{id}/approve` verified terkonfirmasi via GET. |
| 10 | Admin reject (cara Flutter) | GAGAL (422) | Flutter kirim `notes`, server wajibkan `rejection_reason`. Dengan `rejection_reason` terbukti sukses + status rejected. Lihat Bug 2. |
| 11 | Error handling | OK (sebagian) | Password salah 401 (Flutter: invalidCredentials); tanpa token 401; id salah 404. Uji matikan server + recovery perlu device fisik, belum dites. |

## Bug Ditemukan

- Bug 1 (redeem): `PointsLaravelDatasource.redeemPoints` kirim
  `reference_id` = voucher 8 char dan `amount` = harga reward (100-500),
  sedangkan `PointController@store` validasi `reference_id size:36` dan
  `amount max:50`. Akibat: setiap tukar reward di mode Laravel gagal 422,
  voucher terlanjur dibuat tanpa entri redeem. Kontrol dengan
  `reference_id` 36 char + amount 10 terbukti sukses.
- Bug 2 (reject): `WasteLaravelDatasource.rejectWasteLog` kirim `notes`,
  sedangkan `WasteController@reject` validasi `rejection_reason required`.
  Akibat: setiap tolak verifikasi di mode Laravel gagal 422.

## Rekomendasi

- Pilih salah satu sisi perbaikan dan konfirmasi dulu sebelum eksekusi:
  - Opsi A (Flutter): reject kirim `rejection_reason`; redeem kirim
    `reference_id` 36 char (mis. id redemption) dan pecah amount per
    maksimal 50 atau minta relaksasi ke server.
  - Opsi B (Laravel): longgarkan validasi `reference_id` (bebas/8 char)
    dan `amount` (maks 1000), serta terima `notes` sebagai alias
    `rejection_reason` di endpoint reject.
- Ganti `.env` ke `DATA_SOURCE=laravel` + `LARAVEL_API_URL` sebelum uji
  di device, lalu ulangi Tugas 1-8 interaktif (foto kamera, GPS radius).
- Data uji yang tertinggal di MySQL: user `e2e194806@green.com` (1 waste
  verified + 1 waste rejected + 1 redemption + 2 entri points); hapus
  manual bila mengganggu.

## Tindak Lanjut (2026-10-07, Opsi A disetujui dan dieksekusi)

- Bug 2 diperbaiki di `WasteLaravelDatasource.rejectWasteLog`: kirim
  `rejection_reason` (field `notes` dihapus dari body). Terbukti cocok
  dengan validasi server saat E2E.
- Bug 1 diperbaiki di `PointsLaravelDatasource.redeemPoints`: entri
  redeem memakai `reference_id` id redemption (36 char), kode voucher
  pindah ke `description`, amount dipecah per maksimal 50 poin.
  Bentuk payload ini terbukti lolos validasi server pada test kontrol.
- Test baru: 1 reject (isi body + tanpa `notes`) dan 2 redeem (pecah
  100 jadi 2x50, 30 jadi 1 entri). Full suite 334 test lulus, analyze
  bersih.

## Rekomendasi task selanjutnya

- Uji interaktif di device fisik mode `DATA_SOURCE=laravel`.
