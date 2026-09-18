// Use case pengambilan checkpoint terdekat (domain).
//
// Menyembunyikan detail repository dari presentation; jarak dihitung di
// sisi client sesuai strategi MVP (docs/ARCHITECTURE.md 10.5).

import '../entities/checkpoint.dart';
import '../repositories/checkpoint_repository.dart';

/// Use case mengambil daftar checkpoint terdekat dari posisi user.
class GetNearbyCheckpointsUsecase {
  /// Membuat use case dengan repository yang di-inject.
  GetNearbyCheckpointsUsecase(this._repository);

  final CheckpointRepository _repository;

  /// Menjalankan use case: mengembalikan checkpoint terdekat,
  /// diurutkan dari yang terdekat.
  Future<List<Checkpoint>> execute({
    required double latitude,
    required double longitude,
  }) {
    return _repository.getNearbyCheckpoints(
      latitude: latitude,
      longitude: longitude,
    );
  }
}