// Unit test bucket grafik 7 hari dasbor admin.
//
// 7 batang berurutan, label Sen..Min, hitungan per hari kalender.

import 'package:flutter_test/flutter_test.dart';
import 'package:go_green/features/admin/domain/usecases/build_weekly_chart_usecase.dart';

void main() {
  // Rabu, 23 Sep 2026 (weekday Rabu).
  final DateTime now = DateTime(2026, 9, 23, 12);

  test('selalu 7 batang berurutan berakhir hari ini', () {
    final List<DailyWasteCount> days =
        const BuildWeeklyChartUsecase().build(timestamps: <DateTime>[], now: now);
    expect(days, hasLength(7));
    expect(days.last.label, 'Rab');
    expect(days.first.label, 'Kam');
    expect(days.every((DailyWasteCount d) => d.count == 0), isTrue);
  });

  test('timestamp masuk bucket hari kalender yang tepat', () {
    final List<DailyWasteCount> days =
        const BuildWeeklyChartUsecase().build(
      timestamps: <DateTime>[
        DateTime(2026, 9, 23, 8), // hari ini
        DateTime(2026, 9, 23, 20), // hari ini
        DateTime(2026, 9, 22, 10), // kemarin
        DateTime(2026, 9, 10, 10), // di luar jendela
      ],
      now: now,
    );
    expect(days.last.count, 2);
    expect(days[5].count, 1);
    expect(days.first.count, 0);
    final int total = days.fold<int>(
      0,
      (int sum, DailyWasteCount d) => sum + d.count,
    );
    expect(total, 3);
  });

  test('label semua hari valid', () {
    const List<String> valid = <String>[
      'Sen',
      'Sel',
      'Rab',
      'Kam',
      'Jum',
      'Sab',
      'Min',
    ];
    for (int i = 0; i < 7; i++) {
      final DateTime date = DateTime(2026, 9, 21 + i);
      expect(valid, contains(BuildWeeklyChartUsecase.dayLabel(date)));
    }
  });
}
