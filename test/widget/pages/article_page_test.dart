// Widget test halaman daftar dan detail artikel.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/article/presentation/pages/article_detail_page.dart';
import 'package:go_green/features/article/presentation/pages/article_page.dart';

Widget _articleRouter() {
  return ProviderScope(
    child: MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: GoRouter(
        initialLocation: '/article',
        routes: appRoutes,
      ),
    ),
  );
}

void main() {
  group('ArticlePage', () {
    testWidgets('menampilkan empat artikel demo', (WidgetTester tester) async {
      await tester.pumpWidget(_articleRouter());

      expect(find.byType(ArticlePage), findsOneWidget);
      expect(find.text(AppStrings.homeArticle1Title), findsOneWidget);
      expect(find.text(AppStrings.homeArticle4Title), findsOneWidget);
    });

    testWidgets('mencari artikel sesuai kata kunci', (WidgetTester tester) async {
      await tester.pumpWidget(_articleRouter());

      await tester.enterText(find.byType(TextField), 'kompos');
      await tester.pump();

      expect(find.text(AppStrings.homeArticle2Title), findsOneWidget);
      expect(find.text(AppStrings.homeArticle1Title), findsNothing);
    });

    testWidgets('menampilkan empty state saat pencarian tanpa hasil',
        (WidgetTester tester) async {
      await tester.pumpWidget(_articleRouter());

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump();

      expect(find.text(AppStrings.articleNoResultsTitle), findsOneWidget);
      expect(find.text(AppStrings.articleNoResultsMessage), findsOneWidget);
    });

    testWidgets('membuka detail saat artikel ditekan', (WidgetTester tester) async {
      await tester.pumpWidget(_articleRouter());

      await tester.tap(find.text(AppStrings.homeArticle1Title));
      await tester.pumpAndSettle();

      expect(find.byType(ArticleDetailPage), findsOneWidget);
      expect(find.text(AppStrings.articleContentP1), findsOneWidget);
    });
  });

  group('ArticleDetailPage', () {
    testWidgets('menampilkan judul, tanggal, dan konten', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const ArticleDetailPage(articleId: '1'),
        ),
      );

      expect(find.text(AppStrings.homeArticle1Title), findsOneWidget);
      expect(find.text('10 Sep 2026'), findsOneWidget);
      expect(find.text(AppStrings.articleContentP1), findsOneWidget);
      expect(find.text(AppStrings.articleContentP3), findsOneWidget);
    });
  });
}