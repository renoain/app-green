// Halaman detail reward Go Green.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
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
import '../../../../core/widgets/card_widgets.dart';
import '../../../rewards/presentation/widgets/redeem_dialogs.dart';
import '../data/reward_demo_data.dart';

/// Halaman detail reward Go Green.
class RewardDetailPage extends StatelessWidget {
  /// Membuat halaman detail reward.
  const RewardDetailPage({super.key, this.rewardId = '1'});

  /// Identitas reward yang dibuka.
  final String rewardId;

  @override
  Widget build(BuildContext context) {
    RewardDemo? found;
    for (final RewardDemo reward in demoRewards) {
      if (reward.id == rewardId) {
        found = reward;
        break;
      }
    }
    final RewardDemo reward = found ?? demoRewards.first;

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.rewardDetailTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: SafeArea(
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
                  child: Icon(
                    reward.icon,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(reward.title, style: AppTypography.headlineMd),
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
                            '${formatIndonesianNumber(reward.pointCost)} ${AppStrings.rewardPointSuffix}',
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
            Text(reward.description, style: AppTypography.bodyLg),
            const SizedBox(height: AppSpacing.lg),
            const PointCard(
              point: 250,
              label: AppStrings.pointsBalance,
              icon: LucideIcons.coins,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: AppStrings.rewardExchangeButton,
              onPressed: () => _onExchange(context, reward),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Future<void> _onExchange(BuildContext context, RewardDemo reward) async {
    final bool confirmed = await showRedeemConfirmDialog(
      context,
      rewardTitle: reward.title,
      pointCost: reward.pointCost,
    );
    if (!confirmed || !context.mounted) return;
    final bool goVouchers = await showRedeemSuccessDialog(context);
    if (!goVouchers || !context.mounted) return;
    context.pushNamed(AppRouteName.vouchers);
  }
}