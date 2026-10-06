// Data source checkpoint dummy berbasis json-server (tanpa Supabase).

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/utils/geo_utils.dart';
import '../../../../core/utils/logger.dart';
import '../models/checkpoint_model.dart';
import 'checkpoint_remote_datasource.dart';

/// Data source checkpoint untuk mode dummy. Method sama persis dengan [CheckpointRemoteDatasource] sehingga repository tidak perlu berubah.
class CheckpointDummyDatasource extends CheckpointRemoteDatasource {
  CheckpointDummyDatasource({Dio? dio})
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
    AppLogger.error(
      'CheckpointDummyDatasource.$method gagal',
      error,
      stackTrace,
    );
    throw error;
  }

  /// Ambil satu checkpoint berdasarkan id, atau null bila tidak ada.
  CheckpointModel? _singleOrNull(List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) {
      return null;
    }
    return CheckpointModel.fromJson(rows.first);
  }

  /// Ambil semua checkpoint (aktif + nonaktif, untuk admin).
  @override
  Future<List<CheckpointModel>> getAllCheckpoints() async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.checkpoints}',
        queryParameters: <String, dynamic>{
          '_sort': 'name',
          '_order': 'asc',
        },
      );
      return _asList(response).map(CheckpointModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getAllCheckpoints', error, stackTrace);
    }
  }

  /// Ambil checkpoint aktif saja (untuk user).
  @override
  Future<List<CheckpointModel>> getActiveCheckpoints() async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.checkpoints}',
        queryParameters: <String, dynamic>{
          'is_active': true,
          '_sort': 'name',
          '_order': 'asc',
        },
      );
      return _asList(response).map(CheckpointModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getActiveCheckpoints', error, stackTrace);
    }
  }

  /// Ambil checkpoint terdekat dari posisi user (client-side, sama seperti remote).
  @override
  Future<List<CheckpointModel>> getNearbyCheckpoints({
    required double latitude,
    required double longitude,
    bool onlyWithinRadius = true,
  }) async {
    final List<CheckpointModel> all = await getActiveCheckpoints();
    final List<({CheckpointModel checkpoint, int distanceMeters})> withDistance =
        <({CheckpointModel checkpoint, int distanceMeters})>[];
    for (final CheckpointModel checkpoint in all) {
      final int distanceMeters = GeoUtils.distanceMeters(
        latitude,
        longitude,
        checkpoint.latitude,
        checkpoint.longitude,
      );
      if (!onlyWithinRadius || distanceMeters <= checkpoint.radius) {
        withDistance.add(
          (checkpoint: checkpoint, distanceMeters: distanceMeters),
        );
      }
    }
    withDistance.sort(
      (a, b) => a.distanceMeters.compareTo(b.distanceMeters),
    );
    return withDistance
        .map((item) => item.checkpoint)
        .toList(growable: false);
  }

  /// Ambil satu checkpoint berdasarkan id, atau null bila tidak ada.
  @override
  Future<CheckpointModel?> getCheckpointById(String id) async {
    try {
      final Response<dynamic> response =
          await _dio.get('/${AppTables.checkpoints}/$id');
      if (response.data == null) {
        return null;
      }
      return CheckpointModel.fromJson(_asMap(response));
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      _logAndRethrow('getCheckpointById', error, stackTrace);
    }
  }

  /// Ambil satu checkpoint berdasarkan kode QR, atau null bila tidak ada.
  @override
  Future<CheckpointModel?> getCheckpointByQrCode(String qrCode) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/${AppTables.checkpoints}',
        queryParameters: <String, dynamic>{'qr_code': qrCode},
      );
      return _singleOrNull(_asList(response));
    } catch (error, stackTrace) {
      _logAndRethrow('getCheckpointByQrCode', error, stackTrace);
    }
  }

  /// Tambah checkpoint baru.
  @override
  Future<CheckpointModel> createCheckpoint({
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
    int? maxUses,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/${AppTables.checkpoints}',
        data: <String, dynamic>{
          'id': const Uuid().v4(),
          'name': name,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
          if (qrCode != null && qrCode.isNotEmpty) 'qr_code': qrCode,
          if (code != null && code.isNotEmpty) 'code': code,
          if (provinceCode != null && provinceCode.isNotEmpty)
            'province_code': provinceCode,
          if (cityCode != null && cityCode.isNotEmpty) 'city_code': cityCode,
          if (districtCode != null && districtCode.isNotEmpty)
            'district_code': districtCode,
          if (subdistrict != null && subdistrict.isNotEmpty)
            'subdistrict': subdistrict,
          'is_active': true,
          if (maxUses != null) 'max_uses': maxUses,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
      return CheckpointModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('createCheckpoint', error, stackTrace);
    }
  }

  /// Ubah checkpoint.
  @override
  Future<CheckpointModel> updateCheckpoint({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
    int? maxUses,
  }) async {
    try {
      final Response<dynamic> response = await _dio.patch(
        '/${AppTables.checkpoints}/$id',
        data: <String, dynamic>{
          'name': name,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
          'qr_code': (qrCode == null || qrCode.isEmpty) ? null : qrCode,
          'code': (code == null || code.isEmpty) ? null : code,
          'province_code': (provinceCode == null || provinceCode.isEmpty)
              ? null
              : provinceCode,
          'city_code':
              (cityCode == null || cityCode.isEmpty) ? null : cityCode,
          'district_code': (districtCode == null || districtCode.isEmpty)
              ? null
              : districtCode,
          'subdistrict':
              (subdistrict == null || subdistrict.isEmpty) ? null : subdistrict,
          if (maxUses != null) 'max_uses': maxUses,
        },
      );
      return CheckpointModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('updateCheckpoint', error, stackTrace);
    }
  }

  /// Hapus checkpoint.
  @override
  Future<void> deleteCheckpoint(String id) async {
    try {
      await _dio.delete('/${AppTables.checkpoints}/$id');
    } catch (error, stackTrace) {
      _logAndRethrow('deleteCheckpoint', error, stackTrace);
    }
  }

  /// Tambah checkpoint baru (alias untuk [createCheckpoint]).
  @override
  Future<CheckpointModel> insertCheckpoint({
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
    int? maxUses,
  }) {
    return createCheckpoint(
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
      maxUses: maxUses,
    );
  }

  /// Ubah checkpoint (alias untuk [updateCheckpoint]).
  @override
  Future<CheckpointModel> updateCheckpointRecord({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
    int? maxUses,
  }) {
    return updateCheckpoint(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode,
      code: code,
      provinceCode: provinceCode,
      cityCode: cityCode,
      districtCode: districtCode,
      subdistrict: subdistrict,
      maxUses: maxUses,
    );
  }

  /// Nonaktifkan checkpoint (soft-delete).
  @override
  Future<void> deactivateCheckpoint(String id) async {
    try {
      await _dio.patch(
        '/${AppTables.checkpoints}/$id',
        data: <String, dynamic>{'is_active': false},
      );
    } catch (error, stackTrace) {
      _logAndRethrow('deactivateCheckpoint', error, stackTrace);
    }
  }

  /// Aktifkan kembali checkpoint.
  @override
  Future<void> activateCheckpoint(String id) async {
    try {
      await _dio.patch(
        '/${AppTables.checkpoints}/$id',
        data: <String, dynamic>{'is_active': true},
      );
    } catch (error, stackTrace) {
      _logAndRethrow('activateCheckpoint', error, stackTrace);
    }
  }
}
