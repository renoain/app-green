// Widget test seksi forensik di detail verifikasi admin.
//
// Skor + level + badge EXIF + alasan tampil dari log; data lama
// tanpa skor menampilkan pesan belum dinilai.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/core/constants/app_strings.dart';
import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/features/admin/presentation/pages/admin_waste_detail_page.dart';
import 'package:go_green/features/waste/domain/entities/waste_log.dart';

WasteLog _log({int? score, bool? exifOk, String? detail}) {
  final DateTime now = DateTime(2026, 9, 24);
  return WasteLog(
    id: 'w1',
    userId: 'u1',
    category: WasteCategory.anorganik,
    serverTimestamp: now,
    status: WasteLogStatus.pending,
    createdAt: now,
    riskScore: score,
    exifOk: exifOk,
    riskDetail: detail,
  );
}

void main() {
  testWidgets('skor tinggi tampil level + alasan + badge EXIF',
      (WidgetTester tester) async {
    // Halaman panjang: viewport tinggi agar seksi terbawah ter-build.
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: AdminWasteDetailPage(
            logId: 'w1',
            log: _log(
              score: 75,
              exifOk: false,
              detail: 'no_exif,edited_software',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.forensicTitle), findsOneWidget);
    expect(find.textContaining('75/100'), findsOneWidget);
    expect(find.textContaining(AppStrings.forensicHigh), findsOneWidget);
    expect(find.text(AppStrings.forensicExifBad), findsOneWidget);
    expect(find.text(AppStrings.forensicNoExif), findsOneWidget);
    expect(find.text(AppStrings.forensicEdited), findsOneWidget);
  });

  testWidgets('data lama tanpa skor tampil belum dinilai',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: AdminWasteDetailPage(logId: 'w1', log: _log()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.forensicTitle), findsOneWidget);
    expect(find.text(AppStrings.forensicUnassessed), findsOneWidget);
  });
}
