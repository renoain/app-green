// Data source angka dasbor admin (data layer).

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/admin_dashboard_summary.dart';

/// Data source ringkasan dasbor admin Go Green.
class AdminDashboardDatasource {
  /// Membuat data source. [client] bisa di-inject untuk test.
  AdminDashboardDatasource({SupabaseClient? client}) : _override = client;

  final SupabaseClient? _override;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

  /// Mengambil seluruh angka ringkasan dasbor sekaligus.
  Future<AdminDashboardSummary> getSummary() async {
    final List<Map<String, dynamic>> users =
        await _client.from(AppTables.profiles).select('id');
    final List<Map<String, dynamic>> checkpoints =
        await _client.from(AppTables.checkpoints).select('id');
    final DateTime now = DateTime.now().toUtc();
    final DateTime startOfDay =
        DateTime.utc(now.year, now.month, now.day);
    final List<Map<String, dynamic>> today = await _client
        .from(AppTables.wasteLogs)
        .select('id')
        .gte('created_at', startOfDay.toIso8601String());
    final List<Map<String, dynamic>> pending = await _client
        .from(AppTables.wasteLogs)
        .select('id')
        .eq('status', WasteLogStatus.pending.value);
    final List<Map<String, dynamic>> points =
        await _client.from(AppTables.points).select('amount,type');
    int totalPoints = 0;
    for (final Map<String, dynamic> row in points) {
      final int amount = row['amount'] as int? ?? 0;
      totalPoints += PointType.fromDb(row['type'] as String?) == PointType.earn
          ? amount
          : -amount;
    }
    return AdminDashboardSummary(
      totalUsers: users.length,
      totalCheckpoints: checkpoints.length,
      wasteToday: today.length,
      wastePending: pending.length,
      totalPoints: totalPoints,
    );
  }

  /// Waktu pembuatan waste 7 hari terakhir (untuk grafik dasbor).
  Future<List<DateTime>> getWeeklyWasteTimestamps() async {
    final DateTime now = DateTime.now().toUtc();
    final DateTime start =
        DateTime.utc(now.year, now.month, now.day).subtract(
      const Duration(days: 6),
    );
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.wasteLogs)
        .select('created_at')
        .gte('created_at', start.toIso8601String());
    return <DateTime>[
      for (final Map<String, dynamic> row in rows)
        DateTime.tryParse('${row['created_at']}') ?? now,
    ];
  }
}
