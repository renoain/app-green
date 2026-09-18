// Data source reward berbasis Supabase.
//
// Membungkus pembacaan katalog reward dan pengajuan penukaran. Delegasi
// penukaran ke PointsRemoteDatasource (insert redemptions) agar logika
// redemption tidak terduplikasi.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../points/data/datasources/points_remote_datasource.dart';
import '../models/reward_model.dart';

/// Data source reward Go Green.
class RewardRemoteDatasource {
  /// Membuat data source reward. [client] dan [pointsDatasource] bisa
  /// di-inject untuk test.
  RewardRemoteDatasource({
    SupabaseClient? client,
    PointsRemoteDatasource? pointsDatasource,
  })  : _client = client ?? SupabaseService.instance.client,
        _pointsDatasource =
            pointsDatasource ?? PointsRemoteDatasource(client: client);

  final SupabaseClient _client;
  final PointsRemoteDatasource _pointsDatasource;

  /// Ambil semua reward aktif, diurutkan berdasarkan harga poin.
  Future<List<RewardModel>> getAllRewards() async {
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.rewards)
        .select()
        .eq('is_active', true)
        .order('points_cost', ascending: true);
    return rows.map(RewardModel.fromJson).toList();
  }

  /// Ambil satu reward aktif berdasarkan id, atau null bila tidak ada.
  Future<RewardModel?> getRewardById(String id) async {
    final Map<String, dynamic>? row = await _client
        .from(AppTables.rewards)
        .select()
        .eq('id', id)
        .eq('is_active', true)
        .maybeSingle();
    return row == null ? null : RewardModel.fromJson(row);
  }

  /// Mengajukan penukaran reward. Mengembalikan ID redemption yang dibuat.
  Future<String> redeemReward({
    required String userId,
    required String rewardId,
  }) {
    return _pointsDatasource.redeemPoints(
      userId: userId,
      rewardId: rewardId,
    );
  }
}