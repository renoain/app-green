// Halaman detail verifikasi waste untuk admin/petugas (presentation).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../waste/domain/entities/waste_log.dart';
import '../providers/admin_waste_provider.dart';

/// Detail satu waste log pending + aksi setujui/tolak.
class AdminWasteDetailPage extends ConsumerStatefulWidget {
  /// Membuat halaman detail verifikasi. [log] dari extra, [logId] dari path.
  const AdminWasteDetailPage({super.key, required this.logId, this.log});

  /// ID waste log.
  final String logId;

  /// Waste log bawaan navigasi (opsional).
  final WasteLog? log;

  @override
  ConsumerState<AdminWasteDetailPage> createState() =>
      _AdminWasteDetailPageState();
}

class _AdminWasteDetailPageState extends ConsumerState<AdminWasteDetailPage> {
  bool _busy = false;

  WasteLog? _resolve(List<WasteLog> logs) {
    for (final WasteLog item in logs) {
      if (item.id == widget.logId) return item;
    }
    return widget.log;
  }

  Future<void> _approve(WasteLog log) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(adminWasteListProvider.notifier).approve(log.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.adminVerifySuccess)),
        );
      context.pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.genericError)),
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _askRejectReason(WasteLog log) async {
    final TextEditingController controller = TextEditingController();
    final String? reason = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(AppStrings.adminRejectReasonTitle),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: AppStrings.adminRejectReasonHint,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancelButton),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(controller.text.trim()),
            child: const Text(AppStrings.adminReject),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (reason == null) return;
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(AppStrings.adminRejectReasonEmpty),
          ),
        );
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(adminWasteListProvider.notifier).reject(log.id, reason);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.adminRejectSuccess)),
        );
      context.pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppStrings.genericError)),
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<WasteLog>> state =
        ref.watch(adminWasteListProvider);
    final WasteLog? log = state.maybeWhen(
      data: (List<WasteLog> logs) => _resolve(logs),
      orElse: () => widget.log,
    );
    if (log == null) {
      return const Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.adminDetailTitle,
          leading: LucideIcons.arrow_left,
        ),
        body: Center(child: Text(AppStrings.genericError)),
      );
    }
    final int estimate = ref
        .read(verifyWasteUsecaseProvider)
        .estimatePoints(log);

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.adminDetailTitle,
        leading: LucideIcons.arrow_left,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          _PhotoSection(photoPath: log.photoUrl),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
            label: AppStrings.adminCategoryLabel,
            value: log.category.value,
          ),
          _DetailRow(
            label: AppStrings.adminSubmitterLabel,
            value: log.submitterName ?? log.userId,
          ),
          _DetailRow(
            label: AppStrings.adminServerTimeLabel,
            value: formatIndonesianTimestamp(
              log.serverTimestamp.toLocal(),
            ),
          ),
          _DetailRow(
            label: AppStrings.adminLocationLabel,
            value: log.latitude != null && log.longitude != null
                ? '${log.latitude!.toStringAsFixed(5)}, '
                    '${log.longitude!.toStringAsFixed(5)}'
                : '-',
          ),
          _DistanceRow(log: log),
          _DetailRow(
            label: AppStrings.adminHashLabel,
            value: log.hash ?? '-',
          ),
          _DetailRow(
            label: AppStrings.adminPointsEstimateLabel,
            value: '$estimate ${AppStrings.rewardPointSuffix}',
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_busy)
            const Center(child: LoadingIndicator())
          else
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _askRejectReason(log),
                    icon: const Icon(LucideIcons.x, size: 18),
                    label: const Text(AppStrings.adminReject),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _approve(log),
                    icon: const Icon(LucideIcons.check, size: 18),
                    label: const Text(AppStrings.adminApprove),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Baris label-nilai di detail verifikasi.
class _DetailRow extends StatelessWidget {
  /// Membuat baris detail.
  const _DetailRow({required this.label, required this.value});

  /// Label baris.
  final String label;

  /// Nilai baris.
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: AppTypography.labelMd),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTypography.bodyMd),
        ],
      ),
    );
  }
}

/// Baris jarak log ke checkpoint (async).
class _DistanceRow extends ConsumerWidget {
  /// Membuat baris jarak.
  const _DistanceRow({required this.log});

  /// Waste log yang diukur.
  final WasteLog log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<int?>(
      future:
          ref.read(verifyWasteUsecaseProvider).distanceToCheckpoint(log),
      builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
        final String value =
            snapshot.data == null ? '-' : '${snapshot.data} m';
        return _DetailRow(
          label: AppStrings.adminDistanceLabel,
          value: value,
        );
      },
    );
  }
}

/// Foto bukti dari storage privat (signed URL).
class _PhotoSection extends ConsumerWidget {
  /// Membuat section foto bukti.
  const _PhotoSection({required this.photoPath});

  /// Path foto di storage.
  final String? photoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (photoPath == null || photoPath!.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceDim,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Text(AppStrings.adminNoPhoto),
      );
    }
    return FutureBuilder<String>(
      future: ref.read(adminWasteListProvider.notifier).photoUrl(photoPath!),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 200,
            child: Center(child: LoadingIndicator()),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Image.network(
            snapshot.data!,
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.surfaceDim,
              ),
              child: const Text(AppStrings.adminNoPhoto),
            ),
          ),
        );
      },
    );
  }
}
