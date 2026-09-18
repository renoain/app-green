// Widget test notice login di Home: muncul, bisa ditutup, dan aksi Masuk
// membuka halaman Login. Route memakai appRoutes dari lib/core/router.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/auth/domain/entities/auth_session.dart';
import 'package:go_green/features/auth/presentation/pages/login_page.dart';
import 'package:go_green/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_green/features/home/presentation/pages/home_page.dart';

import '../../support/fake_auth_repository.dart';

class _AuthenticatedAuth extends AuthNotifier {
  _AuthenticatedAuth(String email, {String? displayName, String? username})
      : super(
          FakeAuthRepository(
            session: AuthSession(
              userEmail: email,
              displayName: displayName,
              username: username,
            ),
          ),
        );
}

void main() {
  Widget buildApp({List<Override> overrides = const <Override>[]}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: GoRouter(
          initialLocation: '/${AppRouteName.home}',
          routes: appRoutes,
        ),
      ),
    );
  }

  testWidgets('notice login tampil di Home dengan aksi Masuk',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.homeLoginNotice), findsOneWidget);
    expect(find.text(AppStrings.homeLoginNoticeAction), findsOneWidget);
  });

  testWidgets('notice login bisa ditutup', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip(AppStrings.homeLoginNoticeDismiss));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.homeLoginNotice), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('aksi Masuk membuka halaman Login', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.homeLoginNoticeAction));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('notice tidak tampil saat sudah login', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildApp(
        overrides: <Override>[
          authNotifierProvider.overrideWith(
            (ref) => _AuthenticatedAuth('budi@mail.com'),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.homeLoginNotice), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('nama tampilan muncul di header Home saat sudah login',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildApp(
        overrides: <Override>[
          authNotifierProvider.overrideWith(
            (ref) => _AuthenticatedAuth(
              'budi@mail.com',
              displayName: 'Budi Hijau',
              username: 'budi_hijau',
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.homeLoginNotice), findsNothing);
    expect(find.text('Budi Hijau'), findsOneWidget);
    expect(find.text(AppStrings.greeting), findsOneWidget);
  });

  testWidgets('belum login: header menampilkan nama tamu + notice',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.guestName), findsOneWidget);
    expect(find.text(AppStrings.homeLoginNotice), findsOneWidget);
  });
}