// Halaman Voucher Saya: daftar penukaran reward milik user.
//
// Tamu melihat notice login; user login memuat redemptions asli dari
// Supabase; kosong menampilkan empty state.

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
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../../../../core/widgets/login_notice_widget.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../../domain/entities/redemption.dart';
import '../providers/reward_provider.dart';

/// Status UI untuk satu redemption.
({StatusType type, String label}) _statusOf(RedemptionStatus status) {
  return switch (status) {
    RedemptionStatus.pending => (
        type: StatusType.warning,
        label: AppStrings.voucherStatusPending,
      ),
    RedemptionStatus.approved => (
        type: StatusType.success,
        label: AppStrings.voucherStatusApproved,
      ),
    RedemptionStatus.rejected => (
        type: StatusType.error,
        label: AppStrings.voucherStatusRejected,
      ),
    RedemptionStatus.claimed => (
        type: StatusType.info,
        label: AppStrings.voucherStatusClaimed,
      ),
  };
}

/// Halaman daftar voucher milik user.
class VouchersPage extends ConsumerStatefulWidget {
  /// Membuat halaman voucher saya.
  const VouchersPage({super.key});

  @override
  ConsumerState<VouchersPage> createState() => _VouchersPageState();
}

class _VouchersPageState extends ConsumerState<VouchersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    final String? userId = SupabaseService.instance.currentUser?.id;
    if (userId == null || !mounted) return;
    await ref.read(userVouchersProvider.notifier).load(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = SupabaseService.instance.currentUser?.id;
    if (userId == null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: AppStrings.voucherTitle,
          leading: LucideIcons.arrow_left,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              LoginNoticeCard(
                message: AppStrings.profileLoginNotice,
                onLogin: () => context.pushNamed(AppRouteName.login),
              ),
            ],
          ),
        ),
      );
    }
    final AsyncValue<List<Redemption>> state =
        ref.watch(userVouchersProvider);
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.voucherTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: LoadingIndicator()),
          error: (Object error, StackTrace _) => ListView(
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
          data: (List<Redemption> vouchers) {
            if (vouchers.isEmpty) {
              return const Center(
                child: EmptyState(
                  icon: LucideIcons.ticket,
                  title: AppStrings.voucherTitle,
                  message: AppStrings.voucherEmptyMessage,
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: vouchers.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (BuildContext context, int index) {
                final Redemption voucher = vouchers[index];
                final ({String label, StatusType type}) status =
                    _statusOf(voucher.status);
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.ticket,
                          size: 22,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              voucher.rewardName ?? '-',
                              style: AppTypography.labelLg,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              formatIndonesianTimestamp(voucher.createdAt),
                              style: AppTypography.bodySm,
                            ),
                          ],
                        ),
                      ),
                      StatusChip(label: status.label, type: status.type),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
