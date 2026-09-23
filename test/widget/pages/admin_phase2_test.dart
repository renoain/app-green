// Widget test halaman admin fase 2 lanjutan (rewards, users, settings).
//
// Rewards/users memakai override provider agar tanpa Supabase;
// settings info langsung tanpa backend.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/admin/data/datasources/admin_users_datasource.dart';
import 'package:go_green/features/admin/domain/entities/admin_user.dart';
import 'package:go_green/features/admin/presentation/pages/admin_rewards_page.dart';
import 'package:go_green/features/admin/presentation/pages/admin_settings_page.dart';
import 'package:go_green/features/admin/presentation/pages/admin_users_page.dart';
import 'package:go_green/features/admin/presentation/providers/admin_users_provider.dart';
import 'package:go_green/features/rewards/data/datasources/reward_remote_datasource.dart';
import 'package:go_green/features/rewards/data/models/reward_model.dart';
import 'package:go_green/features/rewards/presentation/providers/reward_provider.dart';

/// Datasource reward palsu dengan 2 item admin.
class _FakeRewardDatasource extends RewardRemoteDatasource {
  _FakeRewardDatasource() : super(client: null, pointsDatasource: null);

  @override
  Future<List<RewardModel>> getAllForAdmin() async {
    return <RewardModel>[
      RewardModel(
        id: 'r1',
        name: 'Paket Sembako',
        description: 'Sembako mingguan',
        pointsCost: 300,
        stock: 5,
        isActive: true,
        createdAt: DateTime(2026, 9, 1),
      ),
      RewardModel(
        id: 'r2',
        name: 'Voucher Belanja',
        description: null,
        pointsCost: 500,
        stock: 0,
        isActive: false,
        createdAt: DateTime(2026, 9, 2),
      ),
    ];
  }
}

/// Datasource user palsu dengan 2 user.
class _FakeUsersDatasource extends AdminUsersDatasource {
  _FakeUsersDatasource() : super(client: null);

  @override
  Future<List<AdminUser>> getUsers({int limit = 50}) async {
    return <AdminUser>[
      AdminUser(
        id: 'u1',
        username: 'budi_hijau',
        email: 'budi@mail.com',
        role: UserRole.user,
        createdAt: DateTime(2026, 9, 1),
      ),
      AdminUser(
        id: 'u2',
        username: 'admin1',
        email: 'admin1@green.com',
        role: UserRole.admin,
        createdAt: DateTime(2026, 9, 2),
      ),
    ];
  }
}

void main() {
  testWidgets('admin rewards menampilkan daftar + tambah + switch',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          rewardRemoteDatasourceProvider
              .overrideWithValue(_FakeRewardDatasource()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const AdminRewardsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.adminManageReward), findsWidgets);
    expect(find.text('Paket Sembako'), findsOneWidget);
    expect(find.text('Voucher Belanja'), findsOneWidget);
    expect(find.text(AppStrings.adminRewardManageNote), findsOneWidget);
    expect(find.text(AppStrings.adminRewardAdd), findsOneWidget);
    expect(find.byType(Switch), findsWidgets);
  });

  testWidgets('admin users menampilkan daftar user + role',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          adminUsersDatasourceProvider
              .overrideWithValue(_FakeUsersDatasource()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const AdminUsersPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('budi_hijau'), findsOneWidget);
    expect(find.text('admin1'), findsOneWidget);
    expect(find.textContaining('Role:'), findsWidgets);
  });

  testWidgets('admin settings menampilkan info aplikasi + fase 2',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const AdminSettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.adminSettingsAppTitle), findsOneWidget);
    expect(
      find.text(AppStrings.adminSettingsSecurityTitle),
      findsOneWidget,
    );
    expect(
      find.text(AppStrings.adminSettingsMissionTitle),
      findsOneWidget,
    );
    expect(find.text(AppStrings.adminSettingsPhaseNote), findsOneWidget);
  });
}
