import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/app/routes.dart';

import 'harness.dart';

/// Orders Dashboard and Order Details at every POS screen size: no overflow, the card grid and the
/// details layout adapt, and the popups open and close.
void main() {
  /// Card columns expected at each size (4 dine-in orders, so at most 4 show in a row).
  const columns = {
    'phone-320': 1,
    'phone-portrait': 1,
    'phone-landscape': 2,
    'tablet-portrait': 2,
    'tablet-landscape': 3,
    'pos-1024x768': 3,
    'desktop-1366x768': 4,
    'fullhd-1920x1080': 4,
    'tv-4k-3840x2160': 4,
  };

  Finder keyed(String prefix) =>
      find.byWidgetPredicate((w) => w.key is ValueKey<String> && (w.key! as ValueKey<String>).value.startsWith(prefix));
  final cards = keyed('order-');

  Future<void> tapVisible(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  Future<void> cancel(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
  }

  Future<void> flow(WidgetTester tester, String name) async {
    await setUpPos(tester, orders: 12);
    await tester.pumpWidget(posApp(Routes.orders));
    await settle(tester);

    // dashboard: tabs, grid columns from the width
    for (final tab in ['tabTakeaway', 'tabDelivery', 'tabPartner', 'tabDineIn']) {
      await tapVisible(tester, find.byKey(Key(tab)));
    }
    await settle(tester);
    // the grid is lazy: short screens build only the first rows
    final built = tester.widgetList(cards).length;
    expect(built, inInclusiveRange(1, 4), reason: name);
    final xs = {for (var i = 0; i < built; i++) tester.getTopLeft(cards.at(i)).dx.round()};
    expect(xs.length, math.min(columns[name]!, built), reason: '$name columns');

    // merge popup
    final first = tester.widgetList(cards).first.key! as ValueKey<String>;
    final id = first.value.substring('order-'.length);
    await tapVisible(tester, find.byKey(Key('merge-$id')));
    expect(keyed('mergeInto-'), findsNWidgets(3));
    await tester.tapAt(const Offset(2, 2));
    await tester.pumpAndSettle();

    // details
    await tapVisible(tester, find.byKey(Key('order-$id')));
    await settle(tester);
    expect(find.text('Order Details'), findsOneWidget);
    final wide = tester.view.physicalSize.width >= 900;
    final voidCenter = tester.getCenter(find.byKey(const Key('voidBill')));
    final total = tester.getCenter(find.text('Net Total'));
    if (wide) {
      expect(voidCenter.dx, lessThan(total.dx), reason: '$name: actions beside the bill');
    } else {
      expect(voidCenter.dy, greaterThan(total.dy), reason: '$name: actions below the bill');
    }

    // settle menu
    await tapVisible(tester, find.byKey(const Key('settle')));
    expect(find.byKey(const Key('settle-split')), findsOneWidget);
    Navigator.of(tester.element(find.byKey(const Key('settle-split')))).pop();
    await tester.pumpAndSettle();

    // void bill
    await tapVisible(tester, find.byKey(const Key('voidBill')));
    await tapVisible(tester, find.byKey(const Key('reason-Wrong order')));
    expect(tester.widget<FilledButton>(find.byKey(const Key('voidConfirm'))).onPressed, isNotNull);
    await cancel(tester);

    // apply coupon
    await tapVisible(tester, find.byKey(const Key('applyCoupon')));
    await tester.enterText(find.byKey(const Key('couponCode')), 'SAVE10');
    await tester.pumpAndSettle();
    await cancel(tester);

    // bill split
    await tapVisible(tester, find.byKey(const Key('billSplit')));
    expect(find.byKey(const Key('pickOk')), findsOneWidget);
    await cancel(tester);

    // back to the dashboard
    await tapVisible(tester, find.byKey(const Key('detailBack')));
    await settle(tester);
    expect(cards, findsWidgets);

    await tearDownPos(tester);
  }

  for (final MapEntry(key: name, value: size) in posSizes.entries) {
    testWidgets('orders dashboard and details at $name', (tester) async {
      setScreen(tester, size);
      addTearDown(tester.view.reset);
      await flow(tester, name);
    });
  }

  for (final name in ['phone-320', 'phone-landscape', 'pos-1024x768']) {
    testWidgets('orders dashboard and details at $name, text scale 1.3', (tester) async {
      setScreen(tester, posSizes[name]!);
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      addTearDown(tester.view.reset);
      await flow(tester, name);
    });
  }
}
