# COMPONENT LIBRARY - Go Green

Daftar komponen reusable yang dipakai di Go Green. Setiap komponen:
nama, props, contoh pemakaian. Lihat lib/core/widgets/ dan
DESIGN_SYSTEM.md untuk detail implementasi.

Status: [Selesai] = sudah diimplementasi, [Belum] = belum dibuat.

Implementasi yang sudah ada di lib/core/widgets/:
- app_button_widgets.dart: PrimaryButton, SecondaryButton, AppTextButton
- custom_text_field_widget.dart: CustomTextField, SearchField
- app_bar_and_loading_widgets.dart: CustomAppBar, LoadingIndicator
- custom_bottom_nav_bar_widget.dart: CustomBottomNavBar
- card_widgets.dart: InfoCard, PointCard, ArticleCard, ActivityCard, RewardCard
- status_widgets.dart: StatusType, StatusChip
- display_widgets.dart: Avatar, StatItem, ListTileItem
- feedback_widgets.dart: EmptyState
- auth_leaf_decoration.dart: AuthLeafDecoration, AuthLeafSprig
- auth_header_widget.dart: AuthHeaderWidget
- app_checkbox.dart: AppCheckbox
- app_error_state.dart: AppErrorState
- app_icon.dart: AppIcon
- app_password_field.dart: AppPasswordField
- features/checkpoints/presentation/widgets/checkpoint_tile.dart: CheckpointTile
- features/waste/presentation/widgets/location_status_card.dart: LocationStatusCard
- features/waste/presentation/widgets/category_chip.dart: CategoryChip
- features/waste/presentation/widgets/photo_upload_container.dart: PhotoUploadContainer

---

## 1. Button

### PrimaryButton [Selesai]

Props:
- text: String (label tombol)
- onPressed: VoidCallback?
- isLoading: bool (tampilkan loading indicator)
- isExpanded: bool (full-width)

Pemakaian: konfirmasi, submit form, aksi utama.

### SecondaryButton [Selesai]

Props:
- text: String
- onPressed: VoidCallback?
- isExpanded: bool

Pemakaian: aksi sekunder, batal, navigasi ke form berikutnya.

### AppTextButton [Selesai]

Props:
- text: String
- onPressed: VoidCallback?

Pemakaian: link teks, "Lupa password?", "Belum punya akun?".

Catatan: sebelumnya bernama TextButton di dokumen; diubah menjadi
AppTextButton untuk menghindari bentrok dengan TextButton bawaan Flutter.

### GoogleAuthButton [Selesai]

Props:
- text: String (label, mis. "Masuk dengan Google" / "Daftar dengan Google")
- onPressed: VoidCallback?
- isExpanded: bool (full-width)

Elemen: globe icon (lucide, bukan brand Google) + teks.

Pemakaian: tombol satu klik sign-in Google di halaman Login dan Register.
Tombol ini menampilkan ikon globe (LucideIcons.globe) sebagai pengganti
logo Google — sesuai DESIGN_SYSTEM (ikon lucide, tanpa aset brand pihak
ketiga). Handler ada di masing-masing halaman (login/register) memanggil
AuthRepository.signInWithGoogle.

---

## 2. Input

### CustomTextField [Selesai]

Props:
- label: String?
- hint: String?
- prefixIcon: IconData?
- suffixIcon: IconData?
- controller: TextEditingController?
- validator: String? Function(String?)?
- keyboardType: TextInputType
- obscureText: bool
- enabled: bool (default true; false untuk tampilan baca-saja)
- onSuffixTap: VoidCallback? (toggle jika suffixIcon adalah icon password)

Pemakaian: email, password, nama, input teks.

### SearchField [Selesai]

Props:
- hint: String
- controller: TextEditingController?
- onChanged: ValueChanged<String>?

Pemakaian: search artikel, filter aktivitas.

---

## 3. Card

### InfoCard [Selesai]

Props:
- title: String
- subtitle: String?
- icon: IconData
- onTap: VoidCallback?

Pemakaian: kartu aksi di Home (Buang Sampah, Lihat Poin).

### PointCard [Selesai]

Props:
- point: int
- label: String
- icon: IconData

Tampilan: gradient primary->primaryLight, ikon dalam lingkaran ring.
Pemakaian: total poin di Home dan Profile.

### RewardCard [Selesai]

Props:
- title: String
- description: String
- pointCost: int
- icon: IconData
- onTap: VoidCallback?

Pemakaian: daftar reward di Poin & Reward. Prop image dari rencana awal
diganti icon sampai aset ilustrasi tersedia.

### ActivityCard [Selesai]

Props:
- date: DateTime
- description: String
- point: int
- status: StatusType (success, warning)
- onTap: VoidCallback?

Pemakaian: item di daftar Aktivitas dan Riwayat Poin. Poin positif
ditampilkan dengan tanda plus, status ditampilkan bersama StatusChip.

### ArticleCard [Selesai]

Props:
- title: String
- date: DateTime
- excerpt: String?
- onTap: VoidCallback?
- thumbnailImage: String? (path aset gambar thumbnail opsional)

Pemakaian: item di daftar Artikel dan artikel terbaru di Home. Bila
`thumbnailImage` diisi, thumbnail ditampilkan sebagai gambar (cover);
jika null, fallback ke ikon placeholder book_open dengan latar
tertiaryLight.

---

## 4. Navigation

### CustomBottomNavBar [Selesai]

Props:
- currentIndex: int
- onTap: ValueChanged<int>

Pemakaian: bottom navigation bar (Home, Aktivitas, Buang Sampah, Poin,
Profile). Item "Buang Sampah" tampil sebagai tombol bulat warna primary
di tengah. Item aktif ditandai ikon primary dan titik indikator di bawah
label; tinggi bar 72.

### CustomAppBar [Selesai]

Props:
- title: String
- leading: IconData?
- onLeadingTap: VoidCallback?
- actions: List<Widget>?

Pemakaian: app bar di setiap halaman.

---

## 5. Feedback

### LoadingIndicator [Selesai]

Props:
- size: double
- color: Color?

Pemakaian: loading state.

### EmptyState [Selesai]

Props:
- icon: IconData
- title: String
- message: String
- actionText: String?
- onAction: VoidCallback?

Pemakaian: daftar kosong (pencarian artikel tidak ditemukan).

### ErrorState [Selesai]

Props:
- message: String
- onRetry: VoidCallback?

Pemakaian: error state, tombol coba lagi.

### AppErrorState [Selesai]

Props:
- message: String
- onRetry: VoidCallback?
- icon: IconData? (default LucideIcons.alert_circle)

Pemakaian: state error di halaman yang memuat data (kegagalan load dari
Supabase), dengan tombol coba lagi.

---

## 6. Waste & Checkpoint

### CheckpointTile [Selesai]

Props:
- name: String (nama checkpoint)
- address: String?
- icon: IconData? (default LucideIcons.map_pin)
- selected: bool (status terpilih)
- distanceLabel: String? (label jarak, mis. "120 m")
- onTap: VoidCallback?

Pemakaian: daftar checkpoint terdekat di halaman Buang Sampah. Saat
`selected` true, ditampilkan ikon centang + warna border primary.

### LocationStatusCard [Selesai]

Props:
- withinRadius: bool
- distanceMeters: double
- radiusMeters: double
- onCheckLocation: VoidCallback?

Tampilan: status GPS radius dengan label "Berhasil" (blok hijau) atau
"Di luar radius" (blok error). Menampilkan jarak saat ini dan radius
checkpoint.

Pemakaian: kartu status radius di halaman Buang Sampah.

### CategoryChip [Selesai]

Props:
- label: String
- icon: IconData?
- selected: bool
- onTap: VoidCallback?

Tampilan: chip kategori sampah; saat terpilih berwarna primary dengan teks
onPrimary.

Pemakaian: pilihan kategori/ jenis sampah (organik, anorganik, b3,
daur ulang) di halaman Buang Sampah.

### PhotoUploadContainer [Selesai]

Props:
- label: String (default "Ambil Foto")
- hint: String?
- hasPhoto: bool
- onTap: VoidCallback?

Tampilan: container dashed border + ikon kamera; saat `hasPhoto` true
ditampilkan indikator foto terpasang.

Pemakaian: trigger kamera in-app di halaman Buang Sampah.

### ScanQrButton [Rencana]

Props:
- text: String (default "Scan QR di checkpoint")
- onPressed: VoidCallback?

Pemakaian: membuka route /scan untuk memindai QR checkpoint. Saat ini
navigasi scan dilakukan AppLink/text dari WastePage; komponen terpisah
menyusul bila dipakai ulang di halaman lain.

---

## 7. Form

### AppCheckbox [Selesai]

Props:
- value: bool
- label: String
- onChanged: ValueChanged<bool>?
- linkText: String? (teks tautan opsional di dalam label)
- onLinkTap: VoidCallback?

Pemakaian: checkbox persetujuan Syarat & Ketentuan di Register, "Ingat
saya" di Login.

### AppPasswordField [Selesai]

Props:
- label: String?
- hint: String?
- controller: TextEditingController?
- validator: String? Function(String?)?
- onChanged: ValueChanged<String>?
- onFieldSubmitted: ValueChanged<String>?

Tampilan: membungkus CustomTextField dengan obscureText + suffix toggle
(mata terbuka/tertutup) secara otomatis.

Pemakaian: input password di Login dan Register.

---

## 8. Icon

### AppIcon [Selesai]

Static helper:
- AppIcon.lucide(IconData icon, ...) -> Icon
- AppIcon.asset(String path, ...) -> Image / SvgPicture.asset

Pemakaian: titik tunggal render ikon supaya mudah mengganti implementasi
(flutter_svg untuk aset, flutter_lucide untuk ikon standar).

---

## 9. Display

### Avatar [Selesai]

Props:
- name: String (inisial jika gambar tidak disediakan)
- imageUrl: String?
- size: double (default 48)

Pemakaian: profil user, profil mini di Home.

Catatan: bila imageUrl null, ditampilkan inisial nama di lingkaran primary;
fontSize inisial mengikuti ukuran avatar.

### Badge [Belum]

Props:
- label: String
- color: Color?

Pemakaian: badge poin, status, label kategori.

### StatItem [Selesai]

Props:
- value: String
- label: String
- icon: IconData?

Pemakaian: statistik di Profile (total poin, total buang sampah).

---

## 10. List

### ListTileItem [Selesai]

Props:
- title: String
- subtitle: String?
- icon: IconData
- trailing: Widget? (default chevron kanan)
- onTap: VoidCallback?

Pemakaian: menu di Profile, pilihan filter.

---

## 11. Status

### StatusChip [Selesai]

Props:
- label: String
- type: StatusType (success, warning, error, info; default success)

Pemakaian: status verifikasi, status aktivitas, chip reward.

### ProgressBar [Belum]

Props:
- value: double (0.0 - 1.0)
- height: double

Pemakaian: progress menuju target poin, loading bar.

---

## 12. Auth Decoration

### AuthLeafDecoration [Selesai]

Deskripsi: dekorasi latar (background) halaman autentikasi berupa
lingkaran lembut (orb) di sudut-sudut layar dengan ikon daun samar
di tengahnya. Dipakai dalam Stack sebagai Positioned.fill di belakang
konten utama, sehingga halaman tidak polos tanpa mengganggu keterbacaan.

Props: tidak ada (stateless, murni presentasi dekoratif).

Warna: memakai token tema — secondaryContainer (kanan atas), tertiaryLight
(kiri atas), surfaceDim (kiri bawah) — sehingga tetap konsisten dengan
DESIGN_SYSTEM dan tidak hardcode.

Pemakaian: halaman Login dan Register (kapan pun halaman autentikasi
membutuhkan latar visual bertema hijau).

### AuthLeafSprig [Selesai]

Deskripsi: ilustrasi daun kecil yang ditempatkan di pojok kanan bawah
konten halaman autentikasi, sebagai aksen visual dekoratif (bukan aset
gambar, melainkan kumpulan LucideIcons.leaf dengan warna tema).

Props: tidak ada (stateless).

Pemakaian: ditempatkan di akhir konten scrollable halaman autentikasi
sebagai penanda visual visual yang sejajar dengan referensi UI
"login dengan ilustrasi daun".