// Util perhitungan jarak GPS.

import 'package:geolocator/geolocator.dart';

/// Utilitas perhitungan geografi.
abstract final class GeoUtils {
  GeoUtils._();

  /// Jarak dalam meter (dibulatkan) antara dua koordinat.
  static int distanceMeters(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ).round();
  }
}