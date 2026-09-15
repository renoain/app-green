// Halaman scan QR checkpoint Go Green.
//
// Viewfinder diperlihatkan; deteksi QR memakai mobile_scanner menunggu
// pengujian di device fisik.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';

/// Halaman scan QR checkpoint Go Green.
class ScanPage extends StatelessWidget {
  /// Membuat halaman scan QR.
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.scanTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDim,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: AppColors.primaryLight,
                          width: 2,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            LucideIcons.scan_line,
                            size: 80,
                            color: AppColors.textDisabled,
                          ),
                          SizedBox(height: AppSpacing.lg),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: Text(
                              AppStrings.scanHint,
                              style: AppTypography.bodyLg,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                AppStrings.scanNote,
                style: AppTypography.bodySm,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}