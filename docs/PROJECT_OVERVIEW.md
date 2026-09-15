# PROJECT OVERVIEW - Go Green

## 1. Deskripsi

Go Green adalah aplikasi mobile yang memberi poin kepada user setiap kali
membuang sampah ke checkpoint terdaftar. Poin bisa ditukar reward. Bukti
pembuangan berupa foto + timestamp server + GPS + hash (anti-edit AI).

## 2. Target User

- Warga urban (18-45 tahun) yang sadar lingkungan.
- Komunitas RT/RW yang ingin mengelola sampah bersama.
- Pemerintah daerah / bank sampah yang ingin program digital.

## 3. Masalah yang Diselesaikan

- Sampah rumah tangga/organik tidak terkelola.
- Orang malas memilah sampah.
- Tidak ada insentif untuk membuang sampah dengan benar.

## 4. Solusi & Fitur Utama

- Buang sampah ke checkpoint, dapat poin.
- Poin ditukar reward (sembako, voucher, e-wallet, donasi).
- Bukti foto anti-edit (kamera in-app, timestamp server, GPS, hash).
- Edukasi via artikel.

## 5. Scope MVP vs Fase Berikutnya

### MVP (v0.1.0)

- Onboarding, Login, Register.
- Home.
- Buang Sampah (kamera in-app, timestamp server, GPS radius, hash SHA-256).
- Poin & Reward.
- Aktivitas.
- Artikel.
- Profile.
- Anti-kecurangan level dasar (4 lapisan).

### Fase Berikutnya (v0.2.0+)

- EXIF check, ELA, duplicate detection.
- Approval manual via web admin.
- AI forensics (Hive, Sightengine, AWS Rekognition).
- Petugas checkpoint (mobile app).
- Leaderboard, badge, streak.
- Push notification.
- Multi-bahasa.

## 6. Model Bisnis

- Freemium: gratis untuk user, monetisasi dari:
  - Kerjasama dengan brand (reward sponsor).
  - Program CSR perusahaan.
  - Lisensi ke pemerintah daerah / bank sampah.

## 7. Kompetitor & UVP

| Kompetitor               | Kelebihan                      | Kekurangan            |
| ------------------------ | ------------------------------ | --------------------- |
| Bank Sampah konvensional | Sudah ada                      | Manual, tidak digital |
| Aplikasi sejenis         | Digital                        | Anti-kecurangan lemah |
| Go Green                 | Digital + anti-kecurangan kuat | Baru                  |

UVP: Bukti pembuangan anti-edit (kamera in-app + timestamp server + GPS + hash).

## 8. Tech Stack

Lihat docs/ARCHITECTURE.md.

## 9. Status Project

- Versi: v0.1.0 (MVP, dalam pengembangan)
- Status: Setup fondasi
- Target rilis: TBD