// Data source daftar user admin (data layer).
//
// Baca profiles terbaru + ubah role (policy profiles_update_role_admin,
// migration 018; RLS admin di server).

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/admin_user.dart';

/// Data source daftar user untuk admin.
class AdminUsersDatasource {
  /// Membuat data source. [client] bisa di-inject untuk test.
  AdminUsersDatasource({SupabaseClient? client}) : _override = client;

  final SupabaseClient? _override;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

  /// Ambil user terbaru, dibatasi [limit] agar ringan.
  Future<List<AdminUser>> getUsers({int limit = 50}) async {
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.profiles)
        .select('id,username,email,role,created_at')
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map(_fromJson).toList(growable: false);
  }

  /// Ubah role user (admin, RLS di server).
  Future<void> updateRole({required String id, required UserRole role}) async {
    await _client
        .from(AppTables.profiles)
        .update(<String, dynamic>{'role': role.value}).eq('id', id);
  }

  AdminUser _fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      username: json['username'] as String?,
      email: json['email'] as String?,
      role: UserRole.fromDb(json['role'] as String?),
      createdAt: _parseDate(json['created_at']),
    );
  }

  DateTime _parseDate(Object? value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
