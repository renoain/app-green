// Kerangka admin dengan drawer (presentation).
//
// Perilaku tombol back: di branch root perlu tekan 2 kali dalam 2 detik
// untuk keluar (seperti MainShell user); di sub-route (form/detail)
// back berfungsi normal.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../auth/domain/entities/auth_session.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import 'providers/admin_providers.dart';
import 'widgets/admin_drawer.dart';

/// Jeda maksimal antara dua back agar aplikasi benar-benar tertutup.
const Duration _adminExitConfirmDuration = Duration(seconds: 2);

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
  DateTime? _lastBackPressed;

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(authRepositoryProvider).signOut();
    if (!context.mounted) return;
    context.goNamed(AppRouteName.home);
  }

  void _onPopInvokedWithResult(bool didPop, Object? result) {
    if (didPop) return;
    final DateTime now = DateTime.now();
    final DateTime? last = _lastBackPressed;
    if (last != null && now.difference(last) <= _adminExitConfirmDuration) {
      _lastBackPressed = null;
      SystemNavigator.pop();
      return;
    }
    _lastBackPressed = now;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text(AppStrings.backToExitHint)),
      );
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
            key: ref.watch(adminScaffoldKeyProvider),
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
