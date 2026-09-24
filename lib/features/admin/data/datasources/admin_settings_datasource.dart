// Data source pengaturan operasional admin (data layer).
//
// Baca semua baris app_settings; tulis via upsert per kunci (policy
// app_settings_write_admin, migration 019; RLS admin di server).

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';

/// Data source pengaturan untuk admin + startup aplikasi.
class AdminSettingsDatasource {
  /// Membuat data source. [client] bisa di-inject untuk test.
  AdminSettingsDatasource({SupabaseClient? client}) : _override = client;

  final SupabaseClient? _override;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

  /// Ambil semua pengaturan sebagai map key -> value mentah.
  Future<Map<String, String>> getAll() async {
    final List<Map<String, dynamic>> rows =
        await _client.from(AppTables.appSettings).select('key,value');
    return <String, String>{
      for (final Map<String, dynamic> row in rows)
        (row['key'] as String): '${row['value']}',
    };
  }

  /// Simpan nilai (upsert per kunci).
  Future<void> saveAll(Map<String, String> values) async {
    for (final MapEntry<String, String> entry in values.entries) {
      await _client.from(AppTables.appSettings).upsert(
        <String, dynamic>{'key': entry.key, 'value': entry.value},
        onConflict: 'key',
      );
    }
  }
}
