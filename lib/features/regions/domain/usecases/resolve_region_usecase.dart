// Use case resolve wilayah dari koordinat (domain).
//
// Dipakai form TPS: usai admin menekan lokasi saya atau mengetuk peta,
// koordinat di-reverse-geocode (Nominatim) lalu dicocokkan ke daftar
// wilayah sehingga dropdown terisi otomatis dan kode TPS bisa
// digenerate. Murni Dart kecuali fetch, mudah diuji via matcher statis.

import '../entities/region.dart';
import '../repositories/region_repository.dart';

/// Use case mencocokkan koordinat ke wilayah Indonesia.
class ResolveRegionFromCoordinatesUsecase {
  /// Membuat use case.
  const ResolveRegionFromCoordinatesUsecase(this._repository);

  final RegionRepository _repository;

  /// Resolve [latitude]/[longitude] menjadi pilihan wilayah.
  ///
  /// Mengembalikan null bila tidak ada yang cocok (mis. offline).
  Future<RegionSelection?> resolve({
    required double latitude,
    required double longitude,
  }) async {
    final Map<String, String> address = await _repository.reverseGeocode(
      latitude: latitude,
      longitude: longitude,
    );
    if (address.isEmpty) return null;
    final List<RegionProvince> provinces = await _repository.getProvinces();
    final RegionProvince? province =
        matchProvince(provinces, address['state']);
    if (province == null) return null;
    final List<RegionCity> cities =
        await _repository.getCities(province.id);
    final RegionCity? city = matchCity(
      cities,
      <String?>[address['city'], address['municipality'], address['county']],
    );
    if (city == null) {
      return (province: province, city: null, district: null);
    }
    final List<RegionDistrict> districts =
        await _repository.getDistricts(city.id);
    final RegionDistrict? district = matchDistrict(
      districts,
      <String?>[
        address['city_district'],
        address['suburb'],
        address['town'],
        address['village'],
      ],
    );
    return (province: province, city: city, district: district);
  }

  /// Normalisasi nama untuk pencocokan (huruf besar, tanpa awalan umum).
  static String normalize(String value) {
    String clean = value.toUpperCase().trim();
    for (final String prefix in <String>[
      'PROVINSI ',
      'KOTA ADMINISTRASI ',
      'KABUPATEN ADMINISTRASI ',
      'KOTA ',
      'KABUPATEN ',
      'KAB ',
      'KECAMATAN ',
      'KEC ',
      'KELURAHAN ',
      'KEL ',
      'DESA ',
    ]) {
      if (clean.startsWith(prefix)) {
        clean = clean.substring(prefix.length);
        break;
      }
    }
    return clean.replaceAll(RegExp('[^A-Z ]'), '').trim();
  }

  /// Cocokkan [candidate] ke daftar [items] (sama persis atau mengandung).
  static T? _match<T>(
    List<T> items,
    String? candidate,
    String Function(T) text,
  ) {
    final String want = normalize(candidate ?? '');
    if (want.isEmpty) return null;
    for (final T item in items) {
      if (normalize(text(item)) == want) return item;
    }
    for (final T item in items) {
      final String have = normalize(text(item));
      if (have.contains(want) || want.contains(have)) return item;
    }
    return null;
  }

  /// Cocokkan provinsi dari nama state Nominatim.
  static RegionProvince? matchProvince(
    List<RegionProvince> items,
    String? candidate,
  ) =>
      _match<RegionProvince>(items, candidate, (RegionProvince e) => e.name);

  /// Cocokkan kota dari kandidat nama (city/municipality/county).
  static RegionCity? matchCity(
    List<RegionCity> items,
    List<String?> candidates,
  ) {
    for (final String? candidate in candidates) {
      final RegionCity? found =
          _match<RegionCity>(items, candidate, (RegionCity e) => e.name);
      if (found != null) return found;
    }
    return null;
  }

  /// Cocokkan kecamatan dari kandidat nama (city_district/suburb/town).
  static RegionDistrict? matchDistrict(
    List<RegionDistrict> items,
    List<String?> candidates,
  ) {
    for (final String? candidate in candidates) {
      final RegionDistrict? found = _match<RegionDistrict>(
        items,
        candidate,
        (RegionDistrict e) => e.name,
      );
      if (found != null) return found;
    }
    return null;
  }
}
