// Widget test komponen status: StatusChip.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/status_widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  group('StatusChip', () {
    testWidgets('menampilkan label tipe success', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const StatusChip(label: 'Berhasil', type: StatusType.success),
        ),
      );

      expect(find.text('Berhasil'), findsOneWidget);
    });

    testWidgets('menampilkan label tipe warning', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const StatusChip(
            label: 'Menunggu verifikasi',
            type: StatusType.warning,
          ),
        ),
      );

      expect(find.text('Menunggu verifikasi'), findsOneWidget);
    });

    testWidgets('default tipe adalah success', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const StatusChip(label: 'Berhasil'),
        ),
      );

      expect(find.text('Berhasil'), findsOneWidget);
    });
  });
}