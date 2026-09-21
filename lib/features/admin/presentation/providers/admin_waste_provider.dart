// Provider verifikasi waste admin (presentation).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../checkpoints/presentation/providers/checkpoint_provider.dart';
import '../../../waste/domain/entities/waste_log.dart';
import '../../../waste/presentation/providers/waste_provider.dart'
    show wasteRepositoryProvider;
import '../../domain/usecases/verify_waste_usecase.dart';

/// Rentang filter daftar verifikasi.
enum AdminWasteFilter { today, week, all }

/// Provider use case verifikasi waste admin.
final Provider<VerifyWasteUsecase> verifyWasteUsecaseProvider =
    Provider<VerifyWasteUsecase>(
  (Ref ref) => VerifyWasteUsecase(
    wasteRepository: ref.watch(wasteRepositoryProvider),
    checkpointRepository: ref.watch(checkpointRepositoryProvider),
  ),
);

/// Filter aktif daftar verifikasi.
final StateProvider<AdminWasteFilter> adminWasteFilterProvider =
    StateProvider<AdminWasteFilter>((Ref ref) => AdminWasteFilter.all);

/// Notifier antrean verifikasi pending untuk admin/petugas.
class AdminWasteListNotifier
    extends StateNotifier<AsyncValue<List<WasteLog>>> {
  /// Membuat notifier antrean verifikasi.
  AdminWasteListNotifier(this._usecase, this._ref)
      : super(const AsyncLoading<List<WasteLog>>());

  final VerifyWasteUsecase _usecase;
  final Ref _ref;

  /// Muat waste log berstatus pending.
  Future<void> loadPending() async {
    state = const AsyncLoading<List<WasteLog>>();
    state = await AsyncValue.guard<List<WasteLog>>(
      () => _ref.read(wasteRepositoryProvider).getPendingWasteLogs(),
    );
  }

  /// Daftar tersaring rentang waktu.
  List<WasteLog> filtered(AdminWasteFilter filter) {
    final List<WasteLog> all = state.maybeWhen(
      data: (List<WasteLog> value) => value,
      orElse: () => <WasteLog>[],
    );
    final DateTime now = DateTime.now();
    switch (filter) {
      case AdminWasteFilter.today:
        return all.where((WasteLog log) {
          final DateTime created = log.createdAt;
          return created.year == now.year &&
              created.month == now.month &&
              created.day == now.day;
        }).toList();
      case AdminWasteFilter.week:
        final DateTime weekAgo = now.subtract(const Duration(days: 7));
        return all
            .where((WasteLog log) => log.createdAt.isAfter(weekAgo))
            .toList();
      case AdminWasteFilter.all:
        return all;
    }
  }

  /// Menyetujui log.
  Future<void> approve(String id) async {
    final String? verifiedBy = SupabaseService.instance.currentUser?.id;
    if (verifiedBy == null) throw StateError('Belum login');
    await _usecase.approve(id: id, verifiedBy: verifiedBy);
    await loadPending();
  }

  /// Menolak log dengan alasan.
  Future<void> reject(String id, String reason) async {
    final String? verifiedBy = SupabaseService.instance.currentUser?.id;
    if (verifiedBy == null) throw StateError('Belum login');
    await _usecase.reject(id: id, verifiedBy: verifiedBy, reason: reason);
    await loadPending();
  }

  /// URL foto bukti untuk detail.
  Future<String> photoUrl(String path) {
    return _ref.read(wasteRepositoryProvider).getPhotoSignedUrl(path);
  }
}

/// Provider state antrean verifikasi admin.
final StateNotifierProvider<AdminWasteListNotifier,
        AsyncValue<List<WasteLog>>> adminWasteListProvider =
    StateNotifierProvider<AdminWasteListNotifier,
        AsyncValue<List<WasteLog>>>(
  (Ref ref) => AdminWasteListNotifier(
    ref.watch(verifyWasteUsecaseProvider),
    ref,
  ),
);
