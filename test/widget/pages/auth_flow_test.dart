// Widget test alur auth: Splash -> Onboarding -> Login/Register.
// Route memakai appRoutes dari lib/core/router.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/app_button_widgets.dart';
import 'package:go_green/core/widgets/custom_text_field_widget.dart';
import 'package:go_green/features/activity/presentation/pages/activity_page.dart';
import 'package:go_green/features/auth/presentation/pages/login_page.dart';
import 'package:go_green/features/home/presentation/pages/home_page.dart';
import 'package:go_green/features/onboarding/onboarding_page.dart';
import 'package:go_green/features/points/presentation/pages/points_page.dart';
import 'package:go_green/features/splash/splash_page.dart';

Widget _app(String initialLocation) {
  return ProviderScope(
    child: MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: GoRouter(
        initialLocation: initialLocation,
        routes: appRoutes,
      ),
    ),
  );
}

void main() {
  testWidgets('Splash berpindah ke Onboarding setelah jeda', (WidgetTester tester) async {
    await tester.pumpWidget(_app('/splash'));
    await tester.pump();

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text(AppStrings.appName), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingPage), findsOneWidget);
  });

  testWidgets('Onboarding menyelesaikan 3 slide lalu ke Home', (WidgetTester tester) async {
    await tester.pumpWidget(_app('/onboarding'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);

    await tester.tap(find.text(AppStrings.nextButton));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onboardingTitle2), findsOneWidget);

    await tester.tap(find.text(AppStrings.nextButton));
    await tester.pumpAndSettle();
    expect(find.byType(PrimaryButton), findsOneWidget);

    await tester.tap(find.text(AppStrings.startButton));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text(AppStrings.homeLoginNotice), findsOneWidget);
  });

  testWidgets('Onboarding tombol Lewati langsung ke Home', (WidgetTester tester) async {
    await tester.pumpWidget(_app('/onboarding'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.onboardingSkip));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text(AppStrings.homeLoginNotice), findsOneWidget);
  });

  testWidgets('Login menampilkan error saat form kosong', (WidgetTester tester) async {
    await tester.pumpWidget(_app('/login'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(find.text(AppStrings.errorEmailRequired), findsOneWidget);
    expect(find.text(AppStrings.errorPasswordRequired), findsOneWidget);
  });

  testWidgets('Login berpindah ke Home setelah form valid', (WidgetTester tester) async {
    await tester.pumpWidget(_app('/login'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(CustomTextField).at(0), 'budi@mail.com');
    await tester.enterText(find.byType(CustomTextField).at(1), 'rahasia123');
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('Register menampilkan error saat konfirmasi tidak cocok', (WidgetTester tester) async {
    await tester.pumpWidget(_app('/register'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(CustomTextField).at(0), 'Budi');
    await tester.enterText(find.byType(CustomTextField).at(1), 'budi@mail.com');
    await tester.enterText(find.byType(CustomTextField).at(2), 'rahasia123');
    await tester.enterText(find.byType(CustomTextField).at(3), 'berbeda999');
    await tester.ensureVisible(find.byType(PrimaryButton));
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(find.text(AppStrings.errorPasswordMismatch), findsOneWidget);
  });

  testWidgets('Register berpindah ke Login setelah form valid', (WidgetTester tester) async {
    await tester.pumpWidget(_app('/register'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(CustomTextField).at(0), 'Budi');
    await tester.enterText(find.byType(CustomTextField).at(1), 'budi@mail.com');
    await tester.enterText(find.byType(CustomTextField).at(2), 'rahasia123');
    await tester.enterText(find.byType(CustomTextField).at(3), 'rahasia123');
    await tester.ensureVisible(find.byType(PrimaryButton));
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('Home berpindah tab melalui bottom nav', (WidgetTester tester) async {
    await tester.pumpWidget(_app('/home'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);

    await tester.tap(find.text(AppStrings.navActivity));
    await tester.pumpAndSettle();

    expect(find.byType(ActivityPage), findsOneWidget);
  });

  testWidgets('back dari tab lain kembali ke tab Home dulu', (WidgetTester tester) async {
    await tester.pumpWidget(_app('/home'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.navPoints));
    await tester.pumpAndSettle();
    expect(find.byType(PointsPage), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('back pertama di tab Home hanya menampilkan hint keluar', (WidgetTester tester) async {
    await tester.pumpWidget(_app('/home'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text(AppStrings.backToExitHint), findsOneWidget);
  });
}