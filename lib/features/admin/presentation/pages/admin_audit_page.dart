// Halaman log audit admin (daftar jejak aksi, read-only).
//
// 50 aktivitas terbaru via adminAuditProvider; append-only di server
// (tanpa ubah/hapus dari klien).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../../domain/entities/audit_log.dart';
import '../providers/admin_audit_provider.dart';
import '../providers/admin_providers.dart';

/// Label aksi audit Bahasa Indonesia.
String _actionLabel(String action) {
  return switch (action) {
    AuditAction.create => AppStrings.auditActionCreate,
    AuditAction.update => AppStrings.auditActionUpdate,
    AuditAction.delete => AppStrings.auditActionDelete,
    AuditAction.activate => AppStrings.auditActionActivate,
    AuditAction.deactivate => AppStrings.auditActionDeactivate,
    AuditAction.approve => AppStrings.auditActionApprove,
    AuditAction.reject => AppStrings.auditActionReject,
    AuditAction.changeRole => AppStrings.auditActionChangeRole,
    AuditAction.saveSettings => AppStrings.auditActionSaveSettings,
    _ => action,
  };
}

/// Label entitas audit Bahasa Indonesia.
String _entityLabel(String entity) {
  return switch (entity) {
    AuditEntity.reward => AppStrings.auditEntityReward,
    AuditEntity.user => AppStrings.auditEntityUser,
    AuditEntity.settings => AppStrings.auditEntitySettings,
    AuditEntity.checkpoint => AppStrings.auditEntityCheckpoint,
    AuditEntity.verification => AppStrings.auditEntityVerification,
    _ => entity,
  };
}

/// Halaman log audit admin.
class AdminAuditPage extends ConsumerStatefulWidget {
  /// Membuat halaman log audit admin.
  const AdminAuditPage({super.key});

  @override
  ConsumerState<AdminAuditPage> createState() => _AdminAuditPageState();
}

class _AdminAuditPageState extends ConsumerState<AdminAuditPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    if (!mounted) return;
    await ref.read(adminAuditProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<AuditLog>> state = ref.watch(adminAuditProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.adminAuditLog,
        leading: LucideIcons.menu,
        onLeadingTap: () => ref.read(adminDrawerOpenerProvider)?.call(),
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const _AuditSkeleton(),
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
          data: (List<AuditLog> logs) {
            if (logs.isEmpty) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _reload,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: const <Widget>[
                    EmptyState(
                      icon: LucideIcons.file_text,
                      title: AppStrings.adminAuditLog,
                      message: AppStrings.adminAuditEmpty,
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
                itemCount: logs.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (BuildContext context, int index) {
                  final AuditLog log = logs[index];
                  final String actor =
                      log.actorName ?? log.actorId ?? '-';
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
                              LucideIcons.file_text,
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
                                  '${_actionLabel(log.action)} '
                                  '${_entityLabel(log.entity)}',
                                  style: AppTypography.labelLg,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '$actor • '
                                  '${formatIndonesianDate(log.createdAt)}',
                                  style: AppTypography.bodySm,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (log.detail != null &&
                                    log.detail!.isNotEmpty)
                                  Text(
                                    log.detail!,
                                    style: AppTypography.bodySm,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
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

/// Skeleton daftar log audit.
class _AuditSkeleton extends StatelessWidget {
  const _AuditSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const <Widget>[
        _AuditSkeletonBlock(height: 72),
        SizedBox(height: AppSpacing.sm),
        _AuditSkeletonBlock(height: 72),
        SizedBox(height: AppSpacing.sm),
        _AuditSkeletonBlock(height: 72),
      ],
    );
  }
}

/// Satu blok skeleton log audit.
class _AuditSkeletonBlock extends StatelessWidget {
  const _AuditSkeletonBlock({required this.height});

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
