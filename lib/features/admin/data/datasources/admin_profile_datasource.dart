// Data source role admin (data layer).
//
// Membaca kolom role tabel profiles untuk user yang sedang login.
// Dipakai guard halaman admin; bukan untuk otorisasi server (otorisasi
// tetap di RLS Supabase).

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';

/// Data source role pengguna Go Green.
class AdminProfileDatasource {
  /// Membuat data source. [client] bisa di-inject untuk test.
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
