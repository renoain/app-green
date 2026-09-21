// Data source wilayah Indonesia via API publik (data layer).
//
// Memakai dio yang sudah ada; tanpa dependency wilayah baru. Respons
// di-cache di memory agar dropdown berjenjang tidak fetch berulang.

import 'package:dio/dio.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/region.dart';

/// Data source wilayah Indonesia (emsifa/api-wilayah-indonesia).
class RegionRemoteDatasource {
  /// Membuat data source. [dio] bisa di-inject untuk test.
  RegionRemoteDatasource({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

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
  /// Mengembalikan peta address (state, city, suburb, ...) atau kosong
  /// bila gagal. Tanpa API key; dibatasi pemakaian wajar admin.
  Future<Map<String, String>> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: <String, dynamic>{
          'format': 'json',
          'lat': latitude,
          'lon': longitude,
          'accept-language': 'id',
        },
        options: Options(headers: <String, String>{'User-Agent': 'GoGreen/0.1.0'}),
      );
      final dynamic data = response.data;
      if (data is Map<String, dynamic> && data['address'] is Map) {
        final Map<dynamic, dynamic> address =
            data['address'] as Map<dynamic, dynamic>;
        return address.map(
          (dynamic key, dynamic value) =>
              MapEntry<String, String>('$key', '$value'),
        );
      }
      return <String, String>{};
    } catch (error, stackTrace) {
      AppLogger.error('Gagal reverse geocode', error, stackTrace);
      return <String, String>{};
    }
  }

  Future<List<Map<String, dynamic>>> _fetchList(String url) async {    try {
      final Response<dynamic> response = await _dio.get<dynamic>(url);
      final dynamic data = response.data;
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().toList();
      }
      return <Map<String, dynamic>>[];
    } catch (error, stackTrace) {
      AppLogger.error('Gagal memuat wilayah', error, stackTrace);
      return <Map<String, dynamic>>[];
    }
  }
}
