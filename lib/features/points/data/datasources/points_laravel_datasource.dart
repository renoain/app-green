// Data source poin Laravel via REST (tanpa Supabase).

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_env.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/data/datasources/auth_laravel_datasource.dart';
import 'points_remote_datasource.dart';

/// Data source poin untuk mode Laravel. Method sama persis dengan
/// [PointsRemoteDatasource] sehingga pemanggil tidak perlu berubah.
class PointsLaravelDatasource extends PointsRemoteDatasource {
  PointsLaravelDatasource({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppEnv.laravelApiUrl));

  final Dio _dio;

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
    AppLogger.error('PointsLaravelDatasource.$method gagal', error, stackTrace);
    throw error;
  }

  /// Total poin user (earn dikurangi redeem, dihitung server).
  @override
  Future<int> getTotalPoints(String userId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/points/total',
        queryParameters: <String, dynamic>{'user_id': userId},
        options: await _authOptions(),
      );
      final Map<String, dynamic> data = _asMap(response);
      final Object? total = data['total'];
      if (total is num) {
        return total.toInt();
      }
      int sum = 0;
      for (final Map<String, dynamic> row in _asList(response)) {
        final int amount = row['amount'] as int? ?? 0;
        final PointType type = PointType.fromDb(row['type'] as String?);
        sum += type == PointType.earn ? amount : -amount;
      }
      return sum;
    } catch (error, stackTrace) {
      _logAndRethrow('getTotalPoints', error, stackTrace);
    }
  }

  /// Riwayat poin user, terbaru di atas.
  @override
  Future<List<Map<String, dynamic>>> getPointsHistory(String userId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/points',
        queryParameters: <String, dynamic>{'user_id': userId},
        options: await _authOptions(),
      );
      return _asList(response);
    } catch (error, stackTrace) {
      _logAndRethrow('getPointsHistory', error, stackTrace);
    }
  }

  /// Mencatat poin ke Laravel.
  @override
  Future<void> addPoints({
    required String userId,
    required int amount,
    required PointType type,
    String? referenceId,
    String? description,
  }) async {
    try {
      await _dio.post(
        '/points',
        data: <String, dynamic>{
          'user_id': userId,
          'amount': amount,
          'type': type.value,
          if (referenceId != null) 'reference_id': referenceId,
          if (description != null) 'description': description,
        },
        options: await _authOptions(),
      );
    } catch (error, stackTrace) {
      _logAndRethrow('addPoints', error, stackTrace);
    }
  }

  /// Mengajukan penukaran hadiah. Mengembalikan voucher code. Entri redeem
  /// memakai id redemption sebagai reference_id (36 char) dan dipecah
  /// per maksimal 50 poin mengikuti validasi server.
  @override
  Future<String> redeemPoints({
    required String userId,
    required String rewardId,
  }) async {
    try {
      final int cost = await _rewardCost(rewardId);
      final Response<dynamic> response = await _dio.post(
        '/redemptions',
        data: <String, dynamic>{
          'user_id': userId,
          'reward_id': rewardId,
        },
        options: await _authOptions(),
      );
      final Map<String, dynamic> redemption = _asMap(response);
      final String voucherCode = '${redemption['voucher_code'] ?? ''}';
      final String redemptionId = '${redemption['id'] ?? ''}';
      int remaining = cost;
      while (remaining > 0) {
        final int chunk = remaining > 50 ? 50 : remaining;
        await _dio.post(
          '/points',
          data: <String, dynamic>{
            'user_id': userId,
            'amount': chunk,
            'type': PointType.redeem.value,
            'reference_id': redemptionId,
            'description': 'Redeem reward: $rewardId ($voucherCode)',
          },
          options: await _authOptions(),
        );
        remaining -= chunk;
      }
      return voucherCode;
    } catch (error, stackTrace) {
      _logAndRethrow('redeemPoints', error, stackTrace);
    }
  }

  /// Harga reward untuk entri redeem (fallback 1 agar lolos validasi min:1).
  Future<int> _rewardCost(String rewardId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/rewards/$rewardId',
        options: await _authOptions(),
      );
      final Map<String, dynamic> data = _asMap(response);
      final Object? cost = data['points_cost'];
      if (cost is num && cost.toInt() > 0) {
        return cost.toInt();
      }
    } catch (error) {
      AppLogger.warning('Gagal baca harga reward $rewardId, pakai 1.');
    }
    return 1;
  }
}
