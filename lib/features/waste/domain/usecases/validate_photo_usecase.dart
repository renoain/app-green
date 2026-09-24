// Use case validasi foto bukti sebelum submit (domain).
//
// Langkah anti-kecurangan MVP: cek hash duplikat, cek radius GPS, dan cek
// rate limit harian. Murni domain (tanpa Flutter) sehingga mudah diuji.

import 'dart:math' as math;

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../repositories/waste_repository.dart';

/// Exception validasi waste; [message] aman ditampilkan ke user.
class WasteValidationException implements Exception {
  /// Membuat exception dengan pesan ramah user.
  const WasteValidationException(this.message);

  /// Pesan kesalahan.
  final String message;

  @override
  String toString() => message;
}

/// Use case memvalidasi foto bukti sebelum dikirim.
class ValidatePhotoUsecase {
  /// Membuat use case; [distanceCalculator] bisa di-inject untuk test.
  ValidatePhotoUsecase(
    this._wasteRepository, {
    double Function(
      double,
      double,
      double,
      double,
    )? distanceCalculator,
  }) : _distanceMeters = distanceCalculator ?? _haversineMeters;

  final WasteRepository _wasteRepository;
  final double Function(double, double, double, double) _distanceMeters;

  /// Jarak meter dua koordinat (dipakai ulang penilaian risiko).
  double distanceBetween(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return _distanceMeters(lat1, lon1, lat2, lon2);
  }

  /// Memvalidasi [hash] (duplikat), posisi user terhadap checkpoint, dan
  /// rate limit [userId].
  ///
  /// Melempar [WasteValidationException] bila salah satu cek gagal.
  Future<void> validate({
    required String hash,
    required String userId,
    required double userLatitude,
    required double userLongitude,
    required double checkpointLatitude,
    required double checkpointLongitude,
    required double radiusMeters,
  }) async {
    if (await _wasteRepository.checkDuplicateHash(hash)) {
      throw WasteValidationException(AppStrings.errorPhotoDuplicate);
    }

    final double distance = _distanceMeters(
      userLatitude,
      userLongitude,
      checkpointLatitude,
      checkpointLongitude,
    );
    // Penegakan radius + batas harian mengikuti pengaturan admin
    // (AppConfig, fallback AppValues).
    if (AppConfig.enforceGpsRadius && distance > radiusMeters) {
      throw WasteValidationException(AppStrings.errorGpsOutOfRange);
    }

    final int todayCount = await _wasteRepository.countTodayWasteLogs(userId);
    if (todayCount >= AppConfig.maxWasteLogsPerDay) {
      throw WasteValidationException(AppStrings.errorRateLimitReached);
    }
  }

  /// Formula haversine (meter) — murni Dart agar domain bebas plugin Flutter.
  static double _haversineMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusMeters = 6371000.0;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * earthRadiusMeters * math.asin(math.sqrt(a));
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180.0;
}