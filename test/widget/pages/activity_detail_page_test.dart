// Widget test halaman detail aktivitas.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/activity/presentation/pages/activity_detail_page.dart';

void main() {
  testWidgets('menampilkan status, deskripsi, dan detail aktivitas',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const ActivityDetailPage(activityId: '1'),
      ),
    );

    expect(find.text(AppStrings.activityDetailTitle), findsOneWidget);
    expect(find.text(AppStrings.activityStatusTitle), findsOneWidget);
    expect(find.text(AppStrings.activityDetailDateLabel), findsOneWidget);
    expect(find.text(AppStrings.activityDetailCheckpointLabel), findsOneWidget);
    expect(find.text(AppStrings.activityDetailPointLabel), findsOneWidget);
    expect(
      find.text(AppStrings.activityDetailCheckpointLabel),
      findsOneWidget,
    );
  });

  testWidgets('menampilkan poin dengan tanda plus untuk poin positif',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const ActivityDetailPage(activityId: '1'),
      ),
    );

    expect(find.text('+25 Poin'), findsOneWidget);
    expect(find.text(AppStrings.wasteCheckpointTps), findsOneWidget);
  });

  testWidgets('aktivitas tidak dikenal memakai data pertama',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const ActivityDetailPage(activityId: '999'),
      ),
    );

    expect(find.text('+25 Poin'), findsOneWidget);
  });

  testWidgets('kartu aktivitas membuka halaman detail',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            initialLocation: '/activity',
            routes: appRoutes,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.activityDemoDesc1));
    await tester.pumpAndSettle();

    expect(find.byType(ActivityDetailPage), findsOneWidget);
    expect(find.text(AppStrings.activityDetailTitle), findsOneWidget);
  });
}