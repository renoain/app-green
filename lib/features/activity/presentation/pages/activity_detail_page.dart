// Halaman detail aktivitas Go Green.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../data/activity_demo_data.dart';

/// Halaman detail satu aktivitas pembuangan sampah.
class ActivityDetailPage extends StatelessWidget {
  /// Membuat halaman detail aktivitas.
  const ActivityDetailPage({super.key, this.activityId = '1'});

  /// Identitas aktivitas yang dibuka.
  final String activityId;

  @override
  Widget build(BuildContext context) {
    ActivityDemo? found;
    for (final ActivityDemo demo in demoActivities) {
      if (demo.id == activityId) {
        found = demo;
        break;
      }
    }
    final ActivityDemo activity = found ?? demoActivities.first;

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.activityDetailTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            _StatusHeader(activity: activity),
            const SizedBox(height: AppSpacing.lg),
            Text(activity.description, style: AppTypography.headlineMd),
            const SizedBox(height: AppSpacing.xl),
            _DetailRow(
              icon: LucideIcons.calendar,
              label: AppStrings.activityDetailDateLabel,
              value: formatIndonesianDate(activity.date),
            ),
            const SizedBox(height: AppSpacing.sm),
            _DetailRow(
              icon: LucideIcons.map_pin,
              label: AppStrings.activityDetailCheckpointLabel,
              value: activity.checkpoint,
            ),
            const SizedBox(height: AppSpacing.sm),
            _DetailRow(
              icon: LucideIcons.coins,
              label: AppStrings.activityDetailPointLabel,
              value: '${activity.point > 0 ? '+' : ''}'
                  '${formatIndonesianNumber(activity.point)} '
                  '${AppStrings.rewardPointSuffix}',
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

/// Header status aktivitas pada halaman detail.
class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.activity});

  final ActivityDemo activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity.icon,
              size: 28,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Text(
              AppStrings.activityStatusTitle,
              style: AppTypography.labelLg,
            ),
          ),
          StatusChip(
            label: activity.status == StatusType.success
                ? AppStrings.activityStatusSuccess
                : AppStrings.activityStatusPending,
            type: activity.status,
          ),
        ],
      ),
    );
  }
}

/// Baris detail bernilai tunggal pada halaman detail aktivitas.
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.tertiaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(label, style: AppTypography.labelLg),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.bodyMd,
            ),
          ),
        ],
      ),
    );
  }
}