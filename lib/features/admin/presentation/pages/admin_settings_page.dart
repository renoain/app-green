// Halaman placeholder admin fase 2 (presentation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../providers/admin_providers.dart';

/// Halaman pengaturan admin (fase 2, placeholder).
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
      body: const Center(
        child: EmptyState(
          icon: LucideIcons.settings,
          title: AppStrings.adminSettings,
          message: AppStrings.adminComingSoon,
        ),
      ),
    );
  }
}
