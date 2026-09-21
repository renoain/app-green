// Ringkasan angka dasbor admin (domain).

/// Angka ringkasan untuk dasbor admin.
class AdminDashboardSummary {
  /// Membuat ringkasan dasbor admin.
  const AdminDashboardSummary({
    required this.totalUsers,
    required this.totalCheckpoints,
    required this.wasteToday,
    required this.wastePending,
    required this.totalPoints,
  });

  /// Total user terdaftar.
  final int totalUsers;

  /// Total checkpoint terdaftar.
  final int totalCheckpoints;

  /// Total waste log hari ini.
  final int wasteToday;

  /// Total waste log menunggu verifikasi.
  final int wastePending;

  /// Total poin beredar (earn dikurangi redeem).
  final int totalPoints;
}
