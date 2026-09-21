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
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../../domain/entities/point.dart';
import '../data/reward_demo_data.dart';
import '../providers/point_provider.dart';
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
          child: _PointsList(children: _demoChildren),
        ),
      );
    }
    final AsyncValue<PointsState> state = ref.watch(pointsNotifierProvider);
    return state.when(
      loading: () => const Scaffold(
        body: SafeArea(
          child: Center(child: LoadingIndicator()),
        ),
      ),
      error: (Object error, StackTrace _) => Scaffold(
        body: SafeArea(
          child: _PointsList(
            children: <Widget>[
              const Text(
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
      data: (PointsState points) => Scaffold(
        body: SafeArea(
          child: _PointsList(
            children: <Widget>[
              const Text(
                AppStrings.pointsTitle,
                style: AppTypography.headlineLg,
              ),
              const SizedBox(height: AppSpacing.lg),
              PointCard(
                point: points.totalPoints,
                label: AppStrings.pointsBalance,
                icon: LucideIcons.coins,
              ),
              const SizedBox(height: AppSpacing.xl),
              const _RewardsSection(),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                AppStrings.pointsHistoryTitle,
                style: AppTypography.headlineSm,
              ),
              const SizedBox(height: AppSpacing.md),
              if (points.history.isEmpty) ...<Widget>[
                const EmptyState(
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

/// Anak demo lengkap halaman poin (judul + saldo + reward + riwayat).
final List<Widget> _demoChildren = <Widget>[
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
  const _RewardsSection(),
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
];

/// Isi demo tanpa judul (dipakai di bawah pesan error).
final List<Widget> _demoBodyChildren = <Widget>[
  const PointCard(
    point: 250,
    label: AppStrings.pointsBalance,
    icon: LucideIcons.coins,
  ),
  const SizedBox(height: AppSpacing.xl),
  const _RewardsSection(),
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
];

/// Section daftar reward (masih demo sampai katalog real terpasang).
class _RewardsSection extends StatelessWidget {
  const _RewardsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
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
