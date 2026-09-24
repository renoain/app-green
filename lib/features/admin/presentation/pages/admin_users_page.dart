// Halaman kelola user admin (daftar + filter + ubah role).
//
// Daftar profil terbaru via AdminUsersNotifier; cari nama/email, filter
// role, ketuk item ke detail (total poin + riwayat + ubah role).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../../../../core/widgets/display_widgets.dart';
import '../../../../core/widgets/feedback_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../../domain/entities/admin_user.dart';
import '../providers/admin_providers.dart';
import '../providers/admin_users_provider.dart';

/// Label role user untuk chip admin.
String _roleLabel(UserRole role) {
  return switch (role) {
    UserRole.admin => 'Admin',
    UserRole.petugas => 'Petugas',
    UserRole.user => 'User',
  };
}

/// Tipe chip role user admin.
StatusType _roleType(UserRole role) {
  return switch (role) {
    UserRole.admin => StatusType.success,
    UserRole.petugas => StatusType.info,
    UserRole.user => StatusType.warning,
  };
}

/// Halaman kelola user admin.
class AdminUsersPage extends ConsumerStatefulWidget {
  /// Membuat halaman kelola user admin.
  const AdminUsersPage({super.key});

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    if (!mounted) return;
    await ref.read(adminUsersProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<AdminUser>> state = ref.watch(adminUsersProvider);
    final String query = ref.watch(adminUserSearchProvider);
    final UserRole? roleFilter = ref.watch(adminUserRoleFilterProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.adminManageUser,
        leading: LucideIcons.menu,
        onLeadingTap: () => ref.read(adminDrawerOpenerProvider)?.call(),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: CustomTextField(
                hint: AppStrings.adminUserSearchHint,
                prefixIcon: LucideIcons.search,
                controller: _searchController,
                onChanged: (String v) =>
                    ref.read(adminUserSearchProvider.notifier).state = v,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: <Widget>[
                  ChoiceChip(
                    label: Text(AppStrings.adminUserFilterAll),
                    selected: roleFilter == null,
                    onSelected: (_) => ref
                        .read(adminUserRoleFilterProvider.notifier)
                        .state = null,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ...UserRole.values.map(
                    (UserRole role) => Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(_roleLabel(role)),
                        selected: roleFilter == role,
                        onSelected: (_) => ref
                            .read(adminUserRoleFilterProvider.notifier)
                            .state = role,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: state.when(
                loading: () => const _AdminUserSkeleton(),
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
                data: (List<AdminUser> users) {
                  final List<AdminUser> shown = ref
                      .read(adminUsersProvider.notifier)
                      .filtered(query, roleFilter);
                  if (shown.isEmpty) {
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: _reload,
                      child: ListView(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        children: <Widget>[
                          EmptyState(
                            icon: LucideIcons.users,
                            title: AppStrings.adminManageUser,
                            message: AppStrings.adminUserEmpty,
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
                      itemCount: shown.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (BuildContext context, int index) {
                        final AdminUser user = shown[index];
                        final String name = user.username ??
                            user.email?.split('@').first ??
                            '-';
                        return RepaintBoundary(
                          child: InkWell(
                            onTap: () => context.pushNamed(
                              AppRouteName.adminUserDetail,
                              pathParameters: <String, String>{'id': user.id},
                              extra: user,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.lg),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Avatar(name: name, size: 44),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          name,
                                          style: AppTypography.labelLg,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: AppSpacing.xs,
                                        ),
                                        Text(
                                          formatIndonesianDate(
                                            user.createdAt,
                                          ),
                                          style: AppTypography.bodySm,
                                        ),
                                      ],
                                    ),
                                  ),
                                  StatusChip(
                                    label:
                                        '${AppStrings.adminUserRoleLabel}: ${_roleLabel(user.role)}',
                                    type: _roleType(user.role),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton daftar user admin.
class _AdminUserSkeleton extends StatelessWidget {
  const _AdminUserSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const <Widget>[
        _AdminUserSkeletonBlock(height: 72),
        SizedBox(height: AppSpacing.sm),
        _AdminUserSkeletonBlock(height: 72),
        SizedBox(height: AppSpacing.sm),
        _AdminUserSkeletonBlock(height: 72),
      ],
    );
  }
}

/// Satu blok skeleton user admin.
class _AdminUserSkeletonBlock extends StatelessWidget {
  const _AdminUserSkeletonBlock({required this.height});

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
