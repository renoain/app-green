// Data yang dikirim dari halaman Buang Sampah ke halaman kamera.
//
// Berisi checkpoint terpilih agar kamera bisa menegakkan radius GPS
// sebelum foto diteruskan ke verifikasi. Kategori dipilih user
// setelah foto, di halaman verifikasi.

/// Data ekstra route kamera in-app.
class CaptureExtra {
  const CaptureExtra({
    required this.checkpointId,
    required this.checkpointName,
    required this.latitude,
    required this.longitude,
    required this.radius,
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
}
