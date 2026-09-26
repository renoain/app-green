// Data source token push perangkat (data layer).
//
// Menyimpan token FCM ke kolom profiles.fcm_token milik user sendiri
// (RLS update_own; hanya role yang dikunci).

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';

/// Data source token push Go Green.
class PushTokenDatasource {
  /// Membuat data source. [client] bisa di-inject untuk test.
  PushTokenDatasource({SupabaseClient? client}) : _override = client;

  final SupabaseClient? _override;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

  /// Simpan token perangkat untuk [userId].
  Future<void> saveToken({
    required String userId,
    required String token,
  }) async {
    await _client
        .from(AppTables.profiles)
        .update(<String, dynamic>{'fcm_token': token}).eq('id', userId);
  }

  /// Hapus token perangkat (dipakai saat logout).
  Future<void> clearToken({required String userId}) async {
    await _client
        .from(AppTables.profiles)
        .update(<String, dynamic>{'fcm_token': null}).eq('id', userId);
  }
}
