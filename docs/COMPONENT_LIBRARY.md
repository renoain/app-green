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

### ErrorState [Belum]

Props:
- message: String
- onRetry: VoidCallback?

Pemakaian: error state, tombol coba lagi.

---

## 6. Display

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

## 7. List

### ListTileItem [Selesai]

Props:
- title: String
- subtitle: String?
- icon: IconData
- trailing: Widget? (default chevron kanan)
- onTap: VoidCallback?

Pemakaian: menu di Profile, pilihan filter.

---

## 8. Status

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

## 9. Auth Decoration

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