// Widget test untuk komponen input: CustomTextField dan SearchField.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/custom_text_field_widget.dart';

void main() {
  group('CustomTextField', () {
    testWidgets('menampilkan label dan hint', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: CustomTextField(label: 'Email', hint: 'nama@email.com'),
        ),
      ),);

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('nama@email.com'), findsOneWidget);
    });

    testWidgets('menjalankan validator dan menampilkan error', (WidgetTester tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Form(
            key: formKey,
            child: CustomTextField(
              validator: (String? value) => 'Kata sandi tidak cocok',
            ),
          ),
        ),
      ),);

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Kata sandi tidak cocok'), findsOneWidget);
    });

    testWidgets('menyembunyikan teks saat obscureText', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: CustomTextField(obscureText: true),
        ),
      ),);

      final TextField field = tester.widget<TextField>(
        find
            .descendant(
              of: find.byType(TextFormField),
              matching: find.byType(TextField),
            )
            .first,
      );
      expect(field.obscureText, isTrue);
    });
  });

  group('SearchField', () {
    testWidgets('menampilkan hint dan memicu onChanged', (WidgetTester tester) async {
      String? changed;

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SearchField(
            hint: 'Cari artikel',
            onChanged: (String value) => changed = value,
          ),
        ),
      ),);

      expect(find.text('Cari artikel'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'sampah');
      expect(changed, 'sampah');
    });
  });
}