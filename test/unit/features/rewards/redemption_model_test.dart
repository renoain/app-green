// Unit test model Redemption (join rewards + status tak dikenal).

import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/constants/app_enums.dart';
import 'package:go_green/features/rewards/data/models/redemption_model.dart';

void main() {
  test('fromJson membaca join nama reward', () {
    final RedemptionModel model = RedemptionModel.fromJson(
      <String, dynamic>{
        'id': 'red-1',
        'reward_id': 'rw-1',
        'status': 'approved',
        'created_at': '2026-09-20T10:00:00Z',
        'rewards': <String, dynamic>{'name': 'Voucher Belanja'},
      },
    );
    expect(model.id, 'red-1');
    expect(model.rewardId, 'rw-1');
    expect(model.rewardName, 'Voucher Belanja');
    expect(model.status, RedemptionStatus.approved);
  });

  test('tanpa join nama null dan status tak dikenal jadi pending', () {
    final RedemptionModel model = RedemptionModel.fromJson(
      <String, dynamic>{
        'id': 'red-2',
        'reward_id': null,
        'status': 'aneh',
        'created_at': '2026-09-20T10:00:00Z',
      },
    );
    expect(model.rewardName, isNull);
    expect(model.status, RedemptionStatus.pending);
  });
}
