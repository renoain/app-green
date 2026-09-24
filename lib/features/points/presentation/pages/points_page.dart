// Halaman poin dan reward Go Green.
//
// Saldo dan riwayat dimuat dari Supabase via pointsNotifierProvider saat
// user login; tamu atau saat backend gagal memakai konten demo.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../../domain/entities/point.dart';
import '../data/reward_demo_data.dart';
import '../providers/point_provider.dart';
import '../../../rewards/presentation/providers/reward_provider.dart';
import '../../../waste/presentation/providers/waste_provider.dart';

/// Tanggal riwayat poin demo pertama.
final DateTime _demoHistoryDate1 = DateTime(2026, 9, 11);

/// Tanggal riwayat poin demo kedua.
final DateTime _demoHistoryDate2 = DateTime(2026, 9, 9);

/// Halaman poin dan reward Go Green.
class PointsPage extends ConsumerStatefulWidget {
  /// Membuat halaman poin.
  const PointsPage({super.key});

  @override
  ConsumerState<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends ConsumerState<PointsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    final String? userId = SupabaseService.instance.currentUser?.id;
    if (userId == null || !mounted) return;
    await ref.read(pointsNotifierProvider.notifier).load(userId: userId);
    if (!mounted) return;
    await ref.read(rewardNotifierProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<dynamic>>(
      wasteSubmitNotifierProvider,
      (previous, next) {
        if (next.valueOrNull != null && previous is AsyncLoading) _reload();
      },
    );
    final String? userId = SupabaseService.instance.currentUser?.id;
    if (userId == null) {
      return Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {},
            child: _PointsList(children: _demoChildren),
          ),
        ),
      );
    }
    final AsyncValue<PointsState> state = ref.watch(pointsNotifierProvider);
    return state.when(
      loading: () => const Scaffold(
        body: SafeArea(child: _PointsSkeleton()),
      ),
      error: (Object error, StackTrace _) => Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _reload,
            child: _PointsList(
              children: <Widget>[
                Text(
                  AppStrings.pointsTitle,
                  style: AppTypography.headlineLg,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('$error', style: AppTypography.bodySm),
                const SizedBox(height: AppSpacing.md),
                AppTextButton(
                  text: AppStrings.retryButton,
                  onPressed: _reload,
                ),
                const SizedBox(height: AppSpacing.lg),
                ..._demoBodyChildren,
              ],
            ),
          ),
        ),
      ),
      data: (PointsState points) => Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _reload,
            child: _PointsList(
              children: <Widget>[
                Text(
                  AppStrings.pointsTitle,
                  style: AppTypography.headlineLg,
                ),
                const SizedBox(height: AppSpacing.lg),
                RepaintBoundary(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: PointCard(
                      key: ValueKey<int>(points.totalPoints),
                      point: points.totalPoints,
                      label: AppStrings.pointsBalance,
                      icon: LucideIcons.coins,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const _RewardsSection(),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.pointsHistoryTitle,
                  style: AppTypography.headlineSm,
                ),
                const SizedBox(height: AppSpacing.md),
                if (points.history.isEmpty) ...<Widget>[
                  EmptyState(
                    icon: LucideIcons.coins,
                    title: AppStrings.pointsHistoryTitle,
                    message: AppStrings.pointsHistoryEmpty,
                  ),
                ],
                for (final Point item in points.history) ...<Widget>[
                  ActivityCard(
                    date: item.createdAt,
                    description: item.description ?? item.type.value,
                    point: item.type == PointType.earn
                        ? item.amount
                        : -item.amount,
                    status: item.type == PointType.earn
                        ? StatusType.success
                        : StatusType.warning,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Daftar scroll halaman poin dengan padding konsisten.
class _PointsList extends StatelessWidget {
  const _PointsList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: children,
    );
  }
}

/// Skeleton statis Poin saat memuat data login.
class _PointsSkeleton extends StatelessWidget {
  const _PointsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const <Widget>[
        SizedBox(height: AppSpacing.sm),
        _PointsSkeletonBlock(height: 120),
        SizedBox(height: AppSpacing.xl),
        _PointsSkeletonBlock(height: 96),
        SizedBox(height: AppSpacing.md),
        _PointsSkeletonBlock(height: 96),
      ],
    );
  }
}

/// Satu blok placeholder skeleton Poin.
class _PointsSkeletonBlock extends StatelessWidget {
  const _PointsSkeletonBlock({required this.height});

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

/// Anak demo lengkap halaman poin (judul + saldo + reward + riwayat).
final List<Widget> _demoChildren = <Widget>[
  Text(
    AppStrings.pointsTitle,
    style: AppTypography.headlineLg,
  ),
  const SizedBox(height: AppSpacing.lg),
  PointCard(
    point: 250,
    label: AppStrings.pointsBalance,
    icon: LucideIcons.coins,
  ),
  const SizedBox(height: AppSpacing.xl),
  const _RewardsSection(),
  const SizedBox(height: AppSpacing.lg),
  Text(
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
];

/// Isi demo tanpa judul (dipakai di bawah pesan error).
final List<Widget> _demoBodyChildren = <Widget>[
  PointCard(
    point: 250,
    label: AppStrings.pointsBalance,
    icon: LucideIcons.coins,
  ),
  const SizedBox(height: AppSpacing.xl),
  const _RewardsSection(),
  const SizedBox(height: AppSpacing.lg),
  Text(
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
];

/// Section daftar reward (real bila backend siap, fallback demo).
class _RewardsSection extends ConsumerStatefulWidget {
  const _RewardsSection();

  @override
  ConsumerState<_RewardsSection> createState() => _RewardsSectionState();
}

class _RewardsSectionState extends ConsumerState<_RewardsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(rewardNotifierProvider.notifier).load();
    });
  }

  /// Ikon reward berdasarkan nama katalog.
  IconData _iconForName(String name) {
    final String lower = name.toLowerCase();
    if (lower.contains('voucher') || lower.contains('belanja')) {
      return LucideIcons.shopping_bag;
    }
    if (lower.contains('wallet') ||
        lower.contains('saldo') ||
        lower.contains('e-wallet') ||
        lower.contains('ewallet')) {
      return LucideIcons.wallet;
    }
    if (lower.contains('donasi') || lower.contains('donation')) {
      return LucideIcons.heart_handshake;
    }
    return LucideIcons.gift;
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<dynamic>> rewards = ref.watch(rewardNotifierProvider);
    final List<Widget> realChildren = rewards.maybeWhen(
      data: (List<dynamic> list) {
        if (list.isEmpty) return <Widget>[];
        return <Widget>[
          for (final dynamic reward in list) ...<Widget>[
            RewardCard(
              title: reward.name as String,
              description:
                  (reward.description as String?) ?? reward.name as String,
              pointCost: reward.pointsCost as int,
              icon: _iconForName(reward.name as String),
              onTap: () => context.pushNamed(
                AppRouteName.rewardDetail,
                pathParameters: <String, String>{'id': reward.id as String},
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ];
      },
      orElse: () => <Widget>[],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                AppStrings.rewardsSectionTitle,
                style: AppTypography.headlineSm,
              ),
            ),
            AppTextButton(
              text: AppStrings.voucherTitle,
              onPressed: () => context.pushNamed(AppRouteName.vouchers),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (realChildren.isNotEmpty)
          ...realChildren
        else
          for (final RewardDemo reward in demoRewards) ...<Widget>[
            RewardCard(
              title: reward.title,
              description: reward.description,
              pointCost: reward.pointCost,
              icon: reward.icon,
              onTap: () => context.pushNamed(
                AppRouteName.rewardDetail,
                pathParameters: <String, String>{'id': reward.id},
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
      ],
    );
  }
}
