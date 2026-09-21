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
    this.code,
    this.provinceCode,
    this.cityCode,
    this.districtCode,
    this.subdistrict,
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

  /// Kode TPS unik format KOTA-KEC-NOMOR (migration 017).
  final String? code;

  /// ID provinsi (API wilayah Indonesia).
  final String? provinceCode;

  /// ID kota/kabupaten (API wilayah Indonesia).
  final String? cityCode;

  /// ID kecamatan (API wilayah Indonesia).
  final String? districtCode;

  /// Kelurahan (opsional).
  final String? subdistrict;

  /// Waktu checkpoint dibuat.
  final DateTime createdAt;
}