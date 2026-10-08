// Data source checkpoint Laravel via REST (tanpa Supabase).

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/utils/geo_utils.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/data/datasources/auth_laravel_datasource.dart';
import '../models/checkpoint_model.dart';
import 'checkpoint_remote_datasource.dart';

/// Data source checkpoint untuk mode Laravel. Method sama persis dengan
/// [CheckpointRemoteDatasource] sehingga repository tidak perlu berubah.
class CheckpointLaravelDatasource extends CheckpointRemoteDatasource {
  CheckpointLaravelDatasource({Dio? dio})
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
    AppLogger.error(
      'CheckpointLaravelDatasource.$method gagal',
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

  /// Ambil semua checkpoint (admin dapat semua, user hanya aktif dari server).
  @override
  Future<List<CheckpointModel>> getAllCheckpoints() async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/checkpoints',
        options: await _authOptions(),
      );
      return _asList(response).map(CheckpointModel.fromJson).toList();
    } catch (error, stackTrace) {
      _logAndRethrow('getAllCheckpoints', error, stackTrace);
    }
  }

  /// Ambil checkpoint aktif saja (difilter di klien agar konsisten).
  @override
  Future<List<CheckpointModel>> getActiveCheckpoints() async {
    final List<CheckpointModel> all = await getAllCheckpoints();
    return all.where((CheckpointModel item) => item.isActive).toList();
  }

  /// Ambil checkpoint terdekat dari posisi user (client-side, sama seperti remote).
  @override
  Future<List<CheckpointModel>> getNearbyCheckpoints({
    required double latitude,
    required double longitude,
    bool onlyWithinRadius = true,
  }) async {
    final List<CheckpointModel> all = await getActiveCheckpoints();
    final List<({CheckpointModel checkpoint, int distanceMeters})>
        withDistance = <({CheckpointModel checkpoint, int distanceMeters})>[];
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
    return withDistance.map((item) => item.checkpoint).toList(growable: false);
  }

  /// Ambil satu checkpoint berdasarkan id, atau null bila tidak ada.
  @override
  Future<CheckpointModel?> getCheckpointById(String id) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/checkpoints/$id',
        options: await _authOptions(),
      );
      return CheckpointModel.fromJson(_asMap(response));
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      _logAndRethrow('getCheckpointById', error, stackTrace);
    }
  }

  /// Ambil satu checkpoint berdasarkan kode QR (difilter di klien).
  @override
  Future<CheckpointModel?> getCheckpointByQrCode(String qrCode) async {
    final List<CheckpointModel> all = await getAllCheckpoints();
    for (final CheckpointModel item in all) {
      if (item.qrCode == qrCode) {
        return item;
      }
    }
    return _singleOrNull(const <Map<String, dynamic>>[]);
  }

  /// Tambah checkpoint baru (admin).
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
        '/checkpoints',
        data: <String, dynamic>{
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
          if (maxUses != null) 'max_uses': maxUses,
        },
        options: await _authOptions(),
      );
      return CheckpointModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('createCheckpoint', error, stackTrace);
    }
  }

  /// Ubah checkpoint (admin).
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
      final Response<dynamic> response = await _dio.put(
        '/checkpoints/$id',
        data: <String, dynamic>{
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
          if (maxUses != null) 'max_uses': maxUses,
        },
        options: await _authOptions(),
      );
      return CheckpointModel.fromJson(_asMap(response));
    } catch (error, stackTrace) {
      _logAndRethrow('updateCheckpoint', error, stackTrace);
    }
  }

  /// Hapus checkpoint (admin).
  @override
  Future<void> deleteCheckpoint(String id) async {
    try {
      await _dio.delete(
        '/checkpoints/$id',
        options: await _authOptions(),
      );
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

  /// Nonaktifkan checkpoint (soft-delete via update).
  @override
  Future<void> deactivateCheckpoint(String id) async {
    try {
      await _dio.put(
        '/checkpoints/$id',
        data: <String, dynamic>{'is_active': false},
        options: await _authOptions(),
      );
    } catch (error, stackTrace) {
      _logAndRethrow('deactivateCheckpoint', error, stackTrace);
    }
  }

  /// Aktifkan kembali checkpoint.
  @override
  Future<void> activateCheckpoint(String id) async {
    try {
      await _dio.put(
        '/checkpoints/$id',
        data: <String, dynamic>{'is_active': true},
        options: await _authOptions(),
      );
    } catch (error, stackTrace) {
      _logAndRethrow('activateCheckpoint', error, stackTrace);
    }
  }
}
