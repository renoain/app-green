# UI PAGES - Go Green

Daftar halaman di Go Green MVP (v0.1.0). Setiap halaman: tujuan, elemen,
state, aksi, navigasi, prioritas MVP.

Status: [Selesai] = halaman sudah diimplementasi, [Belum] = belum dibuat.

---

## 1. Splash [Selesai]

- Tujuan: layar awal, penanda awal alur (ke Home, login tidak wajib).
- Elemen: logo Go Green, nama aplikasi.
- State: loading (cek auth status).
- Aksi: navigasi ke Home; jika sudah login notice di Home tidak ditampilkan.
- Catatan: saat ini selalu navigasi ke Home setelah 2 detik; cek
  status login dan penandaan "sudah login" menyusul saat Supabase Auth
  terpasang.
- Prioritas MVP: Ya.

---

## 2. Onboarding [Selesai]

- Tujuan: pengantar fitur utama.
- Elemen: gambar ilustrasi, judul, deskripsi, tombol "Selanjutnya"/"Mulai",
  tombol "Lewati".
- State: current page index.
- Aksi: swipe atau tap tombol, lewati (skip langsung ke Home), navigasi
  langsung ke Home (login tidak wajib di awal).
- Catatan: 3 slide memakai ikon Lucide (recycle, gift, shield_check);
  ilustrasi aset SVG menyusul sesuai ASSET_MANAGEMENT.md.
- Prioritas MVP: Ya.

---

## 3. Login [Selesai]

- Tujuan: masuk ke akun.
- Elemen: ikon daun (kiri atas), judul "Masuk", subtitle, email field,
  password field, checkbox "Ingat saya", link "Lupa kata sandi?", tombol
  "Masuk", divider "atau", tombol "Masuk dengan Google", link "Belum punya
  akun? Daftar di sini", ilustrasi daun pojok kanan bawah.
- Background: dekorasi lingkaran lembut + ikon daun samar (AuthLeafDecoration)
  sebagai Positioned.fill di belakang konten utama.
- Akses cepat: one-click Google sign-in (AuthRepository.signInWithGoogle,
  Supabase OAuth) tanpa isi email manual; dari halaman Login/Register.
- State: form validation, loading, error, rememberMe (checkbox).
- Aksi: validasi, login via AuthRepository (Supabase Auth), navigasi ke Home;
  gagal menampilkan snackbar error; "Lupa kata sandi?" menampilkan snackbar
  fitur belum tersedia.
- Catatan: memakai auth asli bila Supabase terinisialisasi; dalam mode
  demo/test login disimulasikan sukses. Checkbox dan forgot-password
  murni presentasi (belum terhubung backend).
- Prioritas MVP: Ya.

---

## 4. Register [Selesai]

- Tujuan: membuat akun baru.
- Elemen: ikon daun (kiri atas), judul "Daftar", subtitle, field nama,
  email, password, konfirmasi password, tombol "Daftar", divider "atau",
  tombol "Daftar dengan Google", link "Sudah punya akun? Masuk di sini",
  ilustrasi daun pojok kanan bawah.
- Background: dekorasi lingkaran lembut + ikon daun samar (AuthLeafDecoration)
  sebagai Positioned.fill, sama seperti halaman Login.
- Akses cepat: one-click Google (AuthRepository.signInWithGoogle, Supabase
  OAuth) membahas profil cukup via satu klik.
- State: form validation, loading, error, sukses.
- Aksi: validasi, register via AuthRepository (Supabase Auth); baris profile
  dibuat otomatis; navigasi ke Login. Email yang sudah terdaftar
  ditangani ("Email sudah terdaftar...").
- Catatan: memakai auth asli bila Supabase terinisialisasi; dalam mode
  demo/test register disimulasikan sukses.
- Prioritas MVP: Ya.

---

## 5. Home [Selesai]

- Tujuan: beranda, ringkasan aktivitas dan akses cepat.
- Elemen: header sapaan dengan avatar + ikon lonceng, field pencarian,
  banner hero "Buang Sampah, Dapat Poin!" dengan gambar aset dari
  assets/images/ref/ (home_promo.png) sebagai latar dan gradient overlay
  gelap supaya tulisan putih terbaca, section "Menu Utama" berisi empat
  kartu aksi cepat (Buang Sampah, Poin & Reward, Artikel, Scan QR),
  kartu PointCard saldo poin, dan daftar "Artikel Terbaru" dengan
  thumbnail gambar dari assets/images/ref/ (article_1.png, article_2.png).
- Akses cepat: kartu menu dan tombol hero mengarah ke tab/halaman
  terkait via go_router.
- State: data user (placeholder), data ringkasan (placeholder), loading
  (belum diimplementasi), tampil/hilang notice login.
- Aksi: tap menu / hero ke halaman terkait, tutup notice login, tap
  "Masuk" pada notice (buka Login), tap "Lihat semua" ke halaman Artikel,
  tap lonceng menampilkan snackbar fitur belum tersedia.
- Navigasi: bottom nav ke Home, Aktivitas, Buang Sampah, Poin, Profile.
- Keperilakuan back: dari tab selain Beranda, back kembali ke tab Beranda
  dulu (tidak langsung keluar aplikasi); di tab Beranda, back pertama
  menampilkan hint "Tekan kembali lagi untuk keluar" dan back kedua dalam
  2 detik menutup aplikasi (diterapkan di MainShell via PopScope).
- Catatan: login tidak wajib di awal; notice login muncul di atas Home
  (LoginNoticeCard, bisa ditutup oleh tamu, otomatis hilang saat sudah
  login). Data masih placeholder (nama "Warga Go Green", total poin 250,
  dua artikel demo). Hero banner dan thumbnail artikel memakai gambar
  referensi (folder assets/images/ref/) sebagai aset visual sementara;
  bisa diganti dengan aset produksi akhir nanti. Bottom nav memakai
  StatefulShellRoute; tab lain masih placeholder.
- Prioritas MVP: Ya.

---

## 6. Buang Sampah (Waste) [Selesai - menunggu verifikasi device]

- Tujuan: buang sampah ke checkpoint, dapat poin.
- Elemen: pilihan checkpoint (dipilih dengan centang), kartu status GPS
  radius (100 m, status "Berhasil"), tombol "Ambil Foto", disclaimer
  antikecurangan.
- State: checkpoint terpilih, loading upload, error GPS di luar radius.
- Aksi: pilih checkpoint, ambil foto via kamera in-app, cek GPS radius
  (maks 100m dari checkpoint), hitung hash SHA-256, upload, dapat poin.
- Navigasi: back ke Home.
- Catatan: UI selesai; tombol "Ambil Foto" membuka kamera in-app (route
  /capture). Tombol/link "Scan QR di checkpoint" membuka route /scan.
  Cek radius GPS 100 m dinonaktifkan SEMENTARA (lihat CHANGELOG
  2026-09-15) dan akan diaktifkan kembali bersama layer data. Timestamp
  server dan hash SHA-256 menunggu layer data. Task kamera/GPS wajib
  diuji di device fisik.
- Prioritas MVP: Ya.

---

## 7. Scan QR [Selesai - menunggu verifikasi device]

- Tujuan: scan QR code checkpoint.
- Elemen: viewfinder (frame), panduan scan, catatan deteksi.
- State: kamera aktif, QR terdeteksi atau belum.
- Aksi: deteksi QR, verifikasi checkpoint, navigasi ke halaman buang sampah.
- Navigasi: back ke Waste.
- Catatan: UI viewfinder selesai; deteksi QR memakai mobile_scanner
  menunggu pengujian di device fisik.
- Prioritas MVP: Ya.

---

## 8. Ambil Foto (Kamera In-App) [Selesai - menunggu verifikasi device]

- Tujuan: mengambil foto bukti pembuangan lewat kamera in-app (anti-kecurangan,
  bukan galeri).
- Elemen: preview kamera, tombol shutter, tombol flash (mati/otomatis/menyala),
  balik kamera, fallback saat izin ditolak atau kamera tidak tersedia.
- State: inisialisasi kamera, izin ditolak, kamera tidak tersedia, siap, mode
  flash.
- Aksi: ambil foto (lanjut ke Verifikasi), atur flash, balik kamera, kembali.
- Navigasi: dari Waste lewat tombol "Ambil Foto" (route /capture) ke
  Verifikasi; verifikasi dibuka dengan push agar kembali ke kamera tetap
  berfungsi.
- Catatan: memakai package camera + permission_handler; izin CAMERA sudah
  ditambahkan di AndroidManifest dan NSCameraUsageDescription di Info.plist.
  Koordinat GPS dan timestamp (sementara waktu device) diambil saat shutter
  dan dikirim ke Verifikasi. Cek radius GPS 100 m dinonaktifkan sementara
  (lihat CHANGELOG 2026-09-15). Wajib diuji di device fisik.
- Prioritas MVP: Ya.

---

## 9. Verifikasi [Selesai - menunggu verifikasi device]

- Tujuan: menampilkan hasil verifikasi foto bukti.
- Elemen: status, preview foto bukti dengan overlay timestamp (atau
  placeholder), detail (timestamp, lokasi GPS asli, hash, estimasi poin),
  dialog detail hash, tombol Coba Lagi dan Konfirmasi Kirim.
- State: verifikasi lulus/gagal, loading.
- Aksi: konfirmasi kirim (ke Home), lihat detail hash, coba lagi.
- Navigasi: "Coba Lagi" pop kembali ke halaman kamera yang masih aktif;
  Konfirmasi Kirim ke Home.
- Catatan: lokasi memakai koordinat GPS dari geolocator saat shutter
  (izin lokasi ditambahkan di manifest dan Info.plist); jika gagal
  ditampilkan pesan "Lokasi tidak dapat diambil". Timestamp memakai waktu
  device saat shutter untuk keperluan preview; timestamp server menyusul
  bersama integrasi Supabase. Hash masih demo sampai scheduler
  foto/GPS/hash terpasang.
- Prioritas MVP: Ya.

---

## 10. Poin & Reward [Selesai]

- Tujuan: lihat saldo poin dan tukar reward.
- Elemen: total poin, kartu reward (sembako, voucher, e-wallet, donasi),
  histori poin.
- State: data poin, daftar reward, loading.
- Aksi: tukar poin, pilih reward.
- Navigasi: ke detail reward.
- Catatan: data masih placeholder (saldo 250, empat reward demo,
  dua riwayat demo). Detail reward tersedia di route /reward/:id;
  tombol Tukar menampilkan dialog konfirmasi dan snackbar sukses
  (penukaran backend menunggu supabase).
- Prioritas MVP: Ya.

---

## 11. Aktivitas [Selesai]

- Tujuan: riwayat aktivitas pembuangan sampah.
- Elemen: daftar aktivitas (deskripsi, tanggal, poin, status chip).
- State: daftar aktivitas, loading, empty state.
- Aksi: lihat detail (tap kartu membuka route /activity/:id), filter.
- Catatan: data masih placeholder (dua aktivitas demo, satu status
  berhasil dan satu menunggu verifikasi). Filter dan empty state menunggu
  layer data.
- Prioritas MVP: Ya.

---

## 12. Artikel [Selesai]

- Tujuan: edukasi tentang sampah dan lingkungan.
- Elemen: search, daftar artikel (judul, ringkasan, tanggal), empty state
  saat pencarian tanpa hasil.
- State: daftar artikel, loading.
- Aksi: baca artikel, kembali.
- Catatan: empat artikel demo (konten paragraf placeholder). Search
  memfilter judul dan ringkasan di sisi klien menunggu data asli.
- Prioritas MVP: Ya.

---

## 13. Profile [Selesai]

- Tujuan: profil user dan pengaturan.
- Elemen:
  - Belum login: avatar inisial, nama "Warga Go Green", notice login
    (LoginNoticeCard "Masuk atau daftar..."), statistik placeholder,
    menu Pengaturan. Tanpa Edit Profil dan tanpa Logout.
  - Sudah login: avatar inisial, nama, email sesi, statistik,
    menu Edit Profil, Pengaturan, Logout.
- State: data user, status autentikasi, loading.
- Aksi: login via notice (ke Login), edit profil, logout (signOut lalu
  kembali ke Home), buka pengaturan.
- Navigasi ke subhalaman:
  - Edit Profil (route /edit-profile): form nama + email, validasi,
    tombol Simpan menampilkan snackbar sukses lalu kembali.
  - Pengaturan (route /settings): menu akun, toggle Notifikasi dan Mode
    Gelap (lokal), versi aplikasi, dialog Tentang Go Green. Mode Gelap
    diterapkan pada fase berikutnya.
- Catatan: bahwa status login dibaca dari authNotifierProvider (Supabase  Auth); data statistik masih placeholder. Logout menyimpan ke mode tamu
  dan kembali ke Home (notice login muncul kembali). Logout lanjutan
  (konfirmasi, hapus sesi device, sync) dicatat sebagai task fase berikutnya.
- Prioritas MVP: Ya.

---

## 14. Article Detail [Selesai]

- Tujuan: membaca artikel lengkap.
- Elemen: tanggal terbit, judul, konten paragraf.
- State: data artikel, loading.
- Aksi: kembali.
- Catatan: dibuka lewat route /article/:id; konten paragraf placeholder
  (tiga paragraf sama untuk semua artikel demo).
- Prioritas MVP: Ya.

---

## 15. Detail Aktivitas [Selesai]

- Tujuan: detail satu aktivitas pembuangan sampah.
- Elemen: header status (ikon + status chip), deskripsi, baris detail
  (tanggal, checkpoint, poin).
- State: data aktivitas berdasarkan id.
- Aksi: kembali.
- Navigasi: dari Aktivitas via tap kartu (route /activity/:id), back ke
  Aktivitas.
- Catatan: data masih placeholder dari daftar demo yang sama dengan
  halaman Aktivitas.
- Prioritas MVP: Ya.