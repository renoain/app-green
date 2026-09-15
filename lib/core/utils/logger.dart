// Setup logger aplikasi menggunakan package logger.
//
// Level: debug, info, warning, error. Output ke console.
// Dilarang log data sensitif (token, password, foto, GPS detail).

import 'package:logger/logger.dart';

/// Logger global aplikasi Go Green.
///
/// Digunakan di seluruh lapisan kode untuk pencatatan log terstruktur.
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
  );

  /// Mencatat pesan level debug. Khusus untuk keperluan pengembangan.
  static void debug(dynamic message) => _logger.d(message);

  /// Mencatat pesan level info. Untuk milestone penting.
  static void info(dynamic message) => _logger.i(message);

  /// Mencatat pesan level warning. Untuk anomali yang tidak fatal.
  static void warning(dynamic message) => _logger.w(message);

  /// Mencatat pesan level error. Untuk kegagalan.
  static void error(dynamic message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}