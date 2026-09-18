// Provider lapisan waste (Buang Sampah).
//
// Menyediakan repository dan use case pengiriman/validasi/perhitungan poin
// agar halaman bisa memanggil tanpa akses langsung ke data layer.

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../checkpoints/domain/entities/checkpoint.dart';
import '../../../points/data/datasources/points_remote_datasource.dart';
import '../../domain/repositories/waste_repository.dart';
import '../../domain/usecases/calculate_points_usecase.dart';
import '../../domain/usecases/submit_waste_usecase.dart';
import '../../domain/usecases/validate_photo_usecase.dart';
import '../../data/repositories/waste_repository_impl.dart';

/// Provider repository waste log.
final Provider<WasteRepository> wasteRepositoryProvider =
    Provider<WasteRepository>(
  (Ref ref) => WasteRepositoryImpl(),
);

/// Provider use case perhitungan poin.
final Provider<CalculatePointsUsecase> calculatePointsUsecaseProvider =
    Provider<CalculatePointsUsecase>(
  (Ref ref) => const CalculatePointsUsecase(),
);

/// Provider use case validasi foto bukti.
final Provider<ValidatePhotoUsecase> validatePhotoUsecaseProvider =
    Provider<ValidatePhotoUsecase>(
  (Ref ref) => ValidatePhotoUsecase(ref.watch(wasteRepositoryProvider)),
);

/// Provider use case pengiriman pembuangan sampah.
///
/// Poin earn langsung dicatat ke tabel points via PointsRemoteDatasource
/// (butuh policy points_insert_own_earn, migration 014).
final Provider<SubmitWasteUsecase> submitWasteUsecaseProvider =
    Provider<SubmitWasteUsecase>(
  (Ref ref) {
    final PointsRemoteDatasource pointsDatasource =
        PointsRemoteDatasource();
    return SubmitWasteUsecase(
      wasteRepository: ref.watch(wasteRepositoryProvider),
      validatePhoto: ref.watch(validatePhotoUsecaseProvider),
      calculatePoints: ref.watch(calculatePointsUsecaseProvider),
      recordEarnPoints: ({
        required String userId,
        required int amount,
        required String referenceId,
        required String description,
      }) =>
          pointsDatasource.addPoints(
        userId: userId,
        amount: amount,
        type: PointType.earn,
        referenceId: referenceId,
        description: description,
      ),
    );
  },
);

/// Notifier status pengiriman bukti buang sampah.
///
/// Widget hanya memanggil [submit]; seluruh orkestrasi anti-kecurangan
/// (hash, validasi radius/duplikat/rate limit, upload, insert, hitung poin)
/// berjalan di [SubmitWasteUsecase].
class WasteSubmitNotifier
    extends StateNotifier<AsyncValue<SubmitWasteResult?>> {
  /// Membuat notifier dengan use case yang di-inject.
  WasteSubmitNotifier(this._usecase)
      : super(const AsyncData<SubmitWasteResult?>(null));

  final SubmitWasteUsecase _usecase;

  /// Mengirim bukti buang sampah.
  Future<void> submit({
    required String userId,
    required Checkpoint checkpoint,
    required WasteCategory category,
    required Uint8List photoBytes,
    required double latitude,
    required double longitude,
    WasteSource source = WasteSource.manual,
  }) async {
    state = const AsyncLoading<SubmitWasteResult?>();
    state = await AsyncValue.guard<SubmitWasteResult?>(
      () => _usecase.execute(
        userId: userId,
        checkpoint: checkpoint,
        category: category,
        photoBytes: photoBytes,
        latitude: latitude,
        longitude: longitude,
        source: source,
      ),
    );
  }

  /// Mengembalikan state ke idle setelah sukses/gagal ditangani UI.
  void reset() => state = const AsyncData<SubmitWasteResult?>(null);
}

/// Provider status pengiriman bukti buang sampah.
final StateNotifierProvider<WasteSubmitNotifier,
        AsyncValue<SubmitWasteResult?>>
    wasteSubmitNotifierProvider = StateNotifierProvider<WasteSubmitNotifier,
        AsyncValue<SubmitWasteResult?>>(
  (Ref ref) => WasteSubmitNotifier(ref.watch(submitWasteUsecaseProvider)),
);