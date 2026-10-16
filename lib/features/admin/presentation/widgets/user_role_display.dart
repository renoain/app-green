// Pemetaan peran user ke label dan tampilan chip (dipakai bersama oleh
// daftar user dan detail user admin).

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/status_widgets.dart';

/// Label peran [role] sesuai bahasa aktif.
String userRoleLabel(UserRole role) {
  return switch (role) {
    UserRole.admin => AppStrings.adminRoleAdmin,
    UserRole.petugas => AppStrings.adminRolePetugas,
    UserRole.user => AppStrings.adminRoleUser,
  };
}

/// Tipe chip untuk peran [role].
StatusType userRoleStatusType(UserRole role) {
  return switch (role) {
    UserRole.admin => StatusType.success,
    UserRole.petugas => StatusType.info,
    UserRole.user => StatusType.warning,
  };
}