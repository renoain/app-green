// Entity Checkpoint (domain).
//
// Representasi bisnis checkpoint tanpa ketergantungan ke data layer.
// Field mengikuti kolom tabel checkpoints (docs/DATABASE_SCHEMA.md).

/// Lokasi pembuangan sampah terdaftar.
class Checkpoint {
  /// Membuat checkpoint.
  const Checkpoint({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.qrCode,
    required this.createdAt,
  });

  /// ID unik checkpoint.
  final String id;

  /// Nama checkpoint.
  final String name;

  /// Alamat checkpoint.
  final String? address;

  /// Latitude koordinat checkpoint.
  final double latitude;

  /// Longitude koordinat checkpoint.
  final double longitude;

  /// Radius validasi GPS dalam meter.
  final int radius;

  /// Kode QR unik checkpoint.
  final String? qrCode;

  /// Waktu checkpoint dibuat.
  final DateTime createdAt;
}