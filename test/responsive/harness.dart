import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/app/router.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/di/injection.dart';
import 'package:pos_app_ui/core/responsive/responsive.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/sync/sync_change.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/catalogue/data/catalogue_repository.dart';
import 'package:pos_app_ui/features/printing/data/printer_service.dart';
import 'package:pos_app_ui/features/sales/domain/cart.dart';
import 'package:pos_app_ui/features/sales/domain/order_service.dart';
import 'package:pos_app_ui/features/shift/domain/shift_service.dart';
import 'package:pos_app_ui/features/staff/data/staff_repository.dart';
import 'package:pos_app_ui/features/sync/domain/sync_scheduler.dart';
import 'package:pos_app_ui/features/terminal/terminal_cubit.dart';

import '../features/printing/printing_test.dart' show FakeTransport;
import '../helpers/activation.dart';

/// Screen sizes every screen is checked at (logical px, device pixel ratio 1).
const posSizes = <String, Size>{
  'phone-320': Size(320, 640),
  'phone-portrait': Size(390, 844),
  'phone-landscape': Size(844, 390),
  'tablet-portrait': Size(800, 1280),
  'tablet-landscape': Size(1280, 800),
  'pos-1024x768': Size(1024, 768),
  'desktop-1366x768': Size(1366, 768),
  'fullhd-1920x1080': Size(1920, 1080),
  'tv-4k-3840x2160': Size(3840, 2160),
};

void setScreen(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
}

SyncChange _row(int seq, String entity, String id, Map<String, dynamic> fields) => SyncChange(
  changeId: 'c$seq',
  origin: 'SERVER',
  seq: seq,
  txId: 't$seq',
  hlc: '1762585120000-${seq.toString().padLeft(4, '0')}-SERVER',
  entity: entity,
  entityId: id,
  op: 'INSERT',
  fields: fields,
  createdAt: '2026-11-08T07:00:00.000Z',
);

const allPermissions = [
  'order.create',
  'order.void',
  'order.transfer',
  'order.reduce_qty_after_kot',
  'payment.take',
  'shift.open_close',
  'cash.in_out',
  'discount.apply',
  'day.close',
  'settings.manage',
];

/// Dependencies with an in-memory store holding a realistic demo menu (12 categories, 48 products
/// with long names), tables, captains, partners, a customer, a kiosk and two kitchen stations; a
/// logged-in cashier with an open shift and, with [orders], a few placed orders. Call [tearDownPos]
/// at the end of the test.
Future<LocalStore> setUpPos(WidgetTester tester, {int orders = 0, bool captainDevice = false}) async {
  await sl.reset();
  await configureDependencies(
    config: const AppConfig(apiBaseUrl: 'http://pos.test/api/v1', appVersion: '1.0.0'),
    secureStore: MemorySecureStore(),
    database: openTestDatabase(NativeDatabase.memory()),
    printerTransport: FakeTransport(),
  );
  await tester.runAsync(activateTerminal);
  final store = sl<LocalStore>();
  sl<TerminalContextHolder>().ctx = TerminalContext(
    deviceId: 'd1',
    deviceCode: 'P1',
    tokenLetter: 'A',
    storeId: 's1',
    storeName: 'Al Noor Restaurant Deira',
    currency: 'AED',
    currencyDecimals: 2,
    timezone: 'Asia/Dubai',
    businessDayCutoff: '04:00',
    pricesIncludeTax: true,
    kioskId: 'k1',
    deviceType: captainDevice ? 'CAPTAIN' : 'CASHIER',
  );
  const categories = [
    'Fast Food',
    'Bread Items',
    'Break Fast',
    'Chicken',
    'Chinese',
    'Combos',
    'Continental',
    'Egg Special',
    'Juice & Milk Shake',
    'Malabar Specials',
    'North Indian Special',
    'Rice & Biriyani',
  ];
  const names = [
    'Green Chillies Chettinad Dosa',
    'Coconut Uthappam',
    'Paratha with Chicken Masala',
    'Wheat Puttu With Chicken Curry',
  ];
  await tester.runAsync(() async {
    await store.open('P1');
    var seq = 1;
    await store.applyIncoming([
      _row(seq++, 'user', 'u1', {
        'name': 'Anu Cashier',
        'email': 'anucashier@gmail.com',
        'active': true,
        'max_discount_bp': 2000,
        'permissions': allPermissions,
        'roles': ['Cashier'],
      }),
      _row(seq++, 'user', 'cap1', {
        'name': 'Riya Captain',
        'active': true,
        'permissions': ['order.create', 'order.transfer'],
        'roles': ['Captain'],
      }),
      _row(seq++, 'tax', 'tax1', {'name': 'VAT', 'rate_bp': 500, 'is_default': true}),
      _row(seq++, 'kiosk', 'k1', {'name': 'U Kiosk'}),
      _row(seq++, 'kitchen_station', 'st-hot', {'name': 'Hot kitchen'}),
      _row(seq++, 'kitchen_station', 'st-bar', {'name': 'Juice bar'}),
      _row(seq++, 'payment_method', 'pm1', {'name': 'Cash', 'kind': 'CASH', 'is_cash_like': true, 'active': true}),
      _row(seq++, 'payment_method', 'pm2', {'name': 'Card', 'kind': 'CARD', 'is_cash_like': false, 'active': true}),
      for (var t = 1; t <= 12; t++)
        _row(seq++, 'dining_table', 'tb$t', {'name': 'B$t', 'seats': 4, 'area': t <= 6 ? 'Hall' : 'Terrace'}),
      _row(seq++, 'delivery_partner', 'dp1', {'name': 'Talabat', 'active': true}),
      _row(seq++, 'delivery_partner', 'dp2', {'name': 'Deliveroo', 'active': true}),
      _row(seq++, 'customer', 'cu1', {'name': 'Mohammed Al Mansoori', 'mobile': '0501234567'}),
      for (var c = 0; c < categories.length; c++)
        _row(seq++, 'category', 'c$c', {
          'name': categories[c],
          'sort_order': c,
          'kitchen_station_id': c == 8 ? 'st-bar' : 'st-hot',
        }),
      for (var p = 0; p < 48; p++)
        _row(seq++, 'product', 'p$p', {
          'category_id': 'c${p % categories.length}',
          'name': '${names[p % names.length]}${p >= names.length ? ' ${p ~/ names.length}' : ''}',
          'price_minor': 750 + p * 25,
          'active': true,
        }),
    ]);
  });
  sl<StaffSession>().value = const StaffUser(
    id: 'u1',
    name: 'Anu Cashier',
    email: 'anucashier@gmail.com',
    pinHash: null,
    permissions: {...allPermissions},
    maxDiscountBp: 2000,
    roles: {'Cashier'},
  );
  await tester.runAsync(() async {
    await sl<ShiftService>().startShift(userId: 'u1', openingFloatMinor: 10000, name: 'Morning Shift');
    final service = sl<OrderService>();
    for (var i = 0; i < orders; i++) {
      final type = [Channel.dineIn, Channel.takeaway, Channel.homeDelivery][i % 3];
      await service.place(
        cart: Cart(
          orderType: type,
          tableId: type == Channel.dineIn ? 'tb${i + 1}' : null,
          guests: type == Channel.dineIn ? 2 : null,
          captainId: type == Channel.dineIn ? 'cap1' : null,
          customerId: type == Channel.homeDelivery ? 'cu1' : null,
          lines: [
            for (var l = 0; l < 3; l++)
              CartLine(
                key: 'l$i-$l',
                productId: 'p$l',
                name: names[l],
                unitPriceMinor: 1050,
                qtyMilli: 1000 * (l + 1),
                taxRateBp: 500,
                priceIncludesTax: true,
                trackStock: false,
              ),
          ],
        ),
        settings: const SalesSettings(),
        userId: 'u1',
      );
    }
  });
  return store;
}

/// The app's router at [location] (as in the real app: terminal cubit, text scale clamp).
Widget posApp(String location) => BlocProvider.value(
  value: sl<TerminalCubit>(),
  child: MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: createRouter(initialLocation: location),
    builder: clampTextScale,
  ),
);

/// Lets drift / timers settle, then pumps frames.
Future<void> settle(WidgetTester tester, [int ms = 300]) async {
  await tester.runAsync(() => Future<void>.delayed(Duration(milliseconds: ms)));
  await tester.pumpAndSettle();
}

Future<void> tearDownPos(WidgetTester tester) async {
  sl<PrinterService>().stopAutoQueue();
  await tester.pumpWidget(const SizedBox());
  await sl<SyncScheduler>().stop();
  await tester.runAsync(() => sl<LocalStore>().db.close());
}
