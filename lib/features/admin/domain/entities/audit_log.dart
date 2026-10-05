// Entity jejak audit aksi admin (domain).

abstract final class AuditAction {
  AuditAction._();

  /// Tambah data baru.
  static const String create = 'tambah';

  /// Ubah data.
  static const String update = 'ubah';

  /// Hapus data.
  static const String delete = 'hapus';

  /// Aktifkan.
  static const String activate = 'aktifkan';

  /// Nonaktifkan.
  static const String deactivate = 'nonaktifkan';

  /// Setujui verifikasi.
  static const String approve = 'setujui';

  /// Tolak verifikasi.
  static const String reject = 'tolak';

  /// Ubah role user.
  static const String changeRole = 'ubah_role';

  /// Simpan pengaturan.
  static const String saveSettings = 'simpan_pengaturan';
}

/// Entitas yang dicatat audit.
abstract final class AuditEntity {
  AuditEntity._();

  /// Katalog reward.
  static const String reward = 'reward';

  /// Profil user.
  static const String user = 'user';

  /// Pengaturan operasional.
  static const String settings = 'pengaturan';

  /// Checkpoint TPS.
  static const String checkpoint = 'tps';

  /// Verifikasi waste.
  static const String verification = 'verifikasi';
}

/// Satu baris jejak audit admin.
class AuditLog {
  const AuditLog({
    required this.id,
    this.actorId,
    this.actorName,
    required this.action,
    required this.entity,
    this.entityId,
    this.detail,
    required this.createdAt,
  });

  /// ID baris log.
  final String id;

  /// ID admin pelaku (null bila akun dihapus).
  final String? actorId;

  /// Nama pelaku (dari join profiles, opsional).
  final String? actorName;

  /// Aksi (lihat [AuditAction]).
  final String action;

  /// Entitas (lihat [AuditEntity]).
  final String entity;

  /// ID data yang diaksi (opsional).
  final String? entityId;

  /// Ringkasan bebas (opsional).
  final String? detail;

  /// Waktu aksi tercatat.
  final DateTime createdAt;
}
