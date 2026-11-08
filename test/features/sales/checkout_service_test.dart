import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/catalogue/data/catalogue_repository.dart';
import 'package:pos_app_ui/features/printing/data/printer_service.dart';
import 'package:pos_app_ui/features/printing/domain/ticket_formatter.dart';
import 'package:pos_app_ui/features/sales/domain/cart.dart';
import 'package:pos_app_ui/features/sales/domain/checkout_service.dart';
import 'package:pos_app_ui/features/shift/domain/shift_service.dart';

void main() {
  late LocalStore store;
  late ShiftService shifts;
  late CheckoutService checkout;
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
    );
  const cash = PaymentMethod('pm-cash', 'Cash', 'CASH', true);
  const card = PaymentMethod('pm-card', 'Card', 'CARD', false);
  Cart cart() => const Cart(
    orderType: 'DINE_IN',
    discountBp: 1000,
    lines: [
      CartLine(
        key: 'a',
        productId: 'biryani',
        name: 'Chicken biryani',
        unitPriceMinor: 2800,
        qtyMilli: 2000,
        taxRateBp: 500,
        priceIncludesTax: true,
        trackStock: false,
      ),
      CartLine(
        key: 'b',
        productId: 'lime',
        name: 'Fresh lime',
        unitPriceMinor: 800,
        qtyMilli: 3000,
        taxRateBp: 500,
        priceIncludesTax: true,
        trackStock: true,
      ),
    ],
  );
  const settings = SalesSettings(cashRoundingIncrementMinor: 25, serviceChargeBp: 500);

  setUp(() async {
    store = LocalStore(openTestDatabase(NativeDatabase.memory()));
    await store.open('P1');
    shifts = ShiftService(store, ctx);
    checkout = CheckoutService(store, ctx, shifts);
  });
  tearDown(() => store.db.close());

  test('no sale without an open shift', () async {
    expect(
      () => checkout.settle(
        cart: cart(),
        settings: settings,
        tenders: [(method: cash, amountMinor: null)],
        userId: 'u1',
        cashierName: 'A',
      ),
      throwsA(isA<SaleException>()),
    );
  });

  test('SRS 10.5 bill: one atomic transaction, balanced ledger, numbers, shift cash', () async {
    await shifts.startShift(userId: 'u1', openingFloatMinor: 20000);
    final sale = await checkout.settle(
      cart: cart(),
      settings: settings,
      tenders: [(method: card, amountMinor: 5000), (method: cash, amountMinor: null)],
      userId: 'u1',
      cashierName: 'Asha',
      cashTenderedMinor: 3000,
    );

    expect(sale.orderNo, 'P1-000001');
    expect(sale.tokenNo, 'A-001');
    expect(sale.priced.totalMinor, 7560);
    expect(sale.settlement.roundingMinor, -10);
    expect(sale.changeDueMinor, 3000 - 2550);

    final txs = await store.pendingTransactions();
    final saleTx = txs.last;
    expect(saleTx.map((c) => c.entity).toSet(), {
      'orders',
      'order_line',
      'order_discount',
      'order_charge',
      'payment',
      'stock_movement',
      'ledger_entry',
      'order_event',
      'kot', //
    });
    final ledger = saleTx.where((c) => c.entity == 'ledger_entry').map((c) => c.fields).toList();
    final dr = ledger.fold(0, (s, l) => s + (l['debit_minor'] as int));
    final cr = ledger.fold(0, (s, l) => s + (l['credit_minor'] as int));
    expect(dr, cr);
    expect(dr, 8322); // 50.00 card + 25.50 cash + 0.10 rounding + 7.62 discounts allowed (SRS 10.8)
    expect(saleTx.where((c) => c.entity == 'stock_movement').single.fields['qty_milli'], -3000); // tracked item only

    final s = await shifts.summary((await shifts.openShift())!.id);
    expect(s.cashSalesMinor, 2550);
    expect(s.expectedCashMinor, 22550);

    final second = await checkout.settle(
      cart: cart(),
      settings: settings,
      tenders: [(method: cash, amountMinor: null)],
      userId: 'u1',
      cashierName: 'Asha',
    );
    expect([second.orderNo, second.tokenNo], ['P1-000002', 'A-002']);
  });

  test('receipt and KOT are ESC/POS and reach a network printer', () async {
    await shifts.startShift(userId: 'u1', openingFloatMinor: 0);
    final sale = await checkout.settle(
      cart: cart(),
      settings: settings,
      tenders: [(method: cash, amountMinor: null)],
      userId: 'u1',
      cashierName: 'Asha',
      cashTenderedMinor: 10000,
    );
    final receipt = TicketFormatter(ctx.ctx).receipt(sale, footer: 'See you soon', openDrawer: true).bytes;
    final text = String.fromCharCodes(receipt);
    expect(text, contains('Al Noor Deira'));
    expect(text, contains('Bill P1-000001'));
    expect(text, contains('75.50')); // total after cash rounding
    expect(text, contains('See you soon'));
    expect(receipt.sublist(0, 2), [0x1B, 0x40]); // init
    expect(text, contains(String.fromCharCodes([0x1B, 0x70, 0x00, 0x19, 0xFA]))); // drawer kick
    expect(String.fromCharCodes(TicketFormatter(ctx.ctx).kot(sale).bytes), contains('3  x  Fresh lime'));

    // fake printer on localhost receives exactly the bytes
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final received = <int>[];
    final done = server.first.then((s) => s.listen(received.addAll).asFuture<void>());
    await PrinterService(store).send('127.0.0.1', server.port, receipt);
    await done;
    await server.close();
    expect(received, receipt);
  });

  test('close shift records the counted cash; day close totals', () async {
    await shifts.startShift(userId: 'u1', openingFloatMinor: 10000);
    await shifts.cashMovement(userId: 'u1', direction: 'OUT', amountMinor: 1500, reason: 'Ice');
    await checkout.settle(
      cart: cart(),
      settings: settings,
      tenders: [(method: cash, amountMinor: null)],
      userId: 'u1',
      cashierName: 'A',
    );
    final s = await shifts.closeShift(userId: 'u1', countedCashMinor: 16000);
    expect(s.expectedCashMinor, 10000 - 1500 + 7550);
    final shift = (await store.all('shift')).single;
    expect(shift.data['difference_minor'], 16000 - s.expectedCashMinor);
    final totals = await shifts.closeDay(userId: 'u1');
    expect(totals['orders'], 1);
    expect((await store.all('business_day')).single.data['status'], 'CLOSED');
  });
}
