// Widget test komponen feedback: EmptyState.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/feedback_widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  group('EmptyState', () {
    testWidgets('menampilkan judul dan pesan', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const EmptyState(
            icon: LucideIcons.search,
            title: 'Artikel tidak ditemukan',
            message: 'Coba kata kunci lain.',
          ),
        ),
      );

      expect(find.text('Artikel tidak ditemukan'), findsOneWidget);
      expect(find.text('Coba kata kunci lain.'), findsOneWidget);
    });

    testWidgets('memicu onAction saat tombol ditekan', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrap(
          EmptyState(
            icon: LucideIcons.search,
            title: 'Artikel tidak ditemukan',
            message: 'Coba kata kunci lain.',
            actionText: 'Kembali',
            onAction: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Kembali'));
      expect(tapped, isTrue);
    });
  });
}