// Halaman daftar verifikasi waste untuk admin/petugas (presentation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../../../waste/domain/entities/waste_log.dart';
import '../providers/admin_providers.dart';
import '../providers/admin_waste_provider.dart';
import '../widgets/waste_verification_card.dart';

/// Halaman antrean verifikasi: list pending + filter waktu.
class AdminWasteVerificationPage extends ConsumerStatefulWidget {
  /// Membuat halaman antrean verifikasi admin.
  const AdminWasteVerificationPage({super.key});

  @override
  ConsumerState<AdminWasteVerificationPage> createState() =>
      _AdminWasteVerificationPageState();
}

class _AdminWasteVerificationPageState
    extends ConsumerState<AdminWasteVerificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminWasteListProvider.notifier).loadPending();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<WasteLog>> state =
        ref.watch(adminWasteListProvider);
    final AdminWasteFilter filter = ref.watch(adminWasteFilterProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.adminVerifyWaste,
        leading: LucideIcons.menu,
        onLeadingTap: () => ref
            .read(adminScaffoldKeyProvider)
            .currentState
            ?.openDrawer(),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              children: AdminWasteFilter.values.map((AdminWasteFilter value) {
                final String label = switch (value) {
                  AdminWasteFilter.today => AppStrings.adminFilterToday,
                  AdminWasteFilter.week => AppStrings.adminFilterWeek,
                  AdminWasteFilter.all => AppStrings.adminFilterAll,
                };
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: filter == value,
                    onSelected: (_) => ref
                        .read(adminWasteFilterProvider.notifier)
                        .state = value,
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: LoadingIndicator()),
              error: (_, __) => AppErrorState(
                message: AppStrings.genericError,
                onRetry: () => ref
                    .read(adminWasteListProvider.notifier)
                    .loadPending(),
              ),
              data: (_) {
                final List<WasteLog> items = ref
                    .read(adminWasteListProvider.notifier)
                    .filtered(filter);
                if (items.isEmpty) {
                  return const EmptyState(
                    icon: LucideIcons.shield_check,
                    title: AppStrings.adminVerificationEmpty,
                    message: AppStrings.adminVerificationEmpty,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (BuildContext context, int index) {
                    final WasteLog log = items[index];
                    return WasteVerificationCard(
                      log: log,
                      onTap: () => context.pushNamed(
                        AppRouteName.adminWasteDetail,
                        pathParameters: <String, String>{'id': log.id},
                        extra: log,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
