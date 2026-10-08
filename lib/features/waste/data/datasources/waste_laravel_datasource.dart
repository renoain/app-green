// Data source waste log Laravel via REST (tanpa Supabase).

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_env.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/data/datasources/auth_laravel_datasource.dart';
import '../models/waste_log_model.dart';
import 'waste_remote_datasource.dart';

/// Data source waste log untuk mode Laravel. Method sama persis dengan
/// [WasteRemoteDatasource] sehingga repository tidak perlu berubah.
class WasteLaravelDatasource extends WasteRemoteDatasource {
  WasteLaravelDatasource({Dio? dio})
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
    AppLogger.error('WasteLaravelDatasource.$method gagal', error, stackTrace);
    throw error;
  }

  /// Upload dilewati di mode Laravel (tanpa endpoint storage). Path dipakai apa adanya.
  @override
  Future<String> uploadPhoto({
    required String fileName,
    required Uint8List bytes,
  }) async {
    if (bytes.length > AppConfig.maxPhotoBytes) {
      throw ArgumentError(
        'Ukuran foto melebihi batas maksimal ${AppConfig.maxPhotoMb} MB.',
      );
    }
    AppLogger.warning('Mode Laravel: upload foto dilewati untuk $fileName.');
    return fileName;
  }

  /// Menyimpan log pembuangan sampah ke Laravel.
  @override
  Future<WasteLogModel> insertWasteLog({
    required String userId,
    String? checkpointId,
    required WasteCategory category,
    String? photoUrl,
    String? hash,
    double? latitude,
    double? longitude,
    WasteSource source = WasteSource.manual,
    int? riskScore,
    bool? exifOk,
    String? riskDetail,
    String? rejectionReason,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/waste-logs',
        data: <String, dynamic>{
          'user_id': userId,
          if (checkpointId != null) 'checkpoint_id': checkpointId,
          'category': category.value,
          if (photoUrl != null) 'photo_url': photoUrl,
          if (hash != null) 'hash': hash,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
          'source': source.value,
          if (riskScore != null) 'risk_score': riskScore,
          if (exifOk != null) 'exif_ok': exifOk,
          if (riskDetail != null) 'risk_detail': riskDetail,
          if (rejectionReason != null) 'rejection_reason': rejectionReason,
        },
        options: await _authOptions(),
      );
      return WasteLogModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('insertWasteLog', error, stackTrace);
    }
  }

  /// Mengambil daftar waste log milik user, terbaru di atas.
  @override
  Future<List<WasteLogModel>> getWasteLogs(String userId) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/waste-logs',
        queryParameters: <String, dynamic>{'user_id': userId},
        options: await _authOptions(),
      );
      return _asList(response).map(WasteLogModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getWasteLogs', error, stackTrace);
    }
  }

  /// Mengambil waste log berstatus pending untuk verifikasi.
  @override
  Future<List<WasteLogModel>> getPendingWasteLogs() async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/waste-logs',
        queryParameters: <String, dynamic>{
          'status': WasteLogStatus.pending.value,
        },
        options: await _authOptions(),
      );
      return _asList(response).map(WasteLogModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getPendingWasteLogs', error, stackTrace);
    }
  }

  /// Memverifikasi waste log (update status oleh admin/petugas).
  @override
  Future<WasteLogModel> verifyWasteLog({
    required String id,
    required WasteLogStatus status,
    required String verifiedBy,
    String? notes,
  }) async {
    try {
      final Response<dynamic> response = await _dio.patch(
        '/waste-logs/$id',
        data: <String, dynamic>{
          'status': status.value,
          'verified_by': verifiedBy,
          'verified_at': DateTime.now().toUtc().toIso8601String(),
          if (notes != null) 'notes': notes,
        },
        options: await _authOptions(),
      );
      return WasteLogModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('verifyWasteLog', error, stackTrace);
    }
  }

  /// Menyetujui waste log (status verified).
  @override
  Future<WasteLogModel> approveWasteLog({
    required String id,
    required String verifiedBy,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/waste-logs/$id/approve',
        data: <String, dynamic>{'verified_by': verifiedBy},
        options: await _authOptions(),
      );
      return WasteLogModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('approveWasteLog', error, stackTrace);
    }
  }

  /// Menolak waste log (status rejected + alasan di rejection_reason sesuai validasi server).
  @override
  Future<WasteLogModel> rejectWasteLog({
    required String id,
    required String verifiedBy,
    required String reason,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/waste-logs/$id/reject',
        data: <String, dynamic>{
          'verified_by': verifiedBy,
          'rejection_reason': reason,
        },
        options: await _authOptions(),
      );
      return WasteLogModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('rejectWasteLog', error, stackTrace);
    }
  }

  /// Mode Laravel tidak punya signed URL, path dikembalikan apa adanya.
  @override
  Future<String> getPhotoSignedUrl(String path, {int expiresIn = 3600}) async {
    return path;
  }

  /// Mengembalikan true bila ada waste log dengan hash yang sama.
  @override
  Future<bool> checkDuplicateHash(String hash) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/waste-logs',
        queryParameters: <String, dynamic>{'hash': hash},
        options: await _authOptions(),
      );
      return _asList(response).isNotEmpty;
    } catch (error, stackTrace) {
      _logAndRethrow('checkDuplicateHash', error, stackTrace);
    }
  }

  /// Menghitung jumlah waste log user sejak awal hari ini (UTC).
  @override
  Future<int> countTodayWasteLogs(String userId) async {
    try {
      final DateTime start = DateTime.now().toUtc();
      final DateTime startOfDayUtc = DateTime.utc(
        start.year,
        start.month,
        start.day,
      );
      final Response<dynamic> response = await _dio.get(
        '/waste-logs',
        queryParameters: <String, dynamic>{'user_id': userId},
        options: await _authOptions(),
      );
      int count = 0;
      for (final Map<String, dynamic> row in _asList(response)) {
        final DateTime? createdAt = DateTime.tryParse('${row['created_at']}');
        if (createdAt != null && !createdAt.isBefore(startOfDayUtc)) {
          count++;
        }
      }
      return count;
    } catch (error, stackTrace) {
      _logAndRethrow('countTodayWasteLogs', error, stackTrace);
    }
  }
}
