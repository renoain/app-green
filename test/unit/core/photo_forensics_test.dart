// Unit test forensik EXIF on-device (PhotoForensicsService).
//
// Byte rusak/kosong tidak boleh melempar; hasil = tanpa EXIF.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/services/photo_forensics_service.dart';

void main() {
  test('byte sampah tanpa EXIF dan tanpa throw', () async {
    final PhotoForensics result = await PhotoForensicsService().analyze(
      Uint8List.fromList(<int>[1, 2, 3, 4, 5]),
    );
    expect(result.hasExif, isFalse);
    expect(result.softwareTag, isNull);
    expect(result.looksEdited, isFalse);
  });

  test('byte kosong tanpa EXIF dan tanpa throw', () async {
    final PhotoForensics result =
        await PhotoForensicsService().analyze(Uint8List(0));
    expect(result.hasExif, isFalse);
  });
}
