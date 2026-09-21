// Halaman ambil foto bukti via kamera in-app Go Green (anti-kecurangan:
// kamera in-app, bukan galeri). Sesuai docs/UI_PAGES.md (Waste) dan
// docs/SECURITY_AND_VALIDATION.md.

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../admin/presentation/providers/admin_providers.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/geo_utils.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../verification/presentation/data/verification_extra.dart';
import '../data/capture_extra.dart';

/// Status inisialisasi kamera pada halaman CapturePhotoPage.
enum _CaptureStatus { initializing, denied, unavailable, ready }

/// Halaman kamera in-app untuk mengambil foto bukti pembuangan sampah.
///
/// Meminta izin kamera, menampilkan preview, dan mengarahkan ke halaman
/// verifikasi setelah foto diambil.
class CapturePhotoPage extends StatefulWidget {
  /// Membuat halaman ambil foto.
  const CapturePhotoPage({super.key, this.extra});

  /// Checkpoint terpilih dari halaman Waste.
  final CaptureExtra? extra;

  @override
  State<CapturePhotoPage> createState() => _CapturePhotoPageState();
}

class _CapturePhotoPageState extends State<CapturePhotoPage> {
  _CaptureStatus _status = _CaptureStatus.initializing;
  CameraController? _controller;
  List<CameraDescription> _cameras = <CameraDescription>[];
  int _cameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      final PermissionStatus permission = await Permission.camera.request();
      final bool granted =
          permission.isGranted || permission == PermissionStatus.limited;
      if (!granted) {
        if (mounted) setState(() => _status = _CaptureStatus.denied);
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) setState(() => _status = _CaptureStatus.unavailable);
        return;
      }

      _cameraIndex = 0;
      await _disposeController();
      _controller = CameraController(
        _cameras[_cameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _status = _CaptureStatus.ready);
    } catch (_) {
      if (mounted) setState(() => _status = _CaptureStatus.unavailable);
    }
  }

  Future<void> _disposeController() async {
    final CameraController? previous = _controller;
    _controller = null;
    await previous?.dispose();
  }

  Future<void> _takePicture() async {
    final CameraController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    try {
      final XFile photo = await controller.takePicture();
      if (!mounted) return;
      // Lokasi uji admin diutamakan agar testing pindah lokasi mudah.
      final DebugLocation? debug =
          ProviderScope.containerOf(context).read(debugLocationProvider);
      const LocationService locationService = LocationService();
      final position = debug == null
          ? await locationService.getCurrentPosition()
          : null;
      if (!mounted) return;

      final double? userLat = debug?.latitude ?? position?.latitude;
      final double? userLng = debug?.longitude ?? position?.longitude;
      final CaptureExtra? extra = widget.extra;
      if (AppValues.enforceGpsRadius &&
          extra != null &&
          userLat != null &&
          userLng != null) {
        final int distance = GeoUtils.distanceMeters(
          userLat,
          userLng,
          extra.latitude,
          extra.longitude,
        );
        if (distance > extra.radius) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text(AppStrings.wasteGpsOutOfRadius)),
            );
          return;
        }
      }
      final String? locationLabel = debug != null
          ? '${debug.latitude.toStringAsFixed(6)}, '
              '${debug.longitude.toStringAsFixed(6)}'
          : position == null
              ? null
              : locationService.formatPositionLabel(position);
      final String timestampLabel =
          formatIndonesianTimestamp(DateTime.now());
      context.pushNamed(
        AppRouteName.verification,
        extra: VerificationExtra(
          locationLabel: locationLabel,
          imagePath: photo.path,
          timestampLabel: timestampLabel,
          checkpointId: extra?.checkpointId,
          checkpointName: extra?.checkpointName,
          latitude: userLat,
          longitude: userLng,
          radius: extra?.radius,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(AppStrings.genericError)));
    }
  }

  Future<void> _toggleFlash() async {
    final CameraController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final FlashMode next = switch (_flashMode) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.always,
      _ => FlashMode.off,
    };
    try {
      await controller.setFlashMode(next);
      if (!mounted) return;
      setState(() => _flashMode = next);
    } catch (_) {
      // Kamera tanpa dukungan flash diabaikan.
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) return;
    final int next = (_cameraIndex + 1) % _cameras.length;
    final CameraController replacement = CameraController(
      _cameras[next],
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await replacement.initialize();
      final CameraController? previous = _controller;
      _controller = replacement;
      _cameraIndex = next;
      await previous?.dispose();
      if (mounted) setState(() {});
    } catch (_) {
      await replacement.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _CaptureStatus status = _status;
    if (status == _CaptureStatus.ready &&
        _controller != null &&
        _controller!.value.isInitialized) {
      return _buildCamera();
    }
    if (status == _CaptureStatus.denied) {
      return _buildFallback(
        message: AppStrings.capturePermissionDenied,
      );
    }
    if (status == _CaptureStatus.unavailable) {
      return _buildFallback(
        message: AppStrings.captureUnavailable,
      );
    }
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: LoadingIndicator(),
      ),
    );
  }

  Widget _buildFallback({required String message}) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.captureTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.tertiaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.camera_off,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: AppStrings.captureRetryButton,
                onPressed: _initialize,
              ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                text: AppStrings.backButton,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _flipVisible => _cameras.length > 1;

  String get _flashModeTooltip => switch (_flashMode) {
        FlashMode.off => AppStrings.captureFlashOff,
        FlashMode.auto => AppStrings.captureFlashAuto,
        _ => AppStrings.captureFlashOn,
      };

  Widget _buildCamera() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller!),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: <Widget>[
                    _CircleAction(
                      icon: LucideIcons.arrow_left,
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: <Widget>[
                    Text(
                      AppStrings.captureHint,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _CircleAction(
                              icon: _flashMode == FlashMode.off
                                  ? LucideIcons.zap_off
                                  : LucideIcons.zap,
                              iconColor: _flashMode == FlashMode.always
                                  ? AppColors.warning
                                  : null,
                              tooltip: _flashModeTooltip,
                              onPressed: _toggleFlash,
                            ),
                            if (_flipVisible) ...<Widget>[
                              const SizedBox(width: AppSpacing.sm),
                              _CircleAction(
                                icon: LucideIcons.rotate_cw,
                                onPressed: _flipCamera,
                              ),
                            ],
                          ],
                        ),
                        _ShutterButton(onPressed: _takePicture),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol aksi bulat semi-transparan di atas preview kamera.
class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final Widget button = IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 24,
        color: iconColor ?? AppColors.textOnPrimary,
      ),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.textOnPrimary.withValues(alpha: 0.2),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip, child: button);
  }
}

/// Tombol shutter untuk mengambil foto.
class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.textOnPrimary,
          border: Border.all(color: AppColors.textOnPrimary, width: 4),
        ),
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}