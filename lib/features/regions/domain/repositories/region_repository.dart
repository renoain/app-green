// Interface repository wilayah (domain).
//
// Implementasi mengambil dari API wilayah Indonesia via dio yang sudah
// ada (tanpa dependency wilayah baru). Hasil di-cache di memory oleh
// datasource.

import '../entities/region.dart';

/// Kontrak repository wilayah Indonesia.
abstract interface class RegionRepository {
  /// Daftar semua provinsi.
  Future<List<RegionProvince>> getProvinces();

  /// Daftar kota/kabupaten dalam satu provinsi.
  Future<List<RegionCity>> getCities(String provinceId);

  /// Daftar kecamatan dalam satu kota/kabupaten.
  Future<List<RegionDistrict>> getDistricts(String cityId);

  /// Alamat reverse-geocode untuk koordinat (best effort, bisa kosong).
  Future<Map<String, String>> reverseGeocode({
    required double latitude,
    required double longitude,
  });
}
