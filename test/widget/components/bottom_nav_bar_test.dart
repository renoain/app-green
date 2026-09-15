// Widget test CustomBottomNavBar.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/custom_bottom_nav_bar_widget.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('menampilkan lima label navigasi', (WidgetTester tester) async {
    await tester.pumpWidget(
      _wrap(
        CustomBottomNavBar(
          currentIndex: 0,
          onTap: (int index) {},
        ),
      ),
    );

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Aktivitas'), findsOneWidget);
    expect(find.text('Buang Sampah'), findsOneWidget);
    expect(find.text('Poin'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets('memanggil onTap dengan index saat item ditekan', (WidgetTester tester) async {
    int? tappedIndex;

    await tester.pumpWidget(
      _wrap(
        CustomBottomNavBar(
          currentIndex: 0,
          onTap: (int index) => tappedIndex = index,
        ),
      ),
    );

    await tester.tap(find.text('Aktivitas'));
    expect(tappedIndex, 1);

    await tester.tap(find.text('Profil'));
    expect(tappedIndex, 4);
  });
}