// Widget test QR checkpoint admin (dialog + tombol kartu).
//
// Tombol QR di kartu membuka dialog kode + gambar untuk dicetak.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/admin/presentation/widgets/checkpoint_qr_sheet.dart';
import 'package:go_green/features/admin/presentation/widgets/tps_card.dart';
import 'package:go_green/features/checkpoints/domain/entities/checkpoint.dart';

Checkpoint _checkpoint() {
  return Checkpoint(
    id: 'cp-1',
    name: 'TPS Kelurahan',
    latitude: -6.2,
    longitude: 106.816667,
    radius: 100,
    qrCode: 'CP-001',
    createdAt: DateTime(2026, 9, 20),
  );
}

void main() {
  testWidgets('dialog QR menampilkan kode + gambar + petunjuk',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (BuildContext context) => Scaffold(
              body: TextButton(
                onPressed: () =>
                    showCheckpointQrDialog(context, _checkpoint()),
                child: const Text('buka'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('buka'));
    await tester.pumpAndSettle();

    expect(find.text('CP-001'), findsWidgets);
    expect(find.byType(PrettyQrView), findsOneWidget);
    expect(find.text(AppStrings.adminQrPrintHint), findsOneWidget);

    await tester.tap(find.text(AppStrings.closeButton));
    await tester.pumpAndSettle();
    expect(find.byType(PrettyQrView), findsNothing);
  });

  testWidgets('tombol QR di kartu membuka dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: TpsCard(
              checkpoint: _checkpoint(),
              onEdit: () {},
              onDeactivate: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip(AppStrings.adminQrShowTooltip));
    await tester.pumpAndSettle();

    expect(find.byType(PrettyQrView), findsOneWidget);
  });
}
