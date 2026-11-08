import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/di/injection.dart';
import 'package:pos_app_ui/core/responsive/responsive.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/catalogue/data/catalogue_repository.dart';
import 'package:pos_app_ui/features/sales/data/home_repository.dart';
import 'package:pos_app_ui/features/sales/domain/cart.dart';
import 'package:pos_app_ui/features/sales/domain/order_service.dart';
import 'package:pos_app_ui/features/sales/domain/pricing_engine.dart';
import 'package:pos_app_ui/features/sales/presentation/widgets/home_dialogs.dart';
import 'package:pos_app_ui/features/sales/presentation/widgets/payment_dialog.dart';
import 'package:pos_app_ui/features/shift/domain/shift_service.dart';
import 'package:pos_app_ui/features/shift/presentation/shift_dialogs.dart';

import 'harness.dart';

/// Every home / payment / shift popup at every screen size (and at text scale 1.3, and with the
/// on-screen keyboard open on phones): no overflow, the popup stays on screen and its primary
/// button is visible, tappable and at least finger sized.
void main() {
  for (final e in posSizes.entries) {
    testWidgets('popups adapt: ${e.key}', (tester) async {
      setScreen(tester, e.value);
      addTearDown(tester.view.reset);
      await setUpPos(tester);
      await _checkAll(tester, e.value);
      await tearDownPos(tester);
    });
  }

  for (final name in ['phone-320', 'phone-landscape', 'pos-1024x768', 'fullhd-1920x1080']) {
    testWidgets('popups adapt at text scale 1.3: $name', (tester) async {
      setScreen(tester, posSizes[name]!);
      addTearDown(tester.view.reset);
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await setUpPos(tester);
      await _checkAll(tester, posSizes[name]!);
      await tearDownPos(tester);
    });
  }

  for (final name in ['phone-320', 'phone-portrait', 'phone-landscape', 'tablet-portrait']) {
    testWidgets('popups stay usable with the keyboard open: $name', (tester) async {
      final size = posSizes[name]!;
      setScreen(tester, size);
      tester.view.viewInsets = FakeViewPadding(bottom: (size.height * 0.42).roundToDouble());
      addTearDown(tester.view.reset);
      await setUpPos(tester);
      await _checkAll(tester, size);
      await tearDownPos(tester);
    });
  }
}

final _tables = [
  for (var i = 1; i <= 14; i++)
    DiningTableInfo(id: 't$i', name: 'B$i', area: i.isEven ? 'Family Hall Upstairs' : 'Terrace', capacity: 4),
];

const _openOrders = [
  OpenOrder(id: 'o1', orderNo: 'A-0001', orderType: 'DINE_IN', tableId: 't1', guests: 2, totalMinor: 4200),
  OpenOrder(id: 'o2', orderNo: 'A-0002', orderType: 'DINE_IN', tableId: 't1', guests: 1, totalMinor: 1200),
  OpenOrder(id: 'o3', orderNo: 'A-0003', orderType: 'DINE_IN', tableId: 't4', guests: 3, totalMinor: 9800),
];

const _captains = [
  CaptainInfo('cap1', 'Riya Captain'),
  CaptainInfo('cap2', 'Mohammed Abdul Rahman Al Mansoori'),
  CaptainInfo('cap3', 'Joseph'),
  CaptainInfo('cap4', 'Lakshmi Narayanan'),
  CaptainInfo('cap5', 'Ali'),
];

const _partners = [
  DeliveryPartnerInfo('dp1', 'Talabat'),
  DeliveryPartnerInfo('dp2', 'Deliveroo'),
  DeliveryPartnerInfo('dp3', 'Careem Food Delivery Express'),
  DeliveryPartnerInfo('dp4', 'Noon Food'),
  DeliveryPartnerInfo('dp5', 'Zomato'),
  DeliveryPartnerInfo('dp6', 'Instashop'),
];

const _methods = [
  PaymentMethod('pm1', 'Cash', 'CASH', true),
  PaymentMethod('pm2', 'Card', 'CARD', false),
  PaymentMethod('pm3', 'Apple Pay / Google Pay Wallet', 'WALLET', false),
  PaymentMethod('pm4', 'Bank Transfer', 'BANK', false),
];

const _priced = PricedOrder(
  lines: [],
  charges: [],
  subtotalMinor: 123450,
  discountMinor: 0,
  chargeMinor: 0,
  taxMinor: 5878,
  totalMinor: 123450,
);

const _line = CartLine(
  key: 'l1',
  productId: 'p1',
  name: 'Green Chillies Chettinad Dosa with Extra Coconut Chutney and Sambar',
  unitPriceMinor: 1050,
  qtyMilli: 2000,
  taxRateBp: 500,
  priceIncludesTax: true,
  trackStock: false,
  note: 'less spicy',
);

const _summary = ShiftSummary(
  openingFloatMinor: 10000,
  cashSalesMinor: 1234500,
  cashRefundsMinor: 0,
  cashInMinor: 5000,
  cashOutMinor: 2500,
  orders: 87,
  salesMinor: 2345600,
);

typedef _Case = ({String name, Future<Object?> Function(BuildContext c) open, Finder primary, bool scrolls});

Future<void> _checkAll(WidgetTester tester, Size screen) async {
  final t = sl<TerminalContextHolder>().ctx;
  final repo = sl<HomeRepository>();
  final cases = <_Case>[
    (
      name: 'Choose Table',
      open: (c) => showChooseTable(c, tables: _tables, openOrders: _openOrders, selectedTableId: 't2'),
      primary: find.byKey(const Key('tableOk')),
      scrolls: false,
    ),
    (
      name: 'Select Captain',
      open: (c) => showSelectCaptain(c, _captains, selectedId: 'cap2'),
      primary: find.byKey(const Key('dialogOk')),
      scrolls: false,
    ),
    (
      name: 'Delivery Partners',
      open: (c) => showDeliveryPartners(c, _partners, selectedId: 'dp3', orderNo: '123456789'),
      primary: find.byKey(const Key('dialogOk')),
      scrolls: false,
    ),
    (
      name: 'Customer Details',
      open: (c) => showCustomerDetails(c, repo: repo, userId: 'u1', selectedId: 'cu1'),
      primary: find.byKey(const Key('customerSave')),
      scrolls: true,
    ),
    (
      name: 'Kitchen Note',
      open: (c) => showKitchenNote(c, 'less spicy, no onion'),
      primary: find.byKey(const Key('kitchenNoteSave')),
      scrolls: false,
    ),
    (
      name: 'Discount',
      open: (c) => showDiscount(c, currentBp: 1000, maxBp: 2000),
      primary: find.widgetWithText(FilledButton, 'Apply'),
      scrolls: false,
    ),
    (
      name: 'Open Food',
      open: (c) => showOpenFood(c, decimals: 2),
      primary: find.byKey(const Key('openFoodAdd')),
      scrolls: false,
    ),
    (
      name: 'Line Edit',
      open: (c) => showLineEdit(c, _line),
      primary: find.widgetWithText(FilledButton, 'Save'),
      scrolls: false,
    ),
    (
      name: 'Payment',
      open: (c) => showPaymentDialog(c, t: t, priced: _priced, methods: _methods, roundingIncrement: 25),
      primary: find.byKey(const Key('confirmPayment')),
      scrolls: false,
    ),
    (
      name: 'Ask Amount',
      open: (c) => askAmount(c, title: 'Opening cash float', decimals: 2),
      primary: find.widgetWithText(FilledButton, 'OK'),
      scrolls: false,
    ),
    (
      name: 'Cash Movement',
      open: (c) => askCashMovement(c, 2),
      primary: find.widgetWithText(FilledButton, 'Save'),
      scrolls: false,
    ),
    (
      name: 'Shift Closed',
      open: (c) => showShiftClosed(c, t, _summary, 1200000),
      primary: find.widgetWithText(FilledButton, 'OK'),
      scrolls: false,
    ),
  ];

  late BuildContext host;
  await tester.pumpWidget(
    MaterialApp(
      builder: clampTextScale,
      home: Scaffold(
        body: Builder(
          builder: (c) {
            host = c;
            return const SizedBox.expand();
          },
        ),
      ),
    ),
  );
  final screenRect = Offset.zero & screen;
  for (final k in cases) {
    final result = k.open(host);
    await settle(tester, 50);
    final dialog = find.byWidgetPredicate((w) => w is Dialog);
    expect(dialog, findsOneWidget, reason: k.name);
    final rect = tester.getRect(dialog);
    expect(screenRect.inflate(0.5).contains(rect.topLeft), isTrue, reason: '${k.name} top left $rect');
    expect(screenRect.inflate(0.5).contains(rect.bottomRight), isTrue, reason: '${k.name} bottom right $rect');
    if (k.scrolls) {
      await tester.ensureVisible(k.primary);
      await tester.pumpAndSettle();
    }
    expect(k.primary.hitTestable(), findsOneWidget, reason: '${k.name}: primary button visible');
    expect(tester.getSize(k.primary).height, greaterThanOrEqualTo(44), reason: '${k.name}: touch target');
    if (k.name == 'Payment') {
      expect(find.byKey(const Key('payAll-CASH')).hitTestable(), findsOneWidget);
    }
    Navigator.of(host).pop();
    await tester.pumpAndSettle();
    await result;
    final error = tester.takeException();
    if (error != null) fail('${k.name}: ${error is FlutterError ? error.toStringDeep() : error}');
  }
}
