# GLOSSARY - Go Green

Kamus istilah yang dipakai di project Go Green.

---

- **Checkpoint**: Tempat fisik terdaftar di mana user membuang sampah.
  Mempunyai koordinat GPS dan radius yang diizinkan.

- **Poin**: Unit reward digital yang diberikan kepada user setelah buang
  sampah berhasil diverifikasi. Poin bisa ditukar dengan reward.

- **Reward**: Hadiah yang bisa ditukar dengan poin: semako, voucher,
  e-wallet, atau donasi.

- **Hash SHA-256**: Fungsi kriptografik yang menghasilkan sidik jari unik
  berupa string hexadecimal 64 karakter dari sebuah file foto. Digunakan
  untuk mendeteksi duplikasi atau manipulasi.

- **EXIF**: Metadata yang tersimpan dalam file foto, termasuk timestamp,
  lokasi GPS, model kamera. Digunakan untuk validasi bukti foto.

- **ELA (Error Level Analysis)**: Teknik analisis forensik digital yang
  membandingkan level kompresi pada area berbeda dalam satu foto. Berguna
  untuk mendeteksi editing/manipulasi.

- **GPS Radius**: Jarak maksimal (default 100 meter) dari checkpoint yang
  diizinkan agar pembuangan sampah bisa diverifikasi.

- **Timestamp Server**: Waktu dari server (bukan dari device user) yang
  digunakan untuk membuktikan kapan foto diambil. Anti-pengubahan waktu.

- **AI Forensics**: Penggunaan model AI (misal Hive, Sightengine, AWS
  Rekognition) untuk mendeteksi manipulasi foto secara otomatis.

- **Approval Manual**: Proses di mana admin/petugas memverifikasi foto bukti
  secara manual sebelum poin diberikan.

- **Rate Limit**: Batasan jumlah request/upload yang diperbolehkan dalam
  periode waktu tertentu. Mencegah abuse.

- **Streak**: Jumlah hari berturut-turut user membuang sampah. Bisa menjadi
  pengali poin atau syarat reward khusus.

- **B3**: Sampah Bahan Berbahaya dan Beracun. Tidak termasuk dalam MVP.

- **Organik**: Sampah yang bisa terurai secara alami (sisa makanan, daun,
  kulit buah, dll).

- **Anorganik**: Sampah yang tidak mudah terurai (plastik, logam, kaca,
  kertas laminasi, dll).

- **Daur Ulang**: Proses mengolah sampah menjadi bahan baru yang bisa
  dipakai kembali.

- **MVP**: Minimum Viable Product. Versi paling sederhana dari aplikasi
  yang sudah bisa dipakai untuk validasi produk.

- **BaaS**: Backend as a Service. Backend yang sudah siap pakai lewat API.
  Di project ini: Supabase.

- **RLS**: Row Level Security. Fitur PostgreSQL (Supabase) yang mengontrol
  akses data per baris berdasarkan role/auth user.