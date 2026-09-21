// Unit test matcher wilayah dari koordinat (ResolveRegionFromCoordinatesUsecase).

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/features/regions/domain/entities/region.dart';
import 'package:go_green/features/regions/domain/repositories/region_repository.dart';
import 'package:go_green/features/regions/domain/usecases/resolve_region_usecase.dart';

/// Fake repository wilayah dengan data Surabaya + Jakarta tetap.
class _FakeRegionRepository implements RegionRepository {
  _FakeRegionRepository(this.address);

  final Map<String, String> address;

  @override
  Future<List<RegionProvince>> getProvinces() async =>
      const <RegionProvince>[
        RegionProvince(id: '35', name: 'JAWA TIMUR'),
        RegionProvince(id: '31', name: 'DKI JAKARTA'),
      ];

  @override
  Future<List<RegionCity>> getCities(String provinceId) async {
    if (provinceId == '31') {
      return const <RegionCity>[
        RegionCity(id: '3173', name: 'KOTA ADM. JAKARTA PUSAT'),
      ];
    }
    return const <RegionCity>[RegionCity(id: '3578', name: 'KOTA SURABAYA')];
  }

  @override
  Future<List<RegionDistrict>> getDistricts(String cityId) async {
    if (cityId == '3173') {
      return const <RegionDistrict>[
        RegionDistrict(id: '3173010', name: 'GAMBIR'),
        RegionDistrict(id: '3173020', name: 'TANAH ABANG'),
      ];
    }
    return const <RegionDistrict>[
      RegionDistrict(id: '3578010', name: 'GAYUNGAN'),
      RegionDistrict(id: '3578020', name: 'WONOCOLO'),
    ];
  }

  @override
  Future<Map<String, String>> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async =>
      address;
}

void main() {
  group('ResolveRegionFromCoordinatesUsecase.normalize', () {
    test('membuang awalan KOTA dan kapital', () {
      expect(
        ResolveRegionFromCoordinatesUsecase.normalize('Kota Surabaya'),
        'SURABAYA',
      );
    });

    test('membuang awalan KECAMATAN', () {
      expect(
        ResolveRegionFromCoordinatesUsecase.normalize('Kecamatan Ketintang'),
        'KETINTANG',
      );
    });

    test('alias DKI dan awalan ADM ganda', () {
      expect(
        ResolveRegionFromCoordinatesUsecase.normalize(
          'Daerah Khusus Ibukota Jakarta',
        ),
        'DKI JAKARTA',
      );
      expect(
        ResolveRegionFromCoordinatesUsecase.normalize(
          'Daerah Istimewa Yogyakarta',
        ),
        'DI YOGYAKARTA',
      );
      expect(
        ResolveRegionFromCoordinatesUsecase.normalize(
          'KOTA ADM. JAKARTA PUSAT',
        ),
        'JAKARTA PUSAT',
      );
    });
  });

  group('ResolveRegionFromCoordinatesUsecase.match', () {
    final List<RegionProvince> provinces = <RegionProvince>[
      const RegionProvince(id: '35', name: 'JAWA TIMUR'),
      const RegionProvince(id: '32', name: 'JAWA BARAT'),
    ];
    final List<RegionCity> cities = <RegionCity>[
      const RegionCity(id: '3578', name: 'KOTA SURABAYA'),
      const RegionCity(id: '3573', name: 'KOTA MALANG'),
    ];
    final List<RegionDistrict> districts = <RegionDistrict>[
      const RegionDistrict(id: '3578010', name: 'GAYUNGAN'),
      const RegionDistrict(id: '3578020', name: 'WONOCOLO'),
    ];

    test('cocok persis tanpa peduli kapital/awalan', () {
      expect(
        ResolveRegionFromCoordinatesUsecase.matchProvince(
          provinces,
          'Jawa Timur',
        )?.id,
        '35',
      );
      expect(
        ResolveRegionFromCoordinatesUsecase.matchCity(
          cities,
          <String?>[null, 'Surabaya'],
        )?.id,
        '3578',
      );
      expect(
        ResolveRegionFromCoordinatesUsecase.matchDistrict(
          districts,
          <String?>['Wonocolo'],
        )?.id,
        '3578020',
      );
    });

    test('tidak cocok mengembalikan null', () {
      expect(
        ResolveRegionFromCoordinatesUsecase.matchProvince(
          provinces,
          'Bali',
        ),
        isNull,
      );
      expect(
        ResolveRegionFromCoordinatesUsecase.matchCity(
          cities,
          <String?>['Jakarta'],
        ),
        isNull,
      );
    });
  });

  group('ResolveRegionFromCoordinatesUsecase.detail', () {
    test('kelurahan diambil dari village', () {
      expect(
        ResolveRegionFromCoordinatesUsecase.pickSubdistrict(
          <String, String>{'village': 'Ketintang', 'suburb': 'Gayungan'},
          'Gayungan',
        ),
        'Ketintang',
      );
    });

    test('neighbourhood dipakai walau sama dengan kecamatan', () {
      expect(
        ResolveRegionFromCoordinatesUsecase.pickSubdistrict(
          <String, String>{'neighbourhood': 'Gambir', 'suburb': 'Gambir'},
          'Gambir',
        ),
        'Gambir',
      );
    });

    test('suburb dilewati bila sama dengan kecamatan', () {
      expect(
        ResolveRegionFromCoordinatesUsecase.pickSubdistrict(
          <String, String>{'suburb': 'Gayungan'},
          'Gayungan',
        ),
        isNull,
      );
    });

    test('alamat lengkap dari display_name', () {
      expect(
        ResolveRegionFromCoordinatesUsecase.pickFullAddress(
          <String, String>{'display_name': 'Jl. A, Gayungan, Surabaya'},
        ),
        'Jl. A, Gayungan, Surabaya',
      );
      expect(
        ResolveRegionFromCoordinatesUsecase.pickFullAddress(
          <String, String>{},
        ),
        isNull,
      );
    });

    test('resolveDetails mengisi wilayah + kelurahan + alamat', () async {
      final ResolveRegionFromCoordinatesUsecase usecase =
          ResolveRegionFromCoordinatesUsecase(
        _FakeRegionRepository(<String, String>{
          'state': 'Jawa Timur',
          'city': 'Surabaya',
          'municipality': 'Gayungan',
          'village': 'Ketintang',
          'display_name': 'Ketintang, Gayungan, Surabaya, Jawa Timur',
        }),
      );
      final ResolvedLocation? result = await usecase.resolveDetails(
        latitude: -7.33,
        longitude: 112.71,
      );
      expect(result, isNotNull);
      expect(result!.selection.province?.id, '35');
      expect(result.selection.city?.id, '3578');
      expect(result.selection.district?.id, '3578010');
      expect(result.subdistrict, 'Ketintang');
      expect(result.fullAddress, contains('Surabaya'));
    });

    test('kecamatan dari municipality (Nominatim Surabaya)', () async {
      final ResolveRegionFromCoordinatesUsecase usecase =
          ResolveRegionFromCoordinatesUsecase(
        _FakeRegionRepository(<String, String>{
          'neighbourhood': 'RW 05',
          'village': 'Ketintang',
          'municipality': 'Gayungan',
          'city': 'Surabaya',
          'state': 'Jawa Timur',
          'display_name': 'RW 05, Ketintang, Gayungan, Surabaya',
        }),
      );
      final ResolvedLocation? result = await usecase.resolveDetails(
        latitude: -7.327,
        longitude: 112.727,
      );
      expect(result?.selection.district?.id, '3578010');
      expect(result?.subdistrict, 'Ketintang');
    });

    test('tanpa state: provinsi + kota dari city/city_district', () async {
      final ResolveRegionFromCoordinatesUsecase usecase =
          ResolveRegionFromCoordinatesUsecase(
        _FakeRegionRepository(<String, String>{
          'road': 'Jalan Medan Merdeka Utara',
          'neighbourhood': 'Gambir',
          'suburb': 'Gambir',
          'city_district': 'Jakarta Pusat',
          'city': 'Daerah Khusus Ibukota Jakarta',
          'display_name': 'Jalan Medan Merdeka Utara, Gambir, Jakarta Pusat',
        }),
      );
      final ResolvedLocation? result = await usecase.resolveDetails(
        latitude: -6.1754,
        longitude: 106.8272,
      );
      expect(result, isNotNull);
      expect(result!.selection.province?.id, '31');
      expect(result.selection.city?.id, '3173');
      expect(result.selection.district?.id, '3173010');
      expect(result.subdistrict, 'Gambir');
    });

    test('resolveDetails null bila reverse kosong', () async {
      final ResolveRegionFromCoordinatesUsecase usecase =
          ResolveRegionFromCoordinatesUsecase(
        _FakeRegionRepository(<String, String>{}),
      );
      expect(
        await usecase.resolveDetails(latitude: 0, longitude: 0),
        isNull,
      );
    });
  });
}
