// Interface repository checkpoint (domain).
//
// Implementasi data layer (CheckpointRepositoryImpl) wajib mengikuti
// kontrak ini. Mengembalikan entity domain, bukan model data.

import '../entities/checkpoint.dart';

/// Kontrak repository checkpoint Go Green.
abstract interface class CheckpointRepository {
  /// Ambil semua checkpoint (aktif + nonaktif, admin).
  Future<List<Checkpoint>> getAllCheckpoints();

  /// Ambil checkpoint aktif saja (user).
  Future<List<Checkpoint>> getActiveCheckpoints();

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

  /// Tambah checkpoint baru (admin).
  Future<Checkpoint> createCheckpoint({
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
    int? maxUses,
  });

  /// Ubah checkpoint (admin).
  Future<Checkpoint> updateCheckpoint({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
    int? maxUses,
  });

  /// Hapus checkpoint (admin).
  Future<void> deleteCheckpoint(String id);

  /// Tambah checkpoint baru (admin, alias insert).
  Future<Checkpoint> insertCheckpoint({
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
    int? maxUses,
  });

  /// Ubah checkpoint (admin, alias update).
  Future<Checkpoint> updateCheckpointRecord({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
    int? maxUses,
  });

  /// Nonaktifkan checkpoint (admin, soft-delete).
  Future<void> deactivateCheckpoint(String id);

  /// Aktifkan kembali checkpoint (admin).
  Future<void> activateCheckpoint(String id);
}