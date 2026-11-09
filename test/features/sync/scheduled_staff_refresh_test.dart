import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/features/sync/data/sync_api.dart';
import 'package:pos_app_ui/features/sync/domain/sync_engine.dart';

/// SCHEDULED store outside its window: no run, but staff created in the admin still reach the terminal.
class _Api implements SyncApi {
  int pulls = 0;

  @override
  Future<Map<String, dynamic>> config() async => {
    'mode': 'SCHEDULED',
    'schedule_plan': <String, dynamic>{},
    'catch_up_due': false,
  };

  @override
  Future<Map<String, dynamic>> staff() async => {
    'changes': [
      {
        'change_id': 'c1',
        'origin': 'SERVER',
        'seq': 27,
        'txn_id': 't1',
        'hlc': '1794218352727-0000-SERVER',
        'entity': 'user',
        'entity_id': 'u-cashier',
        'operation': 'UPDATE',
        'payload': {'id': 'u-cashier', 'name': 'Cashier', 'active': true, 'roles': ['Cashier']},
        'schema_version': 1,
        'user_id': null,
        'created_at': '2026-11-09T09:59:12.727Z',
      },
    ],
  };

  @override
  Future<Map<String, dynamic>> pull({required int cursor, int limit = 500, String? runId}) async {
    pulls++;
    return {'changes': [], 'next_cursor': cursor, 'has_more': false};
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

void main() {
  test('waiting for schedule still downloads staff without moving the cursor', () async {
    final store = LocalStore(openTestDatabase(NativeDatabase.memory()));
    await store.open('P1');
    final api = _Api();

    final report = await SyncEngine(api, store).sync();

    expect(report.result, SyncResult.waitingForSchedule);
    expect(report.pulled, 1);
    expect(api.pulls, 0);
    expect((await store.all('user')).length, 1);
    expect(await store.getValue('pull_cursor'), isNull);
  });
}
