// Halaman form tambah/ubah titik pembuangan (presentation).
//
// Koordinat dari lokasi saya/peta layar penuh otomatis me-resolve
// wilayah (reverse-geocode) sehingga dropdown + kelurahan + alamat +
// kode TPS terisi sendiri. Validasi bisnis di ManageCheckpointUsecase;
// widget hanya menampilkan pesan ramah Bahasa Indonesia.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../checkpoints/domain/entities/checkpoint.dart';
import '../../../checkpoints/domain/usecases/manage_checkpoint_usecase.dart';
import '../../../checkpoints/presentation/providers/checkpoint_provider.dart';
import '../../../regions/domain/entities/region.dart';
import '../../../regions/domain/usecases/resolve_region_usecase.dart';
import '../../../regions/presentation/providers/region_provider.dart';
import '../providers/admin_checkpoint_provider.dart';
import '../providers/admin_providers.dart';
import '../widgets/checkpoint_map_picker.dart';
import '../widgets/location_ready.dart';
import '../widgets/region_picker_dropdown.dart';
import 'admin_map_picker_page.dart';

/// Form tambah/ubah checkpoint admin.
class AdminCheckpointFormPage extends ConsumerStatefulWidget {
  /// Membuat form checkpoint. [checkpoint] null berarti mode tambah.
  const AdminCheckpointFormPage({super.key, this.checkpoint, this.checkpointId});

  /// Checkpoint yang diubah (null untuk tambah baru).
  final Checkpoint? checkpoint;

  /// Id checkpoint untuk mode ubah via deep link (tanpa extra).
  final String? checkpointId;

  @override
  ConsumerState<AdminCheckpointFormPage> createState() =>
      _AdminCheckpointFormPageState();
}

class _AdminCheckpointFormPageState
    extends ConsumerState<AdminCheckpointFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  late final TextEditingController _radiusController;
  late final TextEditingController _codeController;
  late final TextEditingController _subdistrictController;
  RegionSelection _region = (
    province: null,
    city: null,
    district: null,
  );
  bool _generatingCode = false;
  bool _resolvingRegion = false;
  bool _saving = false;
  bool _locating = false;
  bool _loadingExisting = false;
  String? _loadError;
  Checkpoint? _fetched;

  Checkpoint? get _effective => widget.checkpoint ?? _fetched;
  bool get _isEdit =>
      _effective != null ||
      (widget.checkpointId != null && widget.checkpointId!.isNotEmpty);

  // Koordinat default: Monas bila tambah baru.
  static const double _defaultLat = -6.1754;
  static const double _defaultLng = 106.8272;

  @override
  void initState() {
    super.initState();
    final Checkpoint? checkpoint = widget.checkpoint;
    _nameController = TextEditingController(text: checkpoint?.name ?? '');
    _addressController =
        TextEditingController(text: checkpoint?.address ?? '');
    _latController = TextEditingController(
      text: (checkpoint?.latitude ?? _defaultLat).toString(),
    );
    _lngController = TextEditingController(
      text: (checkpoint?.longitude ?? _defaultLng).toString(),
    );
    _radiusController = TextEditingController(
      text: (checkpoint?.radius ?? 100).toString(),
    );
    _codeController = TextEditingController(text: checkpoint?.code ?? '');
    _subdistrictController =
        TextEditingController(text: checkpoint?.subdistrict ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.checkpoint != null) return;
      final String? id = widget.checkpointId;
      if (id != null && id.isNotEmpty) {
        _loadById(id);
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _subdistrictController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  double get _lat =>
      double.tryParse(_latController.text.replaceAll(',', '.')) ??
      _defaultLat;
  double get _lng =>
      double.tryParse(_lngController.text.replaceAll(',', '.')) ??
      _defaultLng;

  void _onMapPick(LatLng point) {
    setState(() {
      _latController.text = point.latitude.toStringAsFixed(6);
      _lngController.text = point.longitude.toStringAsFixed(6);
    });
    _resolveRegion(point.latitude, point.longitude);
  }

  Future<void> _useMyLocation() async {
    if (_locating) return;
    if (!await ensureLocationReady(context)) return;
    setState(() => _locating = true);
    try {
      const LocationService service = LocationService();
      final position = await service.getCurrentPosition();
      if (!mounted) return;
      if (position == null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(AppStrings.verificationLocationFailed),
            ),
          );
        return;
      }
      setState(() {
        _latController.text = position.latitude.toStringAsFixed(6);
        _lngController.text = position.longitude.toStringAsFixed(6);
      });
      _resolveRegion(position.latitude, position.longitude);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _openFullMap() async {
    if (!mounted) return;
    final LatLng? picked = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute<LatLng>(
        builder: (_) => AdminMapPickerPage(
          initialLatitude: _lat,
          initialLongitude: _lng,
        ),
      ),
    );
    if (!mounted || picked == null) return;
    setState(() {
      _latController.text = picked.latitude.toStringAsFixed(6);
      _lngController.text = picked.longitude.toStringAsFixed(6);
    });
    _resolveRegion(picked.latitude, picked.longitude);
  }

  Future<void> _resolveRegion(double latitude, double longitude) async {
    if (_resolvingRegion) return;
    setState(() => _resolvingRegion = true);
    try {
      final ResolvedLocation? resolved = await ref
          .read(resolveRegionUsecaseProvider)
          .resolveDetails(latitude: latitude, longitude: longitude);
      if (!mounted || resolved == null) return;
      setState(() {
        _region = resolved.selection;
        if (resolved.subdistrict != null &&
            resolved.subdistrict!.isNotEmpty) {
          _subdistrictController.text = resolved.subdistrict!;
        }
        if (resolved.fullAddress != null &&
            resolved.fullAddress!.isNotEmpty) {
          _addressController.text = resolved.fullAddress!;
        }
      });
      final RegionCity? city = resolved.selection.city;
      final RegionDistrict? district = resolved.selection.district;
      if (city != null && district != null) {
        await _generateCodeFor(city, district);
      }
    } catch (error, stackTrace) {
      AppLogger.error('Gagal resolve wilayah', error, stackTrace);
    } finally {
      if (mounted) setState(() => _resolvingRegion = false);
    }
  }

  Future<void> _loadById(String id) async {
    setState(() {
      _loadingExisting = true;
      _loadError = null;
    });
    try {
      final Checkpoint? found =
          await ref.read(checkpointRepositoryProvider).getCheckpointById(id);
      if (!mounted) return;
      if (found == null) {
        setState(() => _loadError = AppStrings.genericError);
        return;
      }
      setState(() {
        _fetched = found;
        _nameController.text = found.name;
        _addressController.text = found.address ?? '';
        _latController.text = found.latitude.toString();
        _lngController.text = found.longitude.toString();
        _radiusController.text = found.radius.toString();
        _codeController.text = found.code ?? '';
        _subdistrictController.text = found.subdistrict ?? '';
      });
    } catch (error, stackTrace) {
      AppLogger.error('Gagal memuat checkpoint admin', error, stackTrace);
      if (!mounted) return;
      setState(() => _loadError = AppStrings.genericError);
    } finally {
      if (mounted) setState(() => _loadingExisting = false);
    }
  }

  Future<void> _onRegionChanged(RegionSelection selection) async {
    setState(() => _region = selection);
    final RegionCity? city = selection.city;
    final RegionDistrict? district = selection.district;
    if (city == null || district == null) return;
    if (_codeController.text.trim().isNotEmpty && _isEdit) return;
    await _generateCodeFor(city, district);
  }

  Future<void> _generateCodeFor(
    RegionCity city,
    RegionDistrict district,
  ) async {
    setState(() => _generatingCode = true);
    try {
      final String code = await ref
          .read(generateTpsCodeUsecaseProvider)
          .nextCode(
            cityName: city.name,
            districtName: district.name,
            cityCode: city.id,
            districtCode: district.id,
          );
      if (!mounted) return;
      _codeController.text = code;
    } catch (error, stackTrace) {
      AppLogger.error('Gagal generate kode TPS', error, stackTrace);
    } finally {
      if (mounted) setState(() => _generatingCode = false);
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final notifier = ref.read(adminCheckpointListProvider.notifier);
      final String name = _nameController.text;
      final String? address = _addressController.text.isEmpty
          ? null
          : _addressController.text;
      final double lat = _lat;
      final double lng = _lng;
      final int radius = int.tryParse(_radiusController.text) ?? 0;
      final Checkpoint? existing = _effective;
      final String? qr = existing?.qrCode;
      final String? tpsCode = _codeController.text.trim().isEmpty
          ? null
          : _codeController.text.trim();
      final String? provinceCode = _region.province?.id;
      final String? cityCode = _region.city?.id;
      final String? districtCode = _region.district?.id;
      final String? subdistrict = _subdistrictController.text.trim().isEmpty
          ? null
          : _subdistrictController.text.trim();
      if (existing == null) {
        await notifier.create(
          name: name,
          address: address,
          latitude: lat,
          longitude: lng,
          radius: radius,
          qrCode: qr,
          code: tpsCode,
          provinceCode: provinceCode,
          cityCode: cityCode,
          districtCode: districtCode,
          subdistrict: subdistrict,
        );
      } else {
        await notifier.update(
          id: existing.id,
          name: name,
          address: address,
          latitude: lat,
          longitude: lng,
          radius: radius,
          qrCode: qr,
          code: tpsCode,
          provinceCode: provinceCode,
          cityCode: cityCode,
          districtCode: districtCode,
          subdistrict: subdistrict,
        );
      }
      try {
        await ref.read(checkpointNotifierProvider.notifier).loadAll();
      } catch (error, stackTrace) {
        AppLogger.error('Gagal sinkron daftar user usai simpan TPS', error, stackTrace);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(AppStrings.adminCheckpointSaved),
          ),
        );
      context.pop(true);
    } on CheckpointValidationException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error, stackTrace) {
      AppLogger.error('Gagal menyimpan checkpoint admin', error, stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.genericError)),
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<bool> isAdmin = ref.watch(isAdminProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: _isEdit
            ? AppStrings.adminEditCheckpoint
            : AppStrings.adminAddCheckpoint,
        leading: LucideIcons.arrow_left,
      ),
      body: isAdmin.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (_, __) => const Center(
          child: Text(AppStrings.adminAccessDenied),
        ),
        data: (bool allowed) {
          if (!allowed) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text(AppStrings.adminAccessDenied),
              ),
            );
          }
          if (_loadingExisting) {
            return const Center(child: LoadingIndicator());
          }
          if (_loadError != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(_loadError!, style: AppTypography.bodySm),
                    const SizedBox(height: AppSpacing.sm),
                    PrimaryButton(
                      text: AppStrings.retryButton,
                      onPressed: () {
                        final String? id = widget.checkpointId;
                        if (id != null && id.isNotEmpty) _loadById(id);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              const Text(
                AppStrings.adminMapHint,
                style: AppTypography.bodySm,
              ),
              const SizedBox(height: AppSpacing.sm),
              CheckpointMapPicker(
                latitude: _lat,
                longitude: _lng,
                onPick: _onMapPick,
                onExpand: _openFullMap,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: _locating ? null : _useMyLocation,
                    icon: _locating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(LucideIcons.locate_fixed, size: 16),
                    label: const Text(AppStrings.adminUseMyLocation),
                  ),
                  TextButton.icon(
                    onPressed: _openFullMap,
                    icon: const Icon(LucideIcons.map, size: 16),
                    label: const Text(AppStrings.adminPickOnMap),
                  ),
                ],
              ),
              if (_resolvingRegion)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: LinearProgressIndicator(),
                ),
              RegionPickerDropdown(
                key: ValueKey<String>(
                  '${_effective?.provinceCode}|${_effective?.cityCode}|${_effective?.districtCode}|'
                  '${_region.province?.id}|${_region.city?.id}|${_region.district?.id}',
                ),
                initialProvinceCode: _region.province?.id ??
                    _effective?.provinceCode,
                initialCityCode:
                    _region.city?.id ?? _effective?.cityCode,
                initialDistrictCode:
                    _region.district?.id ?? _effective?.districtCode,
                onChanged: _onRegionChanged,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _codeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppStrings.adminTpsCodeLabel,
                  suffixIcon: _generatingCode
                      ? const Padding(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _subdistrictController,
                decoration: const InputDecoration(
                  labelText: AppStrings.adminSubdistrictLabel,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.adminCheckpointNameLabel,
                  hintText: AppStrings.adminCheckpointNameHint,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: AppStrings.adminCheckpointAddressLabel,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _latController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: AppStrings.adminCheckpointLatLabel,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _lngController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: AppStrings.adminCheckpointLngLabel,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _radiusController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: AppStrings.adminCheckpointRadiusLabel,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_saving)
                const Center(child: LoadingIndicator())
              else
                PrimaryButton(
                  text: AppStrings.saveButton,
                  onPressed: _save,
                ),
            ],
          );
        },
      ),
    );
  }
}
