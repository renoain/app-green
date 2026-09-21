// Halaman dasbor admin Go Green.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/display_widgets.dart';
import '../../domain/entities/admin_dashboard_summary.dart';
import '../providers/admin_dashboard_provider.dart';
import '../providers/admin_providers.dart';

/// Dasbor admin: ringkasan angka + aksi cepat.
class AdminDashboardPage extends ConsumerWidget {
  /// Membuat halaman dasbor admin.
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AdminDashboardSummary> summary =
        ref.watch(adminDashboardProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.adminDashboard,
        leading: LucideIcons.menu,
        onLeadingTap: () => ref
            .read(adminScaffoldKeyProvider)
            .currentState
            ?.openDrawer(),
      ),
      body: summary.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (_, __) => AppErrorState(
          message: AppStrings.genericError,
          onRetry: () => ref.refresh(adminDashboardProvider),
        ),
        data: (AdminDashboardSummary value) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(adminDashboardProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: <Widget>[
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  children: <Widget>[
                    StatItem(
                      value: formatIndonesianNumber(value.totalUsers),
                      label: AppStrings.adminTotalUsers,
                      icon: LucideIcons.users,
                    ),
                    StatItem(
                      value: formatIndonesianNumber(value.totalCheckpoints),
                      label: AppStrings.adminTotalTps,
                      icon: LucideIcons.map_pin,
                    ),
                    StatItem(
                      value: formatIndonesianNumber(value.wasteToday),
                      label: AppStrings.adminWasteToday,
                      icon: LucideIcons.trash,
                    ),
                    StatItem(
                      value: formatIndonesianNumber(value.wastePending),
                      label: AppStrings.adminWastePending,
                      icon: LucideIcons.shield_check,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        LucideIcons.coins,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Expanded(
                        child: Text(
                          AppStrings.adminPointsCirculating,
                          style: AppTypography.labelLg,
                        ),
                      ),
                      Text(
                        formatIndonesianNumber(value.totalPoints),
                        style: AppTypography.headlineSm,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: () => context.pushNamed(
                    AppRouteName.adminCheckpointNew,
                  ),
                  icon: const Icon(LucideIcons.plus, size: 18),
                  label: const Text(AppStrings.adminAddTps),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed(
                    AppRouteName.adminWasteVerification,
                  ),
                  icon: const Icon(LucideIcons.shield_check, size: 18),
                  label: Text(
                    '${AppStrings.adminViewPending} '
                    '(${value.wastePending})',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
