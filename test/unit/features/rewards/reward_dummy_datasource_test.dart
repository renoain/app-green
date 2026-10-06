// Unit test RewardDummyDatasource (mock dio, tanpa json-server jalan).

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:go_green/features/rewards/data/datasources/reward_dummy_datasource.dart';
import 'package:go_green/features/rewards/data/models/redemption_model.dart';
import 'package:go_green/features/rewards/data/models/reward_model.dart';

class MockDio extends Mock implements Dio {}

Response<dynamic> _response(Object? data, {int statusCode = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: ''),
    data: data,
    statusCode: statusCode,
  );
}

DioException _notFound() {
  return DioException(
    requestOptions: RequestOptions(path: ''),
    response: _response('Not Found', statusCode: 404),
  );
}

Map<String, dynamic> _rewardRow({String id = 'reward-1', bool active = true}) {
  return <String, dynamic>{
    'id': id,
    'name': 'Voucher Belanja 10.000',
    'description': 'Voucher belanja senilai 10 ribu',
    'points_cost': 100,
    'stock': 50,
    'is_active': active,
    'created_at': '2026-09-01T00:00:00Z',
  };
}

void main() {
  late MockDio dio;
  late RewardDummyDatasource datasource;

  setUp(() {
    dio = MockDio();
    datasource = RewardDummyDatasource(dio: dio);
  });

  group('RewardDummyDatasource.getAllRewards', () {
    test('parse daftar reward aktif', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => _response([_rewardRow(), _rewardRow(id: 'reward-2')]),
      );

      final List<RewardModel> items = await datasource.getAllRewards();

      expect(items, hasLength(2));
      expect(items.first.pointsCost, 100);
    });

    test('error jaringan dilempar ulang setelah dicatat', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(
        () => datasource.getAllRewards(),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('RewardDummyDatasource.getRewardById', () {
    test('kembalikan null saat server 404', () async {
      when(() => dio.get(any())).thenThrow(_notFound());

      expect(await datasource.getRewardById('reward-hilang'), isNull);
    });

    test('kembalikan null untuk reward nonaktif', () async {
      when(() => dio.get(any()))
          .thenAnswer((_) async => _response(_rewardRow(active: false)));

      expect(await datasource.getRewardById('reward-1'), isNull);
    });
  });

  group('RewardDummyDatasource.createReward', () {
    test('kirim POST dan parse hasil', () async {
      when(
        () => dio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _response(_rewardRow(id: 'reward-baru')));

      final RewardModel reward = await datasource.createReward(
        name: 'Voucher Baru',
        pointsCost: 200,
        stock: 10,
        isActive: true,
      );

      expect(reward.id, 'reward-baru');
      verify(() => dio.post('/rewards', data: any(named: 'data'))).called(1);
    });
  });

  group('RewardDummyDatasource.deleteReward', () {
    test('kirim DELETE ke id yang benar', () async {
      when(() => dio.delete(any()))
          .thenAnswer((_) async => _response(<String, dynamic>{}));

      await datasource.deleteReward('reward-1');

      verify(() => dio.delete('/rewards/reward-1')).called(1);
    });
  });

  group('RewardDummyDatasource.getUserRedemptions', () {
    test('parse daftar penukaran user', () async {
      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) async => _response([
          <String, dynamic>{
            'id': 'red-1',
            'reward_id': 'reward-1',
            'status': 'pending',
            'voucher_code': 'ABCD1234',
            'created_at': '2026-10-03T08:00:00Z',
          },
        ]),
      );

      final List<RedemptionModel> items =
          await datasource.getUserRedemptions('user-1');

      expect(items, hasLength(1));
      expect(items.first.voucherCode, 'ABCD1234');
    });
  });

  group('RewardDummyDatasource.redeemReward', () {
    test('delegasi ke points dan kembalikan voucher', () async {
      when(
        () => dio.post(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _response(<String, dynamic>{}));

      final String voucher = await datasource.redeemReward(
        userId: 'user-1',
        rewardId: 'reward-1',
      );

      expect(voucher, hasLength(8));
    });
  });
}
