// Widget test halaman verifikasi.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/home/presentation/pages/home_page.dart';
import 'package:go_green/features/verification/presentation/data/verification_extra.dart';
import 'package:go_green/features/verification/presentation/pages/verification_page.dart';
import 'package:go_green/features/verification/presentation/widgets/points_earned_dialog.dart';

Widget _verificationRouter() {
  return ProviderScope(
    child: MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: GoRouter(
        initialLocation: '/verification',
        routes: appRoutes,
      ),
    ),
  );
}

Widget _verificationApp(VerificationExtra? extra) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: VerificationPage(extra: extra),
    ),
  );
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('menampilkan status, detail, dan tombol aksi',
      (WidgetTester tester) async {
    await tester.pumpWidget(_verificationRouter());

    expect(find.byType(VerificationPage), findsOneWidget);
    expect(find.text(AppStrings.verificationSuccess), findsNWidgets(2));
    expect(find.text(AppStrings.verificationTimestampLabel), findsOneWidget);
    expect(find.text(AppStrings.verificationLocationLabel), findsOneWidget);

    await _scrollTo(tester, find.text(AppStrings.verificationSubmitButton));
    expect(find.text(AppStrings.verificationPointsLabel), findsOneWidget);
    expect(find.text(AppStrings.verificationHashLabel), findsOneWidget);
    expect(find.text(AppStrings.verificationSubmitButton), findsOneWidget);
  });

  testWidgets('membuka dialog detail hash', (WidgetTester tester) async {
    await tester.pumpWidget(_verificationRouter());

    await _scrollTo(tester, find.text(AppStrings.verificationHashButton));
    await tester.tap(find.text(AppStrings.verificationHashButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.verificationHashDemo), findsWidgets);
  });

  testWidgets('kirim tanpa foto menampilkan snackbar',
      (WidgetTester tester) async {
    await tester.pumpWidget(_verificationRouter());

    await _scrollTo(tester, find.text(AppStrings.verificationSubmitButton));
    await tester.tap(find.text(AppStrings.verificationSubmitButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.genericError), findsOneWidget);
    expect(find.byType(VerificationPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets('menampilkan lokasi GPS dari data ekstra', (WidgetTester tester) async {    await tester.pumpWidget(
      _verificationApp(
        const VerificationExtra(locationLabel: '-6.200000, 106.816667'),
      ),
    );

    expect(find.text('-6.200000, 106.816667'), findsOneWidget);
    expect(find.text(AppStrings.verificationLocationDemo), findsNothing);
  });

  testWidgets('menampilkan pesan saat lokasi GPS gagal', (WidgetTester tester) async {
    await tester.pumpWidget(
      _verificationApp(
        const VerificationExtra(imagePath: '/tmp/bukti.jpg'),
      ),
    );

    expect(
      find.text(AppStrings.verificationLocationFailed),
      findsOneWidget,
    );
  });

  testWidgets('menampilkan timestamp dari data ekstra pada foto',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _verificationApp(
        const VerificationExtra(
          timestampLabel: '12 Sep 2026, 14.32 WIB',
          imagePath: '/tmp/bukti.jpg',
        ),
      ),
    );

    expect(find.text('12 Sep 2026, 14.32 WIB'), findsNWidgets(2));
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Coba Lagi pop kembali ke halaman sebelumnya', (WidgetTester tester) async {
    final GoRouter router = GoRouter(
      initialLocation: '/first',
      routes: <RouteBase>[
        GoRoute(
          path: '/first',
          name: 'first',
          builder: (BuildContext context, GoRouterState state) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => context.pushNamed(AppRouteName.verification),
                child: const Text('Buka Verification'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/verification',
          name: AppRouteName.verification,
          builder: (BuildContext context, GoRouterState state) =>
              VerificationPage(extra: state.extra as VerificationExtra?),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child:
            MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Buka Verification'));
    await tester.pumpAndSettle();
    expect(find.byType(VerificationPage), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(AppStrings.retryButton),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(AppStrings.retryButton));
    await tester.pumpAndSettle();
    expect(find.byType(VerificationPage), findsNothing);
    expect(find.text('Buka Verification'), findsOneWidget);
  });

  testWidgets('kategori bisa dipilih setelah foto', (WidgetTester tester) async {
    await tester.pumpWidget(_verificationRouter());
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.text(AppStrings.wasteCategoryTitle));
    expect(find.text(AppStrings.wasteCategoryTitle), findsOneWidget);
    expect(find.text(AppStrings.wasteCategoryDaurUlang), findsOneWidget);

    await _scrollTo(tester, find.text(AppStrings.verificationPointsLabel));
    expect(find.text('+25'), findsOneWidget);

    await _scrollTo(tester, find.text(AppStrings.wasteCategoryDaurUlang));
    await tester.tap(find.text(AppStrings.wasteCategoryDaurUlang));
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.text(AppStrings.verificationPointsLabel));
    expect(find.text('+35'), findsOneWidget);
  });

  testWidgets('popup poin tampil dengan animasi dan tombol',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (BuildContext context) => Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () => showPointsEarnedDialog(
                    context,
                    points: 35,
                  ),
                  child: const Text('Tampil'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tampil'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('+35'), findsOneWidget);
    expect(find.text(AppStrings.pointsEarnedTitle), findsOneWidget);
    expect(find.text(AppStrings.pointsEarnedMessage), findsOneWidget);

    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.pointsEarnedButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.pointsEarnedTitle), findsNothing);
  });
}
