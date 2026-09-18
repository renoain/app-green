// Implementasi repository checkpoint (data layer).
//
// Menerjemahkan kontrak CheckpointRepository menjadi panggilan
// CheckpointRemoteDatasource. Tidak boleh dipakai di presentation.

import '../../domain/entities/checkpoint.dart';
import '../../domain/repositories/checkpoint_repository.dart';
import '../datasources/checkpoint_remote_datasource.dart';

/// Implementasi [CheckpointRepository] berbasis Supabase.
class CheckpointRepositoryImpl implements CheckpointRepository {
  /// Membuat repository. [remote] bisa di-inject untuk test.
  CheckpointRepositoryImpl({CheckpointRemoteDatasource? remote})
      : _remote = remote ?? CheckpointRemoteDatasource();

  final CheckpointRemoteDatasource _remote;

  @override
  Future<List<Checkpoint>> getAllCheckpoints() {
    return _remote.getAllCheckpoints();
  }

  @override
  Future<List<Checkpoint>> getNearbyCheckpoints({
    required double latitude,
    required double longitude,
  }) {
    return _remote.getNearbyCheckpoints(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<Checkpoint?> getCheckpointById(String id) {
    return _remote.getCheckpointById(id);
  }

  @override
  Future<Checkpoint?> getCheckpointByQrCode(String qrCode) {
    return _remote.getCheckpointByQrCode(qrCode);
  }
}