// Implementasi repository waste log (data layer).
//
// Menerjemahkan kontrak WasteRepository menjadi panggilan
// WasteRemoteDatasource. Tidak boleh dipakai di presentation.

import 'dart:typed_data';

import '../../../../core/constants/app_enums.dart';
import '../../domain/entities/waste_log.dart';
import '../../domain/repositories/waste_repository.dart';
import '../datasources/waste_remote_datasource.dart';

/// Implementasi [WasteRepository] berbasis Supabase.
class WasteRepositoryImpl implements WasteRepository {
  /// Membuat repository. [remote] bisa di-inject untuk test.
  WasteRepositoryImpl({WasteRemoteDatasource? remote})
      : _remote = remote ?? WasteRemoteDatasource();

  final WasteRemoteDatasource _remote;

  @override
  Future<String> uploadPhoto({
    required String fileName,
    required Uint8List bytes,
  }) {
    return _remote.uploadPhoto(fileName: fileName, bytes: bytes);
  }

  @override
  Future<WasteLog> insertWasteLog({
    required String userId,
    String? checkpointId,
    required WasteCategory category,
    required String photoUrl,
    required String hash,
    double? latitude,
    double? longitude,
    WasteSource source = WasteSource.manual,
  }) {
    return _remote.insertWasteLog(
      userId: userId,
      checkpointId: checkpointId,
      category: category,
      photoUrl: photoUrl,
      hash: hash,
      latitude: latitude,
      longitude: longitude,
      source: source,
    );
  }

  @override
  Future<List<WasteLog>> getWasteLogs(String userId) {
    return _remote.getWasteLogs(userId);
  }

  @override
  Future<List<WasteLog>> getPendingWasteLogs() {
    return _remote.getPendingWasteLogs();
  }

  @override
  Future<WasteLog> verifyWasteLog({
    required String id,
    required WasteLogStatus status,
    required String verifiedBy,
    String? notes,
  }) {
    return _remote.verifyWasteLog(
      id: id,
      status: status,
      verifiedBy: verifiedBy,
      notes: notes,
    );
  }

  @override
  Future<WasteLog> approveWasteLog({
    required String id,
    required String verifiedBy,
  }) {
    return _remote.approveWasteLog(id: id, verifiedBy: verifiedBy);
  }

  @override
  Future<WasteLog> rejectWasteLog({
    required String id,
    required String verifiedBy,
    required String reason,
  }) {
    return _remote.rejectWasteLog(
      id: id,
      verifiedBy: verifiedBy,
      reason: reason,
    );
  }

  @override
  Future<String> getPhotoSignedUrl(String path) {
    return _remote.getPhotoSignedUrl(path);
  }

  @override
  Future<bool> checkDuplicateHash(String hash) {
    return _remote.checkDuplicateHash(hash);
  }

  @override
  Future<int> countTodayWasteLogs(String userId) {
    return _remote.countTodayWasteLogs(userId);
  }
}