# CHANGELOG - Go Green

## [2026-09-21] - Kartu poin Home hijau tua elegan + hiasan statis

Status: Selesai

Laporan: widget poin dan background terlalu sama sehingga monoton;
kartu dibuat sedikit lebih panjang, kontras, tetap elegan.
Animasi jatuh didiskusikan dulu, disepakati hiasan statis saja.

File yang diubah:

- lib/features/home/presentation/pages/home_page.dart (diedit): kartu poin gradient primary ke primaryLight + teks putih + padding vertikal lg + daun samar dan lingkaran lembut + tombol riwayat translusen + divider putih 20 persen + stat putih solid
- docs/UI_PAGES.md (diedit): section 5 catat varian hijau tua elegan

Catatan:

- Tanpa token/warna baru dan tanpa dependency animasi baru; hiasan hanya pakai token existing dan LucideIcons.
- Animasi sampah jatuh loop tidak jadi dipakai (biaya baterai dan risiko ganggu bacaan); opsi animasi momen saja tetap terbuka bila diminta.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (192 test lulus)

## [2026-09-21] - Kartu poin Home seperti Stitch Enhanced

Status: Selesai

Laporan: screen Home Page - Go Green (Enhanced) ADA di Stitch;
bagian Total Poin diganti mengikuti Stitch (gradient lembut,
ikon bintang, angka besar, tombol kompak, stat translusen).

File yang diubah:

- lib/features/home/presentation/pages/home_page.dart (diedit): kartu poin gradient surfaceDim ke tertiaryLight + ikon star + angka headlineLg + tombol 30px labelSm + mini stat surface 85 persen
- lib/core/constants/app_strings.dart (diedit): homeStatCarbonLabel jadi Karbon Dikurangi sesuai Stitch
- docs/UI_PAGES.md (diedit): section 5 sebut gradient Enhanced + label karbon

Catatan:

- Tanpa token/warna baru; gradient hanya pakai token existing surfaceDim dan tertiaryLight, bukan hardcode hex Stitch.
- Struktur section Home tidak berubah.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (192 test lulus)

## [2026-09-21] - Kartu poin Home gaya mockup hijau muda

Status: Selesai

Laporan: samakan bagian Total Poin Kamu dengan mockup (kartu hijau,
tombol kanan, stat grid + divider).

File yang diubah:

- lib/features/home/presentation/pages/home_page.dart (diedit): kartu surfaceDim + tombol Tukar Reward/Lihat Riwayat kanan + divider + mini stat surface
- lib/core/constants/app_strings.dart (diedit): kembalikan homeExchangeReward/homeViewHistory
- docs/UI_PAGES.md: tetap (struktur section 5 tidak berubah)

Catatan:

- Tanpa gradient (aturan anti-AI-slop): hijau mockup dipetakan ke token flat AppColors.surfaceDim; tanpa token/warna baru.
- Tombol dikembalikan mengikuti mockup (sempat dihapus, dibatalkan).

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (192 test lulus)

## [2026-09-21] - Popup sukses vertikal + akses voucher di Poin

Status: Selesai

Laporan: tombol Lihat Voucher Saya terpotong di popup; halaman Poin
belum ada jalan masuk ke Voucher Saya.

Temuan: baris sejajar Batal + Lihat Voucher Saya selebar setengah kartu
(320px) memotong label panjang.

File yang diubah:

- lib/features/rewards/presentation/widgets/redeem_dialogs.dart (diedit): popup sukses tombol bertumpuk vertikal (penuh + penuh), konfirmasi tetap sejajar
- lib/features/points/presentation/pages/points_page.dart (diedit): header section reward tambah tombol Voucher Saya ke /vouchers
- test/widget/pages/points_page_test.dart (diedit): 1 test navigasi voucher
- docs/UI_PAGES.md (diedit): section 10 tombol voucher
- docs/COMPONENT_LIBRARY.md (diedit): catatan tombol bertumpuk

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (192 test lulus, termasuk 1 test baru)

## [2026-09-21] - Popup tukar animasi + Voucher Saya di Profil

Status: Selesai (uji device fisik tukar + buka voucher)

File yang dibuat:

- lib/features/rewards/presentation/widgets/redeem_dialogs.dart (dibuat): popup konfirmasi + sukses animasi scale + fade, Batal kiri + aksi kanan
- lib/features/rewards/domain/entities/redemption.dart (dibuat): entity penukaran
- lib/features/rewards/data/models/redemption_model.dart (dibuat): parse join rewards(name)
- lib/features/rewards/presentation/pages/vouchers_page.dart (dibuat): daftar voucher asli + status + empty + notice tamu
- test/unit/features/rewards/redemption_model_test.dart (dibuat): 2 test parse
- test/widget/pages/vouchers_page_test.dart (dibuat): 1 test tamu

File yang diubah:

- lib/features/points/presentation/pages/reward_detail_page.dart (diedit): konfirmasi + sukses via popup animasi, sukses ke /vouchers
- lib/features/rewards/data/datasources/reward_remote_datasource.dart (diedit): client lazy + getUserRedemptions join nama reward
- lib/features/rewards/presentation/providers/reward_provider.dart (diedit): UserVouchersNotifier + userVouchersProvider
- lib/features/profile/presentation/pages/profile_page.dart (diedit): menu Voucher Saya di bawah Edit Profil (login saja)
- lib/core/router/app_router.dart (diedit): route /vouchers + nama vouchers
- lib/core/constants/app_strings.dart (diedit): tambah string voucher + popup sukses, hapus redeemSuccess tak terpakai
- test/widget/pages/reward_detail_page_test.dart (diedit): popup baru + navigasi voucher
- test/widget/pages/profile_page_test.dart (diedit): menu voucher login/tamu
- docs/UI_PAGES.md (diedit): section 10, 10a Voucher Saya, 13 Profil
- docs/COMPONENT_LIBRARY.md (diedit): RedeemDialogs
- docs/ARCHITECTURE.md (diedit): route /vouchers

Catatan:

- Tanpa dependency baru (animasi bawaan Flutter, Supabase yang ada).
- Penulisan redeem backend + katalog real (id UUID) adalah langkah lanjut; popup sukses dan daftar voucher sudah siap menampungnya.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (191 test lulus, termasuk 3 test baru voucher)

## [2026-09-21] - Home selaras poin + hitungan buang asli

Status: Selesai (uji device fisik login + submit + cek angka Home)

File yang dibuat:

- lib/features/home/domain/usecases/build_home_summary_usecase.dart (dibuat): ringkasan total/mingguan (Senin)/terverifikasi + progres misi
- lib/features/activity/presentation/data/activity_texts.dart (dibuat): deskripsi + status aktivitas bersama
- test/unit/features/home/build_home_summary_test.dart (dibuat): 3 test minggu/progres/batas

File yang diubah:

- lib/features/home/presentation/pages/home_page.dart (diedit): tamu demo, login tampilkan saldo asli + stat Kali Buang/Minggu Ini/Terverifikasi + misi hitungan + 2 log terbaru + refresh tiap submit sukses
- lib/features/activity/presentation/pages/activity_page.dart (diedit): pakai teks bersama + refresh tiap submit sukses
- lib/features/points/presentation/pages/points_page.dart (diedit): refresh tiap submit sukses
- lib/core/constants/app_values.dart (diedit): tambah weeklyMissionTargetDisposals 5
- lib/core/constants/app_strings.dart (diedit): tambah label stat/misi/empty Home Bahasa Indonesia
- docs/UI_PAGES.md (diedit): section 5 Home data asli vs demo

Catatan:

- Tanpa dependency baru; logic hitungan di domain + unit test.
- Gagal backend tetap fallback demo (filosofi Points/Aktivitas).
- Target misi 5 kali/minggu di AppValues; minggu dihitung Senin 00.00 lokal.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (187 test lulus, termasuk 3 test baru ringkasan)

## [2026-09-21] - Kategori setelah foto + popup poin animasi

Status: Selesai (uji device fisik alur buang sampah + submit)

File yang dibuat:

- lib/features/verification/presentation/widgets/points_earned_dialog.dart (dibuat): popup +poin scale easeOutBack + fade 350ms + tombol Ke Beranda
- test: 2 test baru verifikasi (pilih kategori ubah estimasi, popup tampil dan tertutup)

File yang diubah:

- lib/features/waste/presentation/pages/waste_page.dart (diedit): section kategori dihapus, CaptureExtra tanpa kategori
- lib/features/waste/presentation/data/capture_extra.dart (diedit): field category dihapus
- lib/features/waste/presentation/pages/capture_photo_page.dart (diedit): teruskan VerificationExtra tanpa kategori
- lib/features/verification/presentation/pages/verification_page.dart (diedit): pilih kategori setelah foto, estimasi poin live, sukses tampilkan popup lalu ke Home
- lib/core/constants/app_strings.dart (diedit): tambah pointsEarnedTitle/Message/Button, hapus wasteSubmitSuccess + verificationPointsDemo yang tak terpakai
- test/widget/pages/waste_page_test.dart (diedit): kategori tidak ada di Waste
- test/widget/pages/verification_page_test.dart (diedit): scroll sebelum asersi baris bawah + 2 test baru
- docs/UI_PAGES.md (diedit): section 6/8/9 alur kategori + popup
- docs/ARCHITECTURE.md (diedit): alur Buang Sampah baru
- docs/COMPONENT_LIBRARY.md (diedit): CategoryChip pindah ke Verifikasi + PointsEarnedDialog

Catatan:

- Tanpa dependency baru (animasi showGeneralDialog bawaan Flutter).
- Estimasi live: 25/30/35/40 sesuai kategori (streak 0); popup memakai poin hasil submit sebenarnya.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (184 test lulus, termasuk 2 test baru)

## [2026-09-21] - Perbaiki kecamatan otomatis (municipality + alias DKI)

Status: Selesai (uji device fisik tambah TPS Surabaya/Jakarta)

Laporan: kecamatan tidak terisi otomatis saat set lokasi dari GPS/peta.

Temuan (dari respons Nominatim asli):

- Surabaya (Ketintang): kecamatan ada di kunci `municipality`
  ("Gayungan") yang tidak pernah dicek untuk kecamatan; `village`
  berisi kelurahan. Akibatnya district selalu null.
- Jakarta (Monas): tidak ada kunci `state`; `city` berisi
  "Daerah Khusus Ibukota Jakarta" (provinsi), `city_district`
  berisi kota ("Jakarta Pusat"). Akibatnya resolve berhenti di awal.

File yang diubah:

- lib/features/regions/domain/usecases/resolve_region_usecase.dart (diedit): kandidat kecamatan tambah municipality/borough/quarter/city_district, municipality keluar dari kandidat kota, city_district masuk kandidat kota, provinsi fallback ke city bila state kosong, alias DKI/DI + awalan ADM ganda, titik dihapus sebelum normalisasi, kelurahan dari kunci selevel desa dipakai apa adanya
- test/unit/features/regions/resolve_region_test.dart (diedit): fake tambah data DKI, 4 test baru (alias/ADM, municipality Surabaya, fallback Jakarta, neighbourhood)

Catatan:

- Tanpa dependency baru; kontrak repository tidak berubah.
- Bila Nominatim sama sekali tidak mengembalikan kunci selevel kecamatan (kasus langka), dropdown tetap bisa diisi manual.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (182 test lulus, termasuk 4 test baru matcher)

## [2026-09-21] - Perbaiki layar merah tulis provider di initState AdminShell

Status: Selesai (uji device fisik buka aplikasi sesi admin)

Laporan: saat buka aplikasi langsung layar merah "Tried to modify a
provider while the widget tree was building" di
admin_shell.dart baris 48 initState.

Temuan: AdminShell menulis adminDrawerOpenerProvider langsung di
initState, padahal initState berjalan saat widget tree dibangun
(Riverpod melarang tulis provider di fase ini). Halaman admin lain
sudah benar memakai addPostFrameCallback. Dipicu di startup karena
splash kini mengarahkan sesi admin ke dasbor.

File yang dibuat:

- test/widget/pages/admin_shell_test.dart (dibuat): 2 test regresi (shell terpasang tanpa error, tombol menu buka drawer)

File yang diubah:

- lib/features/admin/presentation/admin_shell.dart (diedit): tulis opener via addPostFrameCallback + mounted, hapus tulis di dispose (unmount bisa berbarengan build route baru; closure basi aman karena no-op dan ditimpa saat masuk lagi)

Catatan:

- Tanpa perubahan logic bisnis dan tanpa dependency baru.
- Cara perbaikan: tulis via addPostFrameCallback (solusi 2 dari laporan), sama seperti halaman admin lain.
- Test regresi terbukti gagal di kode lama dan lulus di kode baru.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (178 test lulus, termasuk 2 test baru admin shell)

## [2026-09-21] - Perbaiki navigasi admin, splash role, retry API wilayah

Status: Selesai (uji device fisik login admin + pindah UI + tambah TPS)

Laporan:

- Login admin masuk ke tampilan user; keluar-masuk admin menyebabkan layar merah failed assertion framework.
- Tambah lokasi otomatis gagal dengan DioException 522 dari API wilayah (emsifa.github.io).
- Back di dasbor admin perlu 2 kali untuk kembali ke UI user.

Temuan:

- Menu Mode Admin memakai pushNamed ke route StatefulShellRoute sehingga shell admin menumpuk di atas shell user (pola tak didukung go_router) + GlobalKey Scaffold dipakai bersama antar-instance.
- Splash selalu ke onboarding sehingga sesi admin tersimpan selalu mendarat di UI user.
- Dio tanpa timeout dan tanpa retry sehingga gangguan sesaat API statis langsung menggagalkan dropdown.

File yang dibuat:

- test/unit/features/regions/region_remote_datasource_test.dart (dibuat): 3 test retry (522 lalu sukses, 522 terus, 404 tanpa ulang)

File yang diubah:

- lib/features/profile/presentation/pages/profile_page.dart (diedit): Mode Admin pushNamed menjadi goNamed
- lib/features/admin/presentation/admin_shell.dart (diedit): kunci Scaffold per-instance, back root sekali ke /profile, hapus double-back exit
- lib/features/admin/presentation/providers/admin_providers.dart (diedit): adminScaffoldKeyProvider diganti adminDrawerOpenerProvider
- lib/features/admin/presentation/pages/admin_dashboard_page.dart (diedit): buka drawer via opener
- lib/features/admin/presentation/pages/admin_checkpoint_page.dart (diedit): buka drawer via opener
- lib/features/admin/presentation/pages/admin_waste_verification_page.dart (diedit): buka drawer via opener
- lib/features/admin/presentation/pages/admin_rewards_page.dart (diedit): buka drawer via opener
- lib/features/admin/presentation/pages/admin_users_page.dart (diedit): buka drawer via opener
- lib/features/admin/presentation/pages/admin_settings_page.dart (diedit): buka drawer via opener
- lib/features/splash/splash_page.dart (diedit): ConsumerState, sesi tersimpan redirect sesuai role
- lib/features/regions/data/datasources/region_remote_datasource.dart (diedit): timeout connect/receive, retry transien (3x daftar, 2x reverse), log warning ringkas
- docs/UI_PAGES.md (diedit): section 1 splash redirect role
- docs/ARCHITECTURE.md (diedit): navigasi admin go + opener + back profile + retry wilayah
- docs/PRD_ADMIN.md (diedit): section 4-5, riwayat

Catatan:

- Tanpa dependency baru (pola go_router + dio yang sudah ada; mirror seformat tak ada yang tepercaya sehingga memakai retry).
- Back root admin kini selalu ke /profile (UI user), bukan keluar aplikasi.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (176 test lulus, termasuk 3 test baru retry datasource)

## [2026-09-21] - Admin izin GPS + peta layar penuh + autofill alamat

Status: Selesai (uji device fisik GPS/peta/reverse-geocode)

File yang dibuat:

- lib/features/admin/presentation/pages/admin_map_picker_page.dart (dibuat): peta layar penuh pin tengah (geser peta/ketuk + lokasi saya + konfirmasi, kembali LatLng)
- lib/features/admin/presentation/widgets/location_ready.dart (dibuat): dialog hidupkan GPS + izin ditolak permanen
- test: 5 test baru resolveDetails/kelurahan/alamat di resolve_region_test.dart

File yang diubah:

- lib/core/services/location_service.dart (diedit): helper isServiceEnabled/checkPermission/requestPermission/openLocationSettings/openAppSettings
- lib/features/regions/data/datasources/region_remote_datasource.dart (diedit): reverseGeocode sertakan display_name + addressdetails
- lib/features/regions/domain/usecases/resolve_region_usecase.dart (diedit): ResolvedLocation + resolveDetails + pickSubdistrict/pickFullAddress, kandidat kota/kecamatan diperluas
- lib/features/admin/presentation/pages/admin_checkpoint_form_page.dart (diedit): dialog izin GPS, tombol Pilih di peta, autofill dropdown + kelurahan + alamat + kode TPS
- lib/features/admin/presentation/widgets/checkpoint_map_picker.dart (diedit): tombol layar penuh opsional
- lib/core/constants/app_strings.dart (diedit): string izin GPS + peta layar penuh Bahasa Indonesia, label alamat/kelurahan otomatis
- test/unit/features/regions/resolve_region_test.dart (diedit): fake repository + 5 test detail
- docs/UI_PAGES.md (diedit): section 20 peta layar penuh + autofill
- docs/PRD_ADMIN.md (diedit): section 6.2, struktur folder, riwayat

Catatan:

- Tanpa dependency baru (geolocator + flutter_map yang sudah ada).
- Peta layar penuh via Navigator push (tanpa route baru); GPS mati/izin permanen diarahkan ke pengaturan sistem/aplikasi.
- Kelurahan teks bebas dari Nominatim (dilewati bila sama dengan kecamatan); alamat display_name bisa diubah manual.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (173 test lulus, termasuk 5 test baru resolve detail)

## [2026-09-21] - Push migrasi 017 ke Supabase remote

Status: Selesai

File yang diubah:

- Tidak ada perubahan file (hanya `supabase db push` ke remote).

Catatan:

- Migration list remote kini 001-017 sinkron dengan local.
- Kolom checkpoints code/province_code/city_code/district_code/subdistrict + index kini aktif di remote; insert/update wilayah + kode TPS otomatis sudah bisa diuji dari HP.
- Langkah lanjut: uji tambah/edit TPS dari device fisik + pastikan role admin1@green.com sudah dieskalasi via SQL.

Verifikasi:

- migration list: 001-017 Local = Remote.
- hasil linter/analyze: belum dijalankan (tanpa perubahan kode)
- hasil test: belum dijalankan (tanpa perubahan kode)

## [2026-09-21] - Admin double-back keluar + lokasi otomatis + deskripsi, QR ditunda

Status: Selesai (uji device fisik GPS/peta/reverse-geocode)

File yang dibuat:

- lib/features/regions/domain/usecases/resolve_region_usecase.dart (dibuat): reverse-geocode ke pilihan wilayah + matcher nama statis
- test/unit/features/regions/resolve_region_test.dart (dibuat): 4 test normalisasi + matcher

File yang diubah:

- lib/features/admin/presentation/admin_shell.dart (diedit): ConsumerStateful + PopScope double-back keluar di root branch, back normal di sub-route
- lib/features/regions/data/datasources/region_remote_datasource.dart (diedit): reverseGeocode Nominatim via dio
- lib/features/regions/domain/repositories/region_repository.dart (diedit): kontrak reverseGeocode
- lib/features/regions/data/repositories/region_repository_impl.dart (diedit): teruskan reverseGeocode
- lib/features/regions/domain/entities/region.dart (diedit): typedef RegionSelection pindah ke sini
- lib/features/regions/presentation/providers/region_provider.dart (diedit): resolveRegionUsecaseProvider
- lib/features/admin/presentation/widgets/region_picker_dropdown.dart (diedit): pakai typedef entity + onSelected API v7
- lib/features/admin/presentation/pages/admin_checkpoint_form_page.dart (diedit): lokasi GPS/ketuk peta me-resolve wilayah + generate kode otomatis, hapus field dan preview QR
- lib/features/admin/presentation/pages/admin_checkpoint_page.dart (diedit): import typedef entity
- lib/core/constants/app_strings.dart (diedit): Nama titik menjadi Deskripsi lokasi
- docs/PRD_ADMIN.md (diedit): double-back, resolve otomatis, deskripsi, QR ditunda
- docs/UI_PAGES.md (diedit): section 20 deskripsi + tanpa QR + resolve otomatis
- docs/ARCHITECTURE.md (diedit): catatan double-back admin

Catatan:

- Tanpa dependency baru (Nominatim tanpa API key via dio; batas pemakaian wajar).
- qr_code tetap tersimpan otomatis (CP-XXX) di database; hanya disembunyikan dari form dan menyusul ditampilkan lagi.
- Reverse-geocode best effort: bila offline/tidak cocok, dropdown tetap bisa diisi manual.

Verifikasi:

- hasil linter/analyze: OK (8 path dicek, 0 issue; sempat 1 error import typedef, sudah diperbaiki)
- hasil test: OK (168 test lulus, termasuk 4 test baru resolve_region)

## [2026-09-21] - Kelola TPS wilayah berjenjang + kode TPS otomatis

Status: Selesai (migration 017 perlu `supabase db push` manual; uji device fisik)

File yang dibuat:

- supabase/migrations/017_add_checkpoint_region.sql (dibuat): kolom code unik + province_code/city_code/district_code/subdistrict + index city/district/code, idempoten, baris lama null
- lib/features/regions/domain/entities/region.dart (dibuat): RegionProvince/RegionCity/RegionDistrict
- lib/features/regions/domain/repositories/region_repository.dart (dibuat)
- lib/features/regions/data/datasources/region_remote_datasource.dart (dibuat): dio ke API emsifa + cache memory
- lib/features/regions/data/repositories/region_repository_impl.dart (dibuat)
- lib/features/regions/presentation/providers/region_provider.dart (dibuat): provinces + cities/province + districts/city
- lib/features/checkpoints/domain/usecases/generate_tps_code_usecase.dart (dibuat): singkatan 3 huruf + nomor urut se-wilayah format KOTA-KEC-NN
- lib/features/admin/presentation/widgets/region_picker_dropdown.dart (dibuat): dropdown berjenjang + search
- test/unit/features/checkpoints/generate_tps_code_test.dart (dibuat): 6 test singkatan + nomor urut

File yang diubah:

- pubspec.yaml (diedit): tambah dropdown_search 7.0.0
- pubspec.lock (diedit): hasil flutter pub add
- lib/features/checkpoints/domain/entities/checkpoint.dart (diedit): field code/wilayah
- lib/features/checkpoints/data/models/checkpoint_model.dart (diedit): parse/tulis kolom baru
- lib/features/checkpoints/domain/repositories/checkpoint_repository.dart (diedit): param wilayah opsional
- lib/features/checkpoints/data/repositories/checkpoint_repository_impl.dart (diedit): teruskan param
- lib/features/checkpoints/data/datasources/checkpoint_remote_datasource.dart (diedit): insert/update kolom code + wilayah
- lib/features/checkpoints/domain/usecases/manage_checkpoint_usecase.dart (diedit): teruskan code/wilayah
- lib/features/admin/presentation/providers/admin_checkpoint_provider.dart (diedit): filter wilayah + search nama/kode + param create/update baru
- lib/features/admin/presentation/pages/admin_checkpoint_form_page.dart (diedit): dropdown wilayah + kode otomatis + preview + kelurahan
- lib/features/admin/presentation/pages/admin_checkpoint_page.dart (diedit): filter wilayah + search kode
- lib/features/admin/presentation/widgets/tps_card.dart (diedit): tampilkan kode TPS
- lib/core/constants/app_strings.dart (diedit): string wilayah + kode Bahasa Indonesia
- test fakes (diedit): manage_checkpoint_test, admin_checkpoint_page_test, waste_page_test ikut signature baru
- docs/PRD_ADMIN.md (diedit): section 6.2 wilayah + kode, riwayat 2026-09-21
- docs/DATABASE_SCHEMA.md (diedit): kolom baru checkpoints 3.2
- docs/UI_PAGES.md (diedit): section 19-20 wilayah + kode
- docs/COMPONENT_LIBRARY.md (diedit): RegionPickerDropdown
- docs/ARCHITECTURE.md (diedit): evaluasi dependency 8.4 + kolom checkpoints 10.1

Catatan:

- Evaluasi dependency (PROTOCOL Bagian C): dropdown_search 7.0.0 (MIT, rilis 2026-04, verified publisher, cocok Dart 3.13) dipakai untuk dropdown + search; flutter_wilayah_indonesia 0.1.0 DITOLAK (rilis 13 bulan lalu, lewat 12 bulan, melanggar aturan maintenance) sehingga data wilayah diambil via dio yang sudah ada ke API emsifa/api-wilayah-indonesia dengan cache memory.
- Kolom code terpisah dari qr_code (qr_code CP-XXX untuk cetak tetap jalan).
- Tanpa `supabase db push`, kolom code/wilayah belum ada di remote; insert/update wilayah gagal sampai migration 017 di-push. Jalankan push manual sebelum uji.
- Singkatan kode memakai 3 huruf pertama nama (tanpa awalan KOTA/KABUPATEN/KECAMATAN), mis. SUR-KET-01.

Verifikasi:

- hasil linter/analyze: OK (9 path dicek, 0 issue; sempat 5 issue API dropdown_search v7 + import, sudah diperbaiki)
- hasil test: OK (164 test lulus, termasuk 6 test baru generate_tps_code)

## [2026-09-21] - Admin tambah lokasi dari HP + edit terhubung Supabase

Status: Selesai (perlu uji device fisik GPS/peta + akun role admin)

File yang diubah:

- lib/features/admin/presentation/widgets/checkpoint_map_picker.dart (diedit): Stateful + MapController agar kamera peta mengikuti pin saat koordinat berubah (lokasi saya/ketik/teks)
- lib/features/admin/presentation/pages/admin_checkpoint_form_page.dart (diedit): tambah checkpointId (edit-by-id via Supabase bila extra null), preload QR CP-XXX saat tambah, preview QR live, tombol lokasi saya dengan loading, log AppLogger saat gagal, sinkron daftar user usai simpan
- lib/features/admin/presentation/pages/admin_checkpoint_page.dart (diedit): pull-to-refresh, reload usai kembali dari form tambah/ubah, sinkron daftar user usai nonaktifkan
- lib/core/router/app_router.dart (diedit): teruskan checkpointId ke form edit
- docs/UI_PAGES.md (diedit): section 19-20 update perilaku tambah/ubah lokasi HP + sinkron Supabase

Catatan:

- Tanpa dependency baru (pakai geolocator, flutter_map, Supabase yang sudah ada).
- Tulis checkpoint tetap lewat RLS admin di server; guard UI hanya UX.
- Nonaktifkan = hapus permanen karena skema tanpa kolom is_active.

Verifikasi:

- hasil linter/analyze: OK (4 file dicek, 0 error; 1 info trailing comma sudah diperbaiki)
- hasil test: OK (158 test lulus)

## [2026-09-20] - Fitur admin MVP (shell, dasbor, kelola TPS, verifikasi waste)

Status: Selesai (perlu uji device fisik GPS/kamera + 1x SQL eskalasi role bila belum)

File yang diubah:

- pubspec.yaml (diedit): tambah pretty_qr_code 3.6.0
- pubspec.lock (diedit): hasil flutter pub add
- lib/features/admin/data/datasources/admin_dashboard_datasource.dart (dibuat): count user/TPS/waste/poin
- lib/features/admin/data/models/.gitkeep (dibuat)
- lib/features/admin/data/repositories/.gitkeep (dibuat)
- lib/features/admin/domain/entities/admin_dashboard_summary.dart (dibuat)
- lib/features/admin/domain/repositories/.gitkeep (dibuat)
- lib/features/admin/domain/usecases/verify_waste_usecase.dart (dibuat): approve/reject, estimasi poin, jarak haversine
- lib/features/admin/presentation/admin_shell.dart (dibuat): drawer + guard role + logout
- lib/features/admin/presentation/pages/admin_dashboard_page.dart (ditulis ulang): 4 kartu angka + poin beredar + aksi cepat
- lib/features/admin/presentation/pages/admin_checkpoint_page.dart (dibuat): list + search + nonaktifkan
- lib/features/admin/presentation/pages/admin_checkpoint_form_page.dart (diedit): QR otomatis CP-XXX + preview pretty_qr_code + provider baru
- lib/features/admin/presentation/pages/admin_waste_verification_page.dart (dibuat): list pending + filter hari/7 hari/semua
- lib/features/admin/presentation/pages/admin_waste_detail_page.dart (dibuat): foto signed URL + jarak + hash + approve/reject
- lib/features/admin/presentation/pages/admin_rewards_page.dart (dibuat): placeholder fase 2
- lib/features/admin/presentation/pages/admin_users_page.dart (dibuat): placeholder fase 2
- lib/features/admin/presentation/pages/admin_settings_page.dart (dibuat): placeholder fase 2
- lib/features/admin/presentation/pages/admin_checkpoints_page.dart (dihapus): diganti admin_checkpoint_page
- lib/features/admin/presentation/pages/admin_verification_page.dart (dihapus): diganti verifikasi + detail baru
- lib/features/admin/presentation/widgets/admin_drawer.dart (dibuat)
- lib/features/admin/presentation/widgets/tps_card.dart (dibuat)
- lib/features/admin/presentation/widgets/waste_verification_card.dart (dibuat)
- lib/features/admin/presentation/providers/admin_dashboard_provider.dart (dibuat)
- lib/features/admin/presentation/providers/admin_checkpoint_provider.dart (dibuat): list + search + QR otomatis
- lib/features/admin/presentation/providers/admin_waste_provider.dart (dibuat): pending + filter + approve/reject
- lib/features/admin/presentation/providers/admin_providers.dart (diedit): tambah kunci drawer, hapus notifier lama
- lib/features/checkpoints/data/datasources/checkpoint_remote_datasource.dart (diedit): tambah insert/update/deactivate
- lib/features/checkpoints/domain/repositories/checkpoint_repository.dart (diedit): kontrak insert/update/deactivate
- lib/features/checkpoints/data/repositories/checkpoint_repository_impl.dart (diedit): implementasi insert/update/deactivate
- lib/features/checkpoints/domain/usecases/manage_checkpoint_usecase.dart (diedit): tambah deactivate
- lib/features/checkpoints/domain/usecases/generate_checkpoint_qr_usecase.dart (dibuat): kode CP-XXX berikutnya
- lib/features/waste/data/datasources/waste_remote_datasource.dart (diedit): tambah approve/reject/signed URL
- lib/features/waste/domain/repositories/waste_repository.dart (diedit): kontrak approve/reject/signed URL
- lib/features/waste/data/repositories/waste_repository_impl.dart (diedit): implementasi
- lib/features/waste/domain/entities/waste_log.dart (diedit): tambah submitterName/checkpointName
- lib/features/waste/data/models/waste_log_model.dart (diedit): parse join profiles/checkpoints
- lib/features/auth/presentation/providers/auth_provider.dart (diedit): tambah getCurrentUserRole
- lib/features/auth/presentation/pages/login_page.dart (diedit): redirect admin/petugas/user
- lib/features/profile/presentation/pages/profile_page.dart (diedit): menu Mode Admin ke /admin/dashboard
- lib/core/router/app_router.dart (diedit): AdminShell StatefulShellRoute + 9 route admin
- lib/core/constants/app_strings.dart (diedit): 30+ string admin Bahasa Indonesia
- test/unit/features/admin/admin_dashboard_provider_test.dart (dibuat)
- test/widget/pages/admin_checkpoint_page_test.dart (dibuat)
- test/widget/pages/admin_waste_verification_page_test.dart (dibuat)
- test/unit/features/waste/waste_submit_notifier_test.dart (diedit): fake tambah approve/reject/signed URL
- test/unit/features/checkpoints/manage_checkpoint_test.dart (diedit): fake tambah insert/update/deactivate
- test/widget/pages/waste_page_test.dart (diedit): fake tambah insert/update/deactivate
- docs/UI_PAGES.md (diedit): section 18-22 halaman admin
- docs/COMPONENT_LIBRARY.md (diedit): AdminDrawer, TpsCard, WasteVerificationCard
- docs/ARCHITECTURE.md (diedit): route admin + routing role + evaluasi pretty_qr_code
- docs/PRD_ADMIN.md (diedit): status In Progress

Catatan:

- Evaluasi dependency (PROTOCOL Bagian C): pretty_qr_code 3.6.0 (MIT, rilis 2026-01-31, cocok Dart 3.13); tujuan render QR TPS; alternatif qr_flutter 4.1.0 DITOLAK (rilis terakhir 2023-05, lewat 12 bulan, melanggar aturan maintenance).
- Penyimpangan dari prompt yang disengaja: (1) deactivateCheckpoint = hapus permanen karena tabel checkpoints tanpa kolom is_active dan skema dilarang diubah; (2) approve TIDAK insert poin ulang karena earn sudah tercatat saat submit (SubmitWasteUsecase) agar tidak ganda, hanya tampil estimasi; (3) switch status aktif di form dihilangkan karena tidak bisa persist tanpa kolom; (4) redirect role hanya di login (splash tetap ke onboarding).
- Otorisasi tulis tetap di RLS server; guard UI hanya UX.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (158 test lulus, termasuk 5 test baru admin)

## [2026-09-20] - PRD admin manual + patenkan aturan komentar ringkas

Status: Selesai

File yang diubah:

- docs/PRD_ADMIN.md (diedit): isi tanggal 2026-09-20, catat riwayat dibuat manual oleh owner
- PROTOCOL.md (diedit): Bagian M dipatenkan, komentar wajib ringkas 1 baris dan hanya untuk yang tidak jelas

Catatan:

- docs/PRD_ADMIN.md dibuat manual oleh owner, bukan oleh agent.
- Aturan komentar (PROTOCOL Bagian M) berlaku permanen untuk semua kode berikutnya.

Verifikasi:

- hasil linter/analyze: belum dijalankan (hanya perubahan docs)
- hasil test: belum dijalankan (hanya perubahan docs)

## [2026-09-20] - Buat akun admin testing admin1@green.com di remote

Status: Sebagian (auth + profil jadi; role admin menunggu 1x SQL di dashboard)

File yang diubah:

- Tidak ada perubahan file (hanya API Auth + REST ke Supabase remote).

Catatan:

- User auth admin1@green.com dibuat via signup API (id cb0b6229-...); login email/password terverifikasi OK.
- Trigger handle_new_user membuat baris profiles (username admin1, role user).
- Eskalasi role ke admin DIBLOKIR RLS by design (profiles_update_own menolak ubah role); wajib via SQL Editor dashboard sebagai postgres.
- SQL yang harus dijalankan di dashboard (SQL Editor):
  update public.profiles set role = 'admin', username = 'admin1' where email = 'admin1@green.com';
- Password tidak dicatat di repo/CHANGELOG (hanya di Authentication dashboard).

Verifikasi:

- hasil linter/analyze: belum dijalankan (tanpa perubahan kode)
- hasil test: belum dijalankan (tanpa perubahan kode)

## [2026-09-20] - Halaman admin kelola lokasi + peta OSM + lokasi uji

Status: Selesai (perlu uji device fisik kamera/GPS/peta)

File yang diubah:

- pubspec.yaml (diedit): tambah flutter_map 8.3.2 + latlong2 0.10.1
- pubspec.lock (diedit): hasil flutter pub add
- lib/features/checkpoints/data/datasources/checkpoint_remote_datasource.dart (diedit): tambah create/update/delete (RLS admin)
- lib/features/checkpoints/domain/repositories/checkpoint_repository.dart (diedit): kontrak CRUD admin
- lib/features/checkpoints/data/repositories/checkpoint_repository_impl.dart (diedit): teruskan CRUD ke remote
- lib/features/checkpoints/domain/usecases/manage_checkpoint_usecase.dart (dibuat): validasi nama/koordinat/radius + create/update/delete
- lib/features/admin/data/datasources/admin_profile_datasource.dart (dibuat): baca role dari profiles
- lib/features/admin/presentation/providers/admin_providers.dart (dibuat): role/isAdmin, lokasi uji, notifier checkpoint + verifikasi
- lib/features/admin/presentation/widgets/checkpoint_map_picker.dart (dibuat): peta OSM ketuk untuk pin
- lib/features/admin/presentation/pages/admin_dashboard_page.dart (dibuat): menu titik + verifikasi + status lokasi uji
- lib/features/admin/presentation/pages/admin_checkpoints_page.dart (dibuat): daftar + lokasi uji + ubah + hapus
- lib/features/admin/presentation/pages/admin_checkpoint_form_page.dart (dibuat): form + peta + pakai lokasi saya
- lib/features/admin/presentation/pages/admin_verification_page.dart (dibuat): antrean pending + setujui/tolak
- lib/core/constants/app_strings.dart (diedit): string admin Bahasa Indonesia
- lib/core/router/app_router.dart (diedit): route /admin + nama route admin
- lib/features/profile/presentation/pages/profile_page.dart (diedit): menu Kelola Lokasi khusus admin/petugas
- lib/features/waste/presentation/pages/waste_page.dart (diedit): pakai lokasi uji untuk daftar + radius + banner
- lib/features/waste/presentation/pages/capture_photo_page.dart (diedit): pakai lokasi uji untuk radius + extra verifikasi
- test/unit/features/checkpoints/manage_checkpoint_test.dart (dibuat): 4 test validasi
- test/widget/pages/waste_page_test.dart (diedit): stub CRUD di fake repository
- docs/ARCHITECTURE.md (diedit): baris dependency peta di 1.3
- docs/UI_PAGES.md (diedit): section 17 Admin Kelola Lokasi

Catatan:

- Evaluasi dependency (PROTOCOL Bagian C): flutter_map 8.3.2 (BSD-3-Clause, rilis 2 hari lalu, Dart SDK min 3.6, cocok Dart 3.13) + latlong2 0.10.1; tujuan pin checkpoint testing; alternatif google_maps_flutter ditolak (butuh API key + billing).
- Otorisasi tulis tetap di RLS server (policy checkpoints_insert/update/delete_admin via is_admin()); guard UI hanya UX.
- Lokasi uji in-memory (hilang saat restart); cukup untuk testing pindah lokasi.
- Tanpa migrasi baru (RLS admin sudah ada di 002/010).

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (153 test lulus, termasuk 4 test baru manage_checkpoint)

Status: Selesai

File yang diubah:

- Tidak ada perubahan file (hanya `supabase db push` ke remote).

Catatan:

- Migration list remote kini 001-016 sinkron dengan local (015 sudah ada
  di remote sebelumnya; push ini menerapkan 016).
- Tabel articles + policy points_insert_own (earn/redeem) + kolom
  waste_logs item_type/source kini aktif di remote.

Verifikasi:

- migration list: 001-016 Local = Remote.

## [2026-09-19] - Audit repo: restore PROTOCOL, migrasi 015-016, radius aktif

Status: Selesai (migration 015-016 perlu `supabase db push` manual; uji device fisik)

Temuan audit:

- PROTOCOL.md terhapus di working copy (restore dari index, isi utuh).
- Migration 015_articles_and_points_redeem.sql (tabel articles + seed 4
  artikel + policy points_insert_own earn/redeem) belum tercatat di
  CHANGELOG/docs dan belum di-push ke remote.
- File 003 diedit langsung (tambah item_type + source) padahal sudah
  applied di remote sehingga kolom tidak pernah sampai ke remote.
- enforceGpsRadius masih false (radius nonaktif) setelah masa uji submit.
- Folder build_old_20260918/ (artefak build lama, untracked) mengotori repo.

File yang dibuat:

- supabase/migrations/016_waste_logs_item_type_source.sql (dibuat):
  ALTER TABLE ADD COLUMN IF NOT EXISTS item_type + source (idempoten).

File yang diubah:

- PROTOCOL.md (direstore): file kembali ada, isi sesuai index.
- supabase/migrations/003_create_waste_logs.sql (dikembalikan): revert ke
  versi applied (tanpa item_type/source; kolom pindah ke 016).
- lib/core/constants/app_values.dart (diedit): enforceGpsRadius false ke
  true; anti-kecurangan radius aktif lagi (blokir ke kamera/verifikasi/
  submit bila di luar radius, jarak tetap tampil).
- .gitignore (diedit): tambah build_old_20260918/.
- docs/DATABASE_SCHEMA.md (diedit): RLS points ikut 015, section 3.7
  articles baru, section 7 catat 014 sudah push + 015/016 menunggu push;
  versi 1.2 ke 1.3.
- docs/ARCHITECTURE.md (diedit): migration 001-012 ke 001-016, tabel
  articles di 10.1, RLS points ikut 015 di 10.2.
- docs/UI_PAGES.md (diedit): catatan policy Poin ikut 015.

Catatan:

- Hapus fisik build_old_20260918/ gagal (handle dikunci Gradle daemon:
  java PID 5608/23204, access denied). Sudah di-gitignore; hapus manual
  setelah IDE/daemon Gradle ditutup.
- Tanpa `supabase db push`, kolom item_type/source + tabel articles +
  policy redeem belum ada di remote. Jalankan push sebelum uji device.
- Risiko MVP tetap: insert earn/redeem via klien (batas 50). Pengerasan
  fase lanjut: trigger/RPC saat verified + cabut policy.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue; sempat 5
  error di article_detail_page/app_router, sudah diperbaiki)
- hasil test: OK (149 test lulus; sempat 4 gagal di article_page_test
  karena kurang ProviderScope, sudah diperbaiki)

## [2026-09-18] - Push migrasi 014 ke Supabase remote

Status: Selesai

File yang diubah:

- Tidak ada perubahan file (hanya `supabase db push` ke remote).

Catatan:

- Migration list remote kini 001-014 sinkron dengan local.
- Policy points_insert_own_earn aktif di remote; submit waste kini bisa
  mencatat poin earn dari klien.
- Verifikasi: migration list Local = Remote 001-014.

## [2026-09-18] - Poin langsung saat submit + Aktivitas/Poin real

Status: Selesai (migration 014 perlu `supabase db push` manual; uji device fisik)

Laporan: setelah foto terverifikasi user tidak dapat poin dan aktivitas kosong.

Temuan:

- SubmitWasteUsecase hanya menghitung estimasi poin tanpa insert ke tabel
  points; tabel points pun tidak punya policy insert klien (by design awal
  "pencatatan sisi server fase lanjut" yang belum ada). Jadi tidak ada baris
  poin yang tercipta.
- ActivityPage dan PointsPage masih memakai data demo (belum baca
  waste_logs/points), sehingga hasil submit tidak tampil di mana pun.
- Keputusan user: poin langsung saat submit (bukan saat verified admin).

File yang dibuat:

- supabase/migrations/014_points_insert_own_earn.sql (dibuat): policy
  points_insert_own_earn (own user_id, type earn, amount 1-50). Belum
  di-push ke remote (konvensi: push manual oleh user).
- lib/features/activity/presentation/data/activity_detail_extra.dart (dibuat):
  ActivityDetailExtra primitif (description/date/status/checkpointName/points).

File yang diubah:

- lib/features/waste/domain/usecases/submit_waste_usecase.dart (diedit): tambah
  typedef RecordEarnPoints + param opsional recordEarnPoints; catat earn
  (reference_id = log.id) setelah insert log. Null berarti estimasi saja.
- lib/features/waste/domain/usecases/calculate_points_usecase.dart (diedit):
  tambah const constructor.
- lib/features/waste/presentation/providers/waste_provider.dart (diedit):
  submitWasteUsecaseProvider wiring recordEarnPoints ke
  PointsRemoteDatasource.addPoints (earn); CalculatePointsUsecase const.
- lib/features/points/data/datasources/points_remote_datasource.dart (diedit):
  client Supabase lazy (aman di test/demo).
- lib/core/constants/app_strings.dart (diedit): tambah pointsHistoryEmpty,
  activityLogPrefix, activityLogAt.
- lib/features/points/presentation/pages/points_page.dart (diedit):
  ConsumerStatefulWidget via pointsNotifierProvider (loading/error+retry+demo
  fallback/data real + EmptyState; tamu selalu demo; reward masih demo).
- lib/features/activity/presentation/pages/activity_page.dart (diedit):
  ConsumerStatefulWidget via wasteRepository.getWasteLogs + nama checkpoint
  (loading/error+retry/demo fallback; item real kirim ActivityDetailExtra).
- lib/features/activity/presentation/pages/activity_detail_page.dart (diedit):
  param extra opsional; render real bila ada (status verified/pending/rejected),
  fallback demo seperti sebelumnya. Stateless, const tetap.
- lib/core/router/app_router.dart (diedit): /activity/:id teruskan
  ActivityDetailExtra via state.extra.
- test/unit/features/waste/waste_submit_notifier_test.dart (diedit): 2 test
  baru recordEarnPoints (tercatat + referensi log; tanpa pencatat = estimasi).
- test/unit/features/waste/calculate_points_test.dart (diedit): const.
- test/widget/pages/points_page_test.dart (diedit): ProviderScope.
- test/widget/pages/activity_detail_page_test.dart (diedit): ProviderScope
  untuk kasus router.
- docs/DATABASE_SCHEMA.md (diedit): RLS points + catatan migration 014.
- docs/ARCHITECTURE.md (diedit): RLS points MVP + alur submit/poin/aktivitas.
- docs/UI_PAGES.md (diedit): section Poin & Reward, Aktivitas, Detail Aktivitas.

Catatan:

- Tanpa migration 014 di remote, submit gagal di langkah catat poin (log
  waste tetap terinsert; retry submit kena duplikat hash). Jalankan
  `supabase db push` dulu sebelum uji device.
- Risiko MVP: user bisa insert earn sendiri via API (batas 50). Pengerasan
  fase lanjut: trigger/RPC saat verified + cabut policy (lihat migration 014).
- Timestamp server tercatat di DB; radius tetap nonaktif sementara
  (enforceGpsRadius = false).

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (149 test lulus, termasuk 2 test baru recordEarnPoints)

## [2026-09-18] - Radius GPS dimatikan sementara untuk uji submit device

Status: Selesai

File yang diubah:

- lib/core/constants/app_values.dart (diedit): tambah flag enforceGpsRadius = false.
- lib/features/waste/presentation/pages/waste_page.dart (diedit): blokir ke kamera hanya bila enforceGpsRadius true; jarak tetap tampil.
- lib/features/waste/presentation/pages/capture_photo_page.dart (diedit): blokir ke verifikasi hanya bila enforceGpsRadius true.
- lib/features/waste/domain/usecases/validate_photo_usecase.dart (diedit): cek jarak hanya bila enforceGpsRadius true (duplikat + rate limit tetap jalan).

Catatan:

- Untuk aktifkan lagi: set enforceGpsRadius = true (satu tempat).
- Duplikat hash dan rate limit 5/hari tetap aktif saat uji submit.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (147 test lulus)

## [2026-09-18] - Wiring Buang Sampah ke Supabase (checkpoint real, radius aktif, submit real)

Status: Selesai (kamera/GPS/submit wajib uji device fisik)

File yang dibuat:

- lib/features/waste/presentation/data/capture_extra.dart (dibuat): CaptureExtra (checkpointId/Name/lat/lng/radius/category) dari Waste ke kamera.
- test/unit/features/waste/waste_submit_notifier_test.dart (dibuat): 3 test WasteSubmitNotifier (sukses poin 30, gagal duplikat, reset idle).

File yang diubah:

- lib/core/constants/app_strings.dart (diedit): tambah wasteCategoryTitle/Organik/Anorganik/DaurUlang/B3, wasteCheckpointEmpty/Error, wastePositionFailed, wasteNeedLogin, wasteSubmitSuccess, wasteDistanceHint.
- lib/features/verification/presentation/data/verification_extra.dart (diedit): tambah checkpointId/Name/latitude/longitude/radius/category.
- lib/features/checkpoints/presentation/providers/checkpoint_provider.dart (diedit): CheckpointNotifier tambah loadAll + inject repository.
- lib/features/waste/presentation/providers/waste_provider.dart (diedit): tambah WasteSubmitNotifier + wasteSubmitNotifierProvider (submit via SubmitWasteUsecase, reset idle).
- lib/features/waste/presentation/pages/waste_page.dart (diedit): ConsumerStatefulWidget, checkpoint dari checkpointNotifierProvider (fallback demo bila error/kosong), posisi GPS real + timeout 3 dtk, LocationStatusCard real (GeoUtils), CategoryChip kategori, blokir ke kamera bila di luar radius (snackbar wasteGpsOutOfRadius), kirim CaptureExtra ke /capture.
- lib/features/waste/presentation/pages/capture_photo_page.dart (diedit): terima CaptureExtra, tegakkan radius GPS sebelum ke verifikasi, teruskan VerificationExtra lengkap (checkpoint, kategori, lat/lng).
- lib/features/verification/presentation/pages/verification_page.dart (diedit): ConsumerStatefulWidget, ref.listen submit sukses (snackbar + ke Home) / gagal (snackbar error), \_submit validasi imagePath/checkpoint/lokasi/login, ambil checkpoint via repository (fallback konstruksi dari extra), baca bytes foto, panggil WasteSubmitNotifier.
- lib/core/router/app_router.dart (diedit): /capture teruskan CaptureExtra via state.extra.
- lib/features/checkpoints/data/datasources/checkpoint_remote_datasource.dart (diedit): client Supabase lazy agar konstruksi provider aman di test/demo.
- lib/features/waste/data/datasources/waste_remote_datasource.dart (diedit): client Supabase lazy (sama).
- test/widget/pages/waste_page_test.dart (diedit): ProviderScope + FakeCheckpointRepository, pumpAndSettle setelah load async.
- test/widget/pages/verification_page_test.dart (diedit): ProviderScope di semua kasus langsung, test kirim tanpa foto harapkan genericError (bukan ke Home).
- docs/UI_PAGES.md (diedit): section Waste/Capture/Verifikasi update ke alur real.
- docs/ARCHITECTURE.md (diedit): catat WasteSubmitNotifier + CaptureExtra/VerificationExtra + lazy client.

Catatan:

- Timestamp server tercatat di DB saat insert (server_timestamp default now()); preview masih waktu device.
- Submit butuh login (Supabase currentUser); bila null arahkan ke Login dengan snackbar wasteNeedLogin.
- Mode demo/test tanpa Supabase tetap jalan via fallback demo dan lazy client; submit real butuh Supabase + GPS device.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (147 test lulus, termasuk 3 test baru WasteSubmitNotifier)

## [2026-09-18] - Push migrasi 011-013 ke Supabase remote

Status: Selesai

File yang diubah:

- Tidak ada perubahan file (hanya `supabase db push` ke remote).

Catatan:

- Migration list remote kini 001-013 sinkron dengan local (sebelumnya 011-013 hanya local).
- Mencakup RPC login username (011), set admin (012), normalisasi username lowercase (013).
- Langkah lanjut: uji login pakai username di device/emulator; bila masih gagal, cek `select email, username from profiles` untuk akun itu lalu UPDATE username manual.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (144 test lulus)
- migration list: 001-013 Local = Remote

## [2026-09-18] - Perbaiki login username gagal: migrasi 013 + regression test

Status: Selesai

Laporan: login pakai email bisa, login pakai username gagal dengan notif
"Email atau kata sandi salah" padahal password benar.

Temuan:

- Kode resolusi username -> email benar (identifier tanpa @ -> RPC
  get_email_by_username dengan input lower+trim). Email bisa login
  membuktikan password benar, sehingga gagalnya di tahap resolusi.
- Penyebab utama: data. Akun lama menyimpan profiles.username
  non-normalisasi (kapital/spasi/display name) karena trigger 007 tidak
  me-lower() dan era AuthService sempat insert manual; RPC tidak cocok
  lalu repository mengembalikan invalidCredentials.
- Celah test: nol test menutup jalur login username (test lama hanya
  identifier email; fake selalu sukses).

File yang dibuat:

- supabase/migrations/013_normalize_usernames.sql (dibuat): lower()
  idempoten untuk username lama; baris yang tabrakan unik dilewati agar
  migrasi tidak gagal (perbaiki manual per akun).
- Catatan: db push manual oleh user (konvensi proyek); 013 belum
  ter-apply ke remote sampai user menjalankan push.

File yang diubah:

- lib/features/auth/data/repositories/supabase_auth_repository.dart (diedit): tambah param opsional isDemoOverride (hanya seam test, produksi tidak berubah).
- test/unit/features/auth/supabase_auth_repository_test.dart (diedit): stub datasource + 6 test baru (resolve sukses + normalisasi, username tak ada, RPC gagal, email lewati RPC, password salah, signUp username dipakai).
- docs/DATABASE_SCHEMA.md (diedit): catatan diagnosis login username + migration 013.
- docs/ARCHITECTURE.md (diedit): catatan data lama, pesan generik anti-enumerasi, cakupan test baru.

Catatan:

- Perbaikan data akun spesifik tetap butuh query manual: select email, username dari profiles untuk akun itu, lalu UPDATE username ke nilai benar bila masih salah (migrasi 013 hanya lower(), tidak menebak username yang dimaksud).
- Pesan error login sengaja tetap generik; pembeda hanya di log terminal.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (144 test lulus, termasuk 6 test baru login username)

## [2026-09-18] - Username unik, nama tampil di Home/Profil, notice login kondisional

Status: Selesai

File yang diubah:

- lib/features/auth/domain/entities/auth_session.dart (diedit): tambah displayName + username di sesi.
- lib/features/auth/domain/repositories/auth_repository.dart (diedit): tambah SignUpResult.usernameTaken, tambah isUsernameTaken, currentAccount tambah username.
- lib/features/auth/data/datasources/auth_remote_datasource.dart (diedit): tambah isUsernameTaken via query profiles ilike.
- lib/features/auth/data/mappers/auth_error_mapper.dart (diedit): duplikat username (profiles_username_key/23505/pesan unik) dipetakan ke usernameTaken.
- lib/features/auth/data/repositories/supabase_auth_repository.dart (diedit): signUp cek username dulu, sesi/state membawa displayName+username dari metadata, tambah isUsernameTaken.
- lib/features/auth/presentation/pages/register_page.dart (diedit): tangani usernameTaken dengan snackbar khusus.
- lib/core/constants/app_strings.dart (diedit): tambah errorUsernameTaken.
- lib/features/home/presentation/pages/home_page.dart (diedit): tambah header sapaan + avatar nama; notice login hanya saat belum login.
- lib/features/profile/presentation/pages/profile_page.dart (diedit): nama kartu profil dari sesi (displayName/username/prefix email), notice hanya saat belum login.
- lib/features/profile/presentation/pages/edit_profile_page.dart (diedit): sesuaikan record currentAccount baru.
- test/support/fake_auth_repository.dart (diedit): dukung displayName/username, takenUsernames, isUsernameTaken.
- test/unit/features/auth/auth_error_mapper_test.dart (diedit): tambah 2 test usernameTaken.
- test/widget/pages/profile_page_test.dart (diedit): cek fallback prefix email + test nama tampilan.
- test/widget/pages/home_login_notice_test.dart (diedit): tambah test header nama + tamu.
- docs/ARCHITECTURE.md (diedit): kontrak auth baru (sesi, usernameTaken, isUsernameTaken, header/nama).
- docs/UI_PAGES.md (diedit): Register (username unik), Home (header nama + notice kondisional), Profile (nama tampilan + notice kondisional).

Catatan:

- Username harus beda: cek awal isUsernameTaken (case-insensitive) untuk pesan jelas; penegak akhir tetap unique constraint profiles_username_key (migration 011) sehingga race tetap aman.
- Nama di Home/Profil: displayName ?? username ?? prefix email ?? nama tamu; tamu tetap "Warga Go Green".
- Notice login: Home dan Profil hanya render LoginNoticeCard saat !isLoggedIn; saat sudah login tidak ada notice.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (138 test lulus)

## [2026-09-17 15:00] - Login username, display_name metadata, telepon profil, admin SQL

Status: Selesai

File yang dibuat:

- supabase/migrations/011_login_username.sql (dibuat): unique username idempoten, RPC get_email_by_username (security definer, grant anon/authenticated), trigger handle_new_user normalisasi lowercase.
- supabase/migrations/012_set_admin.sql (dibuat): update idempoten role admin untuk admin@green.com.

File yang diubah:

- lib/features/auth/domain/repositories/auth_repository.dart (diedit): signIn pakai identifier, signUp pakai username+displayName, tambah currentAccount dan updateProfile, tambah SignUpResult.rateLimited dipakai ulang.
- lib/features/auth/data/datasources/auth_remote_datasource.dart (diedit): signup kirim metadata username+display_name, tambah findEmailByUsername via RPC dan updateUserMetadata.
- lib/features/auth/data/repositories/supabase_auth_repository.dart (diedit): login username diselesaikan ke email di repository; updateProfile/currentAccount dengan logging tanpa data sensitif.
- lib/features/auth/presentation/pages/login_page.dart (diedit): field Email atau Username tanpa validasi format email.
- lib/features/auth/presentation/pages/register_page.dart (diedit): field username (regex lowercase 3-20) + nama tampilan (min 2), kirim username+display_name.
- lib/features/profile/presentation/pages/edit_profile_page.dart (diedit): ConsumerStatefulWidget, prefill dari akun, field telepon opsional, email baca-saja, simpan via updateProfile.
- lib/core/widgets/custom_text_field_widget.dart (diedit): tambah prop enabled (default true).
- lib/core/constants/app_strings.dart (diedit): tambah usernameLabel/Hint, errorUsernameInvalid, errorDisplayNameTooShort, loginIdentityLabel/Hint/Required, phoneLabel/Hint, errorPhoneInvalid.
- test/support/fake_auth_repository.dart (diedit): ikuti kontrak baru.
- test/unit/features/auth/supabase_auth_repository_test.dart (diedit): panggilan signIn/signUp baru.
- test/widget/pages/auth_flow_test.dart (diedit): field register 5 input, error identitas baru.
- test/widget/pages/edit_profile_page_test.dart (diedit): cek field telepon, simpan tanpa ubah email.
- docs/ARCHITECTURE.md (diedit): migration 001-012, kontrak auth baru, subbagian RPC login username.
- docs/UI_PAGES.md (diedit): deskripsi Login, Register, Edit Profil baru.
- docs/COMPONENT_LIBRARY.md (diedit): prop enabled CustomTextField.
- docs/DATABASE_SCHEMA.md (diedit): catatan trigger lowercase, RPC, admin idempoten.

Catatan:

- display_name dan phone disimpan di user_metadata auth; tidak ada kolom/tabel/RLS baru sesuai batasan.
- Deviasi dari rencana: (1) datasource tidak mengembalikan SignInResult (menjaga layering domain vs data; resolusi username di repository); (2) admin sebagai migration 012, bukan supabase/seed/ (folder seed tidak dikenal CLI dan edit 009 yang sudah applied tidak jalan ulang di remote).
- db push TIDAK dijalankan (user menjalankan manual). Migration 011-012 belum ter-apply ke remote.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (133 test lulus)

## [2026-09-17 14:00] - Pesan khusus rate limit registrasi

Status: Selesai

File yang diubah:

- lib/features/auth/domain/repositories/auth_repository.dart (diedit): tambah SignUpResult.rateLimited.
- lib/features/auth/data/mappers/auth_error_mapper.dart (diedit): kode over_request_rate_limit/over_email_send_rate_limit/over_sms_send_rate_limit dan pesan rate limit dipetakan ke rateLimited.
- lib/core/constants/app_strings.dart (diedit): tambah errorRateLimitExceeded.
- lib/features/auth/presentation/pages/register_page.dart (diedit): tangani rateLimited dengan snackbar khusus.
- test/unit/features/auth/auth_error_mapper_test.dart (diedit): test rate limit email mengharapkan rateLimited.

Catatan:

- Ditemukan dari log terminal user: AuthApiException over_email_send_rate_limit (429) setelah Confirm email dimatikan; percobaan ulang dengan alamat yang sama tetap dibatasi sampai jendela rate limit reset.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (auth + auth_flow lulus)

## [2026-09-17 13:00] - Perbaiki sign-up dan login gagal tanpa error jelas

Status: Selesai

File yang diubah:

- lib/features/auth/data/mappers/auth_error_mapper.dart (diedit): mapping login tahan tanpa kode (pesan saja); mapping registrasi kenali AuthWeakPasswordException, kode user_already_exists/email_exists/identity_already_exists, dan varian pesan lemah/bocor (weak, leaked, compromised, breached); signup_disabled dan rate limit tetap error umum tetapi tercatat di log.
- lib/features/auth/data/repositories/supabase_auth_repository.dart (diedit): tambah AppLogger.error di catch signIn/signUp/signInWithGoogle (email saja, tanpa password) dan debug hasil sign-up; error asli kini muncul di terminal.
- lib/features/auth/data/datasources/auth_remote_datasource.dart (diedit): metadata username hanya dikirim bila tidak null.
- lib/features/auth/presentation/pages/register_page.dart (diedit): error umum registrasi tampilkan genericError, bukan pesan login.
- test/unit/features/auth/auth_error_mapper_test.dart (diedit): tambah 6 test (kredensial/belum-konfirmasi tanpa kode, AuthWeakPasswordException, user_already_exists, signup_disabled, rate limit).

Catatan:

- Hipotesis utama: password 123456 ditolak proteksi leaked-password Supabase sehingga user tidak pernah terbuat; mapper lama tidak mengenali varian pesannya dan menampilkan error umum.
- Username metadata memang sudah dikirim sebelum perbaikan; trigger handle_new_user tidak tersentuh.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (133 test lulus, termasuk 6 test baru)

## [2026-09-17 12:00] - Redesign Home sesuai Stitch (tanpa ubah BottomNav)

Status: Selesai

File yang diubah:

- lib/features/home/presentation/pages/home_page.dart (diedit): hero carousel Ayo Mulai + dots, kartu Total Poin Kamu + 3 stat, kartu Misi Hijau Mingguan 63%, Aktivitas Terkini 2 tile, Artikel & Edukasi Hijau; navigasi tetap via go_router; BottomNav dan routing tidak diubah.
- lib/core/constants/app_strings.dart (diedit): tambah homeHeroEyebrow, homeTotalPointsTitle, homeExchangeReward, homeViewHistory, homeStatWasteValue/Label, homeStatCarbonValue/Label, homeStatTreeValue/Label, homeMissionTitle/Desc/Collected/Target, homeLatestActivity, seeAllShort, homeActivity1Title/Time, homeActivity2Title/Time, homeVerifiedLabel, homeArticleSection.
- docs/UI_PAGES.md (diedit): deskripsi Home update ke section Stitch, catat pemetaan token existing dan BottomNav tidak diubah.

Catatan:

- Token Stitch dipetakan ke token existing (surfaceDim, tertiaryLight, surface, primary, borderLight, elevation level1, spacing, radius, typography); tidak ada token baru, tidak ada dependency baru, tidak ada aset baru, tidak ada komponen baru di lib/core/widgets/.
- Asumsi teks kecil Stitch yang blur: 12,5 kg Sampah Terpilah, 35 kg Karbon Dihindari, 5 Pohon Selamat, 3,25 kg terkumpul / Target 5,0 kg.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (127 test lulus)

## [2026-09-16 11:30] - Slide 3 Onboarding Menjadi "Dampak untuk Bumi"

Status: Selesai

File yang diubah:

- lib/features/onboarding/onboarding_page.dart (diedit): slide 3 memakai
  ikon globe dan konten onboardingTitle3/onboardingDesc3.
- lib/core/constants/app_strings.dart (diedit): ganti onboardingCtaTitle/
  onboardingCtaDesc menjadi onboardingTitle3 ("Dampak untuk Bumi") dan
  onboardingDesc3 ("Setiap buang sampah dengan benar mengurangi tumpukan
  liar dan menjaga lingkungan.").

Catatan:

- Keputusan user: slide 3 tidak jadi CTA, melainkan pesan dampak
  lingkungan ("Dampak untuk Bumi") agar menyentuh misi produk.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (127 test lulus)

## [2026-09-16 11:15] - Revert Visual Onboarding ke Ikon, Slide 3 Tetap CTA

Status: Selesai

File yang diubah:

- lib/features/onboarding/onboarding_page.dart (diedit): visual slide
  dikembalikan ke placeholder ikon (kotak 160x160 dengan icon lucide
  recycle/gift/recycle). Slide 3 memakai konten CTA (onboardingCtaTitle/
  onboardingCtaDesc, "Buang Sampah Sekarang").
- lib/core/constants/app_assets.dart (diedit): onboarding1/2/3
  dikembalikan ke path awal assets/images/onboarding_1/2/3.png
  (belum disediakan; dipakai mengganti tampilan gambar ref yang dinilai
  tidak cocok).
- docs/ASSET_MANAGEMENT.md (diedit): catatan pemakaian sementara gambar
  ref untuk onboarding dihapus, daftar TBD ilustrasi onboarding kembali
  ke 3 file.

Catatan:

- Keputusan user: visual onboarding dengan gambar ref terlihat kurang
  bagus sehingga dikembalikan ke desain ikon sebelumnya; hanya isi teks
  slide 3 yang diganti menjadi CTA.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (127 test lulus)

## [2026-09-16 11:00] - Onboarding Pakai Gambar dari Assets dan Slide 3 Jadi CTA

Status: Selesai

File yang diubah:

- lib/features/onboarding/onboarding_page.dart (diedit): ilustrasi slide
  tidak lagi memakai ikon placeholder Lucide; diganti Image.asset dari
  AppAssets dengan sudut membulat. Slide 3 (CTA) memakai gambar yang sama
  dengan slide 1.
- lib/core/constants/app*assets.dart (diedit): onboarding1/onboarding2/
  onboarding3 diarahkan ke gambar folder referensi UI
  (waste_illustration.png, reward_banner.png) karena file onboarding*
  1/2/3.png belum tersedia.
- lib/core/constants/app_strings.dart (diedit): ganti onboardingTitle3/
  onboardingDesc3 menjadi onboardingCtaTitle/onboardingCtaDesc
  ("Buang Sampah Sekarang").
- docs/ASSET_MANAGEMENT.md (diedit): catatan pemakaian sementara gambar
  referensi untuk onboarding dan daftar TBD disesuaikan (2 ilustrasi final,
  tanpa slide ketiga khusus).

Catatan:

- Struktur onboarding tetap 3 halaman: slide 1 (buang sampah), slide 2
  (tukar poin), slide 3 CTA (Buang Sampah Sekarang). Tombol slide 3 tetap
  "Mulai" mengarah ke Home.
- Gambar dipakai sampai aset final onboarding tersedia.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (127 test lulus)
- task UI: screenshot belum dilampirkan (belum dijalankan di device/browser)

## [2026-09-16 10:15] - Sambungkan Project ke Supabase dan Migrasi Database

Status: Selesai

File yang diubah:

- supabase/config.toml (dibuat): hasil supabase init; project_id go_green.
- supabase/.temp/\* (baru, digenerate CLI): project_ref, pooler_url, versi
  komponen. Tidak dicommit (di .gitignore Supabase).
- supabase/migrations/010_fix_rls_recursion.sql (baru): perbaikan
  infinite recursion pada policy RLS.

Catatan:

- Project Supabase tujuan: bnwntvfeelwgardryjec ("renown's Project",
  wilayah Seoul), sudah di-link via supabase link.
- Migration 001-009 dari supabase/migrations/ berhasil di-push.
- Seed data masuk: 3 checkpoint (CP-001 s/d CP-003) dan 5 reward.
- Ditemukan bug: query SELECT ke public.checkpoints dan public.profiles
  gagal dengan "infinite recursion detected in policy for relation
  profiles" (42P17) meski fungsi role sudah security definer
  (points/redemptions terbukti sehat). Penyebab: policy nyasar di luar
  definisi kanonik. Migration 010 membersihkan semua policy tabel
  publik Go Green lalu membuat ulang definisi kanonik (RK) dan fungsi
  bantu role. Setelah 010, seluruh tabel bisa diakses via REST 200.
- Bucket storage waste-photos (private) dan avatars (public) dibuat
  via migration 008; bucket privat memang tidak tampil untuk anon.
- Signup berhasil terhadap auth Supabase (user uji
  sgo.green.test@gmail.com). Login belum bisa dites sampai email
  dikonfirmasi; setelan "Confirm email" aktif di dashboard Supabase.
- Telah dibuat user uji yang tidak merusak produksi; bisa dihapus dari
  Authentication di dashboard bila tidak dipakai.

Verifikasi:

- hasil linter/analyze: tidak ada perubahan kode Dart pada task ini.
- hasil test: tidak ada perubahan test pada task ini.
- migration list: 001-010 Local = Remote.
- REST (anon): checkpoints 200 (3 baris), rewards 200 (5 baris),
  profiles/waste_logs/points/redemptions 200 (kosong).

## [2026-09-16 10:45] - Hapus Toggle Mode Gelap (Segera Hadir) dari Pengaturan

Status: Selesai

File yang diubah:

- lib/features/profile/presentation/pages/settings_page.dart (diedit): toggle
  Mode Gelap dihapus karena belum tersedia; state \_darkModeEnabled dan baris
  switch ikut dihapus. Doc header halaman disesuaikan.
- lib/core/constants/app_strings.dart (diedit): hapus settingsDarkMode dan
  settingsDarkModeDesc yang tidak terpakai.
- test/widget/pages/settings_page_test.dart (diedit): hapus asersi dan test
  toggle mode gelap.

Catatan:

- Bagian "segera hadir" (mode gelap) tidak lagi ditampilkan di halaman
  Pengaturan.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (settings_page_test lulus)

## [2026-09-16 10:30] - Layer Data-Domain-Presentation Waste, Checkpoint, Points, Reward

Status: Selesai

File yang diubah:

- lib/core/constants/app_enums.dart (diedit): tambah enum WasteSource
  (qrScan/manual/nfc) dengan fromDb default manual.
- lib/core/constants/app_values.dart (diedit): tambah maxWasteLogsPerDay,
  basePointsPerWaste, categoryBonusOrganik/Anorganik/DaurUlang/B3,
  streakBonusThreshold, streakBonusPoints.
- lib/core/constants/app_strings.dart (diedit): tambah wasteGpsOutsideLabel,
  errorPhotoDuplicate, errorRateLimitReached, photoAttachedLabel.
- lib/features/checkpoints/data/datasources/checkpoint_remote_datasource.dart
  (baru): get/select checkpoint beserta pencarian nearby via GeoUtils.
- lib/features/checkpoints/domain/repositories/checkpoint_repository.dart
  dan data/repositories/checkpoint_repository_impl.dart (baru).
- lib/features/checkpoints/domain/usecases/get_nearby_checkpoints_usecase.dart
  (baru).
- lib/features/checkpoints/presentation/providers/checkpoint_provider.dart
  (baru): CheckpointNotifier (AsyncValue).
- lib/features/checkpoints/presentation/widgets/checkpoint_tile.dart (baru).
- lib/features/waste/domain/entities/waste_log.dart (diedit): tambah field
  WasteSource source.
- lib/features/waste/data/models/waste_log_model.dart (diedit): source pada
  fromJson/toJson.
- lib/features/waste/data/datasources/waste_remote_datasource.dart (diedit):
  insertWasteLog menerima source; tambah checkDuplicateHash dan
  countTodayWasteLogs.
- lib/features/waste/domain/repositories/waste_repository.dart dan
  data/repositories/waste_repository_impl.dart (baru).
- lib/features/waste/domain/usecases/calculate_points_usecase.dart (baru):
  poin dasar + bonus kategori + bonus streak.
- lib/features/waste/domain/usecases/validate_photo_usecase.dart (baru):
  cek duplikat hash, radius GPS (haversine murni Dart), rate limit.
- lib/features/waste/domain/usecases/submit_waste_usecase.dart (baru):
  hash SHA-256 -> validasi -> upload -> insert log -> hitung poin.
- lib/features/waste/presentation/providers/waste_provider.dart (baru).
- lib/features/waste/presentation/widgets/location_status_card.dart,
  category_chip.dart, photo_upload_container.dart (baru).
- lib/features/points/domain/entities/point.dart dan
  data/models/point_model.dart (baru).
- lib/features/points/presentation/providers/point_provider.dart (baru):
  PointsNotifier (saldo + riwayat).
- lib/features/rewards/data/datasources/reward_remote_datasource.dart (baru):
  katalog reward + redeemReward yang mendelegasi ke PointsRemoteDatasource.
- lib/features/rewards/presentation/providers/reward_provider.dart (baru).
- lib/core/widgets/app_checkbox.dart, app_password_field.dart, app_icon.dart,
  app_error_state.dart (baru).
- lib/core/widgets/custom_text_field_widget.dart (diedit): tambah
  onFieldSubmitted.
- test/unit/features/waste/calculate_points_test.dart (baru).

Catatan:

- Mengisi gap arsitektur data-domain-presentation untuk Waste, Checkpoint,
  Points, dan Reward tanpa mengubah kode lama yang sudah berjalan (opsi
  "Isi gap saja").
- app_button_test.dart yang sudah ada tidak diduplikasi.

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (128 test lulus, termasuk calculate_points_test)

## [2026-09-15] - Perbaikan: Back Button Navigasi Free Routes

Status: Selesai

File yang diubah:

- lib/features/home/presentation/pages/home_page.dart (diedit): navigasi dari
  Home ke free routes yang seharusnya bisa kembali (editProfile, article,
  articleDetail, scan) diganti dari context.goNamed menjadi context.pushNamed
  agar halaman Home tetap ada di back stack.
- lib/features/points/presentation/pages/points_page.dart (diedit): navigasi
  dari Points ke rewardDetail diganti dari context.goNamed menjadi
  context.pushNamed agar halaman Points tetap ada di back stack.
- lib/features/article/presentation/pages/article_page.dart (diedit): navigasi
  dari daftar artikel ke articleDetail diganti dari context.goNamed menjadi
  context.pushNamed agar halaman daftar artikel tetap ada di back stack.
- test/widget/pages/back_navigation_test.dart (baru): test regresi back button
  untuk alur Home <> daftar artikel <> detail artikel dan Points <> detail
  reward dengan appRoutes asli (StatefulShellRoute).

Verifikasi:

- hasil linter/analyze: OK (flutter analyze tidak ada issue)
- hasil test: OK (120 test lulus, termasuk back_navigation_test)

## [2026-09-15] - Kecil: Posisi Cari Artikel & Navigasi Avatar Profile

Status: Selesai

File yang diubah:

- lib/features/home/presentation/pages/home_page.dart (diedit): field
  pencarian (SearchField) dipindah dari bawah header ke atas section
  "Artikel Terbaru" (setelah PointCard); avatar profil di header Home
  kini bisa ditekan dan mengarah ke halaman Edit Profil
  (AppRouteName.editProfile).

Verifikasi:

- hasil linter/analyze: OK (dart analyze tidak ada issue)
- hasil test: OK (home_login_notice_test dan auth_flow_test lulus)

Status: Selesai

File yang diubah:

- lib/features/home/presentation/pages/home_page.dart (diedit): tampilan
  Home didesain ulang sesuai contoh clipboard — header sapaan dengan avatar
  (widget Avatar) dan tombol lonceng, field pencarian (SearchField), banner
  hero "Buang Sampah, Dapat Poin!" dengan gambar aset home_promo.png dari
  folder ref sebagai latar, gradient overlay gelap, dan tombol CTA; section
  "Menu Utama" berisi empat kartu aksi cepat (Buang Sampah, Poin & Reward,
  Artikel, Scan QR) dalam satu baris; PointCard dan daftar Artikel Terbaru
  dengan thumbnail gambar (article_1.png, article_2.png dari folder ref).
- lib/core/widgets/card_widgets.dart (diedit): ArticleCard ditambah propopsi
  thumbnailImage (String?) sehingga gambar thumbnail aset bisa ditampilkan;
  jika null tetap fallback ke ikon placeholder seperti sebelumnya.
- lib/core/constants/app_assets.dart (diedit): tambah path aset homeBannerHero,
  articleThumb1, articleThumb2 (dari folder referensi UI).
- lib/core/constants/app_strings.dart (diedit): tambah string homeMenuTitle,
  homeHeroTitle, homeHeroSubtitle, homeHeroCta untuk hero dan section menu.
- pubspec.yaml (diedit): deklarasi aset folder assets/images/ref/ agar gambar
  referensi bisa diakses saat runtime.
- docs/UI_PAGES.md (diedit): update deskripsi section Home.
- docs/COMPONENT_LIBRARY.md (diedit): update deskripsi ArticleCard prop
  thumbnailImage.
- docs/ASSET_MANAGEMENT.md (diedit): catatan bahwa gambar referensi hero dan
  thumbnail dipakai sementara sebagai aset produksi Home.

Catatan:

- Data home masih placeholder (nama "Warga Go Green", total poin 250, dua
  artikel demo). Belum terhubung provider/state nyata.
- Avatar bell menampilkan snackbar "Fitur ini belum tersedia."
- Gambar referensi di folder ref sementara dipakai langsung sebagai aset
  produksi Home; akan diganti dengan aset produksi akhir ketika tersedia.

Verifikasi:

- hasil linter/analyze: OK (dart analyze lib/ tidak ada issue)
- hasil test: OK (home_login_notice_test, auth_flow_test, card_widgets_test
  lulus semua)

Status: Selesai

File yang diubah:

- lib/features/auth/presentation/pages/register_page.dart (diedit): layout
  disamakan dengan LoginPage — ikon daun di atas kiri, judul "Daftar"
  rata kiri, background AuthLeafDecoration (Positioned.fill), form nama/
  email/kata sandi/konfirmasi, tombol Daftar, divider "atau", tombol
  "Daftar dengan Google", link ke Login, dan ilustrasi AuthLeafSprig di
  pojok kanan bawah. AuthHeaderWidget tidak dipakai lagi di halaman ini.

Catatan:

- Urutan tombol Google dan link masuk tetap di bawah sesuai permintaan.
- Tidak ada perubahan logic (validasi, routing, Supabase tetap sama).

Verifikasi:

- hasil linter/analyze: OK (dart analyze tidak ada issue)
- hasil test: tidak dijalankan (sesuai permintaan user)

## [2026-09-15] - Login Berlatar Daun Sesuai Referensi UI

Status: Selesai

File yang diubah:

- lib/core/widgets/auth_leaf_decoration.dart (dibuat): dekorasi latar
  autentikasi (AuthLeafDecoration, lingkaran lembut + ikon daun samar di
  sudut layar) dan ilustrasi daun pojok kanan bawah (AuthLeafSprig).
  Warna memakai token (secondaryContainer, tertiaryLight, surfaceDim).
- lib/features/auth/presentation/pages/login_page.dart (diedit): layout
  disusun ulang meniru contoh UI clipboard/login_leaves.png yaitu ikon
  daun di atas, judul besar kiri, baris "Ingat saya" + "Lupa kata sandi?",
  tombol masuk, divider "atau", masuk dengan Google, link daftar, dan
  ilustrasi daun kanan bawah. Background daftar daun ditambahkan pada
  Stack; AuthHeaderWidget tidak dipakai lagi di halaman ini.
- lib/core/constants/app_strings.dart (diedit): tambah string rememberMe
  ("Ingat saya") dan forgotPassword ("Lupa kata sandi?").

Catatan:

- Urutan tombol Google dan link register tetap di bawah sesuai permintaan.
- Link "Lupa kata sandi?" menampilkan snackbar fitur belum tersedia.
- RegisterPage tidak diubah.
- Gambar di assets/images/ref/ tidak dipakai langsung sebagai aset produksi
  (hanya referensi visual); dekorasi dibangun dengan token tema.

Verifikasi:

- hasil linter/analyze: OK (dart analyze tidak ada issue)
- hasil test: OK (auth_flow_test dan home_login_notice_test lulus)

## [2026-09-15] - Polish Tampilan Login & Register

Status: Selesai

- core/widgets/auth_header_widget.dart (baru): header autentikasi reusable
  (logo daun + judul + deskripsi) dengan spacing konsisten, dipakai oleh
  LoginPage dan RegisterPage agar tampilan kedua halaman seragam.
- Halaman Login & Register: subtitle deskriptif di bawah judul, dekorasi
  latar daun halus (token secondaryContainer + alpha), dan jarak antar
  elemen yang konsisten sesuai DESIGN_SYSTEM. Layout asli dipertahankan
  (Google sign-in, divider "atau", urutan field, routing go_router,
  validasi, dan Supabase tidak berubah).
- Test widget auth_flow: perbaikan agar tombol PrimaryButton dipastikan
  terlihat (ensureVisible) sebelum ditekan, sesuai form yang scrollable.

## [2026-09-15] - Google Sign-In Satu Klik (Login & Register)

Status: Selesai

- Fitur: tombol "Masuk dengan Google" (globe icon, lucide) pada halaman Login
  dan Register. Satu klik langsung login/daftar tanpa isi email manual.
- auth (data/repositories/supabase_auth_repository.dart): tambah
  signInWithGoogle via Supabase Auth OAuth (signInWithOAuth). Error
  non-api di-mapping via AuthErrorMapper.mapSignInError
  (networkError -> pesan "Gagal masuk..." / ekor).

## [2026-09-15] - Auth Login Riil (Repository Layer: Supabase)

Status: Selesai

- Ganti AuthService (lib/core/services/auth_service.dart) dengan lapisan
  auth berarsitektur presentation -> domain -> data. File auth_service.dart
  dihapus; operasi auth kini lewat AuthRepository.
- Domain (lib/features/auth/domain/):
  - entities/auth_session.dart: AuthSession (userEmail, isLoggedIn).
  - repositories/auth_repository.dart: AuthRepository + enum
    SignInResult (success, invalidCredentials, notConfirmed, networkError,
    error) dan SignUpResult (success, alreadyRegistered, needsConfirmation,
    weakPassword, networkError, error).
- Data (lib/features/auth/data/):
  - datasources/auth_remote_datasource.dart: rewire ke Supabase Auth riil
    (signInWithEmail, signUpWithEmail, signOut, currentSession,
    authStateChanges) dengan SupabaseService.instance lazy.
  - repositories/supabase_auth_repository.dart: demonya tetap jalan bila
    Supabase belum terinisialisasi (delay 800ms) supaya widget test aman.
  - mappers/auth_error_mapper.dart: memetakan kode error Supabase
    (invalid_credentials, email_not_confirmed, already registered, weak
    password) dan error jaringan (SocketException, timeout) ke enum.
- Presentation (lib/features/auth/presentation/providers/auth_provider.dart):
  authRepositoryProvider + authNotifierProvider (AuthNotifier
  StateNotifier<AuthSession>) menggantikan authNotifierProvider model lama.
- Login/Register/Profile/Home dipindah dari AuthService ke repository;
  hasil SignInResult/SignUpResult menampilkan snackbar error maping.
- app_strings.dart: tambah errorLoginInvalid, errorEmailNotConfirmed,
  errorNetwork, errorWeakPassword, signUpConfirmationSent.
- Test: tambah auth_error_mapper_test + supabase_auth_repository_test
  (mode demo), FakeAuthRepository di test/support; widget test profil/home
  beralih ke FakeAuthRepository. flutter analyze 0 issue; 116 test lulus.

---

## [2026-09-15] - Setup Supabase Lengkap: Schema, Migration, Data Layer

Status: Selesai

- docs/DATABASE_SCHEMA.md: sumber kebenaran struktur database.
- Migration SQL baru (supabase/migrations/001-009) sesuai DATABASE_SCHEMA.md:
  001 profiles (id, email, username, role) + fungsi role security definer;
  002 checkpoints; 003 waste_logs; 004 points; 005 rewards; 006
  redemptions; 007 trigger handle_new_user; 008 storage buckets
  waste-photos + avatars; 009 seed data (opsional).
- Migration lama 202609150001/0002 dihapus karena belum pernah dijalankan
  dan schema-nya berbeda dari DATABASE_SCHEMA.md.
- AppTables (lib/core/constants/app_tables.dart): konstanta nama tabel
  dan bucket Supabase.
- AppEnums (lib/core/constants/app_enums.dart): UserRole, WasteCategory,
  WasteLogStatus, RedemptionStatus, PointType dengan fromDb().
- SupabaseService (lib/core/services/supabase_service.dart): tambah
  currentUser dan signOut (aman dipanggil dalam mode demo).
- AuthService (lib/core/services/auth_service.dart): signUp tidak lagi
  insert manual ke profiles; metadata username dikirim ke trigger
  handle_new_user yang membuat baris profil otomatis.
- auth_remote_datasource.dart: signInWithEmail, signUpWithEmail,
  signInWithGoogle, signOut, getCurrentUser, getProfile.
- waste_remote_datasource.dart: uploadPhoto (max 5 MB), insertWasteLog,
  getWasteLogs, getPendingWasteLogs, verifyWasteLog.
- points_remote_datasource.dart: getTotalPoints, getPointsHistory,
  addPoints, redeemPoints (pencatatan poin sisi server fase lanjut).
- Entity + Model: WasteLog/WasteLogModel, Profile/ProfileModel,
  Checkpoint/CheckpointModel, Reward/RewardModel.

File yang dibuat:

- docs/DATABASE_SCHEMA.md
- supabase/migrations/001_create_profiles.sql
- supabase/migrations/002_create_checkpoints.sql
- supabase/migrations/003_create_waste_logs.sql
- supabase/migrations/004_create_points.sql
- supabase/migrations/005_create_rewards.sql
- supabase/migrations/006_create_redemptions.sql
- supabase/migrations/007_create_triggers.sql
- supabase/migrations/008_create_storage_buckets.sql
- supabase/migrations/009_seed_data.sql
- lib/core/constants/app_tables.dart
- lib/core/constants/app_enums.dart
- lib/features/auth/data/datasources/auth_remote_datasource.dart
- lib/features/waste/data/datasources/waste_remote_datasource.dart
- lib/features/points/data/datasources/points_remote_datasource.dart
- lib/features/waste/domain/entities/waste_log.dart
- lib/features/waste/data/models/waste_log_model.dart
- lib/features/profile/domain/entities/profile.dart
- lib/features/profile/data/models/profile_model.dart
- lib/features/checkpoints/domain/entities/checkpoint.dart
- lib/features/checkpoints/data/models/checkpoint_model.dart
- lib/features/rewards/domain/entities/reward.dart
- lib/features/rewards/data/models/reward_model.dart

File yang dihapus:

- supabase/migrations/202609150001_initial_schema.sql
- supabase/migrations/202609150002_storage_buckets.sql

File yang diubah:

- lib/core/services/supabase_service.dart (diedit: +currentUser, +signOut)
- lib/core/services/auth_service.dart (diedit: signUp pakai trigger)
- lib/core/constants/app_values.dart (diedit: +maxPhotoBytes)
- docs/ARCHITECTURE.md (diedit: section 10 diupdate schema baru)

Verifikasi: flutter analyze bersih (0 issue), 101 test lulus,
docs/ARCHITECTURE.md diperbarui.

---

## [2026-09-15] - Auth Supabase + Profil Kondisional

Status: Selesai

- AuthService (lib/core/services/auth_service.dart): signIn, signUp,
  signOut, currentUser, onAuthStateChange berbasis Supabase Auth. Dalam
  mode demo (Supabase belum terinisialisasi, contoh pada test widget)
  operasi disimulasikan agar UI tetap bisa berjalan.
- authNotifierProvider (lib/features/auth/presentation/providers/):
  status autentikasi yang mengikuti perubahan sesi Supabase
  (onAuthStateChange).
- Login page: memanggil AuthService; gagal menampilkan
  "Gagal masuk..." (errorLoginFailed).
- Register page: memanggil AuthService; menangani case email sudah
  terdaftar dan error.
- Halaman Profil kondisional berikut status login:
  - Belum login: notice login (LoginNoticeCard) "Masuk atau daftar...",
    menu Pengaturan; TANPA "Keluar" dan TANPA "Edit Profil".
  - Sudah login: menampilkan email user, Edit Profil, Pengaturan, dan
    "Keluar" (signOut -> kembali ke Home).
- Notice login di Home otomatis hilang saat sudah login (tetap bisa
  di-tutup oleh tamu). Widget LoginNoticeCard dipakai bersama Home dan
  Profil.
- String baru: errorLoginFailed, errorEmailRegistered, profileLoginNotice.

File yang diubah:

- lib/core/services/auth_service.dart (baru)
- lib/core/services/supabase_service.dart (diedit: isInitialized + .env)
- lib/features/auth/presentation/providers/auth_provider.dart (baru)
- lib/features/auth/presentation/pages/login_page.dart (diedit)
- lib/features/auth/presentation/pages/register_page.dart (diedit)
- lib/features/home/presentation/pages/home_page.dart (diedit)
- lib/features/profile/presentation/pages/profile_page.dart (diedit)
- lib/core/widgets/login_notice_widget.dart (baru)
- lib/core/constants/app_strings.dart (diedit)
- test/widget/pages/profile_page_test.dart (ditulis ulang)
- test/widget/pages/home_login_notice_test.dart (ditambah test login)
- test/widget/pages/edit_profile_page_test.dart (diedit)
- test/widget/pages/verification_page_test.dart (diedit)

Verifikasi: flutter analyze bersih (0 issue), 101 test lulus,
docs diubah di UI_PAGES.md.

---

## [2026-09-15] - Setup Supabase: Kredensial, Schema, RLS, Storage

Status: Parsial (schema/RLS/storage siap; email/password auth via dashboard
manual)

- Kredensial Supabase (SUPABASE_URL + SUPABASE_ANON_KEY) di .env
  (gitignored). supabase_service.dart membaca dari --dart-define dulu,
  fallback ke .env via flutter_dotenv. Dilarang hardcode secret.
- Migration SQL baru di supabase/migrations/:
  - 202609150001_initial_schema.sql: profiles, checkpoints,
    waste_submissions, rewards, reward_claims, articles, points_log + RLS.
  - 202609150002_storage_buckets.sql: bucket waste-evidence (private),
    article-covers (public read) + RLS storage path user.
- Belum dikerjakan (langkah manual): jalankan migration di SQL Editor,
  aktifkan email/password auth di dashboard.

File yang diubah:

- .env (baru, gitignored)
- .env.example (diedit: instruksi)
- lib/core/services/supabase_service.dart (diedit: fallback .env)
- supabase/migrations/202609150001_initial_schema.sql (baru)
- supabase/migrations/202609150002_storage_buckets.sql (baru)
- docs/ARCHITECTURE.md (diedit: section 10 diisi status aktual)

Verifikasi: flutter analyze bersih; dokumentasi diperbarui.

---

## [2026-09-15] - Perilaku Back: Kembali ke Home Dulu + Exit 2x

Status: Selesai

Perubahan perilaku tombol back (di MainShell/PopScope):

- Di tab selain Beranda (misal Poin), back kembali ke tab Beranda dulu
  (lewat goBranch ke branch 0), bukan langsung keluar aplikasi.
- Di tab Beranda, back pertama menampilkan snackbar "Tekan kembali lagi
  untuk keluar"; back kedua dalam 2 detik menutup aplikasi
  (SystemNavigator.pop).

File yang diubah:

- lib/core/widgets/main_shell.dart (diedit: jadi StatefulWidget,
  PopScope + logika back, SystemNavigator)
- lib/core/constants/app_strings.dart (diedit: backToExitHint)
- test/widget/pages/auth_flow_test.dart (diedit: 2 test back baru)

Verifikasi: flutter analyze bersih (0 issue), 99 test lulus,
docs diubah di UI_PAGES.md.

---

## [2026-09-15] - Login Tidak Wajib di Awal + Notice Login di Home

Status: Selesai

Perubahan alur:

- Setelah Splash dan Onboarding (yang bisa dilewati), user LANGSUNG masuk
  ke Home, tidak lagi diarahkan ke halaman Login.
- Login/Register tetap tersedia; di Home tampil notice login berupa banner
  di bagian atas yang bisa ditutup (ikon x), dengan aksi "Masuk" yang
  membuka halaman Login.
- Notice bersifat per-sesi (state lokal HomePage); login dari notice
  mengarah kembali ke Home setelah berhasil.

File yang diubah:

- lib/features/onboarding/onboarding_page.dart (diedit: last slide dan
  tombol Lewati ke Home)
- lib/features/home/presentation/pages/home_page.dart (diedit: jadi
  StatefulWidget + \_LoginNoticeBanner)
- lib/core/constants/app_strings.dart (diedit: homeLoginNotice\*)
- test/widget/pages/auth_flow_test.dart (diedit: ekspektasi ke Home)
- test/widget/pages/home_login_notice_test.dart (baru)

Verifikasi: flutter analyze bersih (0 issue), 97 test lulus,
docs diubah di UI_PAGES.md.

---

## [2026-09-15] - Tampilan Timestamp pada Foto + Radius Dinonaktifkan Sementara

Status: Selesai

Fitur baru:

- Halaman Verifikasi menampilkan timestamp hasil pengambilan foto:
  - Overlay timestamp di bagian bawah preview foto (ikon jam + label),
  - Baris detail Timestamp ikut menampilkan nilai yang sama.
- Timestamp diambil saat shutter di halaman kamera memakai waktu device dan
  diformat "12 Sep 2026, 14.32 WIB" (formatIndonesianTimestamp).
  Catatan: sementara memakai waktu device sampai timestamp server terpasang
  bersama layer Supabase.

Pengingat (diminta user):

- Cek radius GPS 100 m dari checkpoint yang dibuat sebelumnya DIHAPUS
  sementara agar tidak memblokir preview. Untuk reaktivasi, tinggal
  menghidupkan pemakaian AppValues.gpsRadiusMeters + GeoUtils.distanceMeters
  di \_takePicture (capture_photo_page.dart) dan menampilkan jarak kembali.
  Aset pendukung (koordinat checkpoint, util, konstanta) sengaja disimpan.

File yang diubah:

- lib/core/utils/formatters.dart (diedit: formatIndonesianTimestamp)
- lib/features/verification/presentation/data/verification_extra.dart
  (diedit: timestampLabel; hapus checkpointName/distanceFromCheckpoint)
- lib/features/waste/presentation/pages/capture_photo_page.dart (diedit:
  hapus cek radius, tambah timestamp)
- lib/features/waste/presentation/pages/waste_page.dart (diedit: tidak
  lagi kirim checkpoint ke kamera)
- lib/core/router/app_router.dart (diedit: revert extra /capture)
- lib/features/verification/presentation/pages/verification_page.dart
  (diedit: overlay timestamp pada foto)
- test/unit/core/formatters_test.dart (diedit)
- test/widget/pages/verification_page_test.dart (diedit)

Verifikasi: flutter analyze bersih (0 issue), 94 test lulus,
docs diubah di UI_PAGES.md.

---

## [2026-09-15] - Cek Radius GPS Checkpoint (Anti-Kecurangan)

Status: Selesai (cek radius wajib diuji di device fisik)

Fitur baru:

- Cek radius GPS sebelum lanjut ke verifikasi: jarak posisi user ke
  checkpoint terpilih dihitung dengan geolocator.distanceBetween. Jika lebih
  dari 100 m (AppValues.gpsRadiusMeters), upload diblokir dan ditampilkan
  pesan "Kamu berada di luar radius checkpoint".
- Checkpoint demo kini membawa koordinat (lat/lng) dan dikirim ke halaman
  kamera via route extra.
- Halaman Verifikasi menampilkan jarak ke checkpoint, misal
  "-6.200000, 106.816667 (25 m dari TPS Kelurahan)".
- LocationService refactor: getCurrentPosition() mengembalikan Position,
  formatPositionLabel() memformat koordinat.
- Dependency baru (dev): geolocator_platform_interface ^4.3.0 untuk fake
  pada unit test LocationService/GeoUtils. Evaluasi (PROTOCOL Bagian C):
  milik tim geolocator, sudah diresolusi transitif di dependency graph,
  aktif dipelihara; alternatif dievaluasi: mock method channel
  "flutter.baseflow.com/geolocator" (fragile, tidak dipilih).

File yang diubah:

- lib/core/constants/app_values.dart (dibuat: gpsRadiusMeters)
- lib/core/utils/geo_utils.dart (dibuat: distanceMeters)
- lib/features/waste/presentation/data/checkpoint_demo_data.dart (dibuat)
- lib/core/services/location_service.dart (diedit)
- lib/features/waste/presentation/pages/capture_photo_page.dart (diedit:
  cek radius + kirim checkpoint)
- lib/features/waste/presentation/pages/waste_page.dart (diedit: pakai
  data checkpoint baru + kirim checkpoint terpilih)
- lib/features/verification/presentation/data/verification_extra.dart
  (diedit: checkpointName + distanceFromCheckpoint)
- lib/features/verification/presentation/pages/verification_page.dart
  (diedit: tampil jarak ke checkpoint)
- lib/core/router/app_router.dart (diedit: extra /capture)
- lib/core/constants/app_strings.dart (diedit: pesan luar radius)
- pubspec.yaml (diedit: dev dep geolocator_platform_interface)
- test/unit/core/location_service_test.dart (dibuat)
- test/widget/pages/verification_page_test.dart (diedit)

Verifikasi: flutter analyze bersih (0 issue), 92 test lulus,
docs diubah di UI_PAGES.md dan ARCHITECTURE.md.

---

## [2026-09-15] - Perbaikan Kamera: Lokasi GPS Asli, Retake, dan Flash

Status: Selesai (kamera/GPS/flash menunggu pengujian device fisik)

Perbaikan bug:

- Lokasi verifikasi kini memakai koordinat GPS asli (geolocator) saat foto
  diambil, dikirim via data ekstra route, bukan teks demo statis. Jika GPS
  mati atau izin lokasi ditolak ditampilkan pesan "Lokasi tidak dapat
  diambil".
- Layar hitam saat "Coba Lagi" diperbaiki: kamera pindah ke Verifikasi pakai
  push (bukan go), sehingga halaman kamera tetap hidup dan tombol "Coba
  Lagi" kembali ke kamera yang masih berfungsi.
- Flash kamera: tombol flash (mati -> otomatis -> menyala) memakai
  setFlashMode; ikon zap_off/zap dengan tooltip.
- Retry inisialisasi kamera kini membuang controller lama sebelum membuat
  yang baru agar tidak menyisakan instance rusak.
- Preview foto bukti ditampilkan di halaman Verifikasi dari file hasil
  takePicture; izin lokasi (Android manifest dan Info.plist) ditambahkan.

File yang diubah:

- lib/core/services/location_service.dart (dibuat)
- lib/features/verification/presentation/data/verification_extra.dart (dibuat)
- lib/features/waste/presentation/pages/capture_photo_page.dart (diedit)
- lib/features/verification/presentation/pages/verification_page.dart (diedit)
- lib/core/router/app_router.dart (diedit: baca extra verifikasi)
- lib/core/constants/app_strings.dart (diedit: string flash dan lokasi gagal)
- android/app/src/main/AndroidManifest.xml (diedit: izin lokasi)
- ios/Runner/Info.plist (diedit: NSLocationWhenInUseUsageDescription)
- test/widget/pages/verification_page_test.dart (diedit)

Verifikasi: flutter analyze bersih (0 issue), 85 test lulus,
docs diubah di UI_PAGES.md.

---

## [2026-09-15] - Detail Aktivitas, Skip Onboarding, dan Akses Scan QR

Status: Selesai (front-end, data demo)

Fitur baru:

- Detail Aktivitas: halaman di route /activity/:id menampilkan header status,
  deskripsi, dan baris detail (tanggal, checkpoint, poin). Kartu aktivitas di
  riwayat membuka halaman ini.
- Onboarding: tombol "Lewati" untuk langsung menuju Login.
- Waste: link "Scan QR di checkpoint" sebagai pintu masuk halaman Scan QR.

File yang diubah:

- lib/features/activity/presentation/data/activity_demo_data.dart (dibuat)
- lib/features/activity/presentation/pages/activity_detail_page.dart (dibuat)
- lib/features/activity/presentation/pages/activity_page.dart (diedit: data demo + navigasi)
- lib/features/onboarding/onboarding_page.dart (diedit: tombol Lewati)
- lib/features/waste/presentation/pages/waste_page.dart (diedit: link scan QR)
- lib/core/router/app_router.dart (diedit: route /activity/:id)
- lib/core/constants/app_strings.dart (diedit: string detail aktivitas, lewati, scan)
- test/widget/pages/activity_detail_page_test.dart (dibuat)
- test/widget/pages/auth_flow_test.dart (diedit: test lewati onboarding)
- test/widget/pages/waste_page_test.dart (diedit: test link scan)

Verifikasi: flutter analyze bersih (0 issue), 82 test lulus,
dokumen diubah di UI_PAGES.md dan ARCHITECTURE.md (daftar route).

---

## [2026-09-15] - Kamera In-App, Edit Profil, Pengaturan, dan Polish UI

Status: Selesai (kamera/GPS menunggu pengujian device fisik)

Fitur baru:

- Kamera in-app (anti-kecurangan): halaman CapturePhotoPage memakai package
  camera dengan izin permission_handler. Izin ditolak dan kamera tidak
  tersedia punya fallback UI. Tombol shutter mengarah ke halaman Verifikasi.
- Edit Profil: form nama + email (terisi data demo), validasi, simpan dengan
  snackbar sukses, lalu kembali.
- Pengaturan: menu akun (Edit Profil), toggle Notifikasi dan Mode Gelap
  (lokal), informasi aplikasi (versi + dialog Tentang).
- Tukar reward: dialog konfirmasi, sukses ditampilkan lewat snackbar.

Polish UI:

- PointCard: gradient primary->primaryLight + ring ikon.
- Bottom nav: tinggi 72, indikator titik aktif, bayangan pada tombol aksen.
- Profil: avatar dengan ring primaryLight.

File yang diubah:

- lib/features/waste/presentation/pages/capture_photo_page.dart (dibuat)
- lib/features/profile/presentation/pages/edit_profile_page.dart (dibuat)
- lib/features/profile/presentation/pages/settings_page.dart (dibuat)
- lib/core/router/app_router.dart (diedit: route /capture, /edit-profile, /settings)
- lib/core/constants/app_strings.dart (diedit: string capture/profil/setting/tukar)
- lib/features/waste/presentation/pages/waste_page.dart (diedit: tombol Ambil Foto ke kamera)
- lib/features/profile/presentation/pages/profile_page.dart (diedit: navigasi + ring avatar)
- lib/features/points/presentation/pages/reward_detail_page.dart (diedit: dialog tukar)
- lib/core/widgets/card_widgets.dart (diedit: gradient PointCard)
- lib/core/widgets/custom_bottom_nav_bar_widget.dart (diedit: indikator aktif)
- android/app/src/main/AndroidManifest.xml (diedit: izin CAMERA)
- ios/Runner/Info.plist (diedit: NSCameraUsageDescription)
- test/widget/pages/capture_photo_page_test.dart (dibuat)
- test/widget/pages/edit_profile_page_test.dart (dibuat)
- test/widget/pages/settings_page_test.dart (dibuat)
- test/widget/pages/waste_page_test.dart (diedit: navigasi kamera)
- test/widget/pages/reward_detail_page_test.dart (diedit: dialog tukar)
- docs/ARCHITECTURE.md (diedit: daftar route)
- docs/UI_PAGES.md (diedit: status halaman)

Catatan:

- Widget test memakai mock MethodChannel permission/camera karena device
  plugin tidak tersedia di environment test.
- Task kamera/GPS/QR tetap wajib diverifikasi di device fisik.
- Tidak ada dependency baru pada task ini (camera, permission_handler,
  geolocator sudah ada di pubspec).

Verifikasi:

- hasil linter/analyze: OK (0 issue)
- hasil test: OK (76 test pass)

## [2026-09-15] - Detail Reward, Verifikasi, dan Scan QR

Status: Selesai (data sensor/foto menunggu layer data + device)

File yang diubah:

- lib/features/points/presentation/pages/reward_detail_page.dart (dibuat)
- lib/features/points/presentation/pages/points_page.dart (diedit: looping demo data + navigasi detail)
- lib/features/points/presentation/data/reward_demo_data.dart (dibuat)
- lib/features/verification/presentation/pages/verification_page.dart (dibuat)
- lib/features/scan/presentation/pages/scan_page.dart (dibuat)
- lib/core/router/app_router.dart (diedit: route /reward/:id, /verification, /scan)
- lib/core/constants/app_strings.dart (diedit: string reward/verifikasi/scan)
- test/widget/pages/reward_detail_page_test.dart (dibuat)
- test/widget/pages/verification_page_test.dart (dibuat)
- test/widget/pages/scan_page_test.dart (dibuat)
- test/widget/pages/points_page_test.dart (diedit: navigasi ke detail reward)
- docs/ARCHITECTURE.md (diedit: daftar route)
- docs/UI_PAGES.md (diedit: status halaman)

Catatan:

- Detail reward: ikon, nama, harga poin, benefit, saldo, tombol Tukar
  (snackbar belum tersedia). RewardCard di Poin kini membuka halaman ini.
- Verifikasi: status berhasil, placeholder foto, detail timestamp/lokasi/
  hash/estimasi poin (nilai demo), dialog detail hash, tombol Coba Lagi
  dan Konfirmasi Kirim (ke Home). Kamera, GPS, dan hash SHA-256 asli
  menunggu layer data dan pengujian device.
- Scan QR: viewfinder visual; deteksi mobile_scanner menunggu device.
- Tidak ada perubahan dependency baru pada task ini.

Verifikasi:

- hasil linter/analyze: OK (0 issue)
- hasil test: OK (65 test pass)

## [2026-09-15] - Halaman Waste (UI-first), Artikel, dan Detail Artikel

Status: Selesai (kamera/GPS menunggu layer data + device)

File yang diubah:

- lib/features/waste/presentation/pages/waste_page.dart (diedit: UI-first)
- lib/features/article/presentation/pages/article_page.dart (diedit: search + daftar real)
- lib/features/article/presentation/pages/article_detail_page.dart (dibuat)
- lib/features/article/presentation/data/article_demo_data.dart (dibuat)
- lib/features/home/presentation/pages/home_page.dart (diedit: kard artikel ke detail)
- lib/core/widgets/feedback_widgets.dart (dibuat: EmptyState)
- lib/core/router/app_router.dart (diedit: route /article/:id)
- lib/core/constants/app_strings.dart (diedit: string artikel, waste, detail)
- test/widget/components/feedback_widgets_test.dart (dibuat)
- test/widget/pages/article_page_test.dart (dibuat)
- test/widget/pages/waste_page_test.dart (dibuat)
- docs/ARCHITECTURE.md (diedit: daftar route)
- docs/COMPONENT_LIBRARY.md (diedit: status EmptyState)
- docs/UI_PAGES.md (diedit: status halaman)

Catatan:

- Waste: pilihan checkpoint (ListTileItem + centang), status GPS dalam
  radius demi status "Berhasil". Tombol "Ambil Foto" menampilkan snackbar
  karena kamera in-app, timestamp server, dan hash SHA-256 menunggu layer
  data. Wajib diuji di device fisik.
- Artikel: search filter di sisi klien, empty state EmptyState saat tanpa
  hasil, empat artikel demo. Detail artikel lewat route /article/:id
  (konten paragraf placeholder).
- Home kini membuka detail artikel saat kartu ditekan.
- Tidak ada perubahan dependency baru pada task ini.

Verifikasi:

- hasil linter/analyze: OK (0 issue)
- hasil test: OK (58 test pass)

## [2026-09-15] - Halaman Aktivitas, Poin & Reward, dan Profile

Status: Selesai

File yang diubah:

- lib/features/activity/presentation/pages/activity_page.dart (diedit: halaman real)
- lib/features/points/presentation/pages/points_page.dart (diedit: halaman real)
- lib/features/profile/presentation/pages/profile_page.dart (diedit: halaman real)
- lib/core/widgets/status_widgets.dart (dibuat: StatusType, StatusChip)
- lib/core/widgets/display_widgets.dart (dibuat: Avatar, StatItem, ListTileItem)
- lib/core/widgets/card_widgets.dart (diedit: ActivityCard, RewardCard)
- lib/core/constants/app_strings.dart (diedit: string Aktivitas/Poin/Profile)
- test/widget/components/card_widgets_test.dart (diedit: test ActivityCard, RewardCard)
- test/widget/components/status_widgets_test.dart (dibuat)
- test/widget/components/display_widgets_test.dart (dibuat)
- test/widget/pages/points_page_test.dart (dibuat)
- test/widget/pages/profile_page_test.dart (dibuat)
- docs/COMPONENT_LIBRARY.md (diedit: status komponen)
- docs/UI_PAGES.md (diedit: status halaman)

Catatan:

- Aktivitas: daftar aktivitas demo memakai ActivityCard + StatusChip
  (status berhasil / menunggu verifikasi).
- Poin & Reward: saldo via PointCard, empat RewardCard demo, riwayat poin
  memakai ActivityCard. Detail reward bukan bagian task ini.
- Profile: avatar inisial (Avatar), kartu statistik (StatItem), menu
  (ListTileItem); Edit Profil/Pengaturan menampilkan snackbar, Logout
  kembali ke Login.
- Semua data masih placeholder sampai layer data terpasang.
- Tidak ada perubahan dependency baru pada task ini.

Verifikasi:

- hasil linter/analyze: OK (0 issue)
- hasil test: OK (48 test pass)

## [2026-09-14] - Home, bottom navigation, dan komponen card

Status: Selesai

File yang diubah:

- lib/core/widgets/custom_bottom_nav_bar_widget.dart (dibuat)
- lib/core/widgets/card_widgets.dart (dibuat: InfoCard, PointCard, ArticleCard)
- lib/core/widgets/main_shell.dart (dibuat)
- lib/core/router/app_router.dart (diedit: StatefulShellRoute untuk tab utama, splash pindah ke /splash)
- lib/core/constants/app_strings.dart (diedit: string Home)
- lib/core/utils/formatters.dart (dibuat: format angka dan tanggal Indonesia)
- lib/features/home/presentation/pages/home_page.dart (diedit: halaman real)
- test/unit/core/formatters_test.dart (dibuat)
- test/widget/components/bottom_nav_bar_test.dart (dibuat)
- test/widget/components/card_widgets_test.dart (dibuat)
- test/widget/pages/auth_flow_test.dart (diedit: initial location /splash + test ganti tab)
- docs/ARCHITECTURE.md (diedit: bagian routing)
- docs/COMPONENT_LIBRARY.md (diedit: status komponen)
- docs/UI_PAGES.md (diedit: status halaman Home)

Catatan:

- Routing tab utama kini StatefulShellRoute.indexedStack + MainShell,
  state tiap tab tersimpan; splash berpindah path ke /splash.
- Bottom nav 5 item; "Buang Sampah" sebagai tombol aksen bulat di tengah.
- Home memakai komponen reusable dan token tema; data masih placeholder
  sampai layer data terpasang.
- Tidak ada perubahan dependency baru pada task ini.

Verifikasi:

- hasil linter/analyze: OK (0 issue)
- hasil test: OK (33 test pass)

## [2026-09-14] - Alur auth: Splash, Onboarding, Login, Register

Status: Selesai

File yang diubah:

- lib/core/router/app_router.dart (diedit: route /onboarding, konstanta AppRouteName.onboarding, ekspor appRoutes untuk test)
- lib/core/constants/app_strings.dart (diedit: string konfirmasi password dan error validasi)
- lib/core/widgets/app_button_widgets.dart (dibuat)
- lib/core/widgets/custom_text_field_widget.dart (dibuat)
- lib/core/widgets/app_bar_and_loading_widgets.dart (dibuat)
- lib/features/splash/splash_page.dart (diedit: halaman real dengan navigasi ke onboarding)
- lib/features/onboarding/onboarding_page.dart (dibuat)
- lib/features/auth/presentation/pages/login_page.dart (diedit: halaman real dengan validasi form)
- lib/features/auth/presentation/pages/register_page.dart (diedit: halaman real dengan validasi form)
- pubspec.yaml (diedit: ganti lucide_icons -> flutter_lucide)
- test/widget_test.dart (diedit: akomodasi timer splash)
- test/widget/components/app_button_test.dart (dibuat)
- test/widget/components/input_test.dart (dibuat)
- test/widget/components/app_bar_and_loading_test.dart (dibuat)
- test/widget/pages/auth_flow_test.dart (dibuat)
- docs/ARCHITECTURE.md (diedit: stack ikon dan evaluasi dependency 8.1)
- docs/COMPONENT_LIBRARY.md (diedit: status komponen)
- docs/UI_PAGES.md (diedit: status halaman auth)
- docs/TESTING_STRATEGY.md (diedit: perbaiki file yang rusak)

Catatan:

- Halaman auth memakai komponen reusable (PrimaryButton, CustomTextField,
  dll) dan token tema.
- Navigasi memakai context.goNamed dengan nama route.
- Penggantian dependency: lucide_icons 0.257.0 tidak bisa dikompilasi di
  Flutter 3.47.2 (IconData final class), diganti flutter_lucide 1.45.0
  (aktif dipelihara, terbit 2026-09-11). Nama ikon berubah ke snake_case.
- Evaluasi dependency lengkap ada di docs/ARCHITECTURE.md bagian 8.1.

Verifikasi:

- hasil linter/analyze: OK (0 issue)
- hasil test: OK (19 test pass)

## [2026-09-14] - Setup struktur project

Status: Selesai

File yang diubah:

- docs/\* (dibuat)
- pubspec.yaml (dibuat)
- AGENTS.md (dibuat)
- PROTOCOL.md (dibuat)
- CHANGELOG.md (dibuat)
- .env.example (dibuat)
- .opencode/\* (dibuat)
- assets/\* (dibuat)
  - assets/fonts/\* (dibuat: font Manrope 4 bobot + Geist 3 bobot, unduhan resmi)
- lib/core/\* (dibuat)
- lib/features/\* (dibuat)
- lib/main.dart (dibuat)
- test/\* (dibuat)

Catatan:

- Setup fondasi project sesuai PROTOCOL.md
- Font Manrope dan Geist (TTF) diunduh dari fonts.gstatic.com
- Dependency sesuai spesifikasi awal

Verifikasi:

- hasil linter/analyze: OK (0 issue)
- hasil test: OK (1 test pass)
