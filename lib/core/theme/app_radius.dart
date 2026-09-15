// Menyimpan seluruh token border radius aplikasi sesuai docs/DESIGN_SYSTEM.md.
//
// Wajib dipakai di widget, dilarang hardcode BorderRadius.circular(...)
// langsung.

/// Token border radius aplikasi Go Green.
class AppRadius {
  AppRadius._();

  /// Radius kecil, 4px.
  static const double sm = 4;

  /// Radius medium, 8px.
  static const double md = 8;

  /// Radius besar, 12px.
  static const double lg = 12;

  /// Radius extra besar, 16px.
  static const double xl = 16;

  /// Radius paling besar untuk card, 20px.
  static const double xl2 = 20;

  /// Radius untuk bottom sheet, 32px.
  static const double sheet = 32;

  /// Radius penuh (lingkaran), 9999px.
  static const double full = 9999;
}