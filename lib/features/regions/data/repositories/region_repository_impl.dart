// Implementasi repository wilayah (data layer).

import '../../domain/entities/region.dart';
import '../../domain/repositories/region_repository.dart';
import '../datasources/region_remote_datasource.dart';

/// Implementasi [RegionRepository] via API wilayah.
class RegionRepositoryImpl implements RegionRepository {
  /// Membuat repository. [remote] bisa di-inject untuk test.
  RegionRepositoryImpl({RegionRemoteDatasource? remote})
      : _remote = remote ?? RegionRemoteDatasource();

  final RegionRemoteDatasource _remote;

  @override
  Future<List<RegionProvince>> getProvinces() => _remote.getProvinces();

  @override
  Future<List<RegionCity>> getCities(String provinceId) =>
      _remote.getCities(provinceId);

  @override
  Future<List<RegionDistrict>> getDistricts(String cityId) =>
      _remote.getDistricts(cityId);

  @override
  Future<Map<String, String>> reverseGeocode({
    required double latitude,
    required double longitude,
  }) =>
      _remote.reverseGeocode(latitude: latitude, longitude: longitude);
}
