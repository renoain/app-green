// Entity Point (domain).

import '../../../../core/constants/app_enums.dart';

/// Riwayat penambahan/pengurangan poin user.
class Point {
  const Point({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.referenceId,
    this.description,
    required this.createdAt,
  });

  /// ID unik catatan poin.
  final String id;

  /// ID user pemilik poin.
  final String userId;

  /// Besaran poin; arah (tambah/kurang) ditentukan oleh [type].
  final int amount;

  /// Tipe catatan: earn atau redeem.
  final PointType type;

  /// ID referensi (waste_log atau redemption).
  final String? referenceId;

  /// Deskripsi catatan.
  final String? description;

  /// Waktu pencatatan.
  final DateTime createdAt;
}
