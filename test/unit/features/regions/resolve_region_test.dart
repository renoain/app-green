// Unit test matcher wilayah dari koordinat (ResolveRegionFromCoordinatesUsecase).

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/features/regions/domain/entities/region.dart';
import 'package:go_green/features/regions/domain/usecases/resolve_region_usecase.dart';

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
}
