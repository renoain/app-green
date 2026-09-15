// Unit test untuk utilitas format angka dan tanggal.

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/utils/formatters.dart';

void main() {
  group('formatIndonesianNumber', () {
    test('angka kecil tanpa pemisah', () {
      expect(formatIndonesianNumber(0), '0');
      expect(formatIndonesianNumber(999), '999');
    });

    test('angka ribuan memakai titik', () {
      expect(formatIndonesianNumber(1000), '1.000');
      expect(formatIndonesianNumber(12500), '12.500');
    });

    test('angka jutaan memakai titik', () {
      expect(formatIndonesianNumber(1000000), '1.000.000');
    });

    test('angka dengan trailing grouped nol', () {
      expect(formatIndonesianNumber(104), '104');
      expect(formatIndonesianNumber(1045), '1.045');
    });
  });

  group('formatIndonesianDate', () {
    test('tanggal dasar', () {
      expect(
        formatIndonesianDate(DateTime(2026, 9, 12)),
        '12 Sep 2026',
      );
    });

    test('bulan-bulan tertentu', () {
      expect(
        formatIndonesianDate(DateTime(2026, 1, 3)),
        '3 Jan 2026',
      );
      expect(
        formatIndonesianDate(DateTime(2026, 12, 31)),
        '31 Des 2026',
      );
    });
  });

  group('formatIndonesianTimestamp', () {
    test('memakai jam dan menit', () {
      expect(
        formatIndonesianTimestamp(DateTime(2026, 9, 12, 14, 32)),
        '12 Sep 2026, 14.32 WIB',
      );
    });

    test('memakai nol di depan untuk jam satu digit', () {
      expect(
        formatIndonesianTimestamp(DateTime(2026, 9, 12, 9, 5)),
        '12 Sep 2026, 09.05 WIB',
      );
    });
  });
}