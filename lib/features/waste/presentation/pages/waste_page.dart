// Halaman buang sampah (waste) Go Green.
//
// Checkpoint dimuat dari Supabase via checkpointNotifierProvider dengan
// fallback demo saat backend tidak tersedia. Blokir radius GPS sementara
// dimatikan via AppValues.enforceGpsRadius agar uji device bisa submit
// dari mana saja; jarak tetap ditampilkan di kartu status.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/geo_utils.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/display_widgets.dart';
import '../../../admin/presentation/providers/admin_providers.dart';
import '../../../checkpoints/domain/entities/checkpoint.dart';
import '../../../checkpoints/presentation/providers/checkpoint_provider.dart';
import '../data/capture_extra.dart';
import '../data/checkpoint_demo_data.dart';
import '../widgets/category_chip.dart';
import '../widgets/location_status_card.dart';

/// Checkpoint fallback saat Supabase belum tersedia (mode demo/test).
List<Checkpoint> _fallbackCheckpoints() {
  final DateTime now = DateTime.now();
  return <Checkpoint>[
    for (int i = 0; i < demoCheckpoints.length; i++)
      Checkpoint(
        id: 'demo-${i + 1}',
        name: demoCheckpoints[i].name,
        address: demoCheckpoints[i].address,
        latitude: demoCheckpoints[i].latitude,
        longitude: demoCheckpoints[i].longitude,
        radius: 100,
        createdAt: now,
      ),
  ];
}

/// Label Bahasa Indonesia untuk kategori sampah.
String _categoryLabel(WasteCategory category) {
  return switch (category) {
    WasteCategory.organik => AppStrings.wasteCategoryOrganik,
    WasteCategory.anorganik => AppStrings.wasteCategoryAnorganik,
    WasteCategory.daurUlang => AppStrings.wasteCategoryDaurUlang,
    WasteCategory.b3 => AppStrings.wasteCategoryB3,
  };
}

/// Halaman buang sampah ke checkpoint Go Green.
class WastePage extends ConsumerStatefulWidget {
  /// Membuat halaman buang sampah.
  const WastePage({super.key});

  @override
  ConsumerState<WastePage> createState() => _WastePageState();
}

class _WastePageState extends ConsumerState<WastePage> {
  String? _selectedCheckpointId;
  WasteCategory _selectedCategory = WasteCategory.organik;
  Position? _position;
  bool _loadingPosition = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    setState(() => _loadingPosition = true);
    // Lokasi uji admin (debug) diutamakan agar penguji bisa pindah lokasi
    // tanpa ke lapangan; fallback ke GPS asli bila tidak aktif.
    final DebugLocation? debug = ref.read(debugLocationProvider);
    if (debug != null) {
      if (!mounted) return;
      setState(() => _loadingPosition = false);
      await ref.read(checkpointNotifierProvider.notifier).loadNearby(
            latitude: debug.latitude,
            longitude: debug.longitude,
          );
      return;
    }
    const LocationService locationService = LocationService();
    Position? position;
    try {
      position = await locationService
          .getCurrentPosition()
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      position = null;
    }
    if (!mounted) return;
    setState(() {
      _position = position;
      _loadingPosition = false;
    });
    final CheckpointNotifier notifier =
        ref.read(checkpointNotifierProvider.notifier);
    if (position == null) {
      await notifier.loadAll();
    } else {
      await notifier.loadNearby(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }
  }

  List<Checkpoint> _effectiveCheckpoints(
    AsyncValue<List<Checkpoint>> state,
  ) {
    final List<Checkpoint>? data = state.valueOrNull;
    if (data != null && data.isNotEmpty) return data;
    return _fallbackCheckpoints();
  }

  Checkpoint? _selectedCheckpoint(List<Checkpoint> checkpoints) {
    final String? selectedId = _selectedCheckpointId;
    if (checkpoints.isEmpty) return null;
    if (selectedId == null) return checkpoints.first;
    for (final Checkpoint item in checkpoints) {
      if (item.id == selectedId) return item;
    }
    return checkpoints.first;
  }

  void _takePhoto(Checkpoint? checkpoint, DebugLocation? debug) {
    if (checkpoint == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.wasteCheckpointEmpty)),
        );
      return;
    }
    final Position? position = _position;
    final double? overrideLat = debug?.latitude;
    final double? overrideLng = debug?.longitude;
    final double? checkLat = overrideLat ?? position?.latitude;
    final double? checkLng = overrideLng ?? position?.longitude;
    if (AppValues.enforceGpsRadius && checkLat != null && checkLng != null) {
      final int distance = GeoUtils.distanceMeters(
        checkLat,
        checkLng,
        checkpoint.latitude,
        checkpoint.longitude,
      );
      if (distance > checkpoint.radius) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text(AppStrings.wasteGpsOutOfRadius)),
          );
        return;
      }
    }
    context.pushNamed(
      AppRouteName.capture,
      extra: CaptureExtra(
        checkpointId: checkpoint.id,
        checkpointName: checkpoint.name,
        latitude: checkpoint.latitude,
        longitude: checkpoint.longitude,
        radius: checkpoint.radius,
        category: _selectedCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Checkpoint>> checkpointState =
        ref.watch(checkpointNotifierProvider);
    final List<Checkpoint> checkpoints =
        _effectiveCheckpoints(checkpointState);
    final Checkpoint? selected = _selectedCheckpoint(checkpoints);
    final DebugLocation? debug = ref.watch(debugLocationProvider);
    final bool isLoading =
        checkpointState.isLoading || _loadingPosition;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            const Text(
              AppStrings.wasteTitle,
              style: AppTypography.headlineLg,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              AppStrings.wasteCheckpointTitle,
              style: AppTypography.headlineSm,
            ),
            const SizedBox(height: AppSpacing.md),
            if (isLoading) ...<Widget>[
              const Center(child: LoadingIndicator()),
              const SizedBox(height: AppSpacing.md),
            ],
            if (checkpointState.hasError) ...<Widget>[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        AppStrings.wasteCheckpointError,
                        style: AppTypography.bodySm,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppTextButton(
                      text: AppStrings.retryButton,
                      onPressed: _reload,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (checkpoints.isEmpty) ...<Widget>[
              const Text(
                AppStrings.wasteCheckpointEmpty,
                style: AppTypography.bodySm,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            for (final Checkpoint checkpoint in checkpoints) ...<Widget>[
              ListTileItem(
                title: checkpoint.name,
                subtitle: checkpoint.address ??
                    '${checkpoint.latitude.toStringAsFixed(4)}, '
                        '${checkpoint.longitude.toStringAsFixed(4)}',
                icon: LucideIcons.map_pin,
                trailing: selected?.id == checkpoint.id
                    ? const Icon(
                        LucideIcons.check,
                        size: 20,
                        color: AppColors.primary,
                      )
                    : null,
                onTap: () =>
                    setState(() => _selectedCheckpointId = checkpoint.id),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (debug != null && selected != null)
              _DebugLocationBanner(debug: debug, onClear: _reload),
            _GpsSection(
              position: _position,
              loading: _loadingPosition,
              checkpoint: selected,
              onRetry: _reload,
              debug: debug,
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => context.pushNamed(AppRouteName.scan),
                icon: const Icon(
                  LucideIcons.qr_code,
                  size: 18,
                  color: AppColors.primary,
                ),
                label: const Text(AppStrings.wasteScanHint),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              AppStrings.wasteCategoryTitle,
              style: AppTypography.headlineSm,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                for (final WasteCategory category in WasteCategory.values)
                  CategoryChip(
                    label: _categoryLabel(category),
                    selected: _selectedCategory == category,
                    onTap: () =>
                        setState(() => _selectedCategory = category),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: AppStrings.takePhotoButton,
              onPressed: () => _takePhoto(selected, debug),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              AppStrings.gpsDisclaimerHint,
              style: AppTypography.bodySm,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Banner penanda lokasi uji aktif (debug) di halaman Waste.
class _DebugLocationBanner extends StatelessWidget {
  /// Membuat banner lokasi uji.
  const _DebugLocationBanner({required this.debug, required this.onClear});

  /// Lokasi uji yang aktif.
  final DebugLocation debug;

  /// Aksi muat ulang (sekaligus refresh setelah lokasi uji dimatikan).
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.tertiaryLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            LucideIcons.locate_fixed,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '${AppStrings.adminTestLocationActive}: ${debug.label}',
              style: AppTypography.bodySm,
            ),
          ),
          AppTextButton(
            text: AppStrings.adminTestLocationCleared,
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}

/// Section status GPS: loading, gagal, atau kartu radius real.
class _GpsSection extends StatelessWidget {
  const _GpsSection({
    required this.position,
    required this.loading,
    required this.checkpoint,
    required this.onRetry,
    this.debug,
  });

  final Position? position;
  final bool loading;
  final Checkpoint? checkpoint;
  final VoidCallback onRetry;

  /// Lokasi uji admin; bila ada, jarak dihitung dari titik ini.
  final DebugLocation? debug;

  @override
  Widget build(BuildContext context) {
    final DebugLocation? override = debug;
    final Checkpoint? target = checkpoint;
    if (override != null && target != null) {
      final int distance = GeoUtils.distanceMeters(
        override.latitude,
        override.longitude,
        target.latitude,
        target.longitude,
      );
      return LocationStatusCard(
        withinRadius: distance <= target.radius,
        distanceMeters: distance.toDouble(),
        radiusMeters: target.radius.toDouble(),
        onCheckLocation: onRetry,
      );
    }
    if (loading) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Row(
          children: <Widget>[
            LoadingIndicator(),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                AppStrings.loading,
                style: AppTypography.bodySm,
              ),
            ),
          ],
        ),
      );
    }
    final Position? current = position;
    final Checkpoint? fallbackTarget = checkpoint;
    if (current == null || fallbackTarget == null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                AppStrings.wastePositionFailed,
                style: AppTypography.bodySm,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppTextButton(
              text: AppStrings.retryButton,
              onPressed: onRetry,
            ),
          ],
        ),
      );
    }
    final int distance = GeoUtils.distanceMeters(
      current.latitude,
      current.longitude,
      fallbackTarget.latitude,
      fallbackTarget.longitude,
    );
    return LocationStatusCard(
      withinRadius: distance <= fallbackTarget.radius,
      distanceMeters: distance.toDouble(),
      radiusMeters: fallbackTarget.radius.toDouble(),
      onCheckLocation: onRetry,
    );
  }
}
