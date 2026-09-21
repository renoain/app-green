// Entity wilayah Indonesia (domain).
//
// Nilai id mengikuti API wilayah Indonesia (emsifa) agar tersimpan
// konsisten di kolom province_code/city_code/district_code checkpoints.

/// Provinsi.
class RegionProvince {
  /// Membuat provinsi.
  const RegionProvince({required this.id, required this.name});

  /// ID provinsi (mis. 35 untuk Jawa Timur).
  final String id;

  /// Nama provinsi.
  final String name;
}

/// Kota/kabupaten.
class RegionCity {
  /// Membuat kota/kabupaten.
  const RegionCity({required this.id, required this.name});

  /// ID kota/kabupaten (mis. 3578 untuk Kota Surabaya).
  final String id;

  /// Nama kota/kabupaten.
  final String name;
}

/// Kecamatan.
class RegionDistrict {
  /// Membuat kecamatan.
  const RegionDistrict({required this.id, required this.name});

  /// ID kecamatan.
  final String id;

  /// Nama kecamatan.
  final String name;
}

/// Pilihan wilayah terpilih (null berarti belum pilih/semua).
typedef RegionSelection = ({
  RegionProvince? province,
  RegionCity? city,
  RegionDistrict? district,
});
