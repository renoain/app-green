// Use case grafik setoran 7 hari untuk dasbor admin (domain).

/// Satu batang grafik harian.
class DailyWasteCount {
  const DailyWasteCount({required this.label, required this.count});

  /// Label hari singkat (Sen..Min).
  final String label;

  /// Jumlah setoran hari itu.
  final int count;
}

/// Use case membangun 7 batang grafik dari timestamp waste.
class BuildWeeklyChartUsecase {
  const BuildWeeklyChartUsecase();

  /// Label hari singkat Indonesia untuk [date].
  static String dayLabel(DateTime date) {
    return switch (date.weekday) {
      DateTime.monday => 'Sen',
      DateTime.tuesday => 'Sel',
      DateTime.wednesday => 'Rab',
      DateTime.thursday => 'Kam',
      DateTime.friday => 'Jum',
      DateTime.saturday => 'Sab',
      _ => 'Min',
    };
  }

  /// Kelompokkan [timestamps] ke 7 hari terakhir berakhir di [now].
  List<DailyWasteCount> build({
    required List<DateTime> timestamps,
    DateTime? now,
  }) {
    final DateTime ref = now ?? DateTime.now();
    final DateTime today = DateTime(ref.year, ref.month, ref.day);
    return List<DailyWasteCount>.generate(7, (int i) {
      final DateTime day = today.subtract(Duration(days: 6 - i));
      final DateTime next = day.add(const Duration(days: 1));
      int count = 0;
      for (final DateTime ts in timestamps) {
        if (!ts.isBefore(day) && ts.isBefore(next)) count++;
      }
      return DailyWasteCount(label: dayLabel(day), count: count);
    });
  }
}
