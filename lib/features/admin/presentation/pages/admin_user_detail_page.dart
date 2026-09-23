// Halaman detail user admin (presentation).
//
// Profil + total poin + riwayat buang + ubah role. Validasi cegah
// self-demote di ManageUserUsecase; widget hanya tampilkan pesan.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/display_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../../../points/presentation/providers/point_provider.dart';
import '../../../waste/domain/entities/waste_log.dart';
import '../../../waste/presentation/providers/waste_provider.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/usecases/manage_user_usecase.dart';
import '../providers/admin_users_provider.dart';

/// Label role user.
String _roleLabel(UserRole role) {
  return switch (role) {
    UserRole.admin => 'Admin',
    UserRole.petugas => 'Petugas',
    UserRole.user => 'User',
  };
}

/// Halaman detail user admin.
class AdminUserDetailPage extends ConsumerStatefulWidget {
  /// Membuat detail user. [user] wajib ada (dari extra route).
  const AdminUserDetailPage({super.key, required this.user});

  /// User yang ditampilkan.
  final AdminUser user;

  @override
  ConsumerState<AdminUserDetailPage> createState() =>
      _AdminUserDetailPageState();
}

class _AdminUserDetailPageState extends ConsumerState<AdminUserDetailPage> {
  late UserRole _selectedRole;
  bool _saving = false;
  String? _error;
  int? _totalPoints;
  List<WasteLog>? _history;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.user.role;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDetail());
  }

  Future<void> _loadDetail() async {
    try {
      final int total = await ref
          .read(pointsRemoteDatasourceProvider)
          .getTotalPoints(widget.user.id);
      final List<WasteLog> logs = await ref
          .read(wasteRepositoryProvider)
          .getWasteLogs(widget.user.id);
      if (!mounted) return;
      setState(() {
        _totalPoints = total;
        _history = logs.take(10).toList();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _totalPoints = 0;
        _history = <WasteLog>[];
      });
    }
  }

  Future<void> _saveRole() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final String currentId =
          SupabaseService.instance.currentUser?.id ?? '';
      await ref.read(adminUsersProvider.notifier).updateRole(
            currentUserId: currentId,
            targetId: widget.user.id,
            role: _selectedRole,
          );
      if (!mounted) return;
      context.pop();
    } on UserValidationException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.user.username ??
        widget.user.email?.split('@').first ??
        '-';
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.adminUserDetailTitle),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            Row(
              children: <Widget>[
                Avatar(name: name, size: 56),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name, style: AppTypography.headlineSm),
                      if (widget.user.email != null)
                        Text(
                          widget.user.email!,
                          style: AppTypography.bodySm,
                        ),
                      Text(
                        formatIndonesianDate(widget.user.createdAt),
                        style: AppTypography.bodySm,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(LucideIcons.star, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Text(
                      AppStrings.adminUserTotalPoints,
                      style: AppTypography.labelLg,
                    ),
                  ),
                  Text(
                    _totalPoints == null
                        ? '...'
                        : formatIndonesianNumber(_totalPoints!),
                    style: AppTypography.headlineSm,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              AppStrings.adminUserChangeRole,
              style: AppTypography.headlineSm,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: UserRole.values.map((UserRole role) {
                final bool selected = _selectedRole == role;
                return ChoiceChip(
                  label: Text(_roleLabel(role)),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedRole = role),
                );
              }).toList(),
            ),
            if (_error != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(_error!, style: AppTypography.bodySm),
            ],
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              text: AppStrings.adminRewardSave,
              onPressed: _saving ? null : _saveRole,
              isLoading: _saving,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              AppStrings.adminUserHistoryTitle,
              style: AppTypography.headlineSm,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (_history == null)
              const Text('...', style: AppTypography.bodySm)
            else if (_history!.isEmpty)
              const Text(
                AppStrings.adminUserHistoryEmpty,
                style: AppTypography.bodySm,
              )
            else
              ..._history!.map(
                (WasteLog log) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            log.checkpointName ?? log.category.value,
                            style: AppTypography.labelLg,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StatusChip(
                          label: log.status.value,
                          type: log.status == WasteLogStatus.verified
                              ? StatusType.success
                              : log.status == WasteLogStatus.rejected
                                  ? StatusType.warning
                                  : StatusType.info,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
