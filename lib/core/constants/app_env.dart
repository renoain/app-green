// Saklar mode dummy json-server untuk testing tanpa Supabase.

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi environment mode dummy. Default [useDummyApi] false (Supabase).
class AppEnv {
  AppEnv._();

  /// True bila datasource dummy json-server dipakai (baca USE_DUMMY_API).
  static bool get useDummyApi {
    const String fromDefine = String.fromEnvironment('USE_DUMMY_API');
    if (fromDefine.isNotEmpty) {
      return fromDefine.trim().toLowerCase() == 'true';
    }
    if (dotenv.isInitialized) {
      return (dotenv.env['USE_DUMMY_API'] ?? '').trim().toLowerCase() ==
          'true';
    }
    return false;
  }

  /// Base URL json-server (baca DUMMY_API_URL).
  static String get dummyApiUrl {
    const String fromDefine = String.fromEnvironment('DUMMY_API_URL');
    if (fromDefine.isNotEmpty) {
      return fromDefine.trim();
    }
    if (dotenv.isInitialized) {
      final String? configured = dotenv.env['DUMMY_API_URL']?.trim();
      if (configured != null && configured.isNotEmpty) {
        return configured;
      }
    }
    return 'http://localhost:3000';
  }
}
