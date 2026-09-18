// Widget test reproduksi masalah navigasi back pada free routes.
//
// Memakai appRoutes asli dari lib/core/router dengan initial location /home
// agar halaman berada dalam StatefulShellRoute seperti di aplikasi nyata.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/article/presentation/pages/article_detail_page.dart';
import 'package:go_green/features/article/presentation/pages/article_page.dart';
import 'package:go_green/features/home/presentation/pages/home_page.dart';
import 'package:go_green/features/points/presentation/pages/points_page.dart';
import 'package:go_green/features/points/presentation/pages/reward_detail_page.dart';

Widget _app() {
  return ProviderScope(
    child: MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: GoRouter(
        initialLocation: '/${AppRouteName.home}',
        routes: appRoutes,
      ),
    ),
  );
}

void main() {
  testWidgets('back dari daftar artikel kembali ke Home',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(AppStrings.seeAll),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.seeAll));
    await tester.pumpAndSettle();

    expect(find.byType(ArticlePage), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.arrow_left));
    await tester.pumpAndSettle();

    expect(find.byType(ArticlePage), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('back dari detail artikel kembali ke daftar artikel',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(AppStrings.seeAll),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.seeAll));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.homeArticle1Title));
    await tester.pumpAndSettle();

    expect(find.byType(ArticleDetailPage), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.arrow_left));
    await tester.pumpAndSettle();

    expect(find.byType(ArticleDetailPage), findsNothing);
    expect(find.byType(ArticlePage), findsOneWidget);
  });

  testWidgets('back dari detail artikel langsung dari Home',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(AppStrings.homeArticle1Title),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.homeArticle1Title));
    await tester.pumpAndSettle();

    expect(find.byType(ArticleDetailPage), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.arrow_left));
    await tester.pumpAndSettle();

    expect(find.byType(ArticleDetailPage), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('back dari detail reward kembali ke Points',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.navPoints));
    await tester.pumpAndSettle();

    expect(find.byType(PointsPage), findsOneWidget);

    final Finder rewardCard = find.text(AppStrings.rewardSembako);
    await tester.scrollUntilVisible(
      rewardCard,
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(rewardCard.first);
    await tester.pumpAndSettle();

    expect(find.byType(RewardDetailPage), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.arrow_left));
    await tester.pumpAndSettle();

    expect(find.byType(RewardDetailPage), findsNothing);
    expect(find.byType(PointsPage), findsOneWidget);
  });
}