// Provider wilayah Indonesia (presentation).
//
// Dropdown berjenjang: provinsi -> kota -> kecamatan. Repository
// di-inject agar mudah di-fake di test/widget.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/region_repository_impl.dart';
import '../../domain/entities/region.dart';
import '../../domain/repositories/region_repository.dart';
import '../../domain/usecases/resolve_region_usecase.dart';

/// Provider repository wilayah.
final Provider<RegionRepository> regionRepositoryProvider =
    Provider<RegionRepository>(
  (Ref ref) => RegionRepositoryImpl(),
);

/// Provider use case resolve wilayah dari koordinat.
final Provider<ResolveRegionFromCoordinatesUsecase>
    resolveRegionUsecaseProvider =
    Provider<ResolveRegionFromCoordinatesUsecase>(
  (Ref ref) => ResolveRegionFromCoordinatesUsecase(
    ref.watch(regionRepositoryProvider),
  ),
);

/// Daftar provinsi (cache di datasource).
final FutureProvider<List<RegionProvince>> regionProvincesProvider =
    FutureProvider<List<RegionProvince>>(
  (Ref ref) => ref.watch(regionRepositoryProvider).getProvinces(),
);

/// Daftar kota/kabupaten untuk [provinceId].
final FutureProviderFamily<List<RegionCity>, String> regionCitiesProvider =
    FutureProviderFamily<List<RegionCity>, String>(
  (Ref ref, String provinceId) =>
      ref.watch(regionRepositoryProvider).getCities(provinceId),
);

/// Daftar kecamatan untuk [cityId].
final FutureProviderFamily<List<RegionDistrict>, String>
    regionDistrictsProvider =
    FutureProviderFamily<List<RegionDistrict>, String>(
  (Ref ref, String cityId) =>
      ref.watch(regionRepositoryProvider).getDistricts(cityId),
);
