// Halaman verifikasi bukti pembuangan sampah Go Green.
//
// Menampilkan preview foto + timestamp + lokasi, pilihan kategori
// sampah (dipilih setelah foto), lalu mengirim bukti via
// WasteSubmitNotifier (hash SHA-256, validasi radius/duplikat/rate
// limit, upload, insert waste_logs). Sukses menampilkan popup poin
// animasi. Timestamp server tercatat di database saat insert (kolom
// server_timestamp default now()).

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../../../checkpoints/domain/entities/checkpoint.dart';
import '../../../checkpoints/presentation/providers/checkpoint_provider.dart';
import '../../../waste/domain/usecases/submit_waste_usecase.dart';
import '../../../waste/presentation/providers/waste_provider.dart';
import '../../../waste/presentation/widgets/category_chip.dart';
import '../data/verification_extra.dart';
import '../widgets/points_earned_dialog.dart';

/// Label Bahasa Indonesia untuk kategori sampah.
String _categoryLabel(WasteCategory category) {
  return switch (category) {
    WasteCategory.organik => AppStrings.wasteCategoryOrganik,
    WasteCategory.anorganik => AppStrings.wasteCategoryAnorganik,
    WasteCategory.daurUlang => AppStrings.wasteCategoryDaurUlang,
    WasteCategory.b3 => AppStrings.wasteCategoryB3,
  };
}

/// Halaman verifikasi foto bukti Go Green.
class VerificationPage extends ConsumerStatefulWidget {
  /// Membuat halaman verifikasi.
  const VerificationPage({super.key, this.extra});

  /// Data ekstra dari halaman kamera (lokasi GPS dan path foto).
  final VerificationExtra? extra;

  @override
  ConsumerState<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  WasteCategory _selectedCategory = WasteCategory.organik;

  @override
  void initState() {
    super.initState();
    final WasteCategory? initial = widget.extra?.category;
    if (initial != null) _selectedCategory = initial;
  }

  void _showHash(BuildContext context, String hash) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(AppStrings.verificationHashLabel),
        content: SelectableText(hash),
        actions: <Widget>[
          AppTextButton(
            text: AppStrings.backButton,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final VerificationExtra? extra = widget.extra;
    final String? imagePath = extra?.imagePath;
    if (imagePath == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.genericError)),
        );
      return;
    }
    final String? checkpointId = extra?.checkpointId;
    if (checkpointId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.wasteCheckpointEmpty)),
        );
      return;
    }
    final double? latitude = extra?.latitude;
    final double? longitude = extra?.longitude;
    if (latitude == null || longitude == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(AppStrings.verificationLocationFailed),
          ),
        );
      return;
    }
    final String? userId = SupabaseService.instance.currentUser?.id;
    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.wasteNeedLogin)),
        );
      context.pushNamed(AppRouteName.login);
      return;
    }

    Checkpoint? checkpoint;
    try {
      checkpoint = await ref
          .read(checkpointRepositoryProvider)
          .getCheckpointById(checkpointId);
    } catch (_) {
      checkpoint = null;
    }
    checkpoint ??= Checkpoint(
      id: checkpointId,
      name: extra?.checkpointName ?? checkpointId,
      latitude: extra?.latitude ?? latitude,
      longitude: extra?.longitude ?? longitude,
      radius: extra?.radius ?? 100,
      createdAt: DateTime.now(),
    );

    Uint8List bytes;
    try {
      bytes = await File(imagePath).readAsBytes();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.genericError)),
        );
      return;
    }

    await ref.read(wasteSubmitNotifierProvider.notifier).submit(
          userId: userId,
          checkpoint: checkpoint,
          category: _selectedCategory,
          photoBytes: bytes,
          latitude: latitude,
          longitude: longitude,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<dynamic>>(
      wasteSubmitNotifierProvider,
      (previous, next) async {
        final Object? value = next.valueOrNull;
        if (value is SubmitWasteResult && previous is AsyncLoading) {
          if (!context.mounted) return;
          await showPointsEarnedDialog(
            context,
            points: value.estimatedPoints,
          );
          if (!context.mounted) return;
          ref.read(wasteSubmitNotifierProvider.notifier).reset();
          context.goNamed(AppRouteName.home);
        }
        next.whenOrNull(
          error: (error, _) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('$error')));
          },
        );
      },
    );
    final VerificationExtra? extra = widget.extra;
    final bool hasExtra = extra != null &&
        (extra.locationLabel != null ||
            extra.imagePath != null ||
            extra.timestampLabel != null);
    final String timestampValue =
        extra?.timestampLabel ?? AppStrings.verificationTimestampDemo;
    final String locationValue = extra?.locationLabel ??
        (hasExtra
            ? AppStrings.verificationLocationFailed
            : AppStrings.verificationLocationDemo);
    final AsyncValue<dynamic> submitState =
        ref.watch(wasteSubmitNotifierProvider);
    final bool submitting = submitState.isLoading;
    const String hashValue = AppStrings.verificationHashDemo;
    final int estimatedPoints = ref
        .watch(calculatePointsUsecaseProvider)
        .calculate(category: _selectedCategory);

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.verificationTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.check,
                    size: 22,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: Text(
                    AppStrings.verificationSuccess,
                    style: AppTypography.headlineSm,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const StatusChip(
              label: AppStrings.verificationSuccess,
              type: StatusType.success,
            ),
            const SizedBox(height: AppSpacing.md),
            _PhotoPreview(
              imagePath: extra?.imagePath,
              timestampLabel: timestampValue,
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
                    onTap: submitting
                        ? null
                        : () =>
                            setState(() => _selectedCategory = category),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _DetailRow(
              icon: LucideIcons.clock,
              label: AppStrings.verificationTimestampLabel,
              value: timestampValue,
            ),
            _DetailRow(
              icon: LucideIcons.map_pin,
              label: AppStrings.verificationLocationLabel,
              value: locationValue,
            ),
            _DetailRow(
              icon: LucideIcons.coins,
              label: AppStrings.verificationPointsLabel,
              value: '+${formatIndonesianNumber(estimatedPoints)}',
            ),
            const _DetailRow(
              icon: LucideIcons.shield_check,
              label: AppStrings.verificationHashLabel,
              value: AppStrings.verificationHashDemo,
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: AppTextButton(
                text: AppStrings.verificationHashButton,
                onPressed: () => _showHash(context, hashValue),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SecondaryButton(
              text: AppStrings.retryButton,
              onPressed:
                  submitting ? null : () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: AppSpacing.md),
            if (submitting)
              const Center(child: LoadingIndicator())
            else
              PrimaryButton(
                text: AppStrings.verificationSubmitButton,
                onPressed: _submit,
              ),
          ],
        ),
      ),
    );
  }
}

/// Baris detail (label + nilai) di halaman verifikasi.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.tertiaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: AppTypography.bodySm),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: AppTypography.labelMd,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Preview foto bukti dengan overlay timestamp, atau placeholder saat
/// path foto tidak ada.
class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({this.imagePath, required this.timestampLabel});

  final String? imagePath;
  final String timestampLabel;

  @override
  Widget build(BuildContext context) {
    final String? path = imagePath;
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (path == null)
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  LucideIcons.camera,
                  size: 40,
                  color: AppColors.primary,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  AppStrings.verificationTitle,
                  style: AppTypography.bodySm,
                ),
              ],
            )
          else
            Image.file(
              File(path),
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: _imageErrorBuilder,
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              color: Colors.black.withValues(alpha: 0.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    LucideIcons.clock,
                    size: 14,
                    color: AppColors.textOnPrimary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      timestampLabel,
                      textAlign: TextAlign.center,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _imageErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return const Center(
      child: Icon(
        LucideIcons.image,
        size: 40,
        color: AppColors.textSecondary,
      ),
    );
  }
}
