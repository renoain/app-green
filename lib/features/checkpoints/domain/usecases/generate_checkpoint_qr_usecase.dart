// Use case generate kode QR checkpoint (domain).

import '../entities/checkpoint.dart';
import '../repositories/checkpoint_repository.dart';

/// Use case membuat kode QR unik format CP-XXX untuk checkpoint baru.
class GenerateCheckpointQrUsecase {
  /// Membuat use case.
  const GenerateCheckpointQrUsecase(this._repository);

  final CheckpointRepository _repository;

  /// Menghasilkan kode berikutnya (CP-001, CP-002, ...) dari daftar existing.
  Future<String> nextCode() async {
    final List<Checkpoint> all = await _repository.getAllCheckpoints();
    int max = 0;
    for (final Checkpoint item in all) {
      final String? code = item.qrCode;
      if (code == null || !code.startsWith('CP-')) continue;
      final int number = int.tryParse(code.substring(3)) ?? 0;
      if (number > max) max = number;
    }
    return 'CP-${(max + 1).toString().padLeft(3, '0')}';
  }
}
