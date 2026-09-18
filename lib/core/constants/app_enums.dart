// Konstanta enum domain yang berkaitan dengan database.
//
// Nilai `.value` tiap enum adalah string yang dipakai di kolom database.
// Dipakai oleh model saat fromJson/toJson (lihat docs/DATABASE_SCHEMA.md).

/// Role pengguna. Nilai sesuai kolom `role` tabel profiles.
enum UserRole {
  user('user'),
  admin('admin'),
  petugas('petugas');

  const UserRole(this.value);

  /// String di database.
  final String value;

  /// Mem-parsing string database menjadi [UserRole].
  static UserRole fromDb(String? value) {
    return UserRole.values.firstWhere(
      (UserRole role) => role.value == value,
      orElse: () => UserRole.user,
    );
  }
}

/// Kategori sampah. Nilai sesuai kolom `category` tabel waste_logs.
enum WasteCategory {
  organik('organik'),
  anorganik('anorganik'),
  b3('b3'),
  daurUlang('daur_ulang');

  const WasteCategory(this.value);

  /// String di database.
  final String value;

  /// Mem-parsing string database menjadi [WasteCategory].
  static WasteCategory fromDb(String? value) {
    return WasteCategory.values.firstWhere(
      (WasteCategory category) => category.value == value,
      orElse: () => WasteCategory.organik,
    );
  }
}

/// Status log pembuangan sampah. Sesuai kolom `status` tabel waste_logs.
enum WasteLogStatus {
  pending('pending'),
  verified('verified'),
  rejected('rejected');

  const WasteLogStatus(this.value);

  /// String di database.
  final String value;

  /// Mem-parsing string database menjadi [WasteLogStatus].
  static WasteLogStatus fromDb(String? value) {
    return WasteLogStatus.values.firstWhere(
      (WasteLogStatus status) => status.value == value,
      orElse: () => WasteLogStatus.pending,
    );
  }
}

/// Status penukaran hadiah. Sesuai kolom `status` tabel redemptions.
enum RedemptionStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  claimed('claimed');

  const RedemptionStatus(this.value);

  /// String di database.
  final String value;

  /// Mem-parsing string database menjadi [RedemptionStatus].
  static RedemptionStatus fromDb(String? value) {
    return RedemptionStatus.values.firstWhere(
      (RedemptionStatus status) => status.value == value,
      orElse: () => RedemptionStatus.pending,
    );
  }
}

/// Tipe pencatatan poin. Sesuai kolom `type` tabel points.
enum PointType {
  earn('earn'),
  redeem('redeem');

  const PointType(this.value);

  /// String di database.
  final String value;

  /// Mem-parsing string database menjadi [PointType].
  static PointType fromDb(String? value) {
    return PointType.values.firstWhere(
      (PointType type) => type.value == value,
      orElse: () => PointType.earn,
    );
  }
}

/// Sumber data pembuangan sampah. Sesuai kolom `source` tabel waste_logs.
///
/// Dipakai untuk analytics (distribusi qr_scan / manual / nfc).
enum WasteSource {
  qrScan('qr_scan'),
  manual('manual'),
  nfc('nfc');

  const WasteSource(this.value);

  /// String di database.
  final String value;

  /// Mem-parsing string database menjadi [WasteSource]. Default `manual`
  /// mengikuti default kolom di database.
  static WasteSource fromDb(String? value) {
    return WasteSource.values.firstWhere(
      (WasteSource source) => source.value == value,
      orElse: () => WasteSource.manual,
    );
  }
}