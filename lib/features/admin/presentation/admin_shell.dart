// Kerangka admin dengan drawer (presentation).
//
// Perilaku tombol back: di branch root sekali tekan langsung kembali
// ke UI user (/profile); di sub-route (form/detail) back berjalan
// normal (pop). Masuk admin selalu via go (bukan push) agar hanya
// ada satu instance shell.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../auth/domain/entities/auth_session.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import 'providers/admin_providers.dart';
import 'widgets/admin_drawer.dart';

/// Route root tiap branch admin (back di luar ini berjalan normal).
const List<String> _adminBranchRoots = <String>[
  '/admin/dashboard',
  '/admin/checkpoints',
  '/admin/waste-verification',
  '/admin/rewards',
  '/admin/users',
  '/admin/settings',
];

/// Kerangka admin: drawer + konten branch aktif, tanpa bottom nav user.
class AdminShell extends ConsumerStatefulWidget {
  /// Membuat kerangka admin.
  const AdminShell({super.key, required this.navigationShell});

  /// Navigation shell dari go_router untuk branch admin.
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(adminDrawerOpenerProvider.notifier).state = _openDrawer;
    });
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(authRepositoryProvider).signOut();
    if (!context.mounted) return;
    context.goNamed(AppRouteName.home);
  }

  void _onPopInvokedWithResult(bool didPop, Object? result) {
    if (didPop) return;
    if (!mounted) return;
    context.goNamed(AppRouteName.profile);
  }

  @override
  Widget build(BuildContext context) {
    final AuthSession auth = ref.watch(authNotifierProvider);
    final AsyncValue<UserRole> role = ref.watch(adminRoleProvider);
    final bool isPetugas = role.maybeWhen(
      data: (UserRole value) => value == UserRole.petugas,
      orElse: () => false,
    );
    final String displayName = auth.displayName ??
        auth.username ??
        auth.userEmail?.split('@').first ??
        AppStrings.guestName;
    final String roleLabel = role.maybeWhen(
      data: (UserRole value) => value.value,
      orElse: () => UserRole.admin.value,
    );

    return role.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(child: Text(AppStrings.adminAccessDenied)),
      ),
      data: (UserRole value) {
        if (value != UserRole.admin && value != UserRole.petugas) {
          return const Scaffold(
            body: Center(child: Text(AppStrings.adminAccessDenied)),
          );
        }
        return PopScope(
          canPop:
              !_adminBranchRoots.contains(GoRouterState.of(context).uri.path),
          onPopInvokedWithResult: _onPopInvokedWithResult,
          child: Scaffold(
            key: _scaffoldKey,
            drawer: AdminDrawer(
              displayName: displayName,
              roleLabel: roleLabel,
              currentIndex: widget.navigationShell.currentIndex,
              visibleCount: isPetugas ? 3 : adminMenuItems.length,
              onSelect: (int index) {
                Navigator.of(context).pop();
                widget.navigationShell.goBranch(index);
              },
              onLogout: () => _handleLogout(context, ref),
            ),
            body: widget.navigationShell,
          ),
        );
      },
    );
  }
}
