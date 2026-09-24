// Use case kelola user untuk admin (domain).
//
// Validasi bisnis (cegah admin mencabut role sendiri) tinggal di domain
// agar widget tetap tipis. Murni Dart sehingga mudah diuji.

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/datasources/admin_users_datasource.dart';

/// Exception validasi kelola user; [message] aman tampil ke user.
class UserValidationException implements Exception {
  /// Membuat exception dengan pesan ramah user.
  const UserValidationException(this.message);

  /// Pesan kesalahan.
  final String message;

  @override
  String toString() => message;
}

/// Use case ubah role user oleh admin.
class ManageUserUsecase {
  /// Membuat use case.
  const ManageUserUsecase(this._datasource);

  final AdminUsersDatasource _datasource;

  /// Ubah role [targetId] menjadi [role].
  ///
  /// Menolak bila admin mencoba mencabut role admin miliknya sendiri
  /// ([currentUserId] sama dengan [targetId]) agar tidak terkunci keluar
  /// dari Mode Admin.
  Future<void> updateRole({
    required String currentUserId,
    required String targetId,
    required UserRole role,
  }) async {
    if (currentUserId.isNotEmpty &&
        currentUserId == targetId &&
        role != UserRole.admin) {
      throw UserValidationException(
        AppStrings.adminUserSelfDemoteBlocked,
      );
    }
    await _datasource.updateRole(id: targetId, role: role);
  }
}
