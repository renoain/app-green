// Use case penilaian risiko forensik foto (domain).

import '../../../../core/services/photo_forensics_service.dart';

/// Sinyal risiko individual (kode stabil untuk disimpan).
enum PhotoRiskReason {
  /// Foto tanpa metadata EXIF kamera.
  noExif('no_exif'),

  /// Tag Software terdeteksi (jejak aplikasi edit).
  editedSoftware('edited_software'),

  /// Jarak ke checkpoint melebihi radius (saat penegakan mati).
  farGps('far_gps'),

  /// Setoran beruntun dalam sehari (>= 3 termasuk saat ini).
  rapidSubmit('rapid_submit');

  const PhotoRiskReason(this.code);

  /// Kode sinyal untuk kolom risk_detail.
  final String code;

  /// Parse kode menjadi reason (null bila tak dikenal).
  static PhotoRiskReason? fromCode(String code) {
    for (final PhotoRiskReason reason in PhotoRiskReason.values) {
      if (reason.code == code) return reason;
    }
    return null;
  }
}

/// Tingkat risiko dari skor.
enum PhotoRiskLevel {
  /// Skor 0-29.
  low,

  /// Skor 30-59.
  medium,

  /// Skor 60-100.
  high,
}

/// Hasil penilaian risiko foto.
class PhotoRisk {
  const PhotoRisk({
    required this.score,
    required this.level,
    required this.reasons,
    required this.exifOk,
  });

  /// Skor 0-100.
  final int score;

  /// Tingkat risiko.
  final PhotoRiskLevel level;

  /// Sinyal pemicu skor.
  final List<PhotoRiskReason> reasons;

  /// Apakah EXIF kamera utuh (ada dan tanpa jejak edit).
  final bool exifOk;

  /// Kode sinyal koma-dipisah untuk kolom risk_detail.
  String get detailCodes => reasons.map((PhotoRiskReason r) => r.code).join(',');
}

/// Use case menilai risiko foto bukti.
class AssessPhotoRiskUsecase {
  const AssessPhotoRiskUsecase();

  /// Bobot tiap sinyal risiko.
  static const Map<PhotoRiskReason, int> weights =
      <PhotoRiskReason, int>{
    PhotoRiskReason.noExif: 35,
    PhotoRiskReason.editedSoftware: 40,
    PhotoRiskReason.farGps: 25,
    PhotoRiskReason.rapidSubmit: 15,
  };

  /// Nilai risiko dari sinyal forensik + konteks submit.
  PhotoRisk assess({
    required PhotoForensics forensics,
    required double distanceMeters,
    required double radiusMeters,
    required int todayCount,
  }) {
    final List<PhotoRiskReason> reasons = <PhotoRiskReason>[];
    if (!forensics.hasExif) {
      reasons.add(PhotoRiskReason.noExif);
    }
    if (forensics.looksEdited) {
      reasons.add(PhotoRiskReason.editedSoftware);
    }
    if (distanceMeters > radiusMeters) {
      reasons.add(PhotoRiskReason.farGps);
    }
    if (todayCount >= 2) {
      reasons.add(PhotoRiskReason.rapidSubmit);
    }
    int score = 0;
    for (final PhotoRiskReason reason in reasons) {
      score += weights[reason] ?? 0;
    }
    if (score > 100) score = 100;
    final PhotoRiskLevel level = score >= 60
        ? PhotoRiskLevel.high
        : score >= 30
            ? PhotoRiskLevel.medium
            : PhotoRiskLevel.low;
    return PhotoRisk(
      score: score,
      level: level,
      reasons: List<PhotoRiskReason>.unmodifiable(reasons),
      exifOk: forensics.hasExif && !forensics.looksEdited,
    );
  }
}
