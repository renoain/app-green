// Unit test ringkasan Home (BuildHomeSummaryUsecase).

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/core/constants/app_values.dart';
import 'package:go_green/features/home/domain/usecases/build_home_summary_usecase.dart';
import 'package:go_green/features/waste/domain/entities/waste_log.dart';

WasteLog _log(String id, DateTime createdAt, WasteLogStatus status) {
  return WasteLog(
    id: id,
    userId: 'user-1',
    category: WasteCategory.organik,
    serverTimestamp: createdAt,
    status: status,
    createdAt: createdAt,
  );
}

void main() {
  const BuildHomeSummaryUsecase usecase = BuildHomeSummaryUsecase();

  test('awal minggu adalah Senin 00.00', () {
    expect(
      BuildHomeSummaryUsecase.weekStart(DateTime(2026, 9, 23)),
      DateTime(2026, 9, 21),
    );
    expect(
      BuildHomeSummaryUsecase.weekStart(DateTime(2026, 9, 21)),
      DateTime(2026, 9, 21),
    );
  });

  test('hitung total, mingguan, dan terverifikasi', () {
    final HomeSummary summary = usecase.build(
      logs: <WasteLog>[
        _log('1', DateTime(2026, 9, 22, 10), WasteLogStatus.verified),
        _log('2', DateTime(2026, 9, 23, 8), WasteLogStatus.pending),
        _log('3', DateTime(2026, 9, 13, 8), WasteLogStatus.verified),
      ],
      now: DateTime(2026, 9, 23, 12),
    );
    expect(summary.totalDisposals, 3);
    expect(summary.weeklyDisposals, 2);
    expect(summary.verifiedCount, 2);
    expect(
      summary.missionProgress,
      2 / AppValues.weeklyMissionTargetDisposals,
    );
  });

  test('progres dibatasi 0..1 dan kosong nol', () {
    final HomeSummary full = usecase.build(
      logs: <WasteLog>[
        for (int i = 0; i < 10; i++)
          _log('$i', DateTime(2026, 9, 22, 8), WasteLogStatus.verified),
      ],
      now: DateTime(2026, 9, 23),
    );
    expect(full.missionProgress, 1.0);

    final HomeSummary empty = usecase.build(
      logs: const <WasteLog>[],
      now: DateTime(2026, 9, 23),
    );
    expect(empty.totalDisposals, 0);
    expect(empty.weeklyDisposals, 0);
    expect(empty.verifiedCount, 0);
    expect(empty.missionProgress, 0.0);
  });
}
