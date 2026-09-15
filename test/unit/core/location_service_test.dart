// Unit test layanan lokasi dan util jarak GPS.
// GeolocatorPlatform diganti fake agar berjalan tanpa plugin perangkat.

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import 'package:go_green/core/services/location_service.dart';
import 'package:go_green/core/utils/geo_utils.dart';

/// Fake platform geolocator untuk mode test.
class _FakeGeolocator extends GeolocatorPlatform {
  _FakeGeolocator({
    this.serviceEnabled = true,
    this.permission = LocationPermission.whileInUse,
    this.position,
    this.distance = 50,
  });

  final bool serviceEnabled;
  final LocationPermission permission;
  final Position? position;
  final double distance;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async => permission;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    final Position? value = position;
    if (value == null) throw StateError('position kosong');
    return value;
  }

  @override
  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return distance;
  }
}

Position _position(double latitude, double longitude) => Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime(2026, 9, 15, 10, 0),
      accuracy: 5,
      altitude: 10,
      altitudeAccuracy: 5,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

void main() {
  late GeolocatorPlatform original;

  setUp(() {
    original = GeolocatorPlatform.instance;
  });

  tearDown(() {
    GeolocatorPlatform.instance = original;
  });

  group('LocationService.getCurrentPosition', () {
    test('mengembalikan null saat layanan GPS mati', () async {
      GeolocatorPlatform.instance = _FakeGeolocator(serviceEnabled: false);

      final Position? result =
          await const LocationService().getCurrentPosition();

      expect(result, isNull);
    });

    test('mengembalikan null saat izin lokasi ditolak', () async {
      GeolocatorPlatform.instance =
          _FakeGeolocator(permission: LocationPermission.denied);

      final Position? result =
          await const LocationService().getCurrentPosition();

      expect(result, isNull);
    });

    test('mengembalikan null saat izin ditolak permanen', () async {
      GeolocatorPlatform.instance =
          _FakeGeolocator(permission: LocationPermission.deniedForever);

      final Position? result =
          await const LocationService().getCurrentPosition();

      expect(result, isNull);
    });

    test('mengembalikan posisi saat izin diberikan', () async {
      GeolocatorPlatform.instance = _FakeGeolocator(
        permission: LocationPermission.whileInUse,
        position: _position(-6.200000, 106.816667),
      );

      final Position? result =
          await const LocationService().getCurrentPosition();

      expect(result, isNotNull);
      expect(result!.latitude, -6.2);
      expect(result.longitude, 106.816667);
    });
  });

  group('LocationService.formatPositionLabel', () {
    test('memformat koordinat dengan enam desimal', () {
      final String label =
          const LocationService().formatPositionLabel(_position(-6.2, 106.8));

      expect(label, '-6.200000, 106.800000');
    });
  });

  group('GeoUtils.distanceMeters', () {
    test('memakai distanceBetween dari platform', () {
      GeolocatorPlatform.instance = _FakeGeolocator(distance: 42);

      final int result = GeoUtils.distanceMeters(
        -6.2,
        106.816,
        -6.201,
        106.817,
      );

      expect(result, 42);
    });
  });
}