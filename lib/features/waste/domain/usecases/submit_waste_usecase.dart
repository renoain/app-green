// Use case pengiriman pembuangan sampah (domain).

import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/services/photo_forensics_service.dart';
import '../../../checkpoints/domain/entities/checkpoint.dart';
import '../entities/waste_log.dart';
import '../repositories/waste_repository.dart';
import 'assess_photo_risk_usecase.dart';
import 'calculate_points_usecase.dart';
import 'validate_photo_usecase.dart';

/// Hasil pengiriman pembuangan sampah.
class SubmitWasteResult {
  const SubmitWasteResult({
    required this.log,
    required this.estimatedPoints,
    required this.risk,
  });

  /// Log yang berhasil disimpan.
  final WasteLog log;

  /// Estimasi poin dari pembuangan ini.
  final int estimatedPoints;

  /// Penilaian risiko forensik foto.
  final PhotoRisk risk;
}

/// Mencatat poin earn ke tabel points. Di-inject agar usecase tetap teruji tanpa Supabase; implementasi produksi memakai PointsRemoteDatasource.addPoints (butuh policy points_insert_own_earn).
typedef RecordEarnPoints = Future<void> Function({
  required String userId,
  required int amount,
  required String referenceId,
  required String description,
});

/// Use case mengirim bukti pembuangan sampah.
class SubmitWasteUsecase {
  /// [recordEarnPoints] null berarti poin hanya dihitung (estimasi) tanpa dicatat, untuk kompatibilitas pemanggil lama/test.
  SubmitWasteUsecase({
    required WasteRepository wasteRepository,
    required ValidatePhotoUsecase validatePhoto,
    required CalculatePointsUsecase calculatePoints,
    String Function(Uint8List bytes)? hashFunction,
    RecordEarnPoints? recordEarnPoints,
    AssessPhotoRiskUsecase assessRisk = const AssessPhotoRiskUsecase(),
    Future<PhotoForensics> Function(Uint8List bytes)? analyzeForensics,
  })  : _wasteRepository = wasteRepository,
        _validatePhoto = validatePhoto,
        _calculatePoints = calculatePoints,
        _hashFunction = hashFunction ?? _sha256Hash,
        _recordEarnPoints = recordEarnPoints,
        _assessRisk = assessRisk,
        _analyzeForensics =
            analyzeForensics ?? PhotoForensicsService().analyze;

  final WasteRepository _wasteRepository;
  final ValidatePhotoUsecase _validatePhoto;
  final CalculatePointsUsecase _calculatePoints;
  final String Function(Uint8List bytes) _hashFunction;
  final RecordEarnPoints? _recordEarnPoints;
  final AssessPhotoRiskUsecase _assessRisk;
  final Future<PhotoForensics> Function(Uint8List bytes) _analyzeForensics;

  /// Menjalankan alur submit. Melempar [WasteValidationException] bila validasi foto gagal.
  Future<SubmitWasteResult> execute({
    required String userId,
    required Checkpoint checkpoint,
    required WasteCategory category,
    required Uint8List photoBytes,
    required double latitude,
    required double longitude,
    WasteSource source = WasteSource.manual,
    int currentStreakDays = 0,
  }) async {
    final String hash = _hashFunction(photoBytes);

    await _validatePhoto.validate(
      hash: hash,
      userId: userId,
      userLatitude: latitude,
      userLongitude: longitude,
      checkpointLatitude: checkpoint.latitude,
      checkpointLongitude: checkpoint.longitude,
      radiusMeters: checkpoint.radius.toDouble(),
    );

    final PhotoForensics forensics = await _analyzeForensics(photoBytes);
    final int todayCount =
        await _wasteRepository.countTodayWasteLogs(userId);
    final PhotoRisk risk = _assessRisk.assess(
      forensics: forensics,
      distanceMeters: _validatePhoto.distanceBetween(
        latitude,
        longitude,
        checkpoint.latitude,
        checkpoint.longitude,
      ),
      radiusMeters: checkpoint.radius.toDouble(),
      todayCount: todayCount,
    );

    final String fileName =
        '$userId/${DateTime.now().millisecondsSinceEpoch}_$hash.jpg';
    final String photoUrl = await _wasteRepository.uploadPhoto(
      fileName: fileName,
      bytes: photoBytes,
    );

    final WasteLog log = await _wasteRepository.insertWasteLog(
      userId: userId,
      checkpointId: checkpoint.id,
      category: category,
      photoUrl: photoUrl,
      hash: hash,
      latitude: latitude,
      longitude: longitude,
      source: source,
      riskScore: risk.score,
      exifOk: risk.exifOk,
      riskDetail: risk.detailCodes.isEmpty ? null : risk.detailCodes,
    );

    final int points = _calculatePoints.calculate(
      category: category,
      currentStreakDays: currentStreakDays,
    );

    final RecordEarnPoints? recordEarnPoints = _recordEarnPoints;
    if (recordEarnPoints != null) {
      await recordEarnPoints(
        userId: userId,
        amount: points,
        referenceId: log.id,
        description:
            'Buang sampah ${category.value} di ${checkpoint.name}',
      );
    }

    return SubmitWasteResult(
      log: log,
      estimatedPoints: points,
      risk: risk,
    );
  }

  /// Hash SHA-256 default untuk foto bukti.
  static String _sha256Hash(Uint8List bytes) =>
      sha256.convert(bytes).toString();
}
