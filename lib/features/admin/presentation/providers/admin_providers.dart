// Provider bersama admin (role, lokasi uji, kunci drawer, use case).
//
// Provider state tiap halaman ada di file sendiri (admin_dashboard_provider,
// admin_checkpoint_provider, admin_waste_provider). Logic bisnis tetap di
// domain dan data, bukan di sini.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../checkpoints/domain/usecases/manage_checkpoint_usecase.dart';
import '../../../checkpoints/presentation/providers/checkpoint_provider.dart';
import '../../data/datasources/admin_profile_datasource.dart';

/// Provider data source role admin.
final Provider<AdminProfileDatasource> adminProfileDatasourceProvider =
    Provider<AdminProfileDatasource>(
  (Ref ref) => AdminProfileDatasource(),
);

/// Role user yang sedang login (default user saat demo/belum login).
final FutureProvider<UserRole> adminRoleProvider =
    FutureProvider<UserRole>((Ref ref) async {
  final String? userId = SupabaseService.instance.currentUser?.id;
  if (userId == null) return UserRole.user;
  try {
    return await ref.watch(adminProfileDatasourceProvider).getRole(userId);
  } catch (_) {
    return UserRole.user;
  }
});

/// Provider cepat: apakah user saat ini admin atau petugas.
final Provider<AsyncValue<bool>> isAdminProvider =
    Provider<AsyncValue<bool>>((Ref ref) {
  final AsyncValue<UserRole> role = ref.watch(adminRoleProvider);
  return role.whenData(
    (UserRole value) =>
        value == UserRole.admin || value == UserRole.petugas,
  );
});

/// Pembuka drawer shell admin yang aktif (didaftarkan AdminShell).
///
/// Branch admin memakai ini agar tidak bergantung pada GlobalKey
/// bersama; tiap instance shell mendaftarkan pembukanya sendiri.
final StateProvider<void Function()?> adminDrawerOpenerProvider =
    StateProvider<void Function()?>((Ref ref) => null);

/// Titik lokasi uji (GPS palsu khusus testing).
///
/// Saat aktif, halaman Waste dan Kamera memakai titik ini sebagai posisi
/// user sehingga penguji bisa pindah lokasi tanpa ke lapangan.
class DebugLocation {
  /// Membuat titik lokasi uji.
  const DebugLocation({
    required this.latitude,
    required this.longitude,
    required this.label,
  });

  /// Latitude lokasi uji.
  final double latitude;

  /// Longitude lokasi uji.
  final double longitude;

  /// Label tampilan (mis. nama checkpoint).
  final String label;
}

/// Notifier lokasi uji (null berarti pakai GPS asli).
class DebugLocationNotifier extends StateNotifier<DebugLocation?> {
  /// Membuat notifier lokasi uji.
  DebugLocationNotifier() : super(null);

  /// Aktifkan lokasi uji.
  void set(double latitude, double longitude, String label) {
    state = DebugLocation(
      latitude: latitude,
      longitude: longitude,
      label: label,
    );
  }

  /// Matikan lokasi uji, kembali ke GPS asli.
  void clear() => state = null;
}

/// Provider lokasi uji untuk testing pindah lokasi.
final StateNotifierProvider<DebugLocationNotifier, DebugLocation?>
    debugLocationProvider =
    StateNotifierProvider<DebugLocationNotifier, DebugLocation?>(
  (Ref ref) => DebugLocationNotifier(),
);

/// Provider use case kelola checkpoint admin.
final Provider<ManageCheckpointUsecase> manageCheckpointUsecaseProvider =
    Provider<ManageCheckpointUsecase>(
  (Ref ref) => ManageCheckpointUsecase(
    ref.watch(checkpointRepositoryProvider),
  ),
);
