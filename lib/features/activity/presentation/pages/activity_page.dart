// Halaman riwayat aktivitas Go Green.
//
// Menampilkan waste log milik user dari Supabase; tamu atau saat backend
// gagal memakai daftar demo.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../../../checkpoints/presentation/providers/checkpoint_provider.dart';
import '../../../waste/domain/entities/waste_log.dart';
import '../../../waste/domain/usecases/calculate_points_usecase.dart';
import '../../../waste/presentation/providers/waste_provider.dart';
import '../data/activity_demo_data.dart';
import '../data/activity_detail_extra.dart';
import '../data/activity_texts.dart';

/// Halaman riwayat aktivitas Go Green.
class ActivityPage extends ConsumerStatefulWidget {
  /// Membuat halaman aktivitas.
  const ActivityPage({super.key});

  @override
  ConsumerState<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage> {
  List<WasteLog>? _logs;
  Map<String, String> _checkpointNames = const <String, String>{};
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    final String? userId = SupabaseService.instance.currentUser?.id;
    if (userId == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final List<WasteLog> logs = await ref
          .read(wasteRepositoryProvider)
          .getWasteLogs(userId)
          .timeout(const Duration(seconds: 5));
      Map<String, String> names = const <String, String>{};
      try {
        final checkpoints = await ref
            .read(checkpointRepositoryProvider)
            .getAllCheckpoints()
            .timeout(const Duration(seconds: 5));
        names = <String, String>{
          for (final checkpoint in checkpoints)
            checkpoint.id: checkpoint.name,
        };
      } catch (_) {
        names = const <String, String>{};
      }
      if (!mounted) return;
      setState(() {
        _logs = logs;
        _checkpointNames = names;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<dynamic>>(
      wasteSubmitNotifierProvider,
      (previous, next) {
        if (next.valueOrNull != null && previous is AsyncLoading) _reload();
      },
    );
    final List<WasteLog>? logs = _logs;
    if (_loading) {
      return const Scaffold(
        body: SafeArea(
          child: Center(child: LoadingIndicator()),
        ),
      );
    }
    if (logs == null || logs.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              const Text(
                AppStrings.activityTitle,
                style: AppTypography.headlineLg,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_failed) ...<Widget>[
                const Text(
                  AppStrings.genericError,
                  style: AppTypography.bodySm,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextButton(
                  text: AppStrings.retryButton,
                  onPressed: _reload,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              for (final ActivityDemo activity in demoActivities) ...<Widget>[
                ActivityCard(
                  date: activity.date,
                  description: activity.description,
                  point: activity.point,
                  status: activity.status,
                  onTap: () => context.pushNamed(
                    AppRouteName.activityDetail,
                    pathParameters: <String, String>{'id': activity.id},
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
        ),
      );
    }
    const CalculatePointsUsecase calculatePoints = CalculatePointsUsecase();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            const Text(
              AppStrings.activityTitle,
              style: AppTypography.headlineLg,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final WasteLog log in logs) ...<Widget>[
              Builder(
                builder: (BuildContext context) {
                  final String checkpointName =
                      _checkpointNames[log.checkpointId] ??
                          (log.checkpointId ?? '-');
                  final int points = calculatePoints.calculate(
                    category: log.category,
                  );
                  final ({String label, StatusType type}) status =
                      activityStatusOf(log.status);
                  return ActivityCard(
                    date: log.createdAt,
                    description:
                        activityDescriptionOf(log, checkpointName),
                    point: points,
                    status: status.type,
                    onTap: () => context.pushNamed(
                      AppRouteName.activityDetail,
                      pathParameters: <String, String>{'id': log.id},
                      extra: ActivityDetailExtra(
                        description:
                            activityDescriptionOf(log, checkpointName),
                        date: log.createdAt,
                        status: log.status,
                        checkpointName: checkpointName,
                        points: points,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}
