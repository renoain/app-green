// Komponen card sesuai docs/COMPONENT_LIBRARY.md (Card).
// Dikelompokkan dalam satu file: InfoCard, PointCard, ArticleCard,
// ActivityCard, RewardCard.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/formatters.dart';
import 'status_widgets.dart';

/// Kerangka card latar putih dengan border, shadow, dan ripple.
class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppElevation.level1,
      ),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Kartu aksi di Home (Buang Sampah, Lihat Poin).
class InfoCard extends StatelessWidget {
  /// Membuat kartu informasi dengan aksi.
  const InfoCard({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.onTap,
  });

  /// Judul kartu.
  final String title;

  /// Deskripsi singkat.
  final String? subtitle;

  /// Ikon utama.
  final IconData icon;

  /// Aksi saat kartu ditekan.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.tertiaryLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, size: 24, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: AppTypography.labelLg),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySm,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(
            LucideIcons.chevron_right,
            size: 20,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

/// Kartu saldo poin dengan latar primary (Home dan Profile).
class PointCard extends StatelessWidget {
  /// Membuat kartu total poin.
  const PointCard({
    super.key,
    required this.point,
    required this.label,
    required this.icon,
  });

  /// Total poin.
  final int point;

  /// Label nilai poin.
  final String label;

  /// Ikon poin.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppElevation.level1,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textOnPrimary.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 28,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  formatIndonesianNumber(point),
                  style: AppTypography.headlineXl.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu artikel (Home dan daftar Artikel).
class ArticleCard extends StatelessWidget {
  /// Membuat kartu artikel.
  const ArticleCard({
    super.key,
    required this.title,
    required this.date,
    this.excerpt,
    this.onTap,
    this.thumbnailImage,
  });

  /// Judul artikel.
  final String title;

  /// Tanggal terbit.
  final DateTime date;

  /// Ringkasan artikel.
  final String? excerpt;

  /// Aksi saat kartu ditekan.
  final VoidCallback? onTap;

  /// Path asset thumbnail gambar (opsional). Jika diisi, thumbnail
  /// ditampilkan sebagai gambar; jika null, fallback ke ikon placeholder.
  final String? thumbnailImage;

  @override
  Widget build(BuildContext context) {
    final Widget thumbnail = thumbnailImage != null
        ? Image.asset(
            thumbnailImage!,
            width: 88,
            height: 88,
            fit: BoxFit.cover,
          )
        : Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.tertiaryLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              LucideIcons.book_open,
              size: 28,
              color: AppColors.primary,
            ),
          );

    return _SurfaceCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: thumbnail,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: AppTypography.labelLg,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (excerpt != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    excerpt!,
                    style: AppTypography.bodySm,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: <Widget>[
                    const Icon(
                      LucideIcons.calendar,
                      size: 14,
                      color: AppColors.textDisabled,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      formatIndonesianDate(date),
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu riwayat aktivitas (Aktivitas dan Riwayat Poin).
class ActivityCard extends StatelessWidget {
  /// Membuat kartu aktivitas.
  const ActivityCard({
    super.key,
    required this.date,
    required this.description,
    required this.point,
    this.status = StatusType.success,
    this.onTap,
  });

  /// Tanggal aktivitas.
  final DateTime date;

  /// Deskripsi aktivitas.
  final String description;

  /// Jumlah poin (boleh negatif).
  final int point;

  /// Status verifikasi aktivitas.
  final StatusType status;

  /// Aksi saat kartu ditekan.
  final VoidCallback? onTap;

  String get _statusLabel {
    if (status == StatusType.success) {
      return AppStrings.activityStatusSuccess;
    }
    return AppStrings.activityStatusPending;
  }

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = status == StatusType.success;
    return _SurfaceCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.tertiaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? LucideIcons.check : LucideIcons.clock,
              size: 20,
              color: isSuccess ? AppColors.success : AppColors.warning,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  description,
                  style: AppTypography.labelMd,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: <Widget>[
                    const Icon(
                      LucideIcons.calendar,
                      size: 14,
                      color: AppColors.textDisabled,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      formatIndonesianDate(date),
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '${point >= 0 ? '+' : ''}${formatIndonesianNumber(point)}',
                style: AppTypography.labelLg.copyWith(
                  color: isSuccess ? AppColors.success : AppColors.warning,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              StatusChip(label: _statusLabel, type: status),
            ],
          ),
        ],
      ),
    );
  }
}

/// Kartu reward yang bisa ditukar poin (Poin & Reward).
class RewardCard extends StatelessWidget {
  /// Membuat kartu reward.
  const RewardCard({
    super.key,
    required this.title,
    required this.description,
    required this.pointCost,
    required this.icon,
    this.onTap,
  });

  /// Nama reward.
  final String title;

  /// Deskripsi reward.
  final String description;

  /// Harga reward dalam poin.
  final int pointCost;

  /// Ikon reward.
  final IconData icon;

  /// Aksi saat kartu ditekan.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.tertiaryLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, size: 28, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: AppTypography.labelLg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodySm,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  LucideIcons.star,
                  size: 12,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${formatIndonesianNumber(pointCost)} ${AppStrings.rewardPointSuffix}',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}