// Helper kesiapan lokasi untuk form admin (presentation).
//
// Memeriksa layanan GPS dan izin sebelum memakai lokasi saat ini atau
// membuka pemilih peta. Menampilkan dialog Bahasa Indonesia: minta
// hidupkan GPS (ke pengaturan sistem) atau buka pengaturan aplikasi
// bila izin ditolak permanen.

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/location_service.dart';

/// Memastikan layanan GPS hidup dan izin lokasi diberikan.
///
/// Mengembalikan true bila siap dipakai, false bila user membatalkan
/// atau izin ditolak.
Future<bool> ensureLocationReady(BuildContext context) async {
  const LocationService service = LocationService();
  if (!await service.isServiceEnabled()) {
    if (!context.mounted) return false;
    final bool? open = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text(AppStrings.adminEnableLocationTitle),
        content: const Text(AppStrings.adminEnableLocationMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.adminOpenSettings),
          ),
        ],
      ),
    );
    if (open == true) {
      await service.openLocationSettings();
    }
    return false;
  }

  LocationPermission permission = await service.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await service.requestPermission();
  }
  if (permission == LocationPermission.denied) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(AppStrings.verificationLocationFailed),
        ),
      );
    return false;
  }
  if (permission == LocationPermission.deniedForever) {
    if (!context.mounted) return false;
    final bool? open = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text(AppStrings.adminLocationPermissionTitle),
        content: const Text(AppStrings.adminLocationPermissionMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.adminOpenSettings),
          ),
        ],
      ),
    );
    if (open == true) {
      await service.openAppSettings();
    }
    return false;
  }
  return true;
}
