// Use case generate kode TPS (domain).
//
// Format: <KOTA>-<KEC>-<NOMOR> (mis. SBY-KTT-01). Singkatan diambil
// dari 3 huruf pertama nama (tanpa awalan KOTA/KABUPATEN/KECAMATAN).
// Nomor urut = jumlah kode existing dengan prefiks sama + 1. Murni
// Dart sehingga mudah diuji; widget hanya menampilkan hasil.

import '../entities/checkpoint.dart';
import '../repositories/checkpoint_repository.dart';

/// Use case membuat kode TPS unik per kota + kecamatan.
class GenerateTpsCodeUsecase {
  /// Membuat use case.
  const GenerateTpsCodeUsecase(this._repository);

  final CheckpointRepository _repository;

  /// Singkatan 3 huruf dari [name] (huruf besar, tanpa awalan umum).
  static String abbreviate(String name) {
    String clean = name.toUpperCase().trim();
    for (final String prefix in <String>[
      'KOTA ',
      'KABUPATEN ',
      'KAB ',
      'KECAMATAN ',
      'KEC ',
    ]) {
      if (clean.startsWith(prefix)) {
        clean = clean.substring(prefix.length);
        break;
      }
    }
    clean = clean.replaceAll(RegExp('[^A-Z]'), '');
    if (clean.length <= 3) return clean.padRight(3, 'X');
    return clean.substring(0, 3);
  }

  /// Kode berikutnya untuk [cityName] + [districtName].
  ///
  /// [cityCode]/[districtCode] dipakai memfilter baris se-wilayah bila
  /// tersedia; bila kosong, filter dari prefiks singkatan.
  Future<String> nextCode({
    required String cityName,
    required String districtName,
    String? cityCode,
    String? districtCode,
  }) async {
    final String prefix = '${abbreviate(cityName)}-${abbreviate(districtName)}';
    final List<Checkpoint> all = await _repository.getAllCheckpoints();
    int max = 0;
    for (final Checkpoint item in all) {
      final String? code = item.code;
      if (code == null || !code.startsWith('$prefix-')) continue;
      if (cityCode != null &&
          cityCode.isNotEmpty &&
          item.cityCode != null &&
          item.cityCode!.isNotEmpty &&
          item.cityCode != cityCode) {
        continue;
      }
      if (districtCode != null &&
          districtCode.isNotEmpty &&
          item.districtCode != null &&
          item.districtCode!.isNotEmpty &&
          item.districtCode != districtCode) {
        continue;
      }
      final int number =
          int.tryParse(code.substring(prefix.length + 1)) ?? 0;
      if (number > max) max = number;
    }
    return '$prefix-${(max + 1).toString().padLeft(2, '0')}';
  }
}
