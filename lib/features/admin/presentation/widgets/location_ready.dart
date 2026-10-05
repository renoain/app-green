// Helper kesiapan lokasi untuk form admin (presentation).

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/location_service.dart';

/// Memastikan layanan GPS hidup dan izin lokasi diberikan. Mengembalikan true bila siap dipakai, false bila user membatalkan atau izin ditolak.
Future<bool> ensureLocationReady(BuildContext context) async {
  const LocationService service = LocationService();
  if (!await service.isServiceEnabled()) {
    if (!context.mounted) return false;
    final bool? open = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(AppStrings.adminEnableLocationTitle),
        content: Text(AppStrings.adminEnableLocationMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppStrings.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(AppStrings.adminOpenSettings),
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
        SnackBar(
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
        title: Text(AppStrings.adminLocationPermissionTitle),
        content: Text(AppStrings.adminLocationPermissionMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppStrings.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(AppStrings.adminOpenSettings),
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
