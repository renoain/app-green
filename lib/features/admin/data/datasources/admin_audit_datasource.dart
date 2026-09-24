// Data source jejak audit admin (data layer).
//
// Tulis best effort (kegagalan hanya jadi warning agar aksi utama tidak
// ikut gagal); baca 50 terbaru dengan nama pelaku.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/audit_log.dart';

/// Data source log audit untuk admin.
class AdminAuditDatasource {
  /// Membuat data source. [client] bisa di-inject untuk test.
  AdminAuditDatasource({SupabaseClient? client}) : _override = client;

  final SupabaseClient? _override;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

  /// Catat aksi admin. Lewati diam-diam bila belum login.
  Future<void> log({
    required String action,
    required String entity,
    String? entityId,
    String? detail,
  }) async {
    final String? actorId = SupabaseService.instance.currentUser?.id;
    if (actorId == null) return;
    try {
      await _client.from(AppTables.adminAuditLogs).insert(
        <String, dynamic>{
          'actor_id': actorId,
          'action': action,
          'entity': entity,
          'entity_id': entityId,
          'detail': detail,
        },
      );
    } catch (e) {
      AppLogger.warning('Audit log gagal: $e');
    }
  }

  /// Ambil log terbaru, dibatasi [limit].
  Future<List<AuditLog>> getRecent({int limit = 50}) async {
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.adminAuditLogs)
        .select('*, profiles(username)')
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map(_fromJson).toList(growable: false);
  }

  AuditLog _fromJson(Map<String, dynamic> json) {
    final Object? profile = json['profiles'];
    DateTime createdAt = DateTime.now();
    final Object? rawDate = json['created_at'];
    if (rawDate is String) {
      createdAt = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else if (rawDate is DateTime) {
      createdAt = rawDate;
    }
    return AuditLog(
      id: '${json['id']}',
      actorId: json['actor_id'] as String?,
      actorName: profile is Map<String, dynamic>
          ? profile['username'] as String?
          : null,
      action: '${json['action']}',
      entity: '${json['entity']}',
      entityId: json['entity_id'] as String?,
      detail: json['detail'] as String?,
      createdAt: createdAt,
    );
  }
}
