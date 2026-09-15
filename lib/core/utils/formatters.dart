// Utilitas format angka dan tanggal dengan konvensi Bahasa Indonesia.
//
// Dipakai agar nilai poin dan tanggal tampil konsisten di seluruh UI.

/// Nama bulan pendek Bahasa Indonesia.
const List<String> _monthShort = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// Memformat angka integer menjadi pemisah ribuan titik (mis. 1250 -> 1.250).
String formatIndonesianNumber(int value) {
  final String digits = value.toString();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    buffer.write(digits[i]);
    final int remaining = digits.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

/// Memformat tanggal menjadi "12 Sep 2026" (Bahasa Indonesia).
String formatIndonesianDate(DateTime date) {
  return '${date.day} ${_monthShort[date.month - 1]} ${date.year}';
}

/// Memformat timestamp menjadi "12 Sep 2026, 14.32 WIB".
String formatIndonesianTimestamp(DateTime date) {
  final String hour = date.hour.toString().padLeft(2, '0');
  final String minute = date.minute.toString().padLeft(2, '0');
  return '${formatIndonesianDate(date)}, $hour.$minute WIB';
}