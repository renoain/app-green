// Unit test penilaian risiko forensik foto (AssessPhotoRiskUsecase).
//
// Matriks bobot sinyal + ambang level + kode detail.

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/services/photo_forensics_service.dart';
import 'package:go_green/features/waste/domain/usecases/assess_photo_risk_usecase.dart';

void main() {
  const AssessPhotoRiskUsecase usecase = AssessPhotoRiskUsecase();

  PhotoRisk assess({
    bool hasExif = true,
    String? software,
    double distance = 10,
    double radius = 100,
    int today = 0,
  }) {
    return usecase.assess(
      forensics: PhotoForensics(
        hasExif: hasExif,
        softwareTag: software,
      ),
      distanceMeters: distance,
      radiusMeters: radius,
      todayCount: today,
    );
  }

  test('foto bersih skor 0 rendah tanpa alasan', () {
    final PhotoRisk risk = assess();
    expect(risk.score, 0);
    expect(risk.level, PhotoRiskLevel.low);
    expect(risk.reasons, isEmpty);
    expect(risk.exifOk, isTrue);
    expect(risk.detailCodes, isEmpty);
  });

  test('tanpa EXIF skor 35 sedang', () {
    final PhotoRisk risk = assess(hasExif: false);
    expect(risk.score, 35);
    expect(risk.level, PhotoRiskLevel.medium);
    expect(risk.reasons, <PhotoRiskReason>[PhotoRiskReason.noExif]);
    expect(risk.exifOk, isFalse);
    expect(risk.detailCodes, 'no_exif');
  });

  test('jejak edit + tanpa EXIF skor 75 tinggi', () {
    final PhotoRisk risk = assess(hasExif: false, software: 'Snapseed');
    expect(risk.score, 75);
    expect(risk.level, PhotoRiskLevel.high);
    expect(risk.exifOk, isFalse);
  });

  test('jauh GPS + beruntun menaikkan skor', () {
    final PhotoRisk risk = assess(distance: 500, today: 2);
    expect(risk.score, 40);
    expect(risk.level, PhotoRiskLevel.medium);
    expect(
      risk.reasons,
      <PhotoRiskReason>[
        PhotoRiskReason.farGps,
        PhotoRiskReason.rapidSubmit,
      ],
    );
  });

  test('skor dibatasi 100', () {
    final PhotoRisk risk = assess(
      hasExif: false,
      software: 'Editor',
      distance: 999,
      today: 5,
    );
    expect(risk.score, 100);
    expect(risk.level, PhotoRiskLevel.high);
    expect(risk.detailCodes.split(','), hasLength(4));
  });

  test('batas tepat radius tidak dihitung jauh', () {
    final PhotoRisk risk = assess(distance: 100, radius: 100);
    expect(
      risk.reasons.contains(PhotoRiskReason.farGps),
      isFalse,
    );
  });
}
