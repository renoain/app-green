// Halaman pemilih titik di peta layar penuh (presentation).
//
// Pin tetap di tengah layar; user menggeser peta atau mengetuk titik
// untuk memindahkan pin, lalu menekan Gunakan lokasi ini. Hasil
// dikembalikan via Navigator pop sebagai LatLng.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../widgets/location_ready.dart';

/// Pemilih koordinat di peta layar penuh untuk form TPS admin.
class AdminMapPickerPage extends StatefulWidget {
  /// Membuat pemilih peta dari titik awal [initialLatitude]/[initialLongitude].
  const AdminMapPickerPage({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
  });

  /// Latitude awal pin.
  final double initialLatitude;

  /// Longitude awal pin.
  final double initialLongitude;

  @override
  State<AdminMapPickerPage> createState() => _AdminMapPickerPageState();
}

class _AdminMapPickerPageState extends State<AdminMapPickerPage> {
  final MapController _mapController = MapController();
  late LatLng _selected;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _selected = LatLng(widget.initialLatitude, widget.initialLongitude);
  }

  void _onTap(_, LatLng tapped) {
    _mapController.move(tapped, _mapController.camera.zoom);
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (!hasGesture) return;
    setState(() => _selected = camera.center);
  }

  Future<void> _goToMyLocation() async {
    if (_locating) return;
    if (!await ensureLocationReady(context)) return;
    setState(() => _locating = true);
    try {
      const LocationService service = LocationService();
      final position = await service.getCurrentPosition();
      if (!mounted) return;
      if (position == null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(AppStrings.verificationLocationFailed),
            ),
          );
        return;
      }
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        17,
      );
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _confirm() {
    try {
      Navigator.of(context).pop(_selected);
    } catch (error, stackTrace) {
      AppLogger.error('Gagal memilih lokasi peta', error, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.adminMapPickerTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Text(
              AppStrings.adminMapPickerHint,
              style: AppTypography.bodySm,
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selected,
                    initialZoom: 16,
                    onTap: _onTap,
                    onPositionChanged: _onPositionChanged,
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.go_green',
                    ),
                  ],
                ),
                const IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 36),
                      child: Icon(
                        LucideIcons.map_pin,
                        size: 44,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: FloatingActionButton.small(
                    onPressed: _locating ? null : _goToMyLocation,
                    child: _locating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(LucideIcons.locate_fixed, size: 20),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${_selected.latitude.toStringAsFixed(6)}, '
                  '${_selected.longitude.toStringAsFixed(6)}',
                  style: AppTypography.bodySm,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(
                  text: AppStrings.adminUseThisLocation,
                  onPressed: _confirm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
