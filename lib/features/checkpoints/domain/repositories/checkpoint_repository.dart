// Interface repository checkpoint (domain).
//
// Implementasi data layer (CheckpointRepositoryImpl) wajib mengikuti
// kontrak ini. Mengembalikan entity domain, bukan model data.

import '../entities/checkpoint.dart';

/// Kontrak repository checkpoint Go Green.
abstract interface class CheckpointRepository {
  /// Ambil semua checkpoint.
  Future<List<Checkpoint>> getAllCheckpoints();

  /// Ambil checkpoint terdekat dari posisi user (client-side),
  /// diurutkan dari yang terdekat.
  Future<List<Checkpoint>> getNearbyCheckpoints({
    required double latitude,
    required double longitude,
  });

  /// Ambil satu checkpoint berdasarkan id.
  Future<Checkpoint?> getCheckpointById(String id);

  /// Ambil satu checkpoint berdasarkan kode QR.
  Future<Checkpoint?> getCheckpointByQrCode(String qrCode);
}