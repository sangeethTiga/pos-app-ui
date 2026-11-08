import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/sync/hlc.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/sync/sync_change.dart';

SyncChange server(int seq, String entity, String id, String op, Map<String, dynamic> fields, String hlc) => SyncChange(
  changeId: 'c$seq',
  origin: 'SERVER',
  seq: seq,
  txId: 't$seq',
  hlc: hlc,
  entity: entity,
  entityId: id,
  op: op,
  fields: fields,
  createdAt: '2026-11-08T07:00:00.000Z',
);

void main() {
  late LocalStore store;
  const wall = 1762585120000;

  setUp(() async {
    store = LocalStore(openTestDatabase(NativeDatabase.memory()), () => wall);
    await store.open('P1');
  });
  tearDown(() => store.db.close());

  test('HLC format, ordering and receive rule', () {
    expect(Hlc.parse('1762585120000-0003-P2').toString(), '1762585120000-0003-P2');
    expect(Hlc.parse('1762585120000-0003-P2') > Hlc.parse('1762585120000-0003-P1'), isTrue);
    final clock = HlcClock('P1', wallMs: () => 1000);
    expect(clock.now().toString(), '0000000001000-0000-P1');
    expect(clock.now().counter, 1);
    expect(clock.receive(Hlc(5000, 7, 'SERVER')).toString(), '0000000005000-0008-P1');
    expect(clock.now().toString(), '0000000005000-0009-P1'); // never goes back to wall time 1000
  });

  test('commit: one transaction, contiguous seqs from 1, pending until acknowledged', () async {
    await store.commit([
      LocalChange.insert('orders', {'status': 'OPEN', 'order_no': 'P1-000001'}, id: 'o1'),
      LocalChange.insert('order_line', {'order_id': 'o1', 'qty_milli': 1000}),
    ]);
    await store.commit([
      LocalChange.update('orders', 'o1', {'status': 'SETTLED'}),
    ]);

    final txs = await store.pendingTransactions();
    expect(txs.map((t) => t.map((c) => c.seq).toList()).toList(), [
      [1, 2],
      [3],
    ]);
    expect(txs[0].every((c) => c.txId == txs[0].first.txId), isTrue);
    expect((await store.find('orders', 'o1'))!.data['status'], 'SETTLED');
    expect(await store.heldVector(), {'P1': 3});

    await store.acknowledge({'P1': 2, 'SERVER': 10});
    expect(await store.pendingCount(), 1);
    expect(await store.getJson('acked_vector'), {'P1': 2, 'SERVER': 10});
  });

  test('sequence and HLC survive a restart', () async {
    await store.commit([
      LocalChange.insert('kot', {'order_id': 'o1'}),
    ]);
    final again = LocalStore(store.db, () => 0); // wall clock went backwards
    await again.open('P1');
    await again.commit([
      LocalChange.insert('kot', {'order_id': 'o2'}),
    ]);
    final seqs = (await again.pendingTransactions()).expand((t) => t).map((c) => c.seq).toList();
    final hlcs = (await again.pendingTransactions()).expand((t) => t).map((c) => Hlc.parse(c.hlc)).toList();
    expect(seqs, [1, 2]);
    expect(hlcs[1] > hlcs[0], isTrue);
  });

  test('incoming: field-level last-writer-wins, delete wins, append-only rows never change', () async {
    await store.applyIncoming([
      server(1, 'product', 'p1', 'INSERT', {'name': 'Cola', 'price_minor': 1200}, '1762585120000-0000-SERVER'),
    ]);
    // older price edit loses, newer name edit wins
    await store.applyIncoming([
      server(2, 'product', 'p1', 'UPDATE', {'price_minor': 900}, '1762585110000-0000-SERVER'),
      server(3, 'product', 'p1', 'UPDATE', {'name': 'Cola Zero'}, '1762585130000-0000-SERVER'),
    ]);
    final p = await store.find('product', 'p1');
    expect(p!.data, {'name': 'Cola Zero', 'price_minor': 1200});

    await store.applyIncoming([server(4, 'product', 'p1', 'DELETE', {}, '1762585140000-0000-SERVER')]);
    await store.applyIncoming([
      server(5, 'product', 'p1', 'UPDATE', {'name': 'X'}, '1762585150000-0000-SERVER'),
    ]);
    expect(await store.all('product'), isEmpty);
    expect((await store.find('product', 'p1'))!.deleted, isTrue);

    await store.applyIncoming([
      server(6, 'payment', 'pay1', 'INSERT', {'amount_minor': 100}, '1762585120000-0000-P2'),
    ]);
    await store.applyIncoming([
      server(7, 'payment', 'pay1', 'UPDATE', {'amount_minor': 999}, '1762585190000-0000-P2'),
    ]);
    expect((await store.find('payment', 'pay1'))!.data['amount_minor'], 100);
  });

  test('order status never moves backwards', () async {
    await store.applyIncoming([
      server(1, 'orders', 'o1', 'INSERT', {'status': 'VOIDED'}, '1762585120000-0000-P2'),
      server(2, 'orders', 'o1', 'UPDATE', {'status': 'SETTLED'}, '1762585190000-0000-P3'),
    ]);
    expect((await store.find('orders', 'o1'))!.data['status'], 'VOIDED');
  });

  test('bindTo: another device id empties the database, the same id keeps it', () async {
    await store.bindTo('d1');
    await store.applyIncoming([
      server(1, 'user', 'u1', 'INSERT', {'name': 'Old'}, '1762585120000-0001-SERVER'),
    ]);
    await store.bindTo('d1');
    expect(await store.all('user'), hasLength(1));

    await store.bindTo('d2');
    expect(await store.all('user'), isEmpty);
    expect(await store.getValue('paired_device_id'), 'd2');
  });
}
