// Menyimpan seluruh token elevation (shadow) sesuai docs/DESIGN_SYSTEM.md.
//
// Wajib dipakai di widget, dilarang hardcode BoxShadow langsung.

import 'package:flutter/material.dart';

/// Token elevation aplikasi Go Green.
class AppElevation {
  AppElevation._();

  /// Elevasi paling ringan, untuk card biasa.
  static const List<BoxShadow> level1 = <BoxShadow>[
    BoxShadow(
      color: Color(0x0D1E4633),
      offset: Offset(0, 4),
      blurRadius: 20,
    ),
  ];

  /// Elevasi sedang, untuk elemen mengambang.
  static const List<BoxShadow> level2 = <BoxShadow>[
    BoxShadow(
      color: Color(0x1F1E4633),
      offset: Offset(0, 8),
      blurRadius: 30,
    ),
  ];

  /// Elevasi kuat, untuk modal/sheet.
  static const List<BoxShadow> level3 = <BoxShadow>[
    BoxShadow(
      color: Color(0x401E4633),
      offset: Offset(0, 12),
      blurRadius: 24,
    ),
  ];
}