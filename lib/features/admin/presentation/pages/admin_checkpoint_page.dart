// Halaman daftar TPS untuk admin (presentation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../../../checkpoints/domain/entities/checkpoint.dart';
import '../../../checkpoints/presentation/providers/checkpoint_provider.dart';
import '../../../regions/domain/entities/region.dart';
import '../providers/admin_checkpoint_provider.dart';
import '../providers/admin_providers.dart';
import '../widgets/region_picker_dropdown.dart';
import '../widgets/tps_card.dart';

/// Halaman kelola TPS: daftar semua checkpoint + cari + tambah + ubah.
class AdminCheckpointPage extends ConsumerStatefulWidget {
  /// Membuat halaman daftar TPS admin.
  const AdminCheckpointPage({super.key});

  @override
  ConsumerState<AdminCheckpointPage> createState() =>
      _AdminCheckpointPageState();
}

class _AdminCheckpointPageState extends ConsumerState<AdminCheckpointPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminCheckpointListProvider.notifier).loadAll();
    });
  }

  Future<void> _confirmDeactivate(Checkpoint checkpoint) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(AppStrings.adminDeactivateTitle),
        content: Text(checkpoint.name),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.adminDeactivate),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(adminCheckpointListProvider.notifier)
          .deactivate(checkpoint.id);
      try {
        await ref.read(checkpointNotifierProvider.notifier).loadAll();
      } catch (_) {
        // Sinkron user best effort, abaikan bila gagal.
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(AppStrings.adminCheckpointDeleted),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.genericError)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Checkpoint>> state =
        ref.watch(adminCheckpointListProvider);
    final String query = ref.watch(adminCheckpointSearchProvider);
    final String? provinceFilter =
        ref.watch(adminCheckpointProvinceFilterProvider);
    final String? cityFilter = ref.watch(adminCheckpointCityFilterProvider);
    final String? districtFilter =
        ref.watch(adminCheckpointDistrictFilterProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.adminManageTps,
        leading: LucideIcons.menu,
        onLeadingTap: () => ref
            .read(adminScaffoldKeyProvider)
            .currentState
            ?.openDrawer(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final Object? result =
              await context.pushNamed(AppRouteName.adminCheckpointNew);
          if (result == true && mounted) {
            ref.read(adminCheckpointListProvider.notifier).loadAll();
          }
        },
        icon: const Icon(LucideIcons.plus),
        label: const Text(AppStrings.adminAddTps),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              0,
            ),
            child: SearchField(
              hint: AppStrings.adminSearchTpsHint,
              onChanged: (String value) => ref
                  .read(adminCheckpointSearchProvider.notifier)
                  .state = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: ExpansionTile(
              title: const Text(AppStrings.adminRegionFilterTitle),
              tilePadding: EdgeInsets.zero,
              children: <Widget>[
                RegionPickerDropdown(
                  onChanged: (RegionSelection selection) {
                    ref
                        .read(adminCheckpointProvinceFilterProvider.notifier)
                        .state = selection.province?.id;
                    ref
                        .read(adminCheckpointCityFilterProvider.notifier)
                        .state = selection.city?.id;
                    ref
                        .read(adminCheckpointDistrictFilterProvider.notifier)
                        .state = selection.district?.id;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: LoadingIndicator()),
              error: (_, __) => AppErrorState(
                message: AppStrings.wasteCheckpointError,
                onRetry: () => ref
                    .read(adminCheckpointListProvider.notifier)
                    .loadAll(),
              ),
              data: (_) {
                final List<Checkpoint> items = ref
                    .read(adminCheckpointListProvider.notifier)
                    .filtered(
                      query,
                      provinceCode: provinceFilter,
                      cityCode: cityFilter,
                      districtCode: districtFilter,
                    );
                if (items.isEmpty) {
                  return const EmptyState(
                    icon: LucideIcons.map_pin,
                    title: AppStrings.adminCheckpointEmpty,
                    message: AppStrings.adminSearchTpsHint,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref
                      .read(adminCheckpointListProvider.notifier)
                      .loadAll(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int index) {
                      final Checkpoint checkpoint = items[index];
                      return TpsCard(
                        checkpoint: checkpoint,
                        onEdit: () async {
                          final Object? result =
                              await context.pushNamed(
                            AppRouteName.adminCheckpointEdit,
                            pathParameters: <String, String>{
                              'id': checkpoint.id,
                            },
                            extra: checkpoint,
                          );
                          if (result == true && context.mounted) {
                            ref
                                .read(adminCheckpointListProvider.notifier)
                                .loadAll();
                          }
                        },
                        onDeactivate: () =>
                            _confirmDeactivate(checkpoint),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
