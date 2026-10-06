// Data source waste log dummy berbasis json-server (tanpa Supabase).

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_env.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/utils/logger.dart';
import '../models/waste_log_model.dart';
import 'waste_remote_datasource.dart';

/// Data source waste log untuk mode dummy. Method sama persis dengan [WasteRemoteDatasource] sehingga repository tidak perlu berubah.
class WasteDummyDatasource extends WasteRemoteDatasource {
  WasteDummyDatasource({Dio? dio})
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

  Map<String, dynamic> _asMap(Response<dynamic> response) {
    return Map<String, dynamic>.from(response.data as Map);
  }

  Never _logAndRethrow(String method, Object error, StackTrace stackTrace) {
    AppLogger.error('WasteDummyDatasource.$method gagal', error, stackTrace);
    throw error;
  }

  /// Upload dilewati di mode dummy (json-server tidak punya storage). Path [fileName] dipakai apa adanya sebagai photo_url.
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
    AppLogger.warning('Mode dummy: upload foto dilewati untuk $fileName.');
    return fileName;
  }

  /// Menyimpan log pembuangan sampah ke json-server (status awal pending).
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
      final String now = DateTime.now().toUtc().toIso8601String();
      final Response<dynamic> response = await _dio.post(
        '/${AppTables.wasteLogs}',
        data: <String, dynamic>{
          'id': const Uuid().v4(),
          'user_id': userId,
          'checkpoint_id': checkpointId,
          'category': category.value,
          'photo_url': photoUrl,
          'hash': hash,
          'latitude': latitude,
          'longitude': longitude,
          'server_timestamp': now,
          'status': WasteLogStatus.pending.value,
          'source': source.value,
          if (riskScore != null) 'risk_score': riskScore,
          if (exifOk != null) 'exif_ok': exifOk,
          if (riskDetail != null) 'risk_detail': riskDetail,
          'created_at': now,
        },
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
        '/${AppTables.wasteLogs}',
        queryParameters: <String, dynamic>{
          'user_id': userId,
          '_sort': 'created_at',
          '_order': 'desc',
        },
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
        '/${AppTables.wasteLogs}',
        queryParameters: <String, dynamic>{
          'status': WasteLogStatus.pending.value,
          '_sort': 'created_at',
          '_order': 'asc',
        },
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
        '/${AppTables.wasteLogs}/$id',
        data: <String, dynamic>{
          'status': status.value,
          'verified_by': verifiedBy,
          'verified_at': DateTime.now().toUtc().toIso8601String(),
          'notes': notes,
        },
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
  }) {
    return verifyWasteLog(
      id: id,
      status: WasteLogStatus.verified,
      verifiedBy: verifiedBy,
    );
  }

  /// Menolak waste log (status rejected + alasan di notes).
  @override
  Future<WasteLogModel> rejectWasteLog({
    required String id,
    required String verifiedBy,
    required String reason,
  }) {
    return verifyWasteLog(
      id: id,
      status: WasteLogStatus.rejected,
      verifiedBy: verifiedBy,
      notes: reason,
    );
  }

  /// Mode dummy tidak punya signed URL, path dikembalikan apa adanya.
  @override
  Future<String> getPhotoSignedUrl(String path, {int expiresIn = 3600}) async {
    return path;
  }

  /// Mengembalikan true bila ada waste log dengan hash yang sama.
  @override
  Future<bool> checkDuplicateHash(String hash) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.wasteLogs}',
        queryParameters: <String, dynamic>{'hash': hash},
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
        '/${AppTables.wasteLogs}',
        queryParameters: <String, dynamic>{'user_id': userId},
      );
      int count = 0;
      for (final Map<String, dynamic> row in _asList(response)) {
        final DateTime? createdAt =
            DateTime.tryParse('${row['created_at']}');
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
