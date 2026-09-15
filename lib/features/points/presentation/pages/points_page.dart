// Halaman poin dan reward Go Green.
//
// Menampilkan saldo poin, daftar reward, dan riwayat poin.
// Data masih placeholder sampai layer data terpasang.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../data/reward_demo_data.dart';

/// Tanggal riwayat poin demo pertama.
final DateTime _demoHistoryDate1 = DateTime(2026, 9, 11);

/// Tanggal riwayat poin demo kedua.
final DateTime _demoHistoryDate2 = DateTime(2026, 9, 9);

/// Halaman poin dan reward Go Green.
class PointsPage extends StatelessWidget {
  /// Membuat halaman poin.
  const PointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            const Text(
              AppStrings.pointsTitle,
              style: AppTypography.headlineLg,
            ),
            const SizedBox(height: AppSpacing.lg),
            const PointCard(
              point: 250,
              label: AppStrings.pointsBalance,
              icon: LucideIcons.coins,
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              AppStrings.rewardsSectionTitle,
              style: AppTypography.headlineSm,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final RewardDemo reward in demoRewards) ...<Widget>[
              RewardCard(
                title: reward.title,
                description: reward.description,
                pointCost: reward.pointCost,
                icon: reward.icon,
                onTap: () => context.goNamed(
                  AppRouteName.rewardDetail,
                  pathParameters: <String, String>{'id': reward.id},
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            const SizedBox(height: AppSpacing.lg),
            const Text(
              AppStrings.pointsHistoryTitle,
              style: AppTypography.headlineSm,
            ),
            const SizedBox(height: AppSpacing.md),
            ActivityCard(
              date: _demoHistoryDate1,
              description: AppStrings.activityDemoDesc1,
              point: 25,
              status: StatusType.success,
            ),
            const SizedBox(height: AppSpacing.md),
            ActivityCard(
              date: _demoHistoryDate2,
              description: AppStrings.activityDemoDesc2,
              point: 40,
              status: StatusType.success,
            ),
          ],
        ),
      ),
    );
  }
}