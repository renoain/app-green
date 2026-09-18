// Data yang dikirim dari halaman kamera ke halaman verifikasi.

import '../../../../core/constants/app_enums.dart';

/// Data ekstra route verifikasi.
class VerificationExtra {
  const VerificationExtra({
    this.locationLabel,
    this.imagePath,
    this.timestampLabel,
    this.checkpointId,
    this.checkpointName,
    this.latitude,
    this.longitude,
    this.radius,
    this.category = WasteCategory.organik,
  });

  /// Label koordinat GPS lokasi foto diambil.
  final String? locationLabel;

  /// Path file foto bukti yang diambil kamera in-app.
  final String? imagePath;

  /// Label timestamp pengambilan foto.
  ///
  /// Sementara memakai waktu device sampai timestamp server terpasang.
  final String? timestampLabel;

  /// ID checkpoint tempat foto diambil (null bila alur lama/demo).
  final String? checkpointId;

  /// Nama checkpoint untuk tampilan.
  final String? checkpointName;

  /// Latitude user saat shutter.
  final double? latitude;

  /// Longitude user saat shutter.
  final double? longitude;

  /// Radius checkpoint dalam meter untuk info jarak.
  final int? radius;

  /// Kategori sampah terpilih.
  final WasteCategory category;
}