// Use case perhitungan poin (domain).
//
// Aturan bisnis MVP: poin dasar tetap + bonus per kategori + bonus streak.
// Nilai konstanta terpusat di AppValues agar mudah diubah tanpa menyentuh
// widget.

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_values.dart';

/// Use case menghitung estimasi poin dari satu pembuangan sampah.
class CalculatePointsUsecase {
  /// Membuat use case (stateless).
  const CalculatePointsUsecase();
  /// Menghitung total poin untuk [category] dengan [currentStreakDays]
  /// hari beruntun membuang sampah.
  ///
  /// Formula: poin dasar + bonus kategori + bonus streak (bila streak
  /// melewati ambang [AppValues.streakBonusThreshold]).
  int calculate({
    required WasteCategory category,
    int currentStreakDays = 0,
  }) {
    final int streak = currentStreakDays < 0 ? 0 : currentStreakDays;
    final int categoryBonus = switch (category) {
      WasteCategory.organik => AppValues.categoryBonusOrganik,
      WasteCategory.anorganik => AppValues.categoryBonusAnorganik,
      WasteCategory.daurUlang => AppValues.categoryBonusDaurUlang,
      WasteCategory.b3 => AppValues.categoryBonusB3,
    };
    final int streakBonus = streak >= AppValues.streakBonusThreshold
        ? AppValues.streakBonusPoints
        : 0;
    return AppValues.basePointsPerWaste + categoryBonus + streakBonus;
  }
}