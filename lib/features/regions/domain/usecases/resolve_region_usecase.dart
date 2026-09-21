// Use case resolve wilayah dari koordinat (domain).
//
// Dipakai form TPS: usai admin menekan lokasi saya atau memindahkan pin,
// koordinat di-reverse-geocode (Nominatim) lalu dicocokkan ke daftar
// wilayah sehingga dropdown + kelurahan + alamat + kode TPS terisi
// otomatis. Murni Dart kecuali fetch, mudah diuji via matcher statis.

import '../entities/region.dart';
import '../repositories/region_repository.dart';

/// Hasil resolve lokasi: pilihan wilayah + kelurahan + alamat lengkap.
class ResolvedLocation {
  /// Membuat hasil resolve lokasi.
  const ResolvedLocation({
    required this.selection,
    this.subdistrict,
    this.fullAddress,
  });

  /// Pilihan wilayah berjenjang (provinsi/kota/kecamatan).
  final RegionSelection selection;

  /// Nama kelurahan dari reverse-geocode (teks bebas, bisa null).
  final String? subdistrict;

  /// Alamat lengkap display_name Nominatim (bisa null).
  final String? fullAddress;
}

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
    final ResolvedLocation? details =
        await resolveDetails(latitude: latitude, longitude: longitude);
    return details?.selection;
  }

  /// Resolve lengkap: wilayah + kelurahan + alamat.
  ///
  /// Mengembalikan null bila reverse-geocode gagal total (mis. offline).
  Future<ResolvedLocation?> resolveDetails({
    required double latitude,
    required double longitude,
  }) async {
    final Map<String, String> address = await _repository.reverseGeocode(
      latitude: latitude,
      longitude: longitude,
    );
    if (address.isEmpty) return null;
    final List<RegionProvince> provinces = await _repository.getProvinces();
    final RegionProvince? province = matchProvince(
      provinces,
      address['state'],
    ) ?? matchProvince(provinces, address['city']);
    if (province == null) return null;
    final List<RegionCity> cities =
        await _repository.getCities(province.id);
    final RegionCity? city = matchCity(
      cities,
      <String?>[
        address['city'],
        address['town'],
        address['city_district'],
        address['county'],
        address['regency'],
        address['state_district'],
      ],
    );
    if (city == null) {
      return ResolvedLocation(
        selection: (province: province, city: null, district: null),
        subdistrict: pickSubdistrict(address, null),
        fullAddress: pickFullAddress(address),
      );
    }
    final List<RegionDistrict> districts =
        await _repository.getDistricts(city.id);
    final RegionDistrict? district = matchDistrict(
      districts,
      <String?>[
        address['district'],
        address['municipality'],
        address['borough'],
        address['suburb'],
        address['quarter'],
        address['city_district'],
        address['town'],
        address['village'],
      ],
    );
    return ResolvedLocation(
      selection: (province: province, city: city, district: district),
      subdistrict: pickSubdistrict(address, district?.name),
      fullAddress: pickFullAddress(address),
    );
  }

  /// Normalisasi nama untuk pencocokan (huruf besar, tanpa awalan umum).
  static String normalize(String value) {
    String clean = value.toUpperCase().trim().replaceAll('.', '');
    const Map<String, String> aliases = <String, String>{
      'DAERAH KHUSUS IBUKOTA ': 'DKI ',
      'DAERAH ISTIMEWA ': 'DI ',
    };
    for (final MapEntry<String, String> alias in aliases.entries) {
      if (clean.startsWith(alias.key)) {
        clean = alias.value + clean.substring(alias.key.length);
        break;
      }
    }
    bool stripped = true;
    while (stripped) {
      stripped = false;
      for (final String prefix in <String>[
        'PROVINSI ',
        'KOTA ADMINISTRASI ',
        'KOTA ADM ',
        'KABUPATEN ADMINISTRASI ',
        'KABUPATEN ADM ',
        'KOTA ',
        'KABUPATEN ',
        'KAB ',
        'ADM ',
        'ADMINISTRASI ',
        'KECAMATAN ',
        'KEC ',
        'KELURAHAN ',
        'KEL ',
        'DESA ',
      ]) {
        if (clean.startsWith(prefix)) {
          clean = clean.substring(prefix.length);
          stripped = true;
          break;
        }
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

  /// Ambil nama kelurahan dari peta address Nominatim.
  ///
  /// Kunci selevel kelurahan (village/dst) dipakai apa adanya; kunci
  /// ambigu [suburb] dilewati bila sama dengan [districtName] agar
  /// kelurahan tidak terisi nama kecamatan. Null bila tak ada.
  static String? pickSubdistrict(
    Map<String, String> address,
    String? districtName,
  ) {
    const List<String> villageKeys = <String>[
      'village',
      'hamlet',
      'neighbourhood',
      'quarter',
      'residential',
    ];
    for (final String key in villageKeys) {
      final String? raw = address[key];
      if (raw != null && raw.trim().isNotEmpty) return raw.trim();
    }
    final String? suburb = address['suburb'];
    if (suburb == null || suburb.trim().isEmpty) return null;
    final String districtNorm = normalize(districtName ?? '');
    if (districtNorm.isNotEmpty && normalize(suburb) == districtNorm) {
      return null;
    }
    return suburb.trim();
  }

  /// Ambil alamat lengkap display_name Nominatim (null bila kosong).
  static String? pickFullAddress(Map<String, String> address) {
    final String? raw = address['display_name'];
    if (raw == null || raw.trim().isEmpty) return null;
    return raw.trim();
  }
}
