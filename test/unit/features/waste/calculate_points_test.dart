// Unit test logika perhitungan poin waste (CalculatePointsUsecase).

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/core/constants/app_values.dart';
import 'package:go_green/features/waste/domain/usecases/calculate_points_usecase.dart';

void main() {
  const CalculatePointsUsecase usecase = CalculatePointsUsecase();

  group('CalculatePointsUsecase.calculate', () {
    test('poin dasar tanpa bonus kategori atau streak', () {
      final int points = usecase.calculate(
        category: WasteCategory.organik,
        currentStreakDays: 0,
      );
      expect(points, AppValues.basePointsPerWaste);
      expect(points, 25);
    });

    test('bonus kategori anorganik', () {
      final int points = usecase.calculate(category: WasteCategory.anorganik);
      expect(
        points,
        AppValues.basePointsPerWaste + AppValues.categoryBonusAnorganik,
      );
      expect(points, 30);
    });

    test('bonus kategori daur ulang', () {
      final int points = usecase.calculate(category: WasteCategory.daurUlang);
      expect(
        points,
        AppValues.basePointsPerWaste + AppValues.categoryBonusDaurUlang,
      );
      expect(points, 35);
    });

    test('bonus kategori B3', () {
      final int points = usecase.calculate(category: WasteCategory.b3);
      expect(
        points,
        AppValues.basePointsPerWaste + AppValues.categoryBonusB3,
      );
      expect(points, 40);
    });

    test('bonus streak saat masih di bawah ambang', () {
      final int points = usecase.calculate(
        category: WasteCategory.organik,
        currentStreakDays: AppValues.streakBonusThreshold - 1,
      );
      expect(points, AppValues.basePointsPerWaste);
    });

    test('bonus streak saat menyentuh ambang', () {
      final int points = usecase.calculate(
        category: WasteCategory.organik,
        currentStreakDays: AppValues.streakBonusThreshold,
      );
      expect(
        points,
        AppValues.basePointsPerWaste + AppValues.streakBonusPoints,
      );
    });

    test('bonus streak di atas ambang digabung bonus kategori', () {
      final int points = usecase.calculate(
        category: WasteCategory.b3,
        currentStreakDays: 5,
      );
      expect(
        points,
        AppValues.basePointsPerWaste +
            AppValues.categoryBonusB3 +
            AppValues.streakBonusPoints,
      );
    });

    test('streak negatif diperlakukan sebagai nol', () {
      final int points = usecase.calculate(
        category: WasteCategory.organik,
        currentStreakDays: -3,
      );
      expect(points, AppValues.basePointsPerWaste);
    });
  });
}