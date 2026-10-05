// Kerangka halaman utama berisi bottom navigation.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_strings.dart';
import 'custom_bottom_nav_bar_widget.dart';

/// Index tab Beranda pada bottom navigation.
const int _homeBranchIndex = 0;

/// Jeda maksimal antara dua back agar aplikasi benar-benar tertutup.
const Duration _exitConfirmDuration = Duration(seconds: 2);

/// Kerangka utama aplikasi: konten tab + [CustomBottomNavBar].
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.navigationShell});

  /// Navigation shell dari go_router untuk mengelola tab.
  final StatefulNavigationShell navigationShell;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  DateTime? _lastBackPressed;

  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _goToHomeTab() {
    widget.navigationShell.goBranch(
      _homeBranchIndex,
      initialLocation: false,
    );
  }

  void _onPopInvokedWithResult(bool didPop, Object? result) {
    if (didPop) return;

    if (widget.navigationShell.currentIndex != _homeBranchIndex) {
      _goToHomeTab();
      return;
    }

    final DateTime now = DateTime.now();
    final DateTime? last = _lastBackPressed;
    if (last != null && now.difference(last) <= _exitConfirmDuration) {
      _lastBackPressed = null;
      SystemNavigator.pop();
      return;
    }

    _lastBackPressed = now;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppStrings.backToExitHint)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _goToBranch,
        ),
      ),
    );
  }
}
