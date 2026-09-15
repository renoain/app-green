// Data yang dikirim dari halaman kamera ke halaman verifikasi.

/// Data ekstra route verifikasi.
class VerificationExtra {
  const VerificationExtra({
    this.locationLabel,
    this.imagePath,
    this.timestampLabel,
  });

  /// Label koordinat GPS lokasi foto diambil.
  final String? locationLabel;

  /// Path file foto bukti yang diambil kamera in-app.
  final String? imagePath;

  /// Label timestamp pengambilan foto.
  ///
  /// Sementara memakai waktu device sampai timestamp server terpasang.
  final String? timestampLabel;
}