// Widget pemilih titik checkpoint di atas peta OSM (presentation).
//
// Memakai flutter_map + TileLayer OpenStreetMap tanpa API key.
// Ketuk peta untuk memindahkan pin; tombol layar penuh membuka
// pemilih peta geser-pin bila [onExpand] diisi.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Peta pemilih koordinat checkpoint.
class CheckpointMapPicker extends StatefulWidget {
  /// Membuat peta pemilih titik.
  const CheckpointMapPicker({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onPick,
    this.onExpand,
  });

  /// Latitude pin saat ini.
  final double latitude;

  /// Longitude pin saat ini.
  final double longitude;

  /// Callback saat user mengetuk peta.
  final ValueChanged<LatLng> onPick;

  /// Callback tombol layar penuh (null menyembunyikan tombol).
  final VoidCallback? onExpand;

  @override
  State<CheckpointMapPicker> createState() => _CheckpointMapPickerState();
}

class _CheckpointMapPickerState extends State<CheckpointMapPicker> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(CheckpointMapPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _mapController.move(LatLng(widget.latitude, widget.longitude), 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng point = LatLng(widget.latitude, widget.longitude);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        height: 240,
        child: Stack(
          children: <Widget>[
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: point,
                initialZoom: 16,
                onTap: (_, LatLng tapped) => widget.onPick(tapped),
              ),
              children: <Widget>[
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.go_green',
                ),
                MarkerLayer(
                  markers: <Marker>[
                    Marker(
                      point: point,
                      width: 44,
                      height: 44,
                      child: const Icon(
                        LucideIcons.map_pin,
                        size: 36,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.onExpand != null)
              Positioned(
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: Material(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  color: AppColors.surface,
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    onTap: widget.onExpand,
                    child: const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Icon(LucideIcons.maximize_2, size: 20),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
