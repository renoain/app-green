# UI PAGES - Go Green

Daftar halaman di Go Green MVP (v0.1.0). Setiap halaman: tujuan, elemen,
state, aksi, navigasi, prioritas MVP.

Status: [Selesai] = halaman sudah diimplementasi, [Belum] = belum dibuat.

---

## 1. Splash [Selesai]

- Tujuan: layar awal, redirect sesuai sesi tersimpan.
- Elemen: logo Go Green, nama aplikasi.
- State: loading (cek sesi + role).
- Aksi: tanpa sesi ke Onboarding; sesi admin ke /admin/dashboard,
  petugas ke /admin/waste-verification, user ke /home.
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
- Elemen: ikon daun (kiri atas), judul "Masuk", subtitle, field
  "Email atau Username", password field (dengan toggle mata show/hide),
  checkbox "Ingat saya", link "Lupa kata sandi?", tombol "Masuk",
  divider "atau", tombol "Masuk dengan Google", link "Belum punya akun?
  Daftar di sini", ilustrasi daun pojok kanan bawah.
- Background: dekorasi lingkaran lembut + ikon daun samar (AuthLeafDecoration)
  sebagai Positioned.fill di belakang konten utama.
- Akses cepat: one-click Google sign-in (AuthRepository.signInWithGoogle,
  Supabase OAuth) tanpa isi email manual; dari halaman Login/Register.
- State: form validation (identitas wajib diisi, tanpa cek format email),
  loading, error, rememberMe (checkbox).
- Aksi: validasi, login via AuthRepository (username diselesaikan menjadi
  email lewat RPC get_email_by_username, lalu Supabase Auth), navigasi ke
  Home; gagal menampilkan snackbar error; "Lupa kata sandi?" menampilkan
  snackbar fitur belum tersedia.
- Catatan: memakai auth asli bila Supabase terinisialisasi; dalam mode
  demo/test login disimulasikan sukses. Checkbox dan forgot-password
  murni presentasi (belum terhubung backend).
- Prioritas MVP: Ya.

---

## 4. Register [Selesai]

- Tujuan: membuat akun baru.
- Elemen: ikon daun (kiri atas), judul "Daftar", subtitle, field username
  (lowercase, tanpa spasi, 3-20 karakter huruf/angka/underscore), field
  nama tampilan (minimal 2 karakter), email, password (toggle mata),
  konfirmasi password, checkbox persetujuan Syarat & Ketentuan, tombol
  "Daftar", divider "atau", tombol "Daftar dengan Google", link "Sudah
  punya akun? Masuk di sini", ilustrasi daun pojok kanan bawah.
- Background: dekorasi lingkaran lembut + ikon daun samar (AuthLeafDecoration)
  sebagai Positioned.fill, sama seperti halaman Login.
- Akses cepat: one-click Google (AuthRepository.signInWithGoogle, Supabase
  OAuth) membahas profil cukup via satu klik.
- State: form validation, loading, error, sukses, setuju S&K (checkbox).
- Aksi: validasi (termasuk cek checkbox S&K), register via AuthRepository
  (Supabase Auth dengan metadata username + display_name; cek
  isUsernameTaken dulu, username harus beda/unik); baris profile
  dibuat otomatis oleh trigger (username lowercase); navigasi ke Login.
  Email yang sudah terdaftar ditangani ("Email sudah terdaftar..."),
  username yang sudah dipakai menampilkan "Username sudah dipakai...",
  password lemah/bocor dan rate limit menampilkan snackbar khusus.
- Catatan: memakai auth asli bila Supabase terinisialisasi; dalam mode
  demo/test register disimulasikan sukses.
- Prioritas MVP: Ya.

---

## 5. Home [Selesai]

- Tujuan: beranda, ringkasan aktivitas dan akses cepat.
- Elemen: header sapaan ("Halo," + nama tampilan + avatar inisial),
  notice login (hanya bila belum login), banner hero carousel "Ayo
  Mulai! Buang Sampah Dapat Poin!" dengan CTA "Mulai Sekarang" dan
  indikator 3 titik, kartu "Total Poin Kamu" dengan tombol
  "Tukar Reward" dan "Lihat Riwayat" plus 3 stat, kartu "Misi Hijau
  Mingguan" dengan progress, section "Aktivitas Terkini" berisi dua
  tile, section "Artikel & Edukasi Hijau" dengan thumbnail gambar dari
  assets/images/ref/ (article_1.png, article_2.png).
  Tamu/gagal backend: konten demo (4.324 Poin; Sampah Terpilah,
  Karbon Dikurangi, Pohon Selamat; misi 63% 3,25 kg / 5,0 kg; tile
  Botol Plastik PET +150, Kertas Karton +80). User login: data asli
  selaras Poin & Aktivitas (saldo points, stat Kali Buang/Minggu
  Ini/Terverifikasi, misi hitungan vs target mingguan, 2 log terbaru
  dengan status asli; kosong menampilkan pesan ajakan).
- Akses cepat: CTA hero ke tab Buang Sampah, Tukar Reward ke tab Poin,
  Lihat Riwayat/Semua ke tab Aktivitas, tile aktivitas ke detail
  aktivitas, Lihat Semua artikel ke halaman Artikel.
- State: data user (nama dari AuthSession: displayName ?? username ??
  prefix email ?? nama tamu; tamu/gagal backend: demo; login: saldo
  pointsNotifierProvider + waste log via BuildHomeSummaryUsecase +
  refresh otomatis tiap submit sukses), loading (layar loading saat
  user login memuat data), tampil/hilang notice login.
- Aksi: tap CTA / menu ke halaman terkait, tutup notice login, tap
  "Masuk" pada notice (buka Login), tap "Lihat semua" ke halaman Artikel.
- Navigasi: bottom nav ke Home, Aktivitas, Buang Sampah, Poin, Profile.
- Keperilakuan back: dari tab selain Beranda, back kembali ke tab Beranda
  dulu (tidak langsung keluar aplikasi); di tab Beranda, back pertama
  menampilkan hint "Tekan kembali lagi untuk keluar" dan back kedua dalam
  2 detik menutup aplikasi (diterapkan di MainShell via PopScope).
- Catatan: login tidak wajib di awal; notice login muncul di atas Home
  hanya saat belum login
  (LoginNoticeCard, bisa ditutup oleh tamu, otomatis hilang saat sudah
  login dan tidak tampil lagi selama sesi login). Header selalu tampil:
  tamu melihat "Warga Go Green", user login melihat nama tampilannya.
  Angka Home user login selalu selaras dengan Poin & Aktivitas karena
  memakai sumber yang sama (tabel points + waste_logs); Poin dan
  Aktivitas ikut refresh otomatis tiap submit sukses. Kartu poin
  hijau tua elegan (gradient primary ke primaryLight, teks putih,
  padding vertikal lg agar lebih panjang, hiasan statis daun samar
  + lingkaran lembut, tombol Lihat Riwayat translusen, divider putih
  20 persen, 3 stat putih solid). Token Stitch dipetakan ke token
  existing (surfaceDim/tertiaryLight/surface, primary, borderLight,
  elevation-1, spacing xs/sm/md/lg, radius lg/xl/full) sehingga
  DESIGN_SYSTEM.md tidak perlu token baru. Bottom nav tidak diubah
  (CustomBottomNavBar tetap 5 item via StatefulShellRoute).
- Prioritas MVP: Ya.

---

## 6. Buang Sampah (Waste) [Selesai - menunggu verifikasi device]

- Tujuan: buang sampah ke checkpoint, dapat poin.
- Elemen: daftar checkpoint real dari Supabase via checkpointNotifierProvider
  (fallback demo bila error/kosong/offline), pilihan checkpoint (centang),
  kartu status GPS real (LocationStatusCard: jarak GeoUtils vs radius
  checkpoint, tombol muat ulang), tombol/link "Scan QR di checkpoint",
  tombol "Ambil Foto" (PrimaryButton), disclaimer antikecurangan.
  Kategori sampah TIDAK di sini; dipilih setelah foto di Verifikasi.
- State: checkpoint terpilih (default pertama), posisi GPS + loading 3 dtk
  timeout, daftar checkpoint (AsyncValue), error checkpoint + retry.
- Aksi: pilih checkpoint, cek posisi GPS; bila di luar
  radius checkpoint tampilkan snackbar wasteGpsOutOfRadius dan blokir ke
  kamera; bila di dalam radius (atau GPS null) kirim CaptureExtra
  (checkpointId/Name/lat/lng/radius) ke route /capture.
- Navigasi: back ke Home; Scan QR membuka route /scan.
- Catatan: blokir radius GPS sementara DIMATIKAN via
  AppValues.enforceGpsRadius = false agar uji device bisa submit dari mana
  saja (jarak tetap ditampilkan). Set true untuk aktifkan lagi.
  Timestamp preview masih waktu device; timestamp server tercatat di DB
  saat insert waste_logs. Task kamera/GPS wajib diuji di device fisik.
- Prioritas MVP: Ya.

---

## 7. Scan QR [Selesai - menunggu verifikasi device]

- Tujuan: scan QR code checkpoint.
- Elemen: viewfinder (frame), panduan scan, catatan deteksi, tombol
  senter (flashlight on/off), tombol tutup (close).
- State: kamera aktif, QR terdeteksi atau belum, senter menyala/mati.
- Aksi: deteksi QR, verifikasi checkpoint, parse QR menjadi
  checkpoint_id (source: qr_scan), navigasi ke halaman buang sampah.
- Navigasi: back ke Waste / tutup.
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
- Aksi: terima CaptureExtra (checkpoint) dari Waste; saat shutter
  ambil posisi GPS, tegakkan radius (GeoUtils vs radius checkpoint, blokir +
  snackbar wasteGpsOutOfRadius bila di luar); teruskan VerificationExtra
  lengkap (imagePath, locationLabel, timestampLabel, checkpointId/Name,
  latitude/longitude, radius) ke Verifikasi via push.
- Navigasi: dari Waste lewat tombol "Ambil Foto" (route /capture dengan extra)
  ke Verifikasi; verifikasi dibuka dengan push agar kembali ke kamera tetap
  berfungsi.
- Catatan: memakai package camera + permission_handler; izin CAMERA sudah
  ditambahkan di AndroidManifest dan NSCameraUsageDescription di Info.plist.
  Wajib diuji di device fisik.
- Prioritas MVP: Ya.

---

## 9. Verifikasi [Selesai - menunggu verifikasi device]

- Tujuan: menampilkan hasil verifikasi foto bukti dan mengirim ke Supabase.
- Elemen: status, preview foto bukti dengan overlay timestamp (atau
  placeholder), pilihan kategori sampah setelah foto (CategoryChip:
  Organik/Anorganik/Daur Ulang/B3, default organik), detail (timestamp
  preview, lokasi GPS asli, hash demo, estimasi poin live mengikuti
  kategori), dialog detail hash, tombol Coba Lagi dan Konfirmasi
  Kirim (dengan loading saat submit).
- State: kategori terpilih + submit via wasteSubmitNotifierProvider
  (AsyncValue idle / loading / hasil / error); sukses menampilkan popup
  poin animasi (PointsEarnedDialog: scale + fade 350ms, ikon koin,
  +poin, tombol Ke Beranda) lalu ke Home; gagal menampilkan
  snackbar error dari WasteValidationException (duplikat/radius/rate limit).
- Aksi: validasi imagePath/checkpoint/lokasi/login (bila belum login
  snackbar wasteNeedLogin + ke Login); ambil checkpoint via repository
  (fallback konstruksi dari extra); baca bytes foto; panggil
  WasteSubmitNotifier.submit yang menjalankan SubmitWasteUsecase
  (hash SHA-256 -> validasi -> upload waste-photos -> insert waste_logs ->
  hitung poin). "Coba Lagi" pop ke kamera; Konfirmasi Kirim ke Home saat
  sukses.
- Navigasi: "Coba Lagi" pop kembali ke halaman kamera yang masih aktif;
  sukses ke Home.
- Catatan: timestamp server tercatat di DB (server_timestamp default now());
  preview memakai waktu device. Hash real tersimpan di waste_logs; dialog
  masih demo sampai ditampilkan dari hasil. Wajib diuji di device fisik
  dengan Supabase + GPS.
- Prioritas MVP: Ya.

---

## 10. Poin & Reward [Selesai]

- Tujuan: lihat saldo poin dan tukar reward.
- Elemen: total poin (PointCard), section reward (judul + tombol
  Voucher Saya ke /vouchers), kartu reward (sembako, voucher, e-wallet,
  donasi), histori poin (ActivityCard per catatan Point).
- State: saat login, saldo + riwayat dari pointsNotifierProvider
  (AsyncValue: loading indikator, error + retry + konten demo fallback,
  data real, empty state bila riwayat kosong); tamu selalu konten demo
  (saldo 250, empat reward demo, dua riwayat demo). Katalog reward masih
  demo sampai terpasang ke Supabase.
- Aksi: tukar poin, pilih reward, klaim reward via QR. Riwayat earn
  tercatat otomatis tiap submit waste (reference_id = waste log).
- Navigasi: ke detail reward; klaim (QR) menampilkan dialog konfirmasi.
- Catatan: insert earn/redeem klien butuh policy points_insert_own
  (migration 015, push manual). Detail reward tersedia di route
  /reward/:id; tombol Tukar menampilkan popup konfirmasi animasi
  (Batal kiri + Tukar kanan) lalu popup sukses animasi dengan tombol
  Lihat Voucher Saya ke /vouchers (penulisan backend + katalog real
  menyusul). Alur klaim QR (QR_CODE di
  redemptions) aktif saat supabase terpasang; verifikator memindai QR
  untuk ubah status redemptions menjadi 'claimed'.
- Prioritas MVP: Ya.

---

## 10a. Voucher Saya [Selesai]

- Tujuan: daftar voucher hasil penukaran reward milik user.
- Elemen: kartu voucher (ikon tiket, nama reward, waktu tukar, chip
  status Menunggu/Disetujui/Ditolak/Diklaim), empty state bila kosong,
  notice login bila tamu.
- State: daftar redemptions asli via userVouchersProvider
  (loading, error + retry, kosong); tamu selalu notice login.
- Aksi: buka dari menu Voucher Saya di Profile atau tombol Lihat
  Voucher Saya di popup sukses; muat ulang via retry.
- Navigasi: route /vouchers (free route, back ke halaman sebelumnya).
- Prioritas MVP: Ya.

---

## 11. Aktivitas [Selesai]

- Tujuan: riwayat aktivitas pembuangan sampah.
- Elemen: daftar aktivitas (deskripsi "Buang sampah <kategori> di
  <checkpoint>", tanggal, estimasi poin, status chip verified/pending/
  rejected).
- State: saat login, daftar dari wasteRepository.getWasteLogs + nama
  checkpoint (loading indikator, error + retry + fallback demo, kosong +
  fallback demo); tamu selalu daftar demo (dua aktivitas). Estimasi poin
  per item via CalculatePointsUsecase (formula sama dengan earn tercatat).
- Aksi: tap kartu membuka route /activity/:id dengan ActivityDetailExtra
  (detail real); item demo membuka detail demo seperti sebelumnya.
- Catatan: filter, statistik, dan empty state real menyusul.
- Prioritas MVP: Ya.

---

## 12. Artikel [Selesai]

- Tujuan: edukasi tentang sampah dan lingkungan.
- Elemen: search, filter kategori (chip/kategori artikel), daftar artikel
  (judul, ringkasan, tanggal), empty state saat pencarian tanpa hasil.
- State: daftar artikel, kategori terpilih, loading.
- Aksi: baca artikel, kembali.
- Catatan: empat artikel demo (konten paragraf placeholder). Search
  memfilter judul dan ringkasan di sisi klien menunggu data asli;
  filter kategori menyusul bersama data asli.
- Prioritas MVP: Ya.

---

## 13. Profile [Selesai]

- Tujuan: profil user dan pengaturan.
- Elemen:
  - Belum login: kartu profil (avatar inisial + nama "Warga Go Green"),
    notice login (LoginNoticeCard "Masuk atau daftar...", hanya tampil
    saat belum login), statistik
    placeholder (total poin, total buang), menu Pengaturan. Tanpa Edit
    Profil dan tanpa Logout.
  - Sudah login: kartu profil (avatar inisial + nama tampilan dari
    AuthSession + email sesi, tanpa notice login),
    statistik (total poin, total buang sampah), menu Edit Profil,
    Voucher Saya, Pengaturan, Logout.
- State: data user, status autentikasi, loading.
- Aksi: login via notice (ke Login), edit profil, buka Voucher Saya
  (daftar penukaran milik user), logout (signOut lalu
  kembali ke Home), buka pengaturan.
- Navigasi ke subhalaman:
  - Edit Profil (route /edit-profile): form nama tampilan + telepon
    opsional + email baca-saja, validasi, tombol Simpan menyimpan ke
    metadata auth via AuthRepository.updateProfile lalu snackbar sukses
    dan kembali (gagal menampilkan snackbar error).
  - Voucher Saya (route /vouchers): daftar redemptions asli + status,
    empty state bila kosong, notice login bila tamu.
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
- State: bila dibuka dengan ActivityDetailExtra (dari daftar real),
  tampilkan data real (status verified/pending/rejected, estimasi poin);
  bila tanpa extra, fallback lookup demo seperti sebelumnya (id tak dikenal
  memakai data pertama).
- Aksi: kembali.
- Navigasi: dari Aktivitas via tap kartu (route /activity/:id dengan extra
  untuk item real), back ke Aktivitas.
- Prioritas MVP: Ya.

---

## 16. Permission (Izin) [Selesai - dialog sistem]

- Tujuan: memberi izin kamera, GPS, dan notifikasi (dialog bawaan sistem,
  bukan halaman terpisah).
- Elemen: dialog izin sistem (kamera, lokasi, notifikasi), opsi "Jangan
  tanyakan lagi" bila izin ditolak permanen.
- State: granted, denied, permanently denied, not determined.
- Aksi: izinkan/tolak; arahkan ke pengaturan sistem saat ditolak
  permanen.
- Navigasi: dipanggil sesuai konteks — izin kamera saat membuka halaman
  Ambil Foto/Scan QR, izin GPS saat membuka halaman Buang Sampah,
  izin notifikasi saat login/onboarding (fase 2).
- Catatan: memakai package permission_handler; manifest Android dan
  Info.plist iOS sudah berisi deklarasi kamera dan lokasi.
- Prioritas MVP: Ya.

---

## 17. Admin Kelola Lokasi [Selesai]

- Tujuan: admin/petugas menambah titik pembuangan, mengatur pin di peta,
  dan testing pindah lokasi tanpa ke lapangan.
- Elemen: dasbor admin (menu titik + verifikasi + status lokasi uji),
  daftar titik (nama, koordinat, radius, aksi lokasi uji/ubah/hapus),
  form titik (peta OSM ketuk untuk pin, field nama/alamat/lat/lng/
  radius/QR, tombol pakai lokasi saya), antrean verifikasi (daftar
  pending + setujui/tolak).
- State: role admin (profiles.role), daftar checkpoint, lokasi uji
  debug (in-memory), antrean pending.
- Aksi: CRUD checkpoint via RLS admin (policy
  checkpoints_insert/update/delete_admin), pasang/hapus lokasi uji,
  halaman Waste dan Kamera otomatis memakai lokasi uji saat aktif.
- Navigasi: menu Mode Admin di Profile (hanya admin/petugas) ke
  /admin/dashboard; guard di shell (akses ditolak bila bukan admin).
- Catatan: peta memakai flutter_map + TileLayer OpenStreetMap tanpa
  API key; lokasi uji hanya alat testing, otorisasi tulis tetap di
  RLS server.
- Prioritas MVP: Ya (alat testing).

---

## 18. Dasbor Admin [Selesai]

- Tujuan: ringkasan operasional + jalan pintas ke aksi admin.
- Elemen: 4 kartu angka (Total User, Total TPS, Waste Hari Ini,
  Pending Verifikasi), kartu Poin Beredar, tombol Tambah TPS, tombol
  Lihat Verifikasi Pending (dengan jumlah).
- State: AdminDashboardSummary dari Supabase (loading, error + retry,
  pull-to-refresh).
- Aksi: ke form tambah TPS, ke antrean verifikasi.
- Navigasi: branch pertama AdminShell (/admin/dashboard), dibuka lewat
  drawer atau menu Mode Admin di Profile.
- Prioritas MVP: Ya.

---

## 19. Kelola TPS [Selesai]

- Tujuan: daftar semua checkpoint untuk admin.
- Elemen: search nama/kode TPS, filter wilayah berjenjang
  (Provinsi, Kota, Kecamatan), kartu TPS (kode TPS, nama, koordinat,
  radius, kode QR, tombol Ubah dan Nonaktifkan), FAB Tambah TPS.
- State: daftar checkpoint (loading, error + retry, empty state),
  query pencarian, filter wilayah, pull-to-refresh.
- Aksi: tap Ubah ke form edit, Nonaktifkan dengan dialog konfirmasi
  (hapus permanen karena skema tanpa kolom is_active). Kembali dari
  form dengan hasil tersimpan memuat ulang daftar admin dan daftar
  user (Supabase) agar lokasi baru/terubah langsung tampil.
- Navigasi: /admin/checkpoints di AdminShell.
- Prioritas MVP: Ya.

---

## 20. Form TPS [Selesai]

- Tujuan: tambah/ubah checkpoint.
- Elemen: peta OSM ketuk untuk pin (kamera peta mengikuti pin saat
  koordinat berubah, tombol layar penuh + tombol Pilih di peta membuka
  pemilih peta layar penuh: pin di tengah, geser peta atau ketuk untuk
  memindahkan pin, tombol Gunakan lokasi ini + tombol lokasi saya),
  tombol Pakai Lokasi Saya (minta hidupkan GPS bila mati lewat dialog
  ke pengaturan sistem, dialog ke pengaturan aplikasi bila izin
  ditolak permanen), dropdown wilayah berjenjang Provinsi ->
  Kota/Kabupaten -> Kecamatan (dropdown_search + kotak cari),
  kode TPS baca-saja (otomatis KOTA-KEC-NOMOR + preview, generate
  ulang saat kecamatan dipilih bila kode masih kosong), kelurahan
  otomatis dari reverse-geocode (bisa diubah), deskripsi lokasi manual
  (wajib, menjelaskan titik spesifik), alamat lengkap otomatis
  (display_name Nominatim, bisa diubah), latitude, longitude, radius
  (default 100), tombol Simpan. Kolom QR disembunyikan sementara
  (menyusul fase berikut).
- State: validasi via ManageCheckpointUsecase (pesan Bahasa Indonesia),
  saving, locating, resolving wilayah (reverse-geocode Nominatim +
  kelurahan + alamat), generating code, muat ulang edit-by-id (loading +
  retry bila /admin/checkpoints/:id/edit dibuka tanpa extra).
- Aksi: Pakai Lokasi Saya / ketuk peta / pilih di peta layar penuh
  mengisi lat/lng, me-resolve wilayah otomatis (dropdown + kelurahan +
  alamat), lalu menggenerate kode TPS; simpan kembali ke daftar;
  simpan/tolak juga menyegarkan daftar checkpoint user via Supabase.
- Navigasi: /admin/checkpoints/new dan /admin/checkpoints/:id/edit;
  pemilih peta layar penuh via Navigator push (kembali membawa LatLng).
- Prioritas MVP: Ya.

---

## 21. Verifikasi Waste [Selesai]

- Tujuan: antrean bukti menunggu verifikasi manual.
- Elemen: filter chip (Hari Ini, 7 Hari, Semua), kartu verifikasi
  (kategori, pengirim, waktu) ke halaman detail.
- State: daftar pending dari Supabase (loading, error + retry,
  empty state), filter aktif.
- Aksi: tap kartu ke detail.
- Navigasi: /admin/waste-verification di AdminShell; petugas langsung
  diarahkan ke sini setelah login.
- Prioritas MVP: Ya.

---

## 22. Detail Verifikasi Waste [Selesai]

- Tujuan: periksa bukti lalu setujui/tolak.
- Elemen: foto bukti (signed URL storage privat), kategori, pengirim,
  timestamp server, lokasi, jarak ke checkpoint (haversine domain),
  hash SHA-256, estimasi poin, tombol Setujui dan Tolak (dialog alasan
  wajib).
- State: busy saat approve/reject, snackbar sukses/gagal.
- Aksi: Setujui mengubah status verified; Tolak mengubah rejected +
  alasan di notes. Poin earn tidak dicatat ulang (sudah tercatat saat
  submit) agar tidak ganda.
- Navigasi: /admin/waste-verification/:id, kembali ke antrean.
- Prioritas MVP: Ya.