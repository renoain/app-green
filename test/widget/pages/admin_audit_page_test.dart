// Widget test halaman log audit admin.
//
// Daftar log + empty state memakai override datasource; tanpa Supabase.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/admin/data/datasources/admin_audit_datasource.dart';
import 'package:go_green/features/admin/domain/entities/audit_log.dart';
import 'package:go_green/features/admin/presentation/pages/admin_audit_page.dart';
import 'package:go_green/features/admin/presentation/providers/admin_audit_provider.dart';

/// Datasource audit palsu berisi 2 baris.
class _FakeAuditWithRows extends AdminAuditDatasource {
  _FakeAuditWithRows() : super(client: null);

  @override
  Future<void> log({
    required String action,
    required String entity,
    String? entityId,
    String? detail,
  }) async {}

  @override
  Future<List<AuditLog>> getRecent({int limit = 50}) async {
    return <AuditLog>[
      AuditLog(
        id: 'l1',
        actorId: 'a1',
        actorName: 'admin1',
        action: AuditAction.create,
        entity: AuditEntity.reward,
        entityId: 'r1',
        detail: 'Sembako',
        createdAt: DateTime(2026, 9, 23),
      ),
      AuditLog(
        id: 'l2',
        actorId: 'a1',
        actorName: 'admin1',
        action: AuditAction.approve,
        entity: AuditEntity.verification,
        entityId: 'w1',
        createdAt: DateTime(2026, 9, 23),
      ),
    ];
  }
}

/// Datasource audit palsu kosong.
class _FakeAuditEmpty extends AdminAuditDatasource {
  _FakeAuditEmpty() : super(client: null);

  @override
  Future<void> log({
    required String action,
    required String entity,
    String? entityId,
    String? detail,
  }) async {}

  @override
  Future<List<AuditLog>> getRecent({int limit = 50}) async => <AuditLog>[];
}

void main() {
  testWidgets('daftar log menampilkan aksi + pelaku',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          adminAuditDatasourceProvider
              .overrideWithValue(_FakeAuditWithRows()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const AdminAuditPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.adminAuditLog), findsWidgets);
    expect(find.textContaining('Tambah'), findsOneWidget);
    expect(find.textContaining('Setujui'), findsOneWidget);
    expect(find.textContaining('admin1'), findsWidgets);
    expect(find.textContaining('Sembako'), findsOneWidget);
  });

  testWidgets('log kosong menampilkan empty state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          adminAuditDatasourceProvider.overrideWithValue(_FakeAuditEmpty()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const AdminAuditPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.adminAuditEmpty), findsOneWidget);
  });
}
