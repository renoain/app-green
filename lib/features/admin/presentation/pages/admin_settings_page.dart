// Halaman pengaturan admin (info real, ubah nilai fase 2).
//
// Menampilkan nilai konfigurasi aktif dari AppValues; ubah nilai dari
// aplikasi menyusul di fase 2.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../providers/admin_providers.dart';

/// Halaman pengaturan admin.
class AdminSettingsPage extends ConsumerWidget {
  /// Membuat halaman pengaturan admin.
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.adminSettings,
        leading: LucideIcons.menu,
        onLeadingTap: () => ref.read(adminDrawerOpenerProvider)?.call(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {},
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              const Text(
                AppStrings.adminSettingsAppTitle,
                style: AppTypography.headlineSm,
              ),
              const SizedBox(height: AppSpacing.sm),
              const InfoCard(
                title: 'Go Green 0.1.0',
                subtitle: 'MVP pengelolaan sampah + poin + reward.',
                icon: LucideIcons.leaf,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                AppStrings.adminSettingsSecurityTitle,
                style: AppTypography.headlineSm,
              ),
              const SizedBox(height: AppSpacing.sm),
              InfoCard(
                title:
                    'Radius GPS ${AppValues.gpsRadiusMeters.toInt()} m',
                subtitle:
                    'Penegakan radius: ${AppValues.enforceGpsRadius ? 'aktif' : 'nonaktif'}; hash SHA-256 + timestamp server.',
                icon: LucideIcons.shield_check,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                AppStrings.adminSettingsMissionTitle,
                style: AppTypography.headlineSm,
              ),
              const SizedBox(height: AppSpacing.sm),
              const InfoCard(
                title:
                    'Target ${AppValues.weeklyMissionTargetDisposals} kali/minggu',
                subtitle:
                    'Batas ${AppValues.maxWasteLogsPerDay} setoran/hari; foto maks 5 MB.',
                icon: LucideIcons.activity,
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDim,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: const Text(
                  AppStrings.adminSettingsPhaseNote,
                  style: AppTypography.bodySm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
