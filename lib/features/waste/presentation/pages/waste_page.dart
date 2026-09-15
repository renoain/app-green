// Halaman buang sampah (waste) Go Green.
//
// Pemilihan checkpoint, status GPS radius, dan tombol ambil foto.
// Kamera in-app, timestamp server, dan hash SHA-256 menunggu layer data
// dan pengujian di device fisik.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/display_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../data/checkpoint_demo_data.dart';

/// Halaman buang sampah ke checkpoint Go Green.
class WastePage extends StatefulWidget {
  /// Membuat halaman buang sampah.
  const WastePage({super.key});

  @override
  State<WastePage> createState() => _WastePageState();
}

class _WastePageState extends State<WastePage> {
  int _selectedCheckpoint = 0;

  void _takePhoto() {
    context.pushNamed(AppRouteName.capture);
  }

  @override
  Widget build(BuildContext context) {
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
            for (int index = 0; index < demoCheckpoints.length; index++) ...<Widget>[
              ListTileItem(
                title: demoCheckpoints[index].name,
                subtitle: demoCheckpoints[index].address,
                icon: LucideIcons.map_pin,
                trailing: index == _selectedCheckpoint
                    ? const Icon(
                        LucideIcons.check,
                        size: 20,
                        color: AppColors.primary,
                      )
                    : null,
                onTap: () => setState(() => _selectedCheckpoint = index),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.lg),
            const _GpsStatusCard(),
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
            PrimaryButton(
              text: AppStrings.takePhotoButton,
              onPressed: _takePhoto,
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

/// Kartu status GPS dalam radius checkpoint.
class _GpsStatusCard extends StatelessWidget {
  const _GpsStatusCard();

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
              color: AppColors.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.shield_check,
              size: 20,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(AppStrings.wasteGpsTitle, style: AppTypography.labelLg),
                SizedBox(height: AppSpacing.xs),
                Text(AppStrings.wasteGpsInRadius, style: AppTypography.bodySm),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const StatusChip(
            label: AppStrings.activityStatusSuccess,
            type: StatusType.success,
          ),
        ],
      ),
    );
  }
}