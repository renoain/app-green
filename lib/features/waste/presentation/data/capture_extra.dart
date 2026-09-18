// Data yang dikirim dari halaman Buang Sampah ke halaman kamera.
//
// Berisi checkpoint terpilih dan kategori sampah agar kamera bisa
// menegakkan radius GPS sebelum foto diteruskan ke verifikasi.

import '../../../../core/constants/app_enums.dart';

/// Data ekstra route kamera in-app.
class CaptureExtra {
  const CaptureExtra({
    required this.checkpointId,
    required this.checkpointName,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.category = WasteCategory.organik,
  });

  /// ID checkpoint terpilih.
  final String checkpointId;

  /// Nama checkpoint terpilih untuk pesan error.
  final String checkpointName;

  /// Latitude checkpoint terpilih.
  final double latitude;

  /// Longitude checkpoint terpilih.
  final double longitude;

  /// Radius validasi GPS checkpoint dalam meter.
  final int radius;

  /// Kategori sampah terpilih.
  final WasteCategory category;
}
