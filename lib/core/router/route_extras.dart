// Kontrak argumen route antar halaman (layer router, bukan domain maupun data).
//
// Objek ini hanya jadi payload `extra` pada navigasi go_router. Menaruhnya di
// router membuat dependensi antar fitur lewat kontrak navigasi yang jelas,
// bukan lewat folder internal presentation.

import '../constants/app_enums.dart';

/// Data yang dikirim dari halaman Buang Sampah ke halaman kamera.
class CaptureExtra {
  const CaptureExtra({
    required this.checkpointId,
    required this.checkpointName,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  /// ID checkpoint terpilih.
  final String checkpointId;

  /// Nama checkpoint terpilih untuk pesan error.
  final String checkpointName;

  /// Latitude checkpoint terpilih.
  final double latitude;

  /// Longitude checkpoint terpilih.
  final double longitude;

  /// Radius validasi GPS checkpoint dalam meter.
  final int radius;
}

/// Data yang dikirim dari halaman kamera ke halaman verifikasi.
class VerificationExtra {
  const VerificationExtra({
    this.locationLabel,
    this.imagePath,
    this.timestampLabel,
    this.checkpointId,
    this.checkpointName,
    this.latitude,
    this.longitude,
    this.radius,
    this.category = WasteCategory.organik,
  });

  /// Label koordinat GPS lokasi foto diambil.
  final String? locationLabel;

  /// Path file foto bukti yang diambil kamera in-app.
  final String? imagePath;

  /// Label timestamp pengambilan foto di layar. Waktu otoritatif tetap server.
  final String? timestampLabel;

  /// ID checkpoint tempat foto diambil (null bila alur lama/demo).
  final String? checkpointId;

  /// Nama checkpoint untuk tampilan.
  final String? checkpointName;

  /// Latitude user saat shutter.
  final double? latitude;

  /// Longitude user saat shutter.
  final double? longitude;

  /// Radius checkpoint dalam meter untuk info jarak.
  final int? radius;

  /// Kategori sampah terpilih.
  final WasteCategory category;
}

/// Data yang dikirim dari daftar aktivitas ke halaman detail saat item berasal dari waste log Supabase (bukan demo).
class ActivityDetailExtra {
  const ActivityDetailExtra({
    required this.description,
    required this.date,
    required this.status,
    required this.checkpointName,
    required this.points,
  });

  /// Deskripsi aktivitas (kategori + checkpoint).
  final String description;

  /// Tanggal pembuangan.
  final DateTime date;

  /// Status verifikasi log.
  final WasteLogStatus status;

  /// Nama checkpoint.
  final String checkpointName;

  /// Estimasi poin log.
  final int points;
}