// Halaman verifikasi bukti pembuangan sampah Go Green.
//
// Rincian nilai (timestamp, lokasi, hash) masih demo sampai layer data
// dan kamera/GPS terpasang. Lokasi dan path foto bisa dikirim dari halaman
// kamera lewat data ekstra route.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../data/verification_extra.dart';

/// Halaman verifikasi foto bukti Go Green.
class VerificationPage extends StatelessWidget {
  /// Membuat halaman verifikasi.
  const VerificationPage({super.key, this.extra});

  /// Data ekstra dari halaman kamera (lokasi GPS dan path foto).
  final VerificationExtra? extra;

  void _showHash(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(AppStrings.verificationHashLabel),
        content: const SelectableText(AppStrings.verificationHashDemo),
        actions: <Widget>[
          AppTextButton(
            text: AppStrings.backButton,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final VerificationExtra? extra = this.extra;
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
              value:
                  '+${formatIndonesianNumber(AppStrings.verificationPointsDemo)}',
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
                onPressed: () => _showHash(context),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SecondaryButton(
              text: AppStrings.retryButton,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              text: AppStrings.verificationSubmitButton,
              onPressed: () => context.goNamed(AppRouteName.home),
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