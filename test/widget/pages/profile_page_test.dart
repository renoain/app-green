// Widget test halaman profil: status belum login vs sudah login.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/auth/domain/entities/auth_session.dart';
import 'package:go_green/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_green/features/profile/presentation/pages/profile_page.dart';

import '../../support/fake_auth_repository.dart';

/// AuthNotifier yang diinisialisasi dalam status sudah login.
class _AuthenticatedAuth extends AuthNotifier {
  _AuthenticatedAuth(String email)
      : super(FakeAuthRepository(session: AuthSession(userEmail: email)));
}

void main() {
  Widget buildApp(List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const ProfilePage(),
      ),
    );
  }

  testWidgets('belum login: menampilkan notice login tanpa Keluar',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildApp(<Override>[]));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.profileTitle), findsOneWidget);
    expect(find.text(AppStrings.guestName), findsOneWidget);
    expect(find.text(AppStrings.profileLoginNotice), findsOneWidget);
    expect(find.text(AppStrings.settings), findsOneWidget);
    expect(find.text(AppStrings.editProfile), findsNothing);
    expect(find.text(AppStrings.logout), findsNothing);
  });

  testWidgets('sudah login: tidak ada notice, ada Edit Profil dan Keluar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildApp(<Override>[
        authNotifierProvider.overrideWith(
          (ref) => _AuthenticatedAuth('budi@mail.com'),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.profileLoginNotice), findsNothing);
    expect(find.text('budi@mail.com'), findsOneWidget);
    expect(find.text(AppStrings.editProfile), findsOneWidget);
    expect(find.text(AppStrings.settings), findsOneWidget);
    expect(find.text(AppStrings.logout), findsOneWidget);
  });
}