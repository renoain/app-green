// Use case pengambilan checkpoint terdekat (domain).

import '../entities/checkpoint.dart';
import '../repositories/checkpoint_repository.dart';

/// Use case mengambil daftar checkpoint terdekat dari posisi user.
class GetNearbyCheckpointsUsecase {
  GetNearbyCheckpointsUsecase(this._repository);

  final CheckpointRepository _repository;

  /// Menjalankan use case: mengembalikan checkpoint terdekat, diurutkan dari yang terdekat.
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
