import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/sync/sync_change.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/catalogue/data/catalogue_repository.dart';
import 'package:pos_app_ui/features/orders/presentation/order_detail_cubit.dart';
import 'package:pos_app_ui/features/orders/presentation/orders_cubit.dart';
import 'package:pos_app_ui/features/sales/domain/cart.dart';
import 'package:pos_app_ui/features/sales/domain/checkout_service.dart';
import 'package:pos_app_ui/features/sales/domain/order_manager.dart';
import 'package:pos_app_ui/features/sales/domain/order_service.dart';
import 'package:pos_app_ui/features/shift/domain/shift_service.dart';
import 'package:pos_app_ui/features/staff/data/staff_repository.dart';

/// All cashiers see all orders: another terminal's order arrives through sync (relayed by the
/// server with that terminal's HLC), the dashboard and an open order reload by themselves, and the
/// echo of this terminal's own change never overwrites a newer local edit.
void main() {
  late LocalStore store;
  late OrderManager manager;
  late OrderService orders;
  late ShiftService shifts;
  final ctx = TerminalContextHolder()
    ..ctx = TerminalContext(
      deviceId: 'd1',
      deviceCode: 'P1',
      tokenLetter: 'A',
      storeId: 's1',
      storeName: 'Al Noor',
      currency: 'AED',
      currencyDecimals: 2,
      timezone: 'Asia/Dubai',
      businessDayCutoff: '04:00',
      pricesIncludeTax: true,
    );
  var seq = 100;
  SyncChange relayed(String entity, String id, String op, Map<String, dynamic> fields, String hlc) => SyncChange(
    changeId: 'r${seq++}',
    origin: 'SERVER',
    seq: seq,
    txId: 'tx$seq',
    hlc: hlc,
    entity: entity,
    entityId: id,
    op: op,
    fields: fields,
    createdAt: '2026-11-08T07:00:00.000Z',
  );

  setUp(() async {
    store = LocalStore(openTestDatabase(NativeDatabase.memory()));
    await store.open('P1');
    shifts = ShiftService(store, ctx);
    final checkout = CheckoutService(store, ctx, shifts);
    orders = OrderService(store, ctx, shifts, checkout);
    manager = OrderManager(store, ctx, checkout, StaffRepository(store, MemorySecureStore()));
    await shifts.startShift(userId: 'u1', openingFloatMinor: 0);
  });
  tearDown(() => store.db.close());

  test('another cashier\'s order shows up live on the dashboard and in an open order', () async {
    final dashboard = OrdersCubit(manager, CatalogueRepository(store))..channel(Channel.takeaway);
    await dashboard.load();
    expect(dashboard.state.visible, isEmpty);

    final reloaded = dashboard.stream.firstWhere((s) => s.orders.isNotEmpty);
    await store.applyIncoming([
      relayed('orders', 'o-p2', 'INSERT', {
        'order_no': 'P2-000001',
        'token_no': 'B-001',
        'order_type': 'TAKEAWAY',
        'status': 'OPEN',
        'total_minor': 1050,
        'device_code': 'P2',
      }, '1762585200000-0000-P2'),
      relayed('order_line', 'l-p2', 'INSERT', {
        'order_id': 'o-p2',
        'name_snapshot': 'Karak tea',
        'qty_milli': 1000,
        'unit_price_minor': 1050,
        'tax_rate_bp': 500,
        'price_includes_tax': true,
        'kot_status': 'SENT',
      }, '1762585200000-0001-P2'),
    ]);
    final s = await reloaded.timeout(const Duration(seconds: 2));
    expect(s.visible.single.orderNo, 'P2-000001');

    // the order is open here: P2 settles it, the screen follows
    final detail = OrderDetailCubit('o-p2', manager, CheckoutService(store, ctx, shifts), CatalogueRepository(store));
    await detail.load();
    expect(detail.state.detail!.summary.ongoing, isTrue);
    final settled = detail.stream.firstWhere((s) => s.detail?.summary.state == 'paid');
    await store.applyIncoming([
      relayed('orders', 'o-p2', 'UPDATE', {'status': 'SETTLED', 'payment_status': 'PAID'}, '1762585300000-0000-P2'),
    ]);
    expect((await settled.timeout(const Duration(seconds: 2))).detail!.summary.state, 'paid');

    await detail.close();
    await dashboard.close();
  });

  test('the echo of an own change does not undo a newer local edit; day close counts own orders only', () async {
    final placed = await orders.place(
      cart: const Cart(
        orderType: Channel.takeaway,
        lines: [
          CartLine(
            key: 'a',
            productId: 'p1',
            name: 'Tea',
            unitPriceMinor: 500,
            qtyMilli: 1000,
            taxRateBp: 500,
            priceIncludesTax: true,
            trackStock: false,
          ),
        ],
      ),
      settings: const SalesSettings(),
      userId: 'u1',
    );
    final first = (await store.find('orders', placed.orderId))!;
    final firstHlc = (await store.pendingTransactions()).last.firstWhere((c) => c.entity == 'orders').hlc;
    // a newer local edit, then the server's echo of the first insert arrives
    await store.commit([
      LocalChange.update('orders', placed.orderId, {'token_no': 'A-NEW'}),
    ], userId: 'u1');
    await store.applyIncoming([
      relayed('orders', placed.orderId, 'UPDATE', {'token_no': first.data['token_no']}, firstHlc),
    ]);
    expect((await store.find('orders', placed.orderId))!.data['token_no'], 'A-NEW');

    // P2's order and payment are on this terminal too, but not in this terminal's day close
    await store.applyIncoming([
      relayed('orders', 'o-p2', 'INSERT', {
        'order_no': 'P2-000009',
        'order_type': 'TAKEAWAY',
        'status': 'SETTLED',
        'total_minor': 9000,
        'business_day_id': 'day-p2',
        'business_date': (await shifts.openDay())!.data['business_date'],
      }, '1762585400000-0000-P2'),
      relayed('payment', 'pay-p2', 'INSERT', {
        'order_id': 'o-p2',
        'method_kind': 'CASH',
        'amount_minor': 9000,
        'business_date': (await shifts.openDay())!.data['business_date'],
      }, '1762585400000-0001-P2'),
    ]);
    await shifts.closeShift(userId: 'u1', countedCashMinor: 0);
    final totals = await shifts.closeDay(userId: 'u1');
    expect(totals['payments_by_kind'], isEmpty);
    expect(totals['orders'], 0);
  });
}
