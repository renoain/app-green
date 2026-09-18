// Provider data checkpoint.
//
// Menyediakan repository, use case, dan notifier daftar checkpoint
// terdekat (AsyncValue) agar halaman bisa memuat data tanpa akses langsung
// ke data layer.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/checkpoint.dart';
import '../../domain/repositories/checkpoint_repository.dart';
import '../../domain/usecases/get_nearby_checkpoints_usecase.dart';
import '../../data/repositories/checkpoint_repository_impl.dart';

/// Provider repository checkpoint.
final Provider<CheckpointRepository> checkpointRepositoryProvider =
    Provider<CheckpointRepository>(
  (Ref ref) => CheckpointRepositoryImpl(),
);

/// Provider use case checkpoint terdekat.
final Provider<GetNearbyCheckpointsUsecase> getNearbyCheckpointsUsecaseProvider =
    Provider<GetNearbyCheckpointsUsecase>(
  (Ref ref) => GetNearbyCheckpointsUsecase(
    ref.watch(checkpointRepositoryProvider),
  ),
);

/// Notifier daftar checkpoint terdekat.
class CheckpointNotifier extends StateNotifier<AsyncValue<List<Checkpoint>>> {
  /// Membuat notifier dengan use case yang di-inject.
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

  /// Memuat semua checkpoint (dipakai saat GPS tidak tersedia).
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
      repository.getAllCheckpoints,
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