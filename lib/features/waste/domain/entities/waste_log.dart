// Entity WasteLog (domain).
//
// Representasi bisnis log pembuangan sampah tanpa ketergantungan ke data
// layer. Field mengikuti kolom tabel waste_logs (docs/DATABASE_SCHEMA.md).

import '../../../../core/constants/app_enums.dart';

/// Log pembuangan sampah dari user.
class WasteLog {
  /// Membuat log pembuangan sampah.
  const WasteLog({
    required this.id,
    required this.userId,
    this.checkpointId,
    required this.category,
    this.photoUrl,
    this.hash,
    this.latitude,
    this.longitude,
    required this.serverTimestamp,
    required this.status,
    this.verifiedBy,
    this.verifiedAt,
    this.notes,
    this.source = WasteSource.manual,
    required this.createdAt,
    this.submitterName,
    this.checkpointName,
  });

  /// ID unik log.
  final String id;

  /// ID user yang membuang sampah.
  final String userId;

  /// ID checkpoint (nullable saat checkpoint dihapus).
  final String? checkpointId;

  /// Kategori sampah.
  final WasteCategory category;

  /// Path foto bukti di storage.
  final String? photoUrl;

  /// Hash SHA-256 file foto.
  final String? hash;

  /// Latitude posisi user saat buang.
  final double? latitude;

  /// Longitude posisi user saat buang.
  final double? longitude;

  /// Timestamp dari server (anti-kecurangan).
  final DateTime serverTimestamp;

  /// Status verifikasi log.
  final WasteLogStatus status;

  /// Admin/petugas yang memverifikasi.
  final String? verifiedBy;

  /// Waktu verifikasi.
  final DateTime? verifiedAt;

  /// Catatan verifikator.
  final String? notes;

  /// Asal data log (scan QR, manual, atau NFC).
  final WasteSource source;

  /// Waktu log dibuat.
  final DateTime createdAt;

  /// Username pengirim (dari join profiles, khusus daftar admin).
  final String? submitterName;

  /// Nama checkpoint (dari join checkpoints, khusus daftar admin).
  final String? checkpointName;
}