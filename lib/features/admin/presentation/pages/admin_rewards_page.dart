// Halaman kelola reward admin (daftar + tulis).

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
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../../../rewards/domain/entities/reward.dart';
import '../providers/admin_providers.dart';
import '../providers/admin_reward_provider.dart';

/// Halaman kelola reward admin.
class AdminRewardsPage extends ConsumerStatefulWidget {
  const AdminRewardsPage({super.key});

  @override
  ConsumerState<AdminRewardsPage> createState() => _AdminRewardsPageState();
}

class _AdminRewardsPageState extends ConsumerState<AdminRewardsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    if (!mounted) return;
    await ref.read(adminRewardListProvider.notifier).loadAll();
  }

  Future<void> _confirmDelete(Reward reward) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(AppStrings.adminRewardDelete),
        content: Text(
          '${AppStrings.adminRewardDeleteConfirm}\n${reward.name}',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppStrings.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppStrings.adminRewardDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref.read(adminRewardListProvider.notifier).remove(reward.id);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Reward>> state = ref.watch(adminRewardListProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.adminManageReward,
        leading: LucideIcons.menu,
        onLeadingTap: () => ref.read(adminDrawerOpenerProvider)?.call(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRouteName.adminRewardNew),
        icon: const Icon(LucideIcons.plus),
        label: Text(AppStrings.adminRewardAdd),
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const _AdminRewardSkeleton(),
          error: (Object error, StackTrace _) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: <Widget>[
                Text('$error', style: AppTypography.bodySm),
                const SizedBox(height: AppSpacing.md),
                AppTextButton(
                  text: AppStrings.retryButton,
                  onPressed: _reload,
                ),
              ],
            ),
          ),
          data: (List<Reward> rewards) {
            if (rewards.isEmpty) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _reload,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: <Widget>[
                    EmptyState(
                      icon: LucideIcons.gift,
                      title: AppStrings.adminManageReward,
                      message: AppStrings.adminRewardEmpty,
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _reload,
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: rewards.length + 1,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        AppStrings.adminRewardManageNote,
                        style: AppTypography.bodySm,
                      ),
                    );
                  }
                  final Reward reward = rewards[index - 1];
                  return RepaintBoundary(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppRadius.lg),
                        border:
                            Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () => context.pushNamed(
                              AppRouteName.adminRewardEdit,
                              pathParameters: <String, String>{'id': reward.id},
                              extra: reward,
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: AppColors.tertiaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.gift,
                                    size: 22,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        reward.name,
                                        style: AppTypography.labelLg,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        '${formatIndonesianNumber(reward.pointsCost)} ${AppStrings.rewardPointSuffix} • ${AppStrings.adminRewardStockLabel}: ${formatIndonesianNumber(reward.stock)}',
                                        style: AppTypography.bodySm,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.trash),
                                  onPressed: () => _confirmDelete(reward),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: <Widget>[
                              StatusChip(
                                label: reward.isActive
                                    ? AppStrings.adminRewardActiveLabel
                                    : AppStrings.adminRewardInactiveLabel,
                                type: reward.isActive
                                    ? StatusType.success
                                    : StatusType.warning,
                              ),
                              const Spacer(),
                              Switch(
                                value: reward.isActive,
                                onChanged: (bool v) => ref
                                    .read(adminRewardListProvider.notifier)
                                    .setActive(id: reward.id, isActive: v),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Skeleton daftar reward admin.
class _AdminRewardSkeleton extends StatelessWidget {
  const _AdminRewardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const <Widget>[
        _AdminRewardSkeletonBlock(height: 76),
        SizedBox(height: AppSpacing.sm),
        _AdminRewardSkeletonBlock(height: 76),
        SizedBox(height: AppSpacing.sm),
        _AdminRewardSkeletonBlock(height: 76),
      ],
    );
  }
}

/// Satu blok skeleton reward admin.
class _AdminRewardSkeletonBlock extends StatelessWidget {
  const _AdminRewardSkeletonBlock({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderLight),
      ),
    );
  }
}
