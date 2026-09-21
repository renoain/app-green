// Layanan lokasi (GPS) memakai geolocator.
//
// Mengambil posisi saat ini untuk verifikasi bukti dan cek radius
// checkpoint. Perlu diuji di device fisik sesuai docs/TESTING_STRATEGY.md.

import 'package:geolocator/geolocator.dart';

/// Layanan pengambilan lokasi GPS perangkat.
class LocationService {
  const LocationService();

  /// Mengambil posisi GPS saat ini.
  ///
  /// Mengembalikan null jika GPS mati, izin ditolak, atau gagal.
  Future<Position?> getCurrentPosition() async {    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      return null;
    }
  }

  /// Status layanan lokasi perangkat (GPS hidup atau mati).
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  /// Status izin lokasi saat ini (tanpa meminta).
  Future<LocationPermission> checkPermission() =>
      Geolocator.checkPermission();

  /// Meminta izin lokasi ke sistem.
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  /// Membuka pengaturan lokasi sistem agar user bisa menghidupkan GPS.
  Future<void> openLocationSettings() =>
      Geolocator.openLocationSettings();

  /// Membuka pengaturan aplikasi (untuk izin ditolak permanen).
  Future<void> openAppSettings() => Geolocator.openAppSettings();

  /// Memformat posisi menjadi label koordinat untuk ditampilkan.
  String formatPositionLabel(Position position) =>
      '${position.latitude.toStringAsFixed(6)}, '
      '${position.longitude.toStringAsFixed(6)}';
}