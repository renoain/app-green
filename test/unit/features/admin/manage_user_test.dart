// Unit test use case kelola user admin.
//
// Cegah self-demote + teruskan update role ke datasource.

import 'package:flutter_test/flutter_test.dart';
import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/features/admin/data/datasources/admin_users_datasource.dart';
import 'package:go_green/features/admin/domain/entities/admin_user.dart';
import 'package:go_green/features/admin/domain/usecases/manage_user_usecase.dart';

/// Datasource palsu pencatat update role.
class _FakeUsersDatasource extends AdminUsersDatasource {
  _FakeUsersDatasource() : super(client: null);

  int updateCalls = 0;
  UserRole? lastRole;

  @override
  Future<List<AdminUser>> getUsers({int limit = 50}) async => <AdminUser>[];

  @override
  Future<void> updateRole({
    required String id,
    required UserRole role,
  }) async {
    updateCalls++;
    lastRole = role;
  }
}

void main() {
  test('self-demote admin menjadi user ditolak', () async {
    final _FakeUsersDatasource ds = _FakeUsersDatasource();
    final ManageUserUsecase usecase = ManageUserUsecase(ds);
    expect(
      () => usecase.updateRole(
        currentUserId: 'a1',
        targetId: 'a1',
        role: UserRole.user,
      ),
      throwsA(isA<UserValidationException>()),
    );
    expect(ds.updateCalls, 0);
  });

  test('admin ubah role user lain diteruskan', () async {
    final _FakeUsersDatasource ds = _FakeUsersDatasource();
    final ManageUserUsecase usecase = ManageUserUsecase(ds);
    await usecase.updateRole(
      currentUserId: 'a1',
      targetId: 'u2',
      role: UserRole.petugas,
    );
    expect(ds.updateCalls, 1);
    expect(ds.lastRole, UserRole.petugas);
  });

  test('admin mempertahankan role sendiri boleh', () async {
    final _FakeUsersDatasource ds = _FakeUsersDatasource();
    final ManageUserUsecase usecase = ManageUserUsecase(ds);
    await usecase.updateRole(
      currentUserId: 'a1',
      targetId: 'a1',
      role: UserRole.admin,
    );
    expect(ds.updateCalls, 1);
  });
}
