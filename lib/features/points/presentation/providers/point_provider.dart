// Provider data poin.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/point.dart';
import '../../data/datasources/points_dummy_datasource.dart';
import '../../data/datasources/points_remote_datasource.dart';
import '../../data/models/point_model.dart';
import '../../../../core/constants/app_env.dart';

/// Provider data source poin (dummy saat [AppEnv.useDummyApi] true).
final Provider<PointsRemoteDatasource> pointsRemoteDatasourceProvider =
    Provider<PointsRemoteDatasource>(
  (Ref ref) => AppEnv.useDummyApi
      ? PointsDummyDatasource()
      : PointsRemoteDatasource(),
);

/// State saldo dan riwayat poin.
class PointsState {
  const PointsState({required this.totalPoints, required this.history});

  /// Saldo poin (earn dikurangi redeem).
  final int totalPoints;

  /// Riwayat poin, terbaru di atas.
  final List<Point> history;
}

/// Notifier saldo dan riwayat poin.
class PointsNotifier extends StateNotifier<AsyncValue<PointsState>> {
  PointsNotifier(this._datasource)
      : super(const AsyncLoading<PointsState>());

  final PointsRemoteDatasource _datasource;

  /// Memuat saldo dan riwayat poin user.
  Future<void> load({required String userId}) async {
    state = const AsyncLoading<PointsState>();
    state = await AsyncValue.guard<PointsState>(() async {
      final int total = await _datasource.getTotalPoints(userId);
      final List<Map<String, dynamic>> rows =
          await _datasource.getPointsHistory(userId);
      final List<Point> history =
          rows.map(PointModel.fromJson).toList(growable: false);
      return PointsState(totalPoints: total, history: history);
    });
  }
}

/// Provider state poin user.
final StateNotifierProvider<PointsNotifier, AsyncValue<PointsState>>
    pointsNotifierProvider =
    StateNotifierProvider<PointsNotifier, AsyncValue<PointsState>>(
  (Ref ref) => PointsNotifier(ref.watch(pointsRemoteDatasourceProvider)),
);
