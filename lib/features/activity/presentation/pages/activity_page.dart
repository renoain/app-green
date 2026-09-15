// Halaman riwayat aktivitas Go Green.
//
// Menampilkan histori buang sampah beserta status verifikasi.
// Data masih placeholder sampai layer data terpasang.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../data/activity_demo_data.dart';

/// Halaman riwayat aktivitas Go Green.
class ActivityPage extends StatelessWidget {
  /// Membuat halaman aktivitas.
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            const Text(
              AppStrings.activityTitle,
              style: AppTypography.headlineLg,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final ActivityDemo activity in demoActivities) ...<Widget>[
              ActivityCard(
                date: activity.date,
                description: activity.description,
                point: activity.point,
                status: activity.status,
                onTap: () => context.pushNamed(
                  AppRouteName.activityDetail,
                  pathParameters: <String, String>{'id': activity.id},
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}