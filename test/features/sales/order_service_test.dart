import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/sync/sync_change.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/catalogue/data/catalogue_repository.dart';
import 'package:pos_app_ui/features/sales/data/home_repository.dart';
import 'package:pos_app_ui/features/sales/domain/cart.dart';
import 'package:pos_app_ui/features/sales/domain/checkout_service.dart';
import 'package:pos_app_ui/features/sales/domain/order_service.dart';
import 'package:pos_app_ui/features/shift/domain/shift_service.dart';
import 'package:pos_app_ui/features/staff/data/staff_repository.dart';

var _seq = 0;
SyncChange _server(String entity, String id, Map<String, dynamic> fields) {
  _seq++;
  return SyncChange(
    changeId: 'c$_seq',
    origin: 'SERVER',
    seq: _seq,
    txId: 't$_seq',
    hlc: '1762585120000-${_seq.toString().padLeft(4, '0')}-SERVER',
    entity: entity,
    entityId: id,
    op: 'INSERT',
    fields: fields,
    createdAt: '2026-11-08T07:00:00.000Z',
  );
}

void main() {
  late LocalStore store;
  late ShiftService shifts;
  late CheckoutService checkout;
  late OrderService orders;
  late HomeRepository home;
  final ctx = TerminalContextHolder()
    ..ctx = TerminalContext(
      deviceId: 'd1',
      deviceCode: 'P1',
      tokenLetter: 'A',
      storeId: 's1',
      storeName: 'Al Noor Deira',
      currency: 'AED',
      currencyDecimals: 2,
      timezone: 'Asia/Dubai',
      businessDayCutoff: '04:00',
      pricesIncludeTax: true,
      kioskId: 'k1',
    );
  const settings = SalesSettings();
  CartLine line(String key, int price, {int qty = 1, String? productId = 'p1'}) => CartLine(
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
    shifts = ShiftService(store, ctx);
    checkout = CheckoutService(store, ctx, shifts);
    orders = OrderService(store, ctx, shifts, checkout);
    home = HomeRepository(store, StaffRepository(store, MemorySecureStore()));
  });
  tearDown(() => store.db.close());

  test('place order needs an open business day', () async {
    expect(
      () => orders.place(
        cart: Cart(lines: [line('a', 1000)]),
        settings: settings,
        userId: 'u1',
      ),
      throwsA(isA<SaleException>()),
    );
  });

  test('dine-in Place Order: open order with captain, PAX, KOT and kitchen note; add-on re-prices it', () async {
    await shifts.startShift(userId: 'u1', openingFloatMinor: 0);
    final cart = Cart(
      orderType: Channel.dineIn,
      tableId: 't1',
      tableName: 'B4',
      guests: 3,
      captainId: 'cap1',
      captainName: 'Riya',
      kitchenNote: 'less spicy',
      lines: [line('a', 1200), line('b', 1300, productId: null)],
    );
    final placed = await orders.place(cart: cart, settings: settings, userId: 'u1');
    expect([placed.orderNo, placed.tokenNo, placed.kind], ['P1-000001', 'A-001', 'NEW']);

    final order = (await store.find('orders', placed.orderId))!.data;
    expect(order['status'], 'OPEN');
    expect(order['payment_status'], 'UNPAID');
    expect(
      [order['table_id'], order['guests'], order['captain_id'], order['note'], order['kiosk_id']],
      ['t1', 3, 'cap1', 'less spicy', 'k1'],
    );
    expect(order['total_minor'], 2500);
    final tx = (await store.pendingTransactions()).last;
    expect(tx.map((c) => c.entity).toSet(), {
      'orders',
      'order_line',
      'order_event',
      'kot',
    }); // no payment, stock or ledger
    final kot = tx.firstWhere((c) => c.entity == 'kot').fields;
    expect((kot['lines'] as List).last, {'name': 'NOTE', 'qty_milli': 0, 'note': 'less spicy'});
    expect(tx.where((c) => c.entity == 'order_line').last.fields.containsKey('product_id'), isFalse); // open food

    final open = await orders.openOrders();
    expect(open.single.tableId, 't1');

    final added = await orders.place(
      cart: Cart(
        orderType: Channel.dineIn,
        tableId: 't1',
        existingOrderId: placed.orderId,
        lines: [line('c', 500, qty: 2)],
      ),
      settings: settings,
      userId: 'u1',
    );
    expect([added.orderNo, added.kind], ['P1-000001', 'NEW_ITEMS']);
    expect((await store.find('orders', placed.orderId))!.data['total_minor'], 3500);
    expect((await store.all('order_line')).length, 3);
  });

  test('partner and home-delivery fields go on the order', () async {
    await shifts.startShift(userId: 'u1', openingFloatMinor: 0);
    final placed = await orders.place(
      cart: Cart(
        orderType: 'DELIVERY',
        deliveryPartnerId: 'dp1',
        deliveryPartnerName: 'Keeta',
        partnerOrderNo: 'KT-1',
        lines: [line('a', 1000)],
      ),
      settings: settings,
      userId: 'u1',
    );
    final o = (await store.find('orders', placed.orderId))!.data;
    expect([o['order_type'], o['delivery_partner_id'], o['partner_order_no']], ['DELIVERY', 'dp1', 'KT-1']);
    expect(placed.cart.channel, Channel.partner);
  });

  test('hold and recall: the held cart leaves the list once placed', () async {
    await shifts.startShift(userId: 'u1', openingFloatMinor: 0);
    final cart = Cart(orderType: Channel.takeaway, customerName: 'Anu', lines: [line('a', 1000, qty: 2)]);
    final label = await orders.hold(cart: cart, settings: settings, userId: 'u1');
    expect(label, 'Hold 1 · Anu');
    final held = await orders.heldCarts();
    expect(held.single.totalMinor, 2000);
    final recalled = orders.recall(held.single);
    expect(recalled.lines.single.qtyMilli, 2000);
    expect(recalled.heldCartId, held.single.id);

    await orders.place(cart: recalled, settings: settings, userId: 'u1');
    expect(await orders.heldCarts(), isEmpty);
  });

  test('quick order (no KOT) settles without a kitchen ticket', () async {
    await shifts.startShift(userId: 'u1', openingFloatMinor: 0);
    await checkout.settle(
      cart: Cart(lines: [line('a', 1000)]),
      settings: settings,
      tenders: [(method: const PaymentMethod('pm', 'Cash', 'CASH', true), amountMinor: null)],
      userId: 'u1',
      cashierName: 'A',
      sendKot: false,
    );
    final tx = (await store.pendingTransactions()).last;
    expect(tx.any((c) => c.entity == 'kot'), isFalse);
    expect(tx.any((c) => c.entity == 'payment'), isTrue);
  });

  test('home repository: tables with areas, captains, partners, areas, customers', () async {
    await store.applyIncoming([
      _server('dining_area', 'a1', {'name': 'Balcony'}),
      _server('dining_table', 't2', {'name': 'B2', 'area_id': 'a1', 'seats': 2}),
      _server('dining_table', 't10', {'name': 'B10', 'area_id': 'a1', 'seats': 10}),
      _server('dining_table', 't1', {'name': 'B1', 'area_id': 'a1', 'seats': 2}),
      _server('delivery_partner', 'dp2', {'name': 'Keeta', 'sort_order': 2}),
      _server('delivery_partner', 'dp1', {'name': 'Talabat', 'sort_order': 1}),
      _server('store_setting', 's1', {
        'key': 'delivery_areas',
        'value': {
          'v': ['Deira', 'Karama'],
        },
      }),
      _server('user', 'u1', {
        'name': 'Riya',
        'active': true,
        'password_hash': 'x',
        'roles': ['Captain'],
      }),
      _server('user', 'u2', {
        'name': 'Anu',
        'active': true,
        'password_hash': 'x',
        'roles': ['Cashier'],
      }),
    ]);
    expect((await home.tables()).map((t) => '${t.name}/${t.area}/${t.capacity}'), [
      'B1/Balcony/2',
      'B2/Balcony/2',
      'B10/Balcony/10',
    ]);
    expect((await home.captains()).map((c) => c.name), ['Riya']);
    expect((await home.deliveryPartners()).map((p) => p.name), ['Talabat', 'Keeta']);
    expect(await home.deliveryAreas(), ['Deira', 'Karama']);

    final saved = await home.saveCustomer(
      name: 'Sana',
      mobile: '050 111 2222',
      address: const CustomerAddress(flat: '12A', building: 'Noor Tower', city: 'Dubai', area: 'Deira'),
      userId: 'u2',
    );
    expect(saved.address?.oneLine, '12A, Noor Tower, Deira, Dubai');
    expect((await home.customers(query: '0501112')).single.id, saved.id);
    expect(await home.customers(query: 'nobody'), isEmpty);
  });
}
