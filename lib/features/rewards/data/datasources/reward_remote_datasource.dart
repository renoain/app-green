// Data source reward berbasis Supabase.
//
// Membungkus pembacaan katalog reward dan pengajuan penukaran. Delegasi
// penukaran ke PointsRemoteDatasource (insert redemptions) agar logika
// redemption tidak terduplikasi.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../points/data/datasources/points_remote_datasource.dart';
import '../models/redemption_model.dart';
import '../models/reward_model.dart';

/// Data source reward Go Green.
class RewardRemoteDatasource {
  /// Membuat data source reward. [client] dan [pointsDatasource] bisa
  /// di-inject untuk test.
  ///
  /// Client Supabase diambil malas (lazy) agar konstruksi provider tidak
  /// crash di mode demo/test saat Supabase belum terinisialisasi.
  RewardRemoteDatasource({
    SupabaseClient? client,
    PointsRemoteDatasource? pointsDatasource,
  })  : _override = client,
        _pointsDatasource =
            pointsDatasource ?? PointsRemoteDatasource(client: client);

  final SupabaseClient? _override;
  final PointsRemoteDatasource _pointsDatasource;

  SupabaseClient get _client =>
      _override ?? SupabaseService.instance.client;

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

  /// Daftar penukaran milik user, terbaru di atas, lengkap nama reward.
  Future<List<RedemptionModel>> getUserRedemptions(String userId) async {
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.redemptions)
        .select('*, rewards(name)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return rows.map(RedemptionModel.fromJson).toList();
  }
}