// Widget test halaman edit profil.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/router/app_router.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/auth/domain/entities/auth_session.dart';
import 'package:go_green/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_green/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:go_green/features/profile/presentation/pages/profile_page.dart';

import '../../support/fake_auth_repository.dart';

class _AuthenticatedAuth extends AuthNotifier {
  _AuthenticatedAuth(String email)
      : super(FakeAuthRepository(session: AuthSession(userEmail: email)));
}

void main() {
  Future<void> pumpEditProfile(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            initialLocation: '/edit-profile',
            routes: appRoutes,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('menampilkan form nama dan email sesuai data demo',
      (WidgetTester tester) async {
    await pumpEditProfile(tester);

    expect(find.byType(EditProfilePage), findsOneWidget);
    expect(find.text(AppStrings.editProfileCaption), findsOneWidget);
    expect(find.text(AppStrings.nameLabel), findsOneWidget);
    expect(find.text(AppStrings.emailLabel), findsOneWidget);
    final TextFormField nameField =
        tester.widget<TextFormField>(find.byType(TextFormField).at(0));
    final TextFormField emailField =
        tester.widget<TextFormField>(find.byType(TextFormField).at(1));
    expect(nameField.controller!.text, AppStrings.guestName);
    expect(emailField.controller!.text, AppStrings.profileDemoEmail);
    expect(find.text(AppStrings.saveButton), findsOneWidget);
  });

  testWidgets('simpan profil menampilkan snackbar sukses dan kembali',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          authNotifierProvider.overrideWith(
            (ref) => _AuthenticatedAuth('budi@mail.com'),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            initialLocation: '/profile',
            routes: appRoutes,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.editProfile));
    await tester.pumpAndSettle();
    expect(find.byType(EditProfilePage), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Warga Baru');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'warga.baru@go-green.id',
    );
    await tester.tap(find.text(AppStrings.saveButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.profileSaved), findsOneWidget);
    expect(find.byType(ProfilePage), findsOneWidget);
  });

  testWidgets('nama kosong memunculkan error validasi',
      (WidgetTester tester) async {
    await pumpEditProfile(tester);

    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.tap(find.text(AppStrings.saveButton));
    await tester.pump();

    expect(find.text(AppStrings.errorNameRequired), findsOneWidget);
    expect(find.text(AppStrings.profileSaved), findsNothing);
  });
}