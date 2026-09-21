// Interface repository waste log (domain).
//
// Implementasi data layer (WasteRepositoryImpl) wajib mengikuti kontrak
// ini. Mengembalikan entity domain, bukan model data.

import 'dart:typed_data';

import '../../../../core/constants/app_enums.dart';
import '../entities/waste_log.dart';

/// Kontrak repository waste log Go Green.
abstract interface class WasteRepository {
  /// Upload foto bukti ke bucket waste-photos. Mengembalikan path tersimpan.
  Future<String> uploadPhoto({
    required String fileName,
    required Uint8List bytes,
  });

  /// Menyimpan log pembuangan sampah baru.
  Future<WasteLog> insertWasteLog({
    required String userId,
    String? checkpointId,
    required WasteCategory category,
    required String photoUrl,
    required String hash,
    double? latitude,
    double? longitude,
    WasteSource source = WasteSource.manual,
  });

  /// Mengambil daftar waste log milik user, terbaru di atas.
  Future<List<WasteLog>> getWasteLogs(String userId);

  /// Mengambil waste log berstatus pending untuk verifikasi admin/petugas.
  Future<List<WasteLog>> getPendingWasteLogs();

  /// Memverifikasi waste log (update status oleh admin/petugas).
  Future<WasteLog> verifyWasteLog({
    required String id,
    required WasteLogStatus status,
    required String verifiedBy,
    String? notes,
  });

  /// Menyetujui waste log (status verified). Tanpa insert poin ulang.
  Future<WasteLog> approveWasteLog({
    required String id,
    required String verifiedBy,
  });

  /// Menolak waste log (status rejected + alasan).
  Future<WasteLog> rejectWasteLog({
    required String id,
    required String verifiedBy,
    required String reason,
  });

  /// URL bertanda tangan untuk foto bukti privat.
  Future<String> getPhotoSignedUrl(String path);

  /// Mengecek apakah hash sudah pernah dipakai (anti-kecurangan duplikat).
  Future<bool> checkDuplicateHash(String hash);

  /// Menghitung jumlah waste log user sejak awal hari ini (rate limit).
  Future<int> countTodayWasteLogs(String userId);
}