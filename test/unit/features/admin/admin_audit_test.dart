// Unit test jejak audit aksi admin.
//
// Setiap tulis admin (reward, user, pengaturan, TPS) mencatat baris
// audit; tulis audit best effort (tanpa login = lewati diam-diam).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_config.dart';
import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/features/admin/data/datasources/admin_audit_datasource.dart';
import 'package:go_green/features/admin/data/datasources/admin_settings_datasource.dart';
import 'package:go_green/features/admin/data/datasources/admin_users_datasource.dart';
import 'package:go_green/features/admin/domain/entities/admin_user.dart';
import 'package:go_green/features/admin/domain/entities/app_settings_values.dart';
import 'package:go_green/features/admin/domain/entities/audit_log.dart';
import 'package:go_green/features/admin/presentation/providers/admin_audit_provider.dart';
import 'package:go_green/features/admin/presentation/providers/admin_checkpoint_provider.dart';
import 'package:go_green/features/admin/presentation/providers/admin_reward_provider.dart';
import 'package:go_green/features/admin/presentation/providers/admin_settings_provider.dart';
import 'package:go_green/features/admin/presentation/providers/admin_users_provider.dart';
import 'package:go_green/features/admin/presentation/providers/admin_waste_provider.dart';
import 'package:go_green/features/checkpoints/domain/entities/checkpoint.dart';
import 'package:go_green/features/checkpoints/domain/repositories/checkpoint_repository.dart';
import 'package:go_green/features/checkpoints/presentation/providers/checkpoint_provider.dart';
import 'package:go_green/features/rewards/domain/entities/reward.dart';
import 'package:go_green/features/rewards/domain/repositories/reward_repository.dart';

/// Perekam pemanggilan audit.
class _Call {
  _Call(this.action, this.entity, this.detail);

  final String action;
  final String entity;
  final String? detail;
}

/// Datasource audit palsu pencatat panggilan.
class _FakeAudit extends AdminAuditDatasource {
  _FakeAudit() : super(client: null);

  final List<_Call> calls = <_Call>[];

  @override
  Future<void> log({
    required String action,
    required String entity,
    String? entityId,
    String? detail,
  }) async {
    calls.add(_Call(action, entity, detail));
  }

  @override
  Future<List<AuditLog>> getRecent({int limit = 50}) async => <AuditLog>[];
}

/// Repository reward palsu.
class _FakeRewardRepo implements RewardRepository {
  @override
  Future<List<Reward>> getAllForAdmin() async => <Reward>[];

  @override
  Future<Reward> createReward({
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    return Reward(
      id: 'r1',
      name: name,
      description: description,
      pointsCost: pointsCost,
      stock: stock,
      isActive: isActive,
      createdAt: DateTime(2026, 9, 23),
    );
  }

  @override
  Future<Reward> updateReward({
    required String id,
    required String name,
    String? description,
    required int pointsCost,
    required int stock,
    String? imageUrl,
    required bool isActive,
  }) async {
    return Reward(
      id: id,
      name: name,
      pointsCost: pointsCost,
      stock: stock,
      isActive: isActive,
      createdAt: DateTime(2026, 9, 23),
    );
  }

  @override
  Future<void> setRewardActive({
    required String id,
    required bool isActive,
  }) async {}

  @override
  Future<void> deleteReward(String id) async {}
}

/// Datasource user palsu.
class _FakeUsersDs extends AdminUsersDatasource {
  _FakeUsersDs() : super(client: null);

  @override
  Future<List<AdminUser>> getUsers({int limit = 50}) async => <AdminUser>[];

  @override
  Future<void> updateRole({
    required String id,
    required UserRole role,
  }) async {}
}

/// Datasource pengaturan palsu.
class _FakeSettingsDs extends AdminSettingsDatasource {
  _FakeSettingsDs() : super(client: null);

  @override
  Future<Map<String, String>> getAll() async =>
      AppSettingsValues.defaults().toMap();

  @override
  Future<void> saveAll(Map<String, String> values) async {}
}

/// Repository checkpoint palsu.
class _FakeCheckpointRepo implements CheckpointRepository {
  @override
  Future<List<Checkpoint>> getAllCheckpoints() async => <Checkpoint>[];

  @override
  Future<List<Checkpoint>> getActiveCheckpoints() async => <Checkpoint>[];

  @override
  Future<List<Checkpoint>> getNearbyCheckpoints({
    required double latitude,
    required double longitude,
  }) async =>
      <Checkpoint>[];

  @override
  Future<Checkpoint?> getCheckpointById(String id) async => null;

  @override
  Future<Checkpoint?> getCheckpointByQrCode(String qrCode) async => null;

  @override
  Future<Checkpoint> createCheckpoint({
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
  }) async {
    return Checkpoint(
      id: 'c1',
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      qrCode: qrCode ?? 'CP-TEST',
      createdAt: DateTime(2026, 9, 23),
    );
  }

  @override
  Future<Checkpoint> updateCheckpoint({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCheckpoint(String id) async {}

  @override
  Future<Checkpoint> insertCheckpoint({
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Checkpoint> updateCheckpointRecord({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    required int radius,
    String? qrCode,
    String? code,
    String? provinceCode,
    String? cityCode,
    String? districtCode,
    String? subdistrict,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deactivateCheckpoint(String id) async {}

  @override
  Future<void> activateCheckpoint(String id) async {}
}

void main() {
  tearDown(AppConfig.clear);

  test('tambah reward mencatat audit tambah/reward', () async {
    final _FakeAudit audit = _FakeAudit();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        adminRewardRepositoryProvider.overrideWithValue(_FakeRewardRepo()),
        adminAuditDatasourceProvider.overrideWithValue(audit),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(adminRewardListProvider.notifier)
        .create(name: 'Sembako', pointsCost: 300, stock: 5, isActive: true);

    expect(audit.calls, hasLength(1));
    expect(audit.calls.first.action, AuditAction.create);
    expect(audit.calls.first.entity, AuditEntity.reward);
    expect(audit.calls.first.detail, 'Sembako');
  });

  test('nonaktifkan reward mencatat audit nonaktifkan', () async {
    final _FakeAudit audit = _FakeAudit();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        adminRewardRepositoryProvider.overrideWithValue(_FakeRewardRepo()),
        adminAuditDatasourceProvider.overrideWithValue(audit),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(adminRewardListProvider.notifier)
        .setActive(id: 'r1', isActive: false);

    expect(audit.calls, hasLength(1));
    expect(audit.calls.first.action, AuditAction.deactivate);
  });

  test('ubah role mencatat audit ubah_role/user', () async {
    final _FakeAudit audit = _FakeAudit();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        adminUsersDatasourceProvider.overrideWithValue(_FakeUsersDs()),
        adminAuditDatasourceProvider.overrideWithValue(audit),
      ],
    );
    addTearDown(container.dispose);

    await container.read(adminUsersProvider.notifier).updateRole(
          currentUserId: 'a1',
          targetId: 'u2',
          role: UserRole.petugas,
        );

    expect(audit.calls, hasLength(1));
    expect(audit.calls.first.action, AuditAction.changeRole);
    expect(audit.calls.first.entity, AuditEntity.user);
    expect(audit.calls.first.detail, 'petugas');
  });

  test('simpan pengaturan mencatat audit + terapkan AppConfig', () async {
    final _FakeAudit audit = _FakeAudit();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        adminSettingsDatasourceProvider.overrideWithValue(_FakeSettingsDs()),
        adminAuditDatasourceProvider.overrideWithValue(audit),
      ],
    );
    addTearDown(container.dispose);

    await container.read(adminSettingsProvider.notifier).save(
          const AppSettingsValues(
            gpsRadiusMeters: 150,
            enforceGpsRadius: true,
            maxWasteLogsPerDay: 5,
            weeklyMissionTarget: 5,
            maxPhotoMb: 5,
          ),
        );

    expect(audit.calls, hasLength(1));
    expect(audit.calls.first.action, AuditAction.saveSettings);
    expect(AppConfig.gpsRadiusMeters, 150);
  });

  test('tambah TPS mencatat audit tambah/tps', () async {
    final _FakeAudit audit = _FakeAudit();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        checkpointRepositoryProvider.overrideWithValue(_FakeCheckpointRepo()),
        adminAuditDatasourceProvider.overrideWithValue(audit),
      ],
    );
    addTearDown(container.dispose);

    await container.read(adminCheckpointListProvider.notifier).create(
          name: 'TPS Test',
          latitude: -6.2,
          longitude: 106.8,
          radius: 100,
          qrCode: 'CP-TEST',
        );

    expect(audit.calls, hasLength(1));
    expect(audit.calls.first.action, AuditAction.create);
    expect(audit.calls.first.entity, AuditEntity.checkpoint);
  });

  test('nonaktifkan TPS mencatat audit nonaktifkan/tps', () async {
    final _FakeAudit audit = _FakeAudit();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        checkpointRepositoryProvider.overrideWithValue(_FakeCheckpointRepo()),
        adminAuditDatasourceProvider.overrideWithValue(audit),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(adminCheckpointListProvider.notifier)
        .deactivate('c1');

    expect(audit.calls, hasLength(1));
    expect(audit.calls.first.action, AuditAction.deactivate);
    expect(audit.calls.first.entity, AuditEntity.checkpoint);
  });

  test('aktifkan TPS mencatat audit aktifkan/tps', () async {
    final _FakeAudit audit = _FakeAudit();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        checkpointRepositoryProvider.overrideWithValue(_FakeCheckpointRepo()),
        adminAuditDatasourceProvider.overrideWithValue(audit),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(adminCheckpointListProvider.notifier)
        .activate('c1');

    expect(audit.calls, hasLength(1));
    expect(audit.calls.first.action, AuditAction.activate);
  });

  test('audit tulis tanpa login dilewati diam-diam', () async {
    final AdminAuditDatasource ds = AdminAuditDatasource(client: null);
    await ds.log(action: AuditAction.create, entity: AuditEntity.reward);
  });

  test('approve tanpa login tetap tolak sebelum audit', () async {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      () => container.read(adminWasteListProvider.notifier).approve('w1'),
      throwsA(isA<StateError>()),
    );
  });
}
