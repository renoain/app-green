// Data source poin dummy berbasis json-server (tanpa Supabase).

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_env.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/utils/logger.dart';
import 'points_remote_datasource.dart';

/// Data source poin untuk mode dummy. Method sama persis dengan [PointsRemoteDatasource] sehingga pemanggil tidak perlu berubah.
class PointsDummyDatasource extends PointsRemoteDatasource {
  PointsDummyDatasource({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(baseUrl: AppEnv.dummyApiUrl));

  final Dio _dio;

  List<Map<String, dynamic>> _asList(Response<dynamic> response) {
    final Object? data = response.data;
    if (data is List) {
      return data
          .map((Object? item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }

  Never _logAndRethrow(String method, Object error, StackTrace stackTrace) {
    AppLogger.error('PointsDummyDatasource.$method gagal', error, stackTrace);
    throw error;
  }

  /// Total poin user (earn dikurangi redeem).
  @override
  Future<int> getTotalPoints(String userId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.points}',
        queryParameters: <String, dynamic>{'user_id': userId},
      );
      int total = 0;
      for (final Map<String, dynamic> row in _asList(response)) {
        final int amount = row['amount'] as int? ?? 0;
        final PointType type = PointType.fromDb(row['type'] as String?);
        total += type == PointType.earn ? amount : -amount;
      }
      return total;
    } catch (error, stackTrace) {
      _logAndRethrow('getTotalPoints', error, stackTrace);
    }
  }

  /// Riwayat poin user, terbaru di atas.
  @override
  Future<List<Map<String, dynamic>>> getPointsHistory(String userId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.points}',
        queryParameters: <String, dynamic>{
          'user_id': userId,
          '_sort': 'created_at',
          '_order': 'desc',
        },
      );
      return _asList(response);
    } catch (error, stackTrace) {
      _logAndRethrow('getPointsHistory', error, stackTrace);
    }
  }

  /// Mencatat poin ke json-server.
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
        '/${AppTables.points}',
        data: <String, dynamic>{
          'id': const Uuid().v4(),
          'user_id': userId,
          'amount': amount,
          'type': type.value,
          'reference_id': referenceId,
          'description': description,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
    } catch (error, stackTrace) {
      _logAndRethrow('addPoints', error, stackTrace);
    }
  }

  /// Mengajukan penukaran hadiah. Mengembalikan voucher code.
  @override
  Future<String> redeemPoints({
    required String userId,
    required String rewardId,
  }) async {
    try {
      final String voucherCode = _generateVoucherCode();
      await _dio.post(
        '/${AppTables.redemptions}',
        data: <String, dynamic>{
          'id': const Uuid().v4(),
          'user_id': userId,
          'reward_id': rewardId,
          'status': 'pending',
          'qr_code': const Uuid().v4(),
          'voucher_code': voucherCode,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
      await _dio.post(
        '/${AppTables.points}',
        data: <String, dynamic>{
          'id': const Uuid().v4(),
          'user_id': userId,
          'amount': 0,
          'type': PointType.redeem.value,
          'reference_id': voucherCode,
          'description': 'Redeem reward: $rewardId',
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
      return voucherCode;
    } catch (error, stackTrace) {
      _logAndRethrow('redeemPoints', error, stackTrace);
    }
  }

  /// Menghasilkan kode voucher unik.
  String _generateVoucherCode() {
    return const Uuid().v4().toUpperCase().substring(0, 8);
  }
}
