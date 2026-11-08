import 'dart:async';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/sync/sync_change.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/catalogue/data/catalogue_repository.dart';
import 'package:pos_app_ui/features/printing/data/print_center.dart';
import 'package:pos_app_ui/features/printing/data/printer_service.dart';
import 'package:pos_app_ui/features/printing/data/printer_transport.dart';
import 'package:pos_app_ui/features/printing/domain/esc_pos.dart';
import 'package:pos_app_ui/features/printing/domain/printer_device.dart';
import 'package:pos_app_ui/features/sales/domain/cart.dart';
import 'package:pos_app_ui/features/sales/domain/checkout_service.dart';
import 'package:pos_app_ui/features/sales/domain/order_service.dart';
import 'package:pos_app_ui/features/shift/domain/shift_service.dart';

/// Records what was printed where; printers in [down] are unreachable.
class FakeTransport implements PrinterTransport {
  final sent = <(String, Uint8List)>[];
  final down = <String>{};
  List<PrinterDevice> found = const [];

  @override
  Future<void> send(PrinterDevice device, Uint8List bytes) async {
    if (down.contains(device.name)) throw PrinterException('${device.name}: Error. Printer connection timeout');
    sent.add((device.name, bytes));
  }

  @override
  Stream<List<PrinterDevice>> scan(PrinterKind kind) => Stream.value([
    for (final d in found)
      if (d.kind == kind) d,
  ]);

  @override
  Future<void> stopScan() async {}

  List<String> texts(String printer) => [
    for (final (p, b) in sent)
      if (p == printer) String.fromCharCodes(b),
  ];
}

SyncChange row(int seq, String entity, String id, Map<String, dynamic> fields) => SyncChange(
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

void main() {
  late LocalStore store;
  late FakeTransport transport;
  late PrinterService printer;
  late PrintCenter center;
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
  const kiosk = PrinterDevice(kind: PrinterKind.usb, name: 'XP-80 USB', address: '/dev/usb/lp0');
  final hot = PrinterDevice.wifi('192.168.1.50');
  final bar = PrinterDevice.wifi('192.168.1.51');

  CartLine line(String name, String productId, {int qty = 1}) => CartLine(
    key: name,
    productId: productId,
    name: name,
    unitPriceMinor: 1000,
    qtyMilli: qty * 1000,
    taxRateBp: 500,
    priceIncludesTax: true,
    trackStock: false,
  );

  setUp(() async {
    store = LocalStore(openTestDatabase(NativeDatabase.memory()));
    await store.open('P1');
    await store.applyIncoming([
      row(1, 'kiosk', 'k1', {'name': 'U Kiosk'}),
      row(2, 'kitchen_station', 'st-hot', {'name': 'Hot kitchen'}),
      row(3, 'kitchen_station', 'st-bar', {'name': 'Juice bar'}),
      row(4, 'category', 'cat-drinks', {'name': 'Drinks', 'kitchen_station_id': 'st-bar'}),
      // biryani has its own station, lime takes the category's, the open food line has none
      row(5, 'product', 'biryani', {'name': 'Biryani', 'price_minor': 2800, 'kitchen_station_id': 'st-hot'}),
      row(6, 'product', 'lime', {'name': 'Lime', 'price_minor': 800, 'category_id': 'cat-drinks'}),
    ]);
    transport = FakeTransport();
    printer = PrinterService(store, transport: transport);
    center = PrintCenter(printer, store, ctx);
  });
  tearDown(() async {
    printer.stopAutoQueue();
    await store.db.close();
  });

  test('settings: old IP settings carry over; copies and KOT printer fallback', () async {
    final old = PrinterSettings.fromJson({'receipt_host': '10.0.0.5', 'kitchen_host': '10.0.0.6', 'port': 9101});
    expect([old.bill?.kind, old.bill?.address, old.bill?.port], [PrinterKind.wifi, '10.0.0.5', 9101]);
    expect(old.kotFor('anything')?.address, '10.0.0.6');

    final s = PrinterSettings(
      bill: kiosk,
      kot: {'st-hot': hot},
      copies: const {Channel.homeDelivery: 2, Channel.dineIn: 0},
      style: PrintStyle.image,
      queue: true,
    );
    final back = PrinterSettings.fromJson(s.toJson());
    expect(
      [back.bill?.name, back.bill?.kind, back.style, back.queue],
      ['XP-80 USB', PrinterKind.usb, PrintStyle.image, true],
    );
    expect(
      [back.copiesFor(Channel.partner), back.copiesFor(Channel.dineIn), back.copiesFor(Channel.takeaway)],
      [2, 0, 1],
    );
    expect(back.kotFor('st-bar')?.address, '192.168.1.50'); // no bar printer: any kitchen printer
    expect(await center.stations(), hasLength(2));
    expect(await center.kioskName(), 'U Kiosk');
  });

  test('KOT goes to each kitchen station printer; cancel KOT too', () async {
    await printer.save(PrinterSettings(bill: kiosk, kot: {'st-hot': hot, 'st-bar': bar}));
    const cart = Cart(orderType: Channel.takeaway);
    final r = await center.kot(
      PlacedOrder(
        orderId: 'o1',
        orderNo: 'P1-000001',
        tokenNo: 'A-001',
        cart: cart,
        newLines: [line('Biryani', 'biryani', qty: 2), line('Lime', 'lime'), line('Open food', 'none')],
        cancelledLines: [line('Lime', 'lime')],
        kind: 'UPDATE',
      ),
    );
    expect(r.status, PrintStatus.printed);
    final hotTickets = transport.texts(hot.name);
    final barTickets = transport.texts(bar.name);
    // hot: biryani + the line with no station (goes to the first printer for an unknown station)
    expect(hotTickets.join(), allOf(contains('ADD-ON A-001'), contains('2  x  Biryani'), contains('HOT KITCHEN')));
    expect(barTickets.first, allOf(contains('ADD-ON A-001'), contains('1  x  Lime'), isNot(contains('Biryani'))));
    expect(barTickets.last, contains('CANCEL A-001'));
    expect(transport.texts(kiosk.name), isEmpty);
  });

  test('receipt copies per order type, drawer on cash, nothing set up', () async {
    expect((await center.openDrawer()).status, PrintStatus.noPrinter);
    await printer.save(const PrinterSettings(bill: kiosk, copies: {Channel.homeDelivery: 2, Channel.dineIn: 0}));
    final shifts = ShiftService(store, ctx);
    final checkout = CheckoutService(store, ctx, shifts);
    await shifts.startShift(userId: 'u1', openingFloatMinor: 0);
    const cash = PaymentMethod('pm1', 'Cash', 'CASH', true);
    Future<CompletedSale> sell(String type) => checkout.settle(
      cart: Cart(orderType: type, lines: [line('Lime', 'lime')]),
      settings: const SalesSettings(),
      tenders: [(method: cash, amountMinor: null)],
      userId: 'u1',
      cashierName: 'Anu',
    );

    await center.receipt(await sell(Channel.homeDelivery));
    final receipts = transport.texts(kiosk.name);
    expect(receipts, hasLength(2));
    final kick = String.fromCharCodes([0x1B, 0x70, 0x00, 0x19, 0xFA]);
    expect(receipts.first, contains(kick)); // drawer opens once, with the first copy
    expect(receipts.last, isNot(contains(kick)));

    transport.sent.clear();
    final dine = await center.receipt(await sell(Channel.dineIn));
    expect(dine.status, PrintStatus.printed);
    expect(transport.texts(kiosk.name).single, endsWith(kick)); // 0 copies: drawer kick only
  });

  test('print queue keeps jobs while the printer is down and prints them later', () async {
    await printer.save(PrinterSettings(bill: kiosk, kot: {'': hot}));
    transport.down.add(hot.name);
    final ticket = EscPos()..text('hello');

    expect(() => printer.print(hot, ticket, label: 'KOT'), throwsA(isA<PrinterException>()));
    final failed = await center.kotLines(
      tokenNo: 'A-1',
      orderNo: 'P1-1',
      cart: const Cart(),
      lines: [line('Lime', 'lime')],
    );
    expect(
      [failed.status, failed.tickets.length, failed.message('Kitchen')],
      [PrintStatus.failed, 1, 'Kitchen printer not reachable: 192.168.1.50:9100: Error. Printer connection timeout'],
    );

    await printer.save(PrinterSettings(bill: kiosk, kot: {'': hot}, queue: true, autoQueue: true));
    expect(await printer.print(hot, ticket, label: 'KOT', copies: 2), SendResult.queued);
    expect(await printer.queued(), hasLength(2));
    expect(await printer.flushQueue(), 0);

    transport.down.clear();
    expect(await printer.flushQueue(), 2);
    expect(await printer.queued(), isEmpty);
    expect(transport.texts(hot.name), hasLength(2));
  });

  test('image print style sends a raster image with cut and drawer kick', () async {
    await printer.save(const PrinterSettings(bill: kiosk, style: PrintStyle.image));
    final ticket = EscPos()
      ..align('center')
      ..big(true)
      ..text('KOT A-001')
      ..big(false)
      ..text('شاي بالنعناع  Mint tea')
      ..feed(3)
      ..cut()
      ..openDrawer();
    expect(await printer.print(kiosk, ticket, label: 'x'), SendResult.printed);
    final bytes = transport.sent.single.$2;
    expect(bytes.sublist(2, 6), [0x1D, 0x76, 0x30, 0x00]); // GS v 0 raster
    expect(bytes.sublist(6, 8), [72, 0]); // 576 dots = 72 bytes a row
    expect(bytes.sublist(bytes.length - 9), [0x1D, 0x56, 0x42, 0x03, 0x1B, 0x70, 0x00, 0x19, 0xFA]);
  });
}
