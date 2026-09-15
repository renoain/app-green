// Data checkpoint demo Go Green (placeholder sampai layer data terpasang).

import '../../../../core/constants/app_strings.dart';

/// Data checkpoint pembuangan sampah.
class CheckpointDemo {
  const CheckpointDemo({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  /// Nama checkpoint.
  final String name;

  /// Alamat checkpoint.
  final String address;

  /// Latitude koordinat checkpoint.
  final double latitude;

  /// Longitude koordinat checkpoint.
  final double longitude;
}

/// Daftar checkpoint demo.
const List<CheckpointDemo> demoCheckpoints = <CheckpointDemo>[
  CheckpointDemo(
    name: AppStrings.wasteCheckpointTps,
    address: AppStrings.wasteCheckpointTpsAddress,
    latitude: -6.200000,
    longitude: 106.816667,
  ),
  CheckpointDemo(
    name: AppStrings.wasteCheckpointBank,
    address: AppStrings.wasteCheckpointBankAddress,
    latitude: -6.200500,
    longitude: 106.816900,
  ),
];