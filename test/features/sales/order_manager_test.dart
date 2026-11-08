import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/sync/sync_change.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/catalogue/data/catalogue_repository.dart';
import 'package:pos_app_ui/features/orders/presentation/orders_cubit.dart';
import 'package:pos_app_ui/features/sales/domain/cart.dart';
import 'package:pos_app_ui/features/sales/domain/checkout_service.dart';
import 'package:pos_app_ui/features/sales/domain/order_manager.dart';
import 'package:pos_app_ui/features/sales/domain/order_service.dart';
import 'package:pos_app_ui/features/shift/domain/shift_service.dart';
import 'package:pos_app_ui/features/staff/data/staff_repository.dart';

void main() {
  late LocalStore store;
  late ShiftService shifts;
  late CheckoutService checkout;
  late OrderService orders;
  late OrderManager manager;
  final ctx = TerminalContextHolder()
    ..ctx = TerminalContext(
      deviceId: 'd1',
      deviceCode: 'P1',
      tokenLetter: 'A',
      storeId: 's1',
      storeName: 'Khyber Darbar',
      currency: 'AED',
      currencyDecimals: 2,
      timezone: 'Asia/Dubai',
      businessDayCutoff: '04:00',
      pricesIncludeTax: true,
    );
  const settings = SalesSettings();
  const cash = PaymentMethod('pm1', 'Cash', 'CASH', true);
  CartLine line(String key, int price, {int qty = 1, String productId = 'p1'}) => CartLine(
    key: key,
    productId: productId,
    name: 'Item $key',
    unitPriceMinor: price,
    qtyMilli: qty * 1000,
    taxRateBp: 500,
    priceIncludesTax: true,
    trackStock: false,
  );

  setUp(() async {
    store = LocalStore(openTestDatabase(NativeDatabase.memory()));
    await store.open('P1');
    await store.applyIncoming([
      SyncChange(
        changeId: 'c1',
        origin: 'SERVER',
        seq: 1,
        txId: 't1',
        hlc: '1762585120000-0001-SERVER',
        entity: 'dining_table',
        entityId: 't1',
        op: 'INSERT',
        fields: {'name': 'B4', 'seats': 4},
        createdAt: '2026-11-08T07:00:00.000Z',
      ),
      SyncChange(
        changeId: 'c2',
        origin: 'SERVER',
        seq: 2,
        txId: 't2',
        hlc: '1762585120000-0002-SERVER',
        entity: 'product',
        entityId: 'tracked',
        op: 'INSERT',
        fields: {'name': 'Cola', 'price_minor': 300, 'track_stock': true},
        createdAt: '2026-11-08T07:00:00.000Z',
      ),
    ]);
    shifts = ShiftService(store, ctx);
    checkout = CheckoutService(store, ctx, shifts);
    orders = OrderService(store, ctx, shifts, checkout);
    manager = OrderManager(store, ctx, checkout, StaffRepository(store, MemorySecureStore()));
    await shifts.startShift(userId: 'u1', openingFloatMinor: 0);
  });
  tearDown(() => store.db.close());

  Future<String> place(List<CartLine> lines, {String type = Channel.dineIn}) async => (await orders.place(
    cart: Cart(orderType: type, tableId: type == Channel.dineIn ? 't1' : null, guests: 2, lines: lines),
    settings: settings,
    userId: 'u1',
  )).orderId;

  test(
    'dashboard summary: table, PAX, ongoing, pending sync; settle closes it with payment, stock and ledger',
    () async {
      final id = await place([line('a', 1200), line('b', 300, qty: 2, productId: 'tracked')]);
      var s = (await manager.summaries()).single;
      expect(
        [s.orderNo, s.where, s.state, s.synced, s.totalMinor],
        ['P1-000001', 'Table B4/2', 'ongoing', false, 1800],
      );
      expect(s.openedAt, isNotNull);

      final sale = await checkout.settleOrder(
        orderId: id,
        settings: settings,
        tenders: [(method: cash, amountMinor: null)],
        userId: 'u1',
        cashierName: 'Anu',
        cashTenderedMinor: 2000,
      );
      expect(sale.changeDueMinor, 200);
      s = (await manager.summaries()).single;
      expect(s.state, 'paid');
      final tx = (await store.pendingTransactions()).last;
      expect(tx.map((c) => c.entity).toSet(), {'orders', 'payment', 'stock_movement', 'ledger_entry', 'order_event'});
      expect(tx.firstWhere((c) => c.entity == 'stock_movement').fields['qty_milli'], -2000);
      expect(
        () => checkout.settleOrder(
          orderId: id,
          settings: settings,
          tenders: [(method: cash, amountMinor: null)],
          userId: 'u1',
          cashierName: 'A',
        ),
        throwsA(isA<SaleException>()),
      );
    },
  );

  test('item transfer, bill split and merge move lines and re-price both bills', () async {
    final a = await place([line('a', 1000), line('b', 500)]);
    final b = await place([line('c', 700)], type: Channel.takeaway);
    final aLines = (await manager.detail(a, settings)).lines;

    await manager.transferItems(fromId: a, lineIds: {aLines.last.id}, toId: b, settings: settings, userId: 'u1');
    expect((await store.find('orders', a))!.data['total_minor'], 1000);
    expect((await store.find('orders', b))!.data['total_minor'], 1200);
    expect(
      () => manager.transferItems(fromId: a, lineIds: {aLines.first.id}, toId: b, settings: settings, userId: 'u1'),
      throwsA(isA<SaleException>()),
    ); // last item: use Merge

    final bLines = (await manager.detail(b, settings)).lines;
    final newNo = await manager.split(
      orderId: b,
      lineIds: {bLines.firstWhere((l) => l.name == 'Item c').id},
      settings: settings,
      userId: 'u1',
    );
    expect(newNo, 'P1-000003');
    final all = await manager.summaries();
    expect(all.firstWhere((o) => o.orderNo == newNo).totalMinor, 700);
    expect((await store.find('orders', b))!.data['total_minor'], 500);

    await manager.merge(sourceId: b, targetId: a, settings: settings, userId: 'u1');
    expect((await store.find('orders', a))!.data['total_minor'], 1500);
    final merged = (await manager.summaries()).firstWhere((o) => o.id == b);
    expect([merged.state, merged.voidReason], ['void', 'Merged into P1-000001']);
  });

  test('table transfer, bill type change, discount, reduce with cancel KOT, void', () async {
    final id = await place([line('a', 1000, qty: 3), line('b', 500)]);
    await manager.transferTable(orderId: id, tableId: 't1', guests: 4, userId: 'u1');
    expect((await store.find('orders', id))!.data['guests'], 4);

    await manager.changeType(orderId: id, orderType: Channel.takeaway, settings: settings, userId: 'u1');
    final o = (await store.find('orders', id))!.data;
    expect([o['order_type'], o['table_id']], ['TAKEAWAY', null]);

    await manager.applyDiscount(orderId: id, bp: 1000, settings: settings, userId: 'u1');
    expect((await store.find('orders', id))!.data['total_minor'], 3150); // 3500 - 10 %

    final lines = (await manager.detail(id, settings)).lines;
    await manager.reduce(orderId: id, qty: {lines.first.id: 1000, lines.last.id: 0}, settings: settings, userId: 'u1');
    final d = await manager.detail(id, settings);
    expect(d.lines.single.qtyMilli, 1000);
    expect(d.priced!.totalMinor, 900);
    final kot = (await store.pendingTransactions()).last.firstWhere((c) => c.entity == 'kot').fields;
    expect([kot['kind'], (kot['lines'] as List).length], ['CANCEL', 2]);

    await manager.markBilled(id, 'u1');
    expect((await store.find('orders', id))!.data['status'], 'BILLED');
    await manager.voidOrder(orderId: id, reason: 'Cancelled by customer', userId: 'u1');
    expect((await manager.summaries()).single.state, 'cancelled');
  });

  test('add items to a running order through the home screen intent', () async {
    final id = await place([line('a', 1000)]);
    manager.homeIntent = Cart(
      orderType: Channel.dineIn,
      tableId: 't1',
      existingOrderId: id,
      existingOrderNo: 'P1-000001',
    );
    final intent = manager.homeIntent!;
    await orders.place(
      cart: intent.copyWith(lines: [line('z', 400)]),
      settings: settings,
      userId: 'u1',
    );
    expect((await store.find('orders', id))!.data['total_minor'], 1400);
  });

  test('dashboard opens on the tab of the order just placed', () async {
    final carts = {
      Channel.dineIn: const Cart(orderType: Channel.dineIn, tableId: 't1'),
      Channel.takeaway: const Cart(orderType: Channel.takeaway),
      Channel.homeDelivery: const Cart(orderType: Channel.homeDelivery),
      Channel.partner: const Cart(orderType: Channel.homeDelivery, deliveryPartnerId: 'dp1', partnerOrderNo: 'T-55'),
    };
    for (final MapEntry(key: channel, value: cart) in carts.entries) {
      final placed = await orders.place(
        cart: cart.copyWith(lines: [line(channel, 1000)]),
        settings: settings,
        userId: 'u1',
      );
      expect(placed.cart.channel, channel);
      final cubit = OrdersCubit(manager, CatalogueRepository(store))..open(placed.cart.channel);
      await cubit.load();
      expect(cubit.state.channel, channel);
      expect(cubit.state.visible.map((o) => o.id), contains(placed.orderId));
      await cubit.close();
    }
    final cubit = OrdersCubit(manager, CatalogueRepository(store))..open('NOPE');
    expect(cubit.state.channel, Channel.dineIn);
    await cubit.close();
  });
}
