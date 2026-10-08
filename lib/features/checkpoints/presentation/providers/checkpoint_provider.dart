// Provider data checkpoint.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/checkpoint.dart';
import '../../domain/repositories/checkpoint_repository.dart';
import '../../domain/usecases/get_nearby_checkpoints_usecase.dart';
import '../../data/datasources/checkpoint_dummy_datasource.dart';
import '../../data/datasources/checkpoint_laravel_datasource.dart';
import '../../data/datasources/checkpoint_remote_datasource.dart';
import '../../data/repositories/checkpoint_repository_impl.dart';
import '../../../../core/constants/app_env.dart';

/// Provider data source checkpoint (dummy/laravel sesuai [AppEnv.dataSource]).
final Provider<CheckpointRemoteDatasource> checkpointRemoteDatasourceProvider =
    Provider<CheckpointRemoteDatasource>(
  (Ref ref) {
    switch (AppEnv.dataSource) {
      case 'laravel':
        return CheckpointLaravelDatasource();
      case 'dummy':
        return CheckpointDummyDatasource();
      case 'supabase':
      default:
        return CheckpointRemoteDatasource();
    }
  },
);

/// Provider repository checkpoint.
final Provider<CheckpointRepository> checkpointRepositoryProvider =
    Provider<CheckpointRepository>(
  (Ref ref) => CheckpointRepositoryImpl(
    remote: ref.watch(checkpointRemoteDatasourceProvider),
  ),
);

/// Provider use case checkpoint terdekat.
final Provider<GetNearbyCheckpointsUsecase>
    getNearbyCheckpointsUsecaseProvider = Provider<GetNearbyCheckpointsUsecase>(
  (Ref ref) => GetNearbyCheckpointsUsecase(
    ref.watch(checkpointRepositoryProvider),
  ),
);

/// Notifier daftar checkpoint terdekat.
class CheckpointNotifier extends StateNotifier<AsyncValue<List<Checkpoint>>> {
  CheckpointNotifier(this._usecase, {CheckpointRepository? repository})
      : _repository = repository,
        super(const AsyncLoading<List<Checkpoint>>());

  final GetNearbyCheckpointsUsecase _usecase;
  final CheckpointRepository? _repository;

  /// Memuat checkpoint terdekat dari posisi user.
  Future<void> loadNearby({
    required double latitude,
    required double longitude,
  }) async {
    state = const AsyncLoading<List<Checkpoint>>();
    state = await AsyncValue.guard<List<Checkpoint>>(
      () => _usecase.execute(latitude: latitude, longitude: longitude),
    );
  }

  /// Memuat semua checkpoint aktif (dipakai saat GPS tidak tersedia).
  Future<void> loadAll() async {
    final CheckpointRepository? repository = _repository;
    if (repository == null) {
      state = await AsyncValue.guard<List<Checkpoint>>(
        () => _usecase.execute(latitude: 0, longitude: 0),
      );
      return;
    }
    state = const AsyncLoading<List<Checkpoint>>();
    state = await AsyncValue.guard<List<Checkpoint>>(
      repository.getActiveCheckpoints,
    );
  }
}

/// Provider state daftar checkpoint terdekat.
final StateNotifierProvider<CheckpointNotifier, AsyncValue<List<Checkpoint>>>
    checkpointNotifierProvider =
    StateNotifierProvider<CheckpointNotifier, AsyncValue<List<Checkpoint>>>(
  (Ref ref) => CheckpointNotifier(
    ref.watch(getNearbyCheckpointsUsecaseProvider),
    repository: ref.watch(checkpointRepositoryProvider),
  ),
);
