// Data source role admin (data layer).

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';

/// Data source role pengguna Go Green.
class AdminProfileDatasource {
  AdminProfileDatasource({SupabaseClient? client}) : _override = client;

  final SupabaseClient? _override;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

  /// Ambil role user dari tabel profiles, default [UserRole.user].
  Future<UserRole> getRole(String userId) async {
    final Map<String, dynamic>? row = await _client
        .from(AppTables.profiles)
        .select('role')
        .eq('id', userId)
        .maybeSingle();
    return UserRole.fromDb(row?['role'] as String?);
  }
}
