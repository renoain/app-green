// Halaman detail reward Go Green.
//
// Demo id 1-4 langsung tampil tanpa backend (kompatibel deep link lama +
// test). Id UUID memuat katalog real via Supabase; tukar memakai
// redeem backend dan guard saldo/stok/login.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../../../rewards/domain/entities/reward.dart';
import '../../../rewards/presentation/providers/reward_provider.dart';
import '../../../rewards/presentation/widgets/redeem_dialogs.dart';
import '../providers/point_provider.dart';
import '../data/reward_demo_data.dart';

/// Halaman detail reward Go Green.
class RewardDetailPage extends ConsumerStatefulWidget {
  /// Membuat halaman detail reward.
  const RewardDetailPage({super.key, this.rewardId = '1'});

  /// Identitas reward yang dibuka (demo 1-4 atau UUID real).
  final String rewardId;

  @override
  ConsumerState<RewardDetailPage> createState() => _RewardDetailPageState();
}

class _RewardDetailPageState extends ConsumerState<RewardDetailPage> {
  Reward? _real;
  bool _loadingReal = false;
  bool _failedReal = false;
  bool _redeeming = false;

  bool get _isDemoId {
    return widget.rewardId == '1' ||
        widget.rewardId == '2' ||
        widget.rewardId == '3' ||
        widget.rewardId == '4';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensurePoints();
      if (!_isDemoId) _loadReal();
    });
  }

  Future<void> _ensurePoints() async {
    final String? userId = SupabaseService.instance.currentUser?.id;
    if (userId == null || !mounted) return;
    await ref.read(pointsNotifierProvider.notifier).load(userId: userId);
  }

  Future<void> _loadReal() async {
    if (!mounted) return;
    setState(() {
      _loadingReal = true;
      _failedReal = false;
    });
    try {
      final Reward? reward = await ref
          .read(rewardRemoteDatasourceProvider)
          .getRewardById(widget.rewardId)
          .timeout(const Duration(seconds: 5));
      if (!mounted) return;
      setState(() {
        _real = reward;
        _loadingReal = false;
        _failedReal = reward == null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingReal = false;
        _failedReal = true;
      });
    }
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
    if (!_isDemoId) {
      if (_loadingReal) {
        return const Scaffold(
          appBar: CustomAppBar(
            title: AppStrings.rewardDetailTitle,
            leading: LucideIcons.arrow_left,
          ),
          body: SafeArea(child: _RewardDetailSkeleton()),
        );
      }
      if (_failedReal || _real == null) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: AppStrings.rewardDetailTitle,
            leading: LucideIcons.arrow_left,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: <Widget>[
                Text('$AppStrings.rewardDetailTitle', style: AppTypography.headlineSm),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  AppStrings.genericError,
                  style: AppTypography.bodySm,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextButton(
                  text: AppStrings.retryButton,
                  onPressed: _loadReal,
                ),
              ],
            ),
          ),
        );
      }
      final Reward reward = _real!;
      return _RewardDetailBody(
        title: reward.name,
        description: reward.description ?? reward.name,
        pointCost: reward.pointsCost,
        icon: _iconForName(reward.name),
        stock: reward.stock,
        redeeming: _redeeming,
        onExchange: () => _onExchange(
          title: reward.name,
          pointCost: reward.pointsCost,
          stock: reward.stock,
        ),
      );
    }
    RewardDemo? found;
    for (final RewardDemo reward in demoRewards) {
      if (reward.id == widget.rewardId) {
        found = reward;
        break;
      }
    }
    final RewardDemo reward = found ?? demoRewards.first;
    return _RewardDetailBody(
      title: reward.title,
      description: reward.description,
      pointCost: reward.pointCost,
      icon: reward.icon,
      stock: 99,
      redeeming: _redeeming,
      onExchange: () => _onExchange(
        title: reward.title,
        pointCost: reward.pointCost,
        stock: 99,
        demoId: reward.id,
      ),
    );
  }

  Future<void> _onExchange({
    required String title,
    required int pointCost,
    required int stock,
    String? demoId,
  }) async {
    // Alur demo (id 1-4): tanpa login/backend agar kompatibel test
    // dan deep link lama; hanya tampilkan popup konfirmasi + sukses.
    if (demoId != null) {
      final bool confirmed = await showRedeemConfirmDialog(
        context,
        rewardTitle: title,
        pointCost: pointCost,
      );
      if (!confirmed || !mounted) return;
      final bool goVouchers = await showRedeemSuccessDialog(context);
      if (!goVouchers || !mounted) return;
      context.pushNamed(AppRouteName.vouchers);
      return;
    }
    final String? userId = SupabaseService.instance.currentUser?.id;
    if (userId == null || !mounted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.redeemNeedLogin)),
      );
      context.pushNamed(AppRouteName.login);
      return;
    }
    if (stock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.redeemOutOfStock)),
      );
      return;
    }
    final int? saldo =
        ref.read(pointsNotifierProvider).valueOrNull?.totalPoints;
    if (saldo != null && saldo < pointCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.redeemInsufficientPoints)),
      );
      return;
    }
    final bool confirmed = await showRedeemConfirmDialog(
      context,
      rewardTitle: title,
      pointCost: pointCost,
    );
    if (!confirmed || !mounted) return;
    setState(() => _redeeming = true);
    try {
      await ref.read(rewardNotifierProvider.notifier).redeem(
            userId: userId,
            rewardId: widget.rewardId,
          );
      await ref.read(pointsNotifierProvider.notifier).load(userId: userId);
      await ref.read(userVouchersProvider.notifier).load(userId: userId);
    } catch (_) {
      if (!mounted) return;
      setState(() => _redeeming = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.redeemFailedMessage)),
      );
      return;
    }
    if (!mounted) return;
    setState(() => _redeeming = false);
    final bool goVouchers = await showRedeemSuccessDialog(context);
    if (!goVouchers || !mounted) return;
    context.pushNamed(AppRouteName.vouchers);
  }
}

/// Isi detail reward dengan saldo asli bila login.
class _RewardDetailBody extends ConsumerWidget {
  const _RewardDetailBody({
    required this.title,
    required this.description,
    required this.pointCost,
    required this.icon,
    required this.stock,
    required this.redeeming,
    required this.onExchange,
  });

  final String title;
  final String description;
  final int pointCost;
  final IconData icon;
  final int stock;
  final bool redeeming;
  final VoidCallback onExchange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? userId = SupabaseService.instance.currentUser?.id;
    final int? saldo =
        ref.watch(pointsNotifierProvider).valueOrNull?.totalPoints;
    final int shownBalance = saldo ?? 250;
    final bool notEnough = saldo != null && saldo < pointCost;
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.rewardDetailTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            final String? id = SupabaseService.instance.currentUser?.id;
            if (id == null) return;
            await ref.read(pointsNotifierProvider.notifier).load(userId: id);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Icon(icon, size: 36, color: AppColors.primary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title, style: AppTypography.headlineMd),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          AppStrings.rewardDetailCostLabel,
                          style: AppTypography.bodySm,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: <Widget>[
                            const Icon(
                              LucideIcons.star,
                              size: 14,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${formatIndonesianNumber(pointCost)} ${AppStrings.rewardPointSuffix}',
                              style: AppTypography.labelLg.copyWith(
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                AppStrings.rewardBenefitLabel,
                style: AppTypography.headlineSm,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(description, style: AppTypography.bodyLg),
              if (userId != null && notEnough) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                const Text(
                  AppStrings.redeemInsufficientPoints,
                  style: AppTypography.bodySm,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              RepaintBoundary(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: PointCard(
                    key: ValueKey<int>(shownBalance),
                    point: shownBalance,
                    label: AppStrings.pointsBalance,
                    icon: LucideIcons.coins,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: redeeming
                    ? AppStrings.redeemLoadingLabel
                    : AppStrings.rewardExchangeButton,
                onPressed: redeeming ? null : onExchange,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton detail reward saat memuat katalog real.
class _RewardDetailSkeleton extends StatelessWidget {
  const _RewardDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const <Widget>[
        _RewardSkeletonBlock(height: 96),
        SizedBox(height: AppSpacing.lg),
        _RewardSkeletonBlock(height: 120),
      ],
    );
  }
}

/// Satu blok skeleton detail reward.
class _RewardSkeletonBlock extends StatelessWidget {
  const _RewardSkeletonBlock({required this.height});

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
