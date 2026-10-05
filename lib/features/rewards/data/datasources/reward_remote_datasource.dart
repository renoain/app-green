// Data source reward berbasis Supabase.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../points/data/datasources/points_remote_datasource.dart';
import '../models/redemption_model.dart';
import '../models/reward_model.dart';

/// Data source reward Go Green.
class RewardRemoteDatasource {
  /// di-inject untuk test. Client Supabase diambil malas (lazy) agar konstruksi provider tidak crash di mode demo/test saat Supabase belum terinisialisasi.
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

  /// Ambil semua reward untuk admin (aktif + nonaktif).
  Future<List<RewardModel>> getAllForAdmin() async {
    final List<Map<String, dynamic>> rows = await _client
        .from(AppTables.rewards)
        .select()
        .order('points_cost', ascending: true);
    return rows.map(RewardModel.fromJson).toList();
  }

  /// Tambah reward baru (admin, RLS di server).
  Future<RewardModel> createReward({
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    final Map<String, dynamic> row = await _client
        .from(AppTables.rewards)
        .insert(<String, dynamic>{
      'name': name,
      'description': description,
      'points_cost': pointsCost,
      'stock': stock,
      'image_url': imageUrl,
      'is_active': isActive,
    }).select().single();
    return RewardModel.fromJson(row);
  }

  /// Ubah reward (admin, RLS di server).
  Future<RewardModel> updateReward({
    required String id,
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    final Map<String, dynamic> row = await _client
        .from(AppTables.rewards)
        .update(<String, dynamic>{
      'name': name,
      'description': description,
      'points_cost': pointsCost,
      'stock': stock,
      'image_url': imageUrl,
      'is_active': isActive,
    }).eq('id', id).select().single();
    return RewardModel.fromJson(row);
  }

  /// Ubah status aktif reward (admin).
  Future<void> setRewardActive({
    required String id,
    required bool isActive,
  }) async {
    await _client
        .from(AppTables.rewards)
        .update(<String, dynamic>{'is_active': isActive}).eq('id', id);
  }

  /// Hapus reward (admin).
  Future<void> deleteReward(String id) async {
    await _client.from(AppTables.rewards).delete().eq('id', id);
  }

  /// Mengajukan penukaran reward. Mengembalikan voucher code.
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
