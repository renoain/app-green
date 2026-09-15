// Test minimal: pastikan widget utama (GoGreenApp) bisa di-build.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/main.dart';

void main() {
  testWidgets('GoGreenApp dapat di-build', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: GoGreenApp()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}