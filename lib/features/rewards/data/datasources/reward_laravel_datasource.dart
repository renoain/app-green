// Data source reward Laravel via REST (tanpa Supabase).

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/data/datasources/auth_laravel_datasource.dart';
import '../../../points/data/datasources/points_laravel_datasource.dart';
import '../models/redemption_model.dart';
import '../models/reward_model.dart';
import 'reward_remote_datasource.dart';

/// Data source reward untuk mode Laravel. Method sama persis dengan
/// [RewardRemoteDatasource] sehingga pemanggil tidak perlu berubah.
class RewardLaravelDatasource extends RewardRemoteDatasource {
  RewardLaravelDatasource({Dio? dio, PointsLaravelDatasource? pointsDatasource})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppEnv.laravelApiUrl)),
        _pointsLaravel = pointsDatasource ?? PointsLaravelDatasource(dio: dio),
        super(
          pointsDatasource:
              pointsDatasource ?? PointsLaravelDatasource(dio: dio),
        );

  final Dio _dio;
  final PointsLaravelDatasource _pointsLaravel;

  List<Map<String, dynamic>> _asList(Response<dynamic> response) {
    final Object? body = response.data;
    final Object? payload = body is Map ? body['data'] : body;
    if (payload is! List) {
      return const <Map<String, dynamic>>[];
    }
    final List<Map<String, dynamic>> rows = <Map<String, dynamic>>[];
    for (final Object? item in payload) {
      rows.add(Map<String, dynamic>.from(item as Map));
    }
    return rows;
  }

  Map<String, dynamic> _asMap(Response<dynamic> response) {
    final Object? body = response.data;
    final Object? payload = body is Map ? body['data'] : body;
    if (payload is Map) {
      return Map<String, dynamic>.from(payload);
    }
    return Map<String, dynamic>.from(body as Map);
  }

  Future<Options> _authOptions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(laravelTokenKey);
    if (token == null || token.isEmpty) {
      return Options();
    }
    return Options(
      headers: <String, dynamic>{'Authorization': 'Bearer $token'},
    );
  }

  Never _logAndRethrow(String method, Object error, StackTrace stackTrace) {
    AppLogger.error('RewardLaravelDatasource.$method gagal', error, stackTrace);
    throw error;
  }

  /// Ambil semua reward aktif, diurutkan berdasarkan harga poin.
  @override
  Future<List<RewardModel>> getAllRewards() async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/rewards',
        options: await _authOptions(),
      );
      return _asList(response).map(RewardModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getAllRewards', error, stackTrace);
    }
  }

  /// Ambil satu reward berdasarkan id, atau null bila tidak ada.
  @override
  Future<RewardModel?> getRewardById(String id) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/rewards/$id',
        options: await _authOptions(),
      );
      final RewardModel reward = RewardModel.fromJson(_asMap(response));
      return reward.isActive ? reward : null;
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      _logAndRethrow('getRewardById', error, stackTrace);
    }
  }

  /// Ambil semua reward untuk admin (server hanya kirim aktif, filter di klien dilewati).
  @override
  Future<List<RewardModel>> getAllForAdmin() async {
    return getAllRewards();
  }

  /// Tambah reward baru (admin).
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
        '/rewards',
        data: <String, dynamic>{
          'name': name,
          'description': description,
          'points_cost': pointsCost,
          'stock': stock,
          'image_url': imageUrl,
          'is_active': isActive,
        },
        options: await _authOptions(),
      );
      return RewardModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('createReward', error, stackTrace);
    }
  }

  /// Ubah reward (admin).
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
      final Response<dynamic> response = await _dio.put(
        '/rewards/$id',
        data: <String, dynamic>{
          'name': name,
          'description': description,
          'points_cost': pointsCost,
          'stock': stock,
          'image_url': imageUrl,
          'is_active': isActive,
        },
        options: await _authOptions(),
      );
      return RewardModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('updateReward', error, stackTrace);
    }
  }

  /// Ubah status aktif reward (admin).
  @override
  Future<void> setRewardActive({
    required String id,
    required bool isActive,
  }) async {
    try {
      await _dio.put(
        '/rewards/$id',
        data: <String, dynamic>{'is_active': isActive},
        options: await _authOptions(),
      );
    } catch (error, stackTrace) {
      _logAndRethrow('setRewardActive', error, stackTrace);
    }
  }

  /// Hapus reward (admin).
  @override
  Future<void> deleteReward(String id) async {
    try {
      await _dio.delete(
        '/rewards/$id',
        options: await _authOptions(),
      );
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
    return _pointsLaravel.redeemPoints(userId: userId, rewardId: rewardId);
  }

  /// Daftar penukaran milik user, terbaru di atas.
  @override
  Future<List<RedemptionModel>> getUserRedemptions(String userId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/redemptions',
        queryParameters: <String, dynamic>{'user_id': userId},
        options: await _authOptions(),
      );
      return _asList(response).map(RedemptionModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getUserRedemptions', error, stackTrace);
    }
  }
}
