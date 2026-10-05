// Data yang dikirim dari halaman Buang Sampah ke halaman kamera.

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
