// Entity Reward (domain).
//
// Representasi bisnis reward tanpa ketergantungan ke data layer.
// Field mengikuti kolom tabel rewards (docs/DATABASE_SCHEMA.md).

/// Hadiah yang bisa ditukar dengan poin.
class Reward {
  /// Membuat reward.
  const Reward({
    required this.id,
    required this.name,
    this.description,
    required this.pointsCost,
    required this.stock,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
  });

  /// ID unik reward.
  final String id;

  /// Nama hadiah.
  final String name;

  /// Deskripsi hadiah.
  final String? description;

  /// Harga dalam poin.
  final int pointsCost;

  /// Stok hadiah.
  final int stock;

  /// URL gambar hadiah.
  final String? imageUrl;

  /// Apakah hadiah aktif.
  final bool isActive;

  /// Waktu reward dibuat.
  final DateTime createdAt;
}