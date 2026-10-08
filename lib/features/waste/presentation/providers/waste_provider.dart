// Provider lapisan waste (Buang Sampah).

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_env.dart';
import '../../../checkpoints/domain/entities/checkpoint.dart';
import '../../../points/data/datasources/points_dummy_datasource.dart';
import '../../../points/data/datasources/points_laravel_datasource.dart';
import '../../../points/data/datasources/points_remote_datasource.dart';
import '../../data/datasources/waste_dummy_datasource.dart';
import '../../data/datasources/waste_laravel_datasource.dart';
import '../../data/datasources/waste_remote_datasource.dart';
import '../../domain/repositories/waste_repository.dart';
import '../../domain/usecases/calculate_points_usecase.dart';
import '../../domain/usecases/submit_waste_usecase.dart';
import '../../domain/usecases/validate_photo_usecase.dart';
import '../../data/repositories/waste_repository_impl.dart';

/// Provider data source waste log (dummy/laravel sesuai [AppEnv.dataSource]).
final Provider<WasteRemoteDatasource> wasteRemoteDatasourceProvider =
    Provider<WasteRemoteDatasource>(
  (Ref ref) {
    switch (AppEnv.dataSource) {
      case 'laravel':
        return WasteLaravelDatasource();
      case 'dummy':
        return WasteDummyDatasource();
      case 'supabase':
      default:
        return WasteRemoteDatasource();
    }
  },
);

/// Provider repository waste log.
final Provider<WasteRepository> wasteRepositoryProvider =
    Provider<WasteRepository>(
  (Ref ref) => WasteRepositoryImpl(
    remote: ref.watch(wasteRemoteDatasourceProvider),
  ),
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

/// Provider use case pengiriman pembuangan sampah. Poin earn langsung dicatat ke tabel points via PointsRemoteDatasource (butuh policy points_insert_own_earn, migration 014).
final Provider<SubmitWasteUsecase> submitWasteUsecaseProvider =
    Provider<SubmitWasteUsecase>(
  (Ref ref) {
    final PointsRemoteDatasource pointsDatasource;
    switch (AppEnv.dataSource) {
      case 'laravel':
        pointsDatasource = PointsLaravelDatasource();
        break;
      case 'dummy':
        pointsDatasource = PointsDummyDatasource();
        break;
      case 'supabase':
      default:
        pointsDatasource = PointsRemoteDatasource();
        break;
    }
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

/// Notifier status pengiriman bukti buang sampah. Widget hanya memanggil [submit]; seluruh orkestrasi anti-kecurangan (hash, validasi radius/duplikat/rate limit, upload, insert, hitung poin) berjalan di [SubmitWasteUsecase].
class WasteSubmitNotifier
    extends StateNotifier<AsyncValue<SubmitWasteResult?>> {
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
final StateNotifierProvider<WasteSubmitNotifier, AsyncValue<SubmitWasteResult?>>
    wasteSubmitNotifierProvider =
    StateNotifierProvider<WasteSubmitNotifier, AsyncValue<SubmitWasteResult?>>(
  (Ref ref) => WasteSubmitNotifier(ref.watch(submitWasteUsecaseProvider)),
);
