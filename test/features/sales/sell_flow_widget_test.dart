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

/// Cashier logs in with a PIN, opens a shift, sells a product for cash; the sale lands in the change log.
void main() {
  testWidgets('PIN login -> open shift -> sell -> pay cash', (tester) async {
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
          'active': true,
          'pin_hash': r'$2y$10$Ucs/UZbky3AT4mFew8TLo.kfbvDor4e9kkf3daMNSO9kMLL68DR5W',
          'max_discount_bp': 1000,
          'permissions': ['order.create', 'payment.take', 'shift.open_close', 'cash.in_out', 'discount.apply'],
        }),
        row(2, 'tax', 't1', {'name': 'VAT', 'rate_bp': 500, 'is_default': true}),
        row(3, 'category', 'c1', {'name': 'Drinks'}),
        row(4, 'product', 'p1', {'category_id': 'c1', 'name': 'Fresh lime', 'price_minor': 800, 'active': true}),
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

    // PIN login (bcrypt hash; verification runs in an isolate)
    await tester.tap(find.byKey(const Key('user-u1')));
    await tester.pump();
    for (final d in ['1', '2', '3', '4']) {
      await tester.tap(find.byKey(Key('pin-$d')));
      await tester.pump();
    }
    await tester.tap(find.byKey(const Key('pin-ok')));
    await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 2)));
    await tester.pumpAndSettle();
    expect(GoRouter.of(tester.element(find.byType(Scaffold).first)).state.matchedLocation, Routes.sell);

    // open shift with 100.00 float
    await tester.tap(find.byKey(const Key('openShift')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '100');
    await tester.tap(find.text('OK'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pumpAndSettle();

    // sell 2 x Fresh lime, pay all cash
    await tester.tap(find.byKey(const Key('product-p1')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('product-p1')));
    await tester.pumpAndSettle();
    expect(find.text('16.00'), findsWidgets);
    await tester.tap(find.byKey(const Key('pay')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('payAll-CASH')));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 500)));
    await tester.pumpAndSettle();
    expect(find.text('Paid · P1-000001'), findsOneWidget);
    await tester.tap(find.byKey(const Key('nextSale')));
    await tester.pumpAndSettle();

    final orders = await tester.runAsync(() => store.all('orders'));
    expect(orders!.single.data['total_minor'], 1600);
    expect(await tester.runAsync(store.pendingCount), greaterThan(5));
    await sl<SyncScheduler>().stop(); // cancels the upload debounce timer
    await tester.runAsync(() => store.db.close());
  });
}
