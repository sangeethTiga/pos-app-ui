import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app_ui/app/router.dart';
import 'package:pos_app_ui/app/routes.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/di/injection.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/sync/sync_change.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/sync/domain/sync_scheduler.dart';
import 'package:pos_app_ui/features/terminal/terminal_cubit.dart';

SyncChange row(int seq, String entity, String id, Map<String, dynamic> fields) => SyncChange(
  changeId: 'c$seq',
  origin: 'SERVER',
  seq: seq,
  txId: 't$seq',
  hlc: '1762585120000-000$seq-SERVER',
  entity: entity,
  entityId: id,
  op: 'INSERT',
  fields: fields,
  createdAt: '2026-11-08T07:00:00.000Z',
);

/// Place a takeaway order (dashboard opens on Take Away), open it, Edit Order (home screen in edit
/// mode with the whole order), add more and Update Order (add-on KOT, totals re-priced).
void main() {
  testWidgets('place -> dashboard tab -> edit order on home -> update order', (tester) async {
    Future<void> settle([int ms = 400]) async {
      await tester.runAsync(() => Future<void>.delayed(Duration(milliseconds: ms)));
      await tester.pumpAndSettle();
    }

    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await sl.reset();
    await configureDependencies(
      config: const AppConfig(apiBaseUrl: 'http://pos.test/api/v1', appVersion: '1.0.0'),
      secureStore: MemorySecureStore(),
      database: openTestDatabase(NativeDatabase.memory()),
    );
    final store = sl<LocalStore>();
    sl<TerminalContextHolder>().ctx = TerminalContext(
      deviceId: 'd1',
      deviceCode: 'P1',
      tokenLetter: 'A',
      storeId: 's1',
      storeName: 'Demo store',
      currency: 'AED',
      currencyDecimals: 2,
      timezone: 'Asia/Dubai',
      businessDayCutoff: '04:00',
      pricesIncludeTax: true,
    );
    await tester.runAsync(() async {
      await store.open('P1');
      await store.applyIncoming([
        row(1, 'user', 'u1', {
          'name': 'Asha',
          'email': 'anucashier@gmail.com',
          'active': true,
          'pin_hash': r'$2y$10$Ucs/UZbky3AT4mFew8TLo.kfbvDor4e9kkf3daMNSO9kMLL68DR5W',
          'password_hash': r'$2y$10$Ucs/UZbky3AT4mFew8TLo.kfbvDor4e9kkf3daMNSO9kMLL68DR5W', // "1234"
          'max_discount_bp': 1000,
          'permissions': [
            'order.create',
            'payment.take',
            'shift.open_close',
            'cash.in_out',
            'discount.apply',
            'order.reduce_qty_after_kot',
          ],
          'roles': ['Cashier'],
        }),
        row(2, 'tax', 't1', {'name': 'VAT', 'rate_bp': 500, 'is_default': true}),
        row(3, 'category', 'c1', {'name': 'Drinks'}),
        row(4, 'product', 'p1', {'category_id': 'c1', 'name': 'Fresh lime', 'price_minor': 800, 'active': true}),
        row(6, 'product', 'p2', {'category_id': 'c1', 'name': 'Mint tea', 'price_minor': 500, 'active': true}),
        row(5, 'payment_method', 'pm1', {'name': 'Cash', 'kind': 'CASH', 'is_cash_like': true, 'active': true}),
      ]);
    });

    final router = createRouter(initialLocation: Routes.lock);
    await tester.pumpWidget(
      BlocProvider.value(
        value: sl<TerminalCubit>(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    // Login: user, password (bcrypt; verification runs in an isolate), Morning Shift, 100.00 in the drawer.
    await tester.tap(find.byKey(const Key('userField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('anucashier@gmail.com').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('passwordField')), '1234');
    await tester.enterText(find.byKey(const Key('drawerField')), '100');
    expect(find.text('Morning Shift'), findsOneWidget);
    expect(find.text('CASHIER'), findsOneWidget);
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 2)));
    await tester.pumpAndSettle();
    expect(GoRouter.of(tester.element(find.byType(Scaffold).first)).state.matchedLocation, Routes.sell);
    final shift = (await tester.runAsync(() => store.all('shift')))!.single;
    expect([shift.data['name'], shift.data['opening_float_minor']], ['Morning Shift', 10000]);

    // place 2 x Fresh lime as takeaway
    await tester.tap(find.byKey(const Key('product-p1')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('product-p1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('chTakeaway')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('placeOrder')));
    await settle();
    GoRouter router0() => GoRouter.of(tester.element(find.byType(Scaffold).first));
    expect(router0().state.uri.toString(), '/orders?channel=TAKEAWAY');
    final order = (await tester.runAsync(() => store.all('orders')))!.single;
    expect(find.byKey(Key('order-${order.id}')), findsOneWidget);

    // Order Details -> Edit Order: home screen shows the whole order
    await tester.tap(find.byKey(Key('order-${order.id}')));
    await settle();
    await tester.tap(find.byKey(const Key('editOrder')));
    await settle();
    expect(router0().state.matchedLocation, Routes.sell);
    expect(find.textContaining('Bill No :  #P1-000001'), findsOneWidget);
    expect(find.textContaining('Bill Type : Take away'), findsOneWidget);
    expect(find.text('Update Order'), findsOneWidget);
    expect(find.text('Quick Update Order'), findsOneWidget);
    final lineId = (await tester.runAsync(() => store.all('order_line')))!.single.id;

    // one more Fresh lime on the same line, a new Mint tea, Update Order
    await tester.tap(find.byKey(Key('plus-$lineId')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('product-p2')));
    await tester.pumpAndSettle();
    expect(find.text('items(4)'), findsOneWidget);
    await tester.tap(find.byKey(const Key('placeOrder')));
    await settle();
    expect(router0().state.uri.toString(), '/orders?channel=TAKEAWAY');

    final lines = (await tester.runAsync(() => store.all('order_line')))!;
    expect(
      {for (final l in lines) l.data['name_snapshot']: l.data['qty_milli']},
      {'Fresh lime': 3000, 'Mint tea': 1000},
    );
    expect((await tester.runAsync(() => store.find('orders', order.id)))!.data['total_minor'], 2900);
    final kots = [for (final k in (await tester.runAsync(() => store.all('kot')))!) k.data['kind']];
    expect(kots, ['NEW', 'NEW_ITEMS']);

    await tester.pumpWidget(const SizedBox()); // disposes the dashboard timers
    await sl<SyncScheduler>().stop();
    await tester.runAsync(() => store.db.close());
  });
}
