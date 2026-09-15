// Halaman splash: layar pembuka dengan logo, nama aplikasi, dan indikator
// loading. Setelah jeda singkat, berpindah ke Onboarding.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../core/constants/app_strings.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_bar_and_loading_widgets.dart';

/// Halaman splash Go Green.
class SplashPage extends StatefulWidget {
  /// Membuat halaman splash.
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.goNamed(AppRouteName.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _SplashLogo(),
            SizedBox(height: AppSpacing.md),
            Text(AppStrings.appName, style: AppTypography.headlineXl),
            SizedBox(height: AppSpacing.xl),
            LoadingIndicator(size: 24),
          ],
        ),
      ),
    );
  }
}

/// Logo splash sementara (placeholder sampai asset SVG tersedia).
class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl2),
      ),
      child: const Icon(
        LucideIcons.leaf,
        size: 48,
        color: AppColors.primary,
      ),
    );
  }
}