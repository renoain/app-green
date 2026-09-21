// Data source wilayah Indonesia via API publik (data layer).
//
// Memakai dio yang sudah ada; tanpa dependency wilayah baru. Respons
// di-cache di memory agar dropdown berjenjang tidak fetch berulang.
// GET dibatasi timeout dan diulang untuk galat transien (timeout,
// koneksi, HTTP 5xx seperti 522) agar dropdown tahan terhadap
// gangguan sesaat API statis.

import 'package:dio/dio.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/region.dart';

/// Data source wilayah Indonesia (emsifa/api-wilayah-indonesia).
class RegionRemoteDatasource {
  /// Membuat data source. [dio] bisa di-inject untuk test.
  RegionRemoteDatasource({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  final Dio _dio;

  /// Jumlah percobaan GET untuk daftar wilayah.
  static const int listMaxAttempts = 3;

  /// Jumlah percobaan reverse-geocode (hemat sesuai kebijakan Nominatim).
  static const int reverseMaxAttempts = 2;

  /// Basis URL API wilayah.
  static const String baseUrl =
      'https://emsifa.github.io/api-wilayah-indonesia/api';

  final List<Map<String, dynamic>> _provinceCache = <Map<String, dynamic>>[];
  final Map<String, List<Map<String, dynamic>>> _cityCache =
      <String, List<Map<String, dynamic>>>{};
  final Map<String, List<Map<String, dynamic>>> _districtCache =
      <String, List<Map<String, dynamic>>>{};

  /// Ambil daftar provinsi (sekali fetch, lalu cache).
  Future<List<RegionProvince>> getProvinces() async {
    if (_provinceCache.isEmpty) {
      _provinceCache.addAll(await _fetchList('$baseUrl/provinces.json'));
    }
    return _provinceCache
        .map(
          (Map<String, dynamic> json) => RegionProvince(
            id: '${json['id']}',
            name: '${json['name']}',
          ),
        )
        .toList();
  }

  /// Ambil kota/kabupaten milik [provinceId] (cache per provinsi).
  Future<List<RegionCity>> getCities(String provinceId) async {
    if (!_cityCache.containsKey(provinceId)) {
      _cityCache[provinceId] =
          await _fetchList('$baseUrl/regencies/$provinceId.json');
    }
    return _cityCache[provinceId]!
        .map(
          (Map<String, dynamic> json) => RegionCity(
            id: '${json['id']}',
            name: '${json['name']}',
          ),
        )
        .toList();
  }

  /// Ambil kecamatan milik [cityId] (cache per kota).
  Future<List<RegionDistrict>> getDistricts(String cityId) async {
    if (!_districtCache.containsKey(cityId)) {
      _districtCache[cityId] =
          await _fetchList('$baseUrl/districts/$cityId.json');
    }
    return _districtCache[cityId]!
        .map(
          (Map<String, dynamic> json) => RegionDistrict(
            id: '${json['id']}',
            name: '${json['name']}',
          ),
        )
        .toList();
  }

  /// Alamat hasil reverse-geocode Nominatim untuk [latitude]/[longitude].
  ///
  /// Mengembalikan peta address (state, city, suburb, ...) ditambah kunci
  /// `display_name` berisi alamat lengkap, atau kosong bila gagal.
  /// Tanpa API key; dibatasi pemakaian wajar admin.
  Future<Map<String, String>> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final Response<dynamic>? response = await _getWithRetry(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: <String, dynamic>{
          'format': 'json',
          'lat': latitude,
          'lon': longitude,
          'accept-language': 'id',
          'addressdetails': 1,
        },
        options: Options(headers: <String, String>{'User-Agent': 'GoGreen/0.1.0'}),
        maxAttempts: reverseMaxAttempts,
      );
      final dynamic data = response?.data;
      if (data is Map<String, dynamic>) {
        final Map<String, String> result = <String, String>{};
        if (data['address'] is Map) {
          final Map<dynamic, dynamic> address =
              data['address'] as Map<dynamic, dynamic>;
          address.forEach(
            (dynamic key, dynamic value) =>
                result['$key'] = '$value',
          );
        }
        if (data['display_name'] is String &&
            (data['display_name'] as String).isNotEmpty) {
          result['display_name'] = data['display_name'] as String;
        }
        return result;
      }
      return <String, String>{};
    } catch (_) {
      AppLogger.warning('Gagal reverse geocode (jaringan/server).');
      return <String, String>{};
    }
  }

  Future<List<Map<String, dynamic>>> _fetchList(String url) async {
    try {
      final Response<dynamic>? response = await _getWithRetry(
        url,
        maxAttempts: listMaxAttempts,
      );
      final dynamic data = response?.data;
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().toList();
      }
      return <Map<String, dynamic>>[];
    } catch (_) {
      AppLogger.warning('Gagal memuat wilayah: $url');
      return <Map<String, dynamic>>[];
    }
  }

  /// GET dengan ulang untuk galat transien (timeout/koneksi/HTTP 5xx).
  ///
  /// Galat permanen (HTTP 4xx) langsung dilempar tanpa ulang.
  Future<Response<dynamic>?> _getWithRetry(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required int maxAttempts,
  }) async {
    DioException? lastError;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await _dio.get<dynamic>(
          url,
          queryParameters: queryParameters,
          options: options,
        );
      } on DioException catch (error) {
        lastError = error;
        if (!_isTransient(error) || attempt == maxAttempts) rethrow;
        await Future<void>.delayed(Duration(milliseconds: 400 * attempt));
      }
    }
    throw lastError!;
  }

  /// Galat transien: timeout, koneksi, atau respons HTTP 5xx.
  bool _isTransient(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }
    final int? status = error.response?.statusCode;
    return status != null && status >= 500;
  }
}
