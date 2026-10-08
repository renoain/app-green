// Widget test MorphingNextButton (lingkaran panah vs pil label).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/features/onboarding/widgets/morphing_next_button.dart';

Widget _harness({required bool expanded}) {
  return MaterialApp(
    home: Scaffold(
      body: MorphingNextButton(
        label: 'Mulai',
        expanded: expanded,
        onPressed: () {},
      ),
    ),
  );
}

void main() {
  testWidgets('mode lingkaran tampilkan ikon tanpa label', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_harness(expanded: false));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('morph-circle')), findsOneWidget);
    expect(find.text('Mulai'), findsNothing);
  });

  testWidgets('mode pil tampilkan label dan ikon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_harness(expanded: true));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('morph-pill')), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
  });

  testWidgets('ketuk tombol memanggil onPressed', (
    WidgetTester tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MorphingNextButton(
            label: 'Mulai',
            expanded: true,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(MorphingNextButton));
    expect(tapped, isTrue);
  });
}
