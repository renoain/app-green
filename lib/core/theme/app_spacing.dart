// Menyimpan seluruh token spacing aplikasi sesuai docs/DESIGN_SYSTEM.md.
//
// Semua spacing kelipatan 4. Wajib dipakai di widget, dilarang hardcode
// EdgeInsets.all(...) langsung.

/// Token spacing aplikasi Go Green.
class AppSpacing {
  AppSpacing._();

  /// Spacing terkecil, 4px.
  static const double xs = 4;

  /// Spacing kecil, 8px.
  static const double sm = 8;

  /// Spacing medium, 16px.
  static const double md = 16;

  /// Spacing besar, 24px.
  static const double lg = 24;

  /// Spacing terbesar, 32px.
  static const double xl = 32;
}