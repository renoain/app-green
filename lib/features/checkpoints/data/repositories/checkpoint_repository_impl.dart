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

  @override
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
  }) {
    return _remote.createCheckpoint(
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
    );
  }

  @override
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
  }) {
    return _remote.updateCheckpoint(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
    );
  }

  @override
  Future<void> deleteCheckpoint(String id) {
    return _remote.deleteCheckpoint(id);
  }

  @override
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
  }) {
    return _remote.insertCheckpoint(
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
    );
  }

  @override
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
  }) {
    return _remote.updateCheckpointRecord(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
    );
  }

  @override
  Future<void> deactivateCheckpoint(String id) {
    return _remote.deactivateCheckpoint(id);
  }
}