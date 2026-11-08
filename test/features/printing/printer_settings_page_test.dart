import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/di/injection.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/printing/data/printer_service.dart';
import 'package:pos_app_ui/features/printing/domain/printer_device.dart';
import 'package:pos_app_ui/features/printing/presentation/printer_settings_page.dart';
import 'package:pos_app_ui/features/sales/domain/cart.dart';
import 'package:pos_app_ui/features/sync/domain/sync_scheduler.dart';

import 'printing_test.dart' show FakeTransport, row;

/// Pick a USB printer and "Set as KIOSK", type a LAN printer's IP and "Set as" a kitchen station,
/// turn the print queue on and set the home delivery copies.
void main() {
  testWidgets('printer settings: set kiosk and station printers, queue, print count', (tester) async {
    tester.view.physicalSize = const Size(1500, 1300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final transport = FakeTransport()
      ..found = const [PrinterDevice(kind: PrinterKind.usb, name: 'XP-80 USB', address: '/dev/usb/lp0')];
    await sl.reset();
    await configureDependencies(
      config: const AppConfig(apiBaseUrl: 'http://pos.test/api/v1', appVersion: '1.0.0'),
      secureStore: MemorySecureStore(),
      database: openTestDatabase(NativeDatabase.memory()),
      printerTransport: transport,
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
      kioskId: 'k1',
    );
    await tester.runAsync(() async {
      await store.open('P1');
      await store.applyIncoming([
        row(1, 'kiosk', 'k1', {'name': 'U Kiosk'}),
        row(2, 'kitchen_station', 'st-hot', {'name': 'Hot kitchen'}),
        row(3, 'kitchen_station', 'st-bar', {'name': 'Juice bar'}),
      ]);
    });
    Future<void> settle() async {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));
      await tester.pumpAndSettle();
    }

    Future<PrinterSettings> saved() async => (await tester.runAsync(() => sl<PrinterService>().settings()))!;

    await tester.pumpWidget(const MaterialApp(home: PrinterSettingsPage()));
    await settle();
    expect(find.text('U Kiosk Printer : '), findsOneWidget);
    expect(find.text('Set as Hot kitchen'), findsOneWidget);
    expect(find.text('Set as Juice bar'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byKey(const Key('setAs-bill'))).onPressed, isNull);

    // usb: pick the found printer, Set as KIOSK
    await tester.tap(find.byKey(const Key('printerType')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('usb').last);
    await settle();
    await tester.tap(find.text('XP-80 USB'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('setAs-bill')));
    await settle();
    expect((await saved()).bill?.kind, PrinterKind.usb);
    expect(find.text('U Kiosk Printer : XP-80 USB'), findsOneWidget);

    // LAN printer by IP for the hot kitchen
    await tester.enterText(find.byKey(const Key('printerIp')), '192.168.1.50');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('setAs-kot-st-hot')));
    await settle();
    expect((await saved()).kotFor('st-hot')?.address, '192.168.1.50');

    // test ticket goes to the typed printer
    await tester.tap(find.byKey(const Key('printTest')));
    await settle();
    expect(transport.texts('192.168.1.50:9100').single, contains('TEST TICKET'));

    // queue on, then auto queue; 2 copies for home delivery
    expect(tester.widget<Checkbox>(find.byKey(const Key('autoQueue'))).onChanged, isNull);
    await tester.tap(find.byKey(const Key('printQueue')));
    await settle();
    await tester.tap(find.byKey(const Key('autoQueue')));
    await settle();
    await tester.ensureVisible(find.byKey(const Key('countDelivery')));
    await tester.tap(find.byKey(const Key('countDelivery')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(': 2').last);
    await settle();
    final s = await saved();
    expect([s.queue, s.autoQueue, s.copiesFor(Channel.homeDelivery), s.copiesFor(Channel.dineIn)], [true, true, 2, 1]);

    sl<PrinterService>().stopAutoQueue();
    await tester.pumpWidget(const SizedBox());
    await sl<SyncScheduler>().stop();
    await tester.runAsync(() => store.db.close());
  });
}
