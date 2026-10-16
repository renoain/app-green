// Setup logger aplikasi menggunakan package logger.

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Logger global aplikasi Go Green. Digunakan di seluruh lapisan kode untuk pencatatan log terstruktur.
///
/// Semua output dimatikan pada build release (lihat [Level.off]) supaya log tidak
/// bocor ke logcat/syslog device pengguna, sesuai aturan "dilarang log data sensitif".
class AppLogger {
  AppLogger._();

  /// Instance logger tunggal.
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: false,
    ),
    level: kDebugMode ? Level.debug : Level.off,
  );

  /// Mencatat pesan level debug. Khusus untuk keperluan pengembangan.
  static void debug(dynamic message) => _logger.d(_sanitize(message));

  /// Mencatat pesan level info. Untuk milestone penting.
  static void info(dynamic message) => _logger.i(_sanitize(message));

  /// Mencatat pesan level warning. Untuk anomali yang tidak fatal.
  static void warning(dynamic message) => _logger.w(_sanitize(message));

  /// Mencatat pesan level error. Untuk kegagalan. [error] dan [stackTrace] ikut dicatat di debug mode.
  static void error(dynamic message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(_sanitize(message), error: _sanitize(error), stackTrace: stackTrace);

  /// Redaksi nilai sensitif sebelum masuk log: sensor alamat email agar data
  /// pribadi pengguna tidak terekspos ke logcat.
  static dynamic _sanitize(dynamic value) {
    if (value is String) return _maskEmail(value);
    return value;
  }

  /// Sensor alamat email pada teks log, mis. u***@domain.com.
  static String _maskEmail(String input) {
    return input.replaceAllMapped(
      RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'),
      (Match match) {
        final String local = match.group(0)!.split('@').first;
        final String maskedLocal = local.isEmpty
            ? local
            : '${local[0]}${'*' * (local.length - 1)}';
        return '$maskedLocal@${match.group(0)!.split('@')[1]}';
      },
    );
  }
}