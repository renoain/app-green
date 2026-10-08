// Saklar mode datasource untuk testing tanpa Supabase.
// Nilai DATA_SOURCE: 'supabase' (default), 'dummy' (json-server), 'laravel'.
// USE_DUMMY_API tetap didukung untuk backward compatibility.

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi environment pilihan datasource. Default [dataSource] 'supabase'.
class AppEnv {
  AppEnv._();

  /// Nama datasource aktif: 'supabase', 'dummy', atau 'laravel'.
  /// Dibaca dari DATA_SOURCE; bila kosong fallback ke USE_DUMMY_API.
  static String get dataSource {
    final String? configured = _dataSourceRaw;
    if (configured != null && configured.isNotEmpty) {
      return configured;
    }
    return _legacyDummyFlag ? 'dummy' : 'supabase';
  }

  /// True bila datasource dummy json-server dipakai. Selalu konsisten
  /// dengan [dataSource] sehingga USE_DUMMY_API diabaikan total saat
  /// DATA_SOURCE terisi (mis. mode laravel + USE_DUMMY_API=true = false).
  static bool get useDummyApi => dataSource == 'dummy';

  /// Nilai mentah DATA_SOURCE atau null bila tidak diset.
  static String? get _dataSourceRaw {
    const String fromDefine = String.fromEnvironment('DATA_SOURCE');
    if (fromDefine.isNotEmpty) {
      return fromDefine.trim().toLowerCase();
    }
    if (dotenv.isInitialized) {
      final String? configured = dotenv.env['DATA_SOURCE']?.trim();
      if (configured != null && configured.isNotEmpty) {
        return configured.toLowerCase();
      }
    }
    return null;
  }

  /// Flag lama USE_DUMMY_API (dipakai bila DATA_SOURCE kosong).
  static bool get _legacyDummyFlag {
    const String fromDefine = String.fromEnvironment('USE_DUMMY_API');
    if (fromDefine.isNotEmpty) {
      return fromDefine.trim().toLowerCase() == 'true';
    }
    if (dotenv.isInitialized) {
      return (dotenv.env['USE_DUMMY_API'] ?? '').trim().toLowerCase() == 'true';
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

  /// Base URL Laravel API (baca LARAVEL_API_URL).
  static String get laravelApiUrl {
    const String fromDefine = String.fromEnvironment('LARAVEL_API_URL');
    if (fromDefine.isNotEmpty) {
      return fromDefine.trim();
    }
    if (dotenv.isInitialized) {
      final String? configured = dotenv.env['LARAVEL_API_URL']?.trim();
      if (configured != null && configured.isNotEmpty) {
        return configured;
      }
    }
    return 'http://127.0.0.1:8000/api';
  }
}
