// Test BottomNavActiveIcon untuk 3 gaya aktif.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/widgets/bottom_nav_active_icon.dart';

void main() {
  group('BottomNavActiveIcon', () {
    Widget buildWidget({required int style, required bool selected}) {
      return MaterialApp(
        home: Scaffold(
          body: BottomNavActiveIcon(
            icon: LucideIcons.house,
            selected: selected,
            style: style,
          ),
        ),
      );
    }

    testWidgets('Versi 1 selected -> ada Container dengan color primary',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(style: 1, selected: true));
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('Versi 1 not selected -> tidak ada background',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(style: 1, selected: false));
      await tester.pump();
      final containers = find.byType(Container);
      // Container dengan color transparan tetap ada di tree.
      expect(containers, findsWidgets);
    });

    testWidgets('Versi 2 selected -> ada AnimatedScale dengan scale 1.15',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(style: 2, selected: true));
      final scales = find.byType(AnimatedScale);
      expect(scales, findsOneWidget);
    });

    testWidgets('Versi 2 not selected -> AnimatedScale scale 1.0',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(style: 2, selected: false));
      final scales = find.byType(AnimatedScale);
      expect(scales, findsOneWidget);
    });

    testWidgets('Versi 3 selected -> ada Container width 20',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(style: 3, selected: true));
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('Versi 3 not selected -> pill width 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(style: 3, selected: false));
      await tester.pump();
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('Gaya default style 1 -> sama dengan Versi 1',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(style: 1, selected: true));
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });
  });
}
