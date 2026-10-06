// Data source reward dummy berbasis json-server (tanpa Supabase).

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/utils/logger.dart';
import '../../../points/data/datasources/points_dummy_datasource.dart';
import '../models/redemption_model.dart';
import '../models/reward_model.dart';
import 'reward_remote_datasource.dart';

/// Data source reward untuk mode dummy. Method sama persis dengan [RewardRemoteDatasource] sehingga pemanggil tidak perlu berubah.
class RewardDummyDatasource extends RewardRemoteDatasource {
  RewardDummyDatasource({Dio? dio, PointsDummyDatasource? pointsDatasource})
      : _dio = dio ??
            Dio(BaseOptions(baseUrl: AppEnv.dummyApiUrl)),
        _pointsDummy =
            pointsDatasource ?? PointsDummyDatasource(dio: dio),
        super(
          pointsDatasource:
              pointsDatasource ?? PointsDummyDatasource(dio: dio),
        );

  final Dio _dio;
  final PointsDummyDatasource _pointsDummy;

  List<Map<String, dynamic>> _asList(Response<dynamic> response) {
    final Object? data = response.data;
    if (data is List) {
      return data
          .map((Object? item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _asMap(Response<dynamic> response) {
    return Map<String, dynamic>.from(response.data as Map);
  }

  Never _logAndRethrow(String method, Object error, StackTrace stackTrace) {
    AppLogger.error('RewardDummyDatasource.$method gagal', error, stackTrace);
    throw error;
  }

  /// Ambil semua reward aktif, diurutkan berdasarkan harga poin.
  @override
  Future<List<RewardModel>> getAllRewards() async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.rewards}',
        queryParameters: <String, dynamic>{
          'is_active': true,
          '_sort': 'points_cost',
          '_order': 'asc',
        },
      );
      return _asList(response).map(RewardModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getAllRewards', error, stackTrace);
    }
  }

  /// Ambil satu reward aktif berdasarkan id, atau null bila tidak ada.
  @override
  Future<RewardModel?> getRewardById(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get('/${AppTables.rewards}/$id');
      if (response.data == null) {
        return null;
      }
      final RewardModel reward = RewardModel.fromJson(_asMap(response));
      return reward.isActive ? reward : null;
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      _logAndRethrow('getRewardById', error, stackTrace);
    }
  }

  /// Ambil semua reward untuk admin (aktif + nonaktif).
  @override
  Future<List<RewardModel>> getAllForAdmin() async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.rewards}',
        queryParameters: <String, dynamic>{
          '_sort': 'points_cost',
          '_order': 'asc',
        },
      );
      return _asList(response).map(RewardModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getAllForAdmin', error, stackTrace);
    }
  }

  /// Tambah reward baru.
  @override
  Future<RewardModel> createReward({
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/${AppTables.rewards}',
        data: <String, dynamic>{
          'id': const Uuid().v4(),
          'name': name,
          'description': description,
          'points_cost': pointsCost,
          'stock': stock,
          'image_url': imageUrl,
          'is_active': isActive,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
      return RewardModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('createReward', error, stackTrace);
    }
  }

  /// Ubah reward.
  @override
  Future<RewardModel> updateReward({
    required String id,
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    try {
      final Response<dynamic> response = await _dio.patch(
        '/${AppTables.rewards}/$id',
        data: <String, dynamic>{
          'name': name,
          'description': description,
          'points_cost': pointsCost,
          'stock': stock,
          'image_url': imageUrl,
          'is_active': isActive,
        },
      );
      return RewardModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('updateReward', error, stackTrace);
    }
  }

  /// Ubah status aktif reward.
  @override
  Future<void> setRewardActive({
    required String id,
    required bool isActive,
  }) async {
    try {
      await _dio.patch(
        '/${AppTables.rewards}/$id',
        data: <String, dynamic>{'is_active': isActive},
      );
    } catch (error, stackTrace) {
      _logAndRethrow('setRewardActive', error, stackTrace);
    }
  }

  /// Hapus reward.
  @override
  Future<void> deleteReward(String id) async {
    try {
      await _dio.delete('/${AppTables.rewards}/$id');
    } catch (error, stackTrace) {
      _logAndRethrow('deleteReward', error, stackTrace);
    }
  }

  /// Mengajukan penukaran reward. Mengembalikan voucher code.
  @override
  Future<String> redeemReward({
    required String userId,
    required String rewardId,
  }) {
    return _pointsDummy.redeemPoints(userId: userId, rewardId: rewardId);
  }

  /// Daftar penukaran milik user, terbaru di atas.
  @override
  Future<List<RedemptionModel>> getUserRedemptions(String userId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.redemptions}',
        queryParameters: <String, dynamic>{
          'user_id': userId,
          '_sort': 'created_at',
          '_order': 'desc',
        },
      );
      return _asList(response).map(RedemptionModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getUserRedemptions', error, stackTrace);
    }
  }
}
