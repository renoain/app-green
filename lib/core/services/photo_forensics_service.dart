// Forensik foto on-device (EXIF) untuk anti-kecurangan.
//
// Memeriksa metadata kamera memakai paket exif yang sudah ada; tanpa
// API cloud/kunci. Tidak pernah melempar: byte rusak = tanpa EXIF.

import 'dart:typed_data';

import 'package:exif/exif.dart';

/// Hasil analisis EXIF satu foto bukti.
class PhotoForensics {
  /// Membuat hasil forensik.
  const PhotoForensics({
    required this.hasExif,
    this.softwareTag,
    this.dateOriginal,
  });

  /// Apakah foto mengandung metadata EXIF.
  final bool hasExif;

  /// Tag Software bila ada (indikasi diedit aplikasi).
  final String? softwareTag;

  /// Tag DateTimeOriginal bila ada.
  final String? dateOriginal;

  /// Apakah ada jejak aplikasi edit dari tag Software.
  bool get looksEdited =>
      softwareTag != null && softwareTag!.trim().isNotEmpty;
}

/// Layanan forensik foto Go Green.
class PhotoForensicsService {
  /// Menganalisis [bytes] foto (aman untuk byte apa pun).
  Future<PhotoForensics> analyze(Uint8List bytes) async {
    late final Map<String, IfdTag> tags;
    try {
      tags = await readExifFromBytes(bytes);
    } catch (_) {
      return const PhotoForensics(hasExif: false);
    }
    if (tags.isEmpty) return const PhotoForensics(hasExif: false);
    String? text(String key) {
      final String? raw = tags[key]?.printable;
      final String trimmed = (raw ?? '').trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    return PhotoForensics(
      hasExif: true,
      softwareTag: text('Image Software'),
      dateOriginal: text('EXIF DateTimeOriginal'),
    );
  }
}
