// Halaman profil pengguna Go Green.
//
// Menampilkan identitas, statistik, dan menu pengguna tergantung status
// login:
// - Belum login: notice login (Masuk/Daftar) + Pengaturan; tanpa Keluar,
//   tanpa Edit Profil.
// - Sudah login: identitas user, Edit Profil, Pengaturan, dan Keluar.
//
// Statistik data masih placeholder sampai layer data terpasang.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_elevation.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display_widgets.dart';
import '../../../../core/widgets/login_notice_widget.dart';
import '../../../admin/presentation/providers/admin_providers.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Halaman profil Go Green.
class ProfilePage extends ConsumerWidget {
  /// Membuat halaman profil.
  const ProfilePage({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(authRepositoryProvider).signOut();
    if (!context.mounted) {
      return;
    }
    context.goNamed(AppRouteName.home);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthSession auth = ref.watch(authNotifierProvider);
    final bool isLoggedIn = auth.isLoggedIn;
    final bool isAdmin =
        ref.watch(isAdminProvider).maybeWhen(
              data: (bool allowed) => allowed,
              orElse: () => false,
            );
    final String displayName = isLoggedIn
        ? (auth.displayName ??
            auth.username ??
            auth.userEmail?.split('@').first ??
            AppStrings.guestName)
        : AppStrings.guestName;
    final String subtitle = isLoggedIn
        ? (auth.userEmail ?? AppStrings.profileDemoEmail)
        : AppStrings.profileDemoEmail;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            const Text(
              AppStrings.profileTitle,
              style: AppTypography.headlineLg,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Avatar(name: displayName, size: 60),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        displayName,
                        style: AppTypography.headlineMd,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        style: AppTypography.bodySm,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: AppElevation.level1,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: StatItem(
                      value: formatIndonesianNumber(250),
                      label: AppStrings.profileStatsPoints,
                      icon: LucideIcons.coins,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.borderLight,
                  ),
                  Expanded(
                    child: StatItem(
                      value: formatIndonesianNumber(12),
                      label: AppStrings.profileStatsWaste,
                      icon: LucideIcons.trash,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (!isLoggedIn) ...<Widget>[
              LoginNoticeCard(
                message: AppStrings.profileLoginNotice,
                onLogin: () => context.pushNamed(AppRouteName.login),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (isLoggedIn) ...<Widget>[
              ListTileItem(
                title: AppStrings.editProfile,
                icon: LucideIcons.pencil,
                onTap: () => context.pushNamed(AppRouteName.editProfile),
              ),
              const SizedBox(height: AppSpacing.sm),
              ListTileItem(
                title: AppStrings.voucherTitle,
                icon: LucideIcons.ticket,
                onTap: () => context.pushNamed(AppRouteName.vouchers),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            ListTileItem(
              title: AppStrings.settings,
              icon: LucideIcons.settings,
              onTap: () => context.pushNamed(AppRouteName.settings),
            ),
            if (isLoggedIn && isAdmin) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              ListTileItem(
                title: AppStrings.adminMode,
                icon: LucideIcons.shield_check,
                onTap: () =>
                    context.goNamed(AppRouteName.adminDashboard),
              ),
            ],
            if (isLoggedIn) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              ListTileItem(
                title: AppStrings.logout,
                icon: LucideIcons.log_out,
                onTap: () => _handleLogout(context, ref),
              ),
            ],
          ],
        ),
      ),
    );
  }
}