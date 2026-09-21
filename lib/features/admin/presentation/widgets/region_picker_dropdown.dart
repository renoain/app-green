// Dropdown wilayah berjenjang untuk form/filter TPS (presentation).
//
// Provinsi -> Kota/Kabupaten -> Kecamatan memakai DropdownSearch
// dengan kotak cari. Data dari region_providers (API wilayah via dio).
// Logic generate kode TPS tetap di domain (GenerateTpsCodeUsecase).

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../regions/domain/entities/region.dart';
import '../../../regions/domain/repositories/region_repository.dart';
import '../../../regions/presentation/providers/region_provider.dart';

/// Dropdown pemilih wilayah berjenjang.
class RegionPickerDropdown extends ConsumerStatefulWidget {
  /// Membuat pemilih wilayah.
  const RegionPickerDropdown({
    super.key,
    this.initialProvinceCode,
    this.initialCityCode,
    this.initialDistrictCode,
    this.onChanged,
  });

  /// Kode provinsi awal (mode ubah).
  final String? initialProvinceCode;

  /// Kode kota awal (mode ubah).
  final String? initialCityCode;

  /// Kode kecamatan awal (mode ubah).
  final String? initialDistrictCode;

  /// Callback tiap pilihan berubah.
  final ValueChanged<RegionSelection>? onChanged;

  @override
  ConsumerState<RegionPickerDropdown> createState() =>
      _RegionPickerDropdownState();
}

class _RegionPickerDropdownState
    extends ConsumerState<RegionPickerDropdown> {
  RegionProvince? _province;
  RegionCity? _city;
  RegionDistrict? _district;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolveInitial());
  }

  Future<void> _resolveInitial() async {
    if (_resolved || !mounted) return;
    try {
      final RegionRepository repository = ref.read(regionRepositoryProvider);
      if (widget.initialProvinceCode != null &&
          widget.initialProvinceCode!.isNotEmpty) {
        final List<RegionProvince> provinces =
            await repository.getProvinces();
        for (final RegionProvince item in provinces) {
          if (item.id == widget.initialProvinceCode) _province = item;
        }
      }
      if (_province != null &&
          widget.initialCityCode != null &&
          widget.initialCityCode!.isNotEmpty) {
        final List<RegionCity> cities =
            await repository.getCities(_province!.id);
        for (final RegionCity item in cities) {
          if (item.id == widget.initialCityCode) _city = item;
        }
      }
      if (_city != null &&
          widget.initialDistrictCode != null &&
          widget.initialDistrictCode!.isNotEmpty) {
        final List<RegionDistrict> districts =
            await repository.getDistricts(_city!.id);
        for (final RegionDistrict item in districts) {
          if (item.id == widget.initialDistrictCode) _district = item;
        }
      }
    } finally {
      _resolved = true;
      if (mounted) {
        setState(() {});
        widget.onChanged?.call(
          (province: _province, city: _city, district: _district),
        );
      }
    }
  }

  void _emit() {
    widget.onChanged?.call(
      (province: _province, city: _city, district: _district),
    );
  }

  String _titleCase(String value) {
    if (value.isEmpty) return value;
    return value
        .toLowerCase()
        .split(' ')
        .map(
          (String word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  List<T> _filter<T>(List<T> items, String filter, String Function(T) text) {
    final String keyword = filter.trim().toLowerCase();
    if (keyword.isEmpty) return items;
    return items
        .where((T item) => text(item).toLowerCase().contains(keyword))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<RegionProvince>> provinces =
        ref.watch(regionProvincesProvider);
    final AsyncValue<List<RegionCity>> cities = _province == null
        ? const AsyncData(<RegionCity>[])
        : ref.watch(regionCitiesProvider(_province!.id));
    final AsyncValue<List<RegionDistrict>> districts = _city == null
        ? const AsyncData(<RegionDistrict>[])
        : ref.watch(regionDistrictsProvider(_city!.id));

    return Column(
      children: <Widget>[
        provinces.when(
          loading: () => const _RegionLoading(
            label: AppStrings.adminRegionProvinceLabel,
          ),
          error: (_, __) => const _RegionError(
            label: AppStrings.adminRegionProvinceLabel,
          ),
          data: (List<RegionProvince> items) => DropdownSearch<RegionProvince>(
            selectedItem: _province,
            items: (String filter, _) => _filter<RegionProvince>(
              items,
              filter,
              (RegionProvince item) => item.name,
            ),
            itemAsString: (RegionProvince item) => _titleCase(item.name),
            compareFn: (RegionProvince a, RegionProvince b) => a.id == b.id,
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: AppStrings.adminRegionProvinceLabel,
              ),
            ),
            popupProps: const PopupProps.menu(showSearchBox: true),
            onSelected: (RegionProvince? value) => setState(() {
              _province = value;
              _city = null;
              _district = null;
              _emit();
            }),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        cities.when(
          loading: () => const _RegionLoading(
            label: AppStrings.adminRegionCityLabel,
          ),
          error: (_, __) => const _RegionError(
            label: AppStrings.adminRegionCityLabel,
          ),
          data: (List<RegionCity> items) => DropdownSearch<RegionCity>(
            selectedItem: _city,
            enabled: _province != null,
            items: (String filter, _) => _filter<RegionCity>(
              items,
              filter,
              (RegionCity item) => item.name,
            ),
            itemAsString: (RegionCity item) => _titleCase(item.name),
            compareFn: (RegionCity a, RegionCity b) => a.id == b.id,
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: AppStrings.adminRegionCityLabel,
              ),
            ),
            popupProps: const PopupProps.menu(showSearchBox: true),
            onSelected: (RegionCity? value) => setState(() {
              _city = value;
              _district = null;
              _emit();
            }),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        districts.when(
          loading: () => const _RegionLoading(
            label: AppStrings.adminRegionDistrictLabel,
          ),
          error: (_, __) => const _RegionError(
            label: AppStrings.adminRegionDistrictLabel,
          ),
          data: (List<RegionDistrict> items) =>
              DropdownSearch<RegionDistrict>(
            selectedItem: _district,
            enabled: _city != null,
            items: (String filter, _) => _filter<RegionDistrict>(
              items,
              filter,
              (RegionDistrict item) => item.name,
            ),
            itemAsString: (RegionDistrict item) => _titleCase(item.name),
            compareFn: (RegionDistrict a, RegionDistrict b) => a.id == b.id,
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: AppStrings.adminRegionDistrictLabel,
              ),
            ),
            popupProps: const PopupProps.menu(showSearchBox: true),
            onSelected: (RegionDistrict? value) => setState(() {
              _district = value;
              _emit();
            }),
          ),
        ),
      ],
    );
  }
}

/// Placeholder loading dropdown wilayah.
class _RegionLoading extends StatelessWidget {
  /// Membuat placeholder loading.
  const _RegionLoading({required this.label});

  /// Label dropdown.
  final String label;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: const LinearProgressIndicator(),
    );
  }
}

/// Placeholder gagal muat dropdown wilayah.
class _RegionError extends StatelessWidget {
  /// Membuat placeholder error.
  const _RegionError({required this.label});

  /// Label dropdown.
  final String label;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        errorText: AppStrings.genericError,
      ),
      child: const SizedBox.shrink(),
    );
  }
}
