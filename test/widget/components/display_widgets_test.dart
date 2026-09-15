// Widget test komponen display: Avatar, StatItem, ListTileItem.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/display_widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  group('Avatar', () {
    testWidgets('menampilkan inisial dari dua kata', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(const Avatar(name: 'Warga Go Green', size: 64)),
      );

      expect(find.text('WG'), findsOneWidget);
    });

    testWidgets('menampilkan satu inisial untuk nama satu kata', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(const Avatar(name: 'Budi')),
      );

      expect(find.text('B'), findsOneWidget);
    });
  });

  group('StatItem', () {
    testWidgets('menampilkan nilai dan label', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const StatItem(
            value: '250',
            label: 'Total Poin',
            icon: LucideIcons.coins,
          ),
        ),
      );

      expect(find.text('250'), findsOneWidget);
      expect(find.text('Total Poin'), findsOneWidget);
    });
  });

  group('ListTileItem', () {
    testWidgets('menampilkan judul dan memicu onTap', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrap(
          ListTileItem(
            title: 'Edit Profil',
            icon: LucideIcons.pencil,
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Edit Profil'), findsOneWidget);
      await tester.tap(find.text('Edit Profil'));
      expect(tapped, isTrue);
    });

    testWidgets('menampilkan subtitle bila disediakan', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const ListTileItem(
            title: 'Pengaturan',
            subtitle: 'Notifikasi dan privasi',
            icon: LucideIcons.settings,
          ),
        ),
      );

      expect(find.text('Pengaturan'), findsOneWidget);
      expect(find.text('Notifikasi dan privasi'), findsOneWidget);
    });
  });
}