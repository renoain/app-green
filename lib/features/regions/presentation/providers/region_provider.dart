// Provider wilayah Indonesia (presentation).

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

/// Daftar provinsi. Auto-dispose supaya cache provider ikut dibuang saat
/// tidak ada layar yang memakainya.
final AutoDisposeFutureProvider<List<RegionProvince>> regionProvincesProvider =
    AutoDisposeFutureProvider<List<RegionProvince>>(
  (Ref ref) => ref.watch(regionRepositoryProvider).getProvinces(),
);

/// Daftar kota/kabupaten untuk [provinceId].
///
/// Family ini wajib auto-dispose: tanpa itu setiap provinsi yang pernah dibuka
/// akan tersimpan selamanya di memori selama proses berjalan.
final AutoDisposeFutureProviderFamily<List<RegionCity>, String>
    regionCitiesProvider =
    AutoDisposeFutureProviderFamily<List<RegionCity>, String>(
  (Ref ref, String provinceId) =>
      ref.watch(regionRepositoryProvider).getCities(provinceId),
);

/// Daftar kecamatan untuk [cityId]. Auto-dispose, sama seperti daftar kota.
final AutoDisposeFutureProviderFamily<List<RegionDistrict>, String>
    regionDistrictsProvider =
    AutoDisposeFutureProviderFamily<List<RegionDistrict>, String>(
  (Ref ref, String cityId) =>
      ref.watch(regionRepositoryProvider).getDistricts(cityId),
);
