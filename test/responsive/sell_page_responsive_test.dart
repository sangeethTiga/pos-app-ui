import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/app/routes.dart';

import 'harness.dart';

/// Finds widgets whose string key starts with [prefix] (cart lines use generated keys).
Finder _keyPrefix(String prefix) =>
    find.byWidgetPredicate((w) => w.key is ValueKey<String> && (w.key! as ValueKey<String>).value.startsWith(prefix));

Finder _heldLabel(int n) => find.byWidgetPredicate(
  (w) =>
      w is Text &&
      RegExp(
        r'^Held( Orders)?\('
        '$n'
        r'\)$',
      ).hasMatch(w.data ?? ''),
);

Future<void> _pumpSell(WidgetTester tester, Size size) async {
  setScreen(tester, size);
  addTearDown(tester.view.reset);
  await setUpPos(tester, orders: 2);
  await tester.pumpWidget(posApp(Routes.sell));
  await settle(tester);
}

Future<void> _tapVisible(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  expect(f.hitTestable(), findsOneWidget, reason: '$f is not hittable');
  await tester.tap(f);
  await tester.pump();
}

/// Scrolls [f] into view; in a short cart the totals are built lazily below the lines.
Future<void> _reveal(WidgetTester tester, Finder f) async {
  if (f.evaluate().isEmpty) {
    final lines = find.ancestor(of: _keyPrefix('line-').first, matching: find.byType(Scrollable)).first;
    await tester.scrollUntilVisible(f, 80, scrollable: lines);
  } else {
    await tester.ensureVisible(f);
  }
  await tester.pumpAndSettle();
}

/// Adds three lines, opens the cart (sheet when there is no cart pane), checks + and the
/// Hold / Place Order buttons, then holds the order.
Future<void> _sellFlow(WidgetTester tester) async {
  expect(find.text('Fast Moving'), findsWidgets);
  for (final id in ['p0', 'p1', 'p2']) {
    await _tapVisible(tester, find.byKey(Key('product-$id')));
  }
  await tester.pumpAndSettle();

  final sheet = find.byKey(const Key('openCart'));
  if (sheet.evaluate().isNotEmpty) {
    expect(find.byKey(const Key('placeOrder')), findsNothing);
    await _tapVisible(tester, sheet);
    await tester.pumpAndSettle();
  }
  // Hold / Place Order are on screen without scrolling, finger-sized.
  for (final key in ['placeOrder', 'hold']) {
    final f = find.byKey(Key(key));
    expect(f.hitTestable(), findsOneWidget, reason: '$key is not hittable');
    expect(tester.getSize(f).height, greaterThanOrEqualTo(44), reason: '$key too small');
  }
  await _reveal(tester, find.text('items(3)'));
  expect(find.text('items(3)'), findsOneWidget);

  final plus = _keyPrefix('plus-').first;
  await tester.ensureVisible(plus);
  await tester.pumpAndSettle();
  expect(tester.getSize(plus).height, greaterThanOrEqualTo(44));
  expect(tester.getSize(_keyPrefix('minus-').first).height, greaterThanOrEqualTo(44));
  await _tapVisible(tester, plus);
  await tester.pumpAndSettle();
  await _reveal(tester, find.text('items(4)'));
  expect(find.text('items(4)'), findsOneWidget);

  for (final key in ['pay', 'chTakeaway', 'chDineIn', 'deliveryChargeEdit']) {
    final f = find.byKey(Key(key));
    await _reveal(tester, f);
    expect(f, findsOneWidget, reason: key);
  }
  expect(find.byKey(const Key('hold')).hitTestable(), findsOneWidget);

  await tester.tap(find.byKey(const Key('hold')));
  await settle(tester);
  if (find.byType(BottomSheet).evaluate().isNotEmpty) {
    await tester.tapAt(const Offset(4, 4)); // dismiss the sheet
    await tester.pumpAndSettle();
  }
  expect(_heldLabel(1), findsOneWidget);
}

void main() {
  for (final MapEntry(key: name, value: size) in posSizes.entries) {
    testWidgets('sell page at $name', (tester) async {
      await _pumpSell(tester, size);
      await _sellFlow(tester);
      await tearDownPos(tester);
    });
  }

  for (final name in ['phone-320', 'pos-1024x768', 'tablet-portrait']) {
    testWidgets('sell page at $name with text scale 1.3', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await _pumpSell(tester, posSizes[name]!);
      await _sellFlow(tester);
      await tearDownPos(tester);
    });
  }

  testWidgets('drawer on a phone', (tester) async {
    await _pumpSell(tester, posSizes['phone-320']!);
    await _tapVisible(tester, find.byKey(const Key('homeMenu')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('menu-settings')), findsOneWidget);
    await tester.tap(find.byKey(const Key('menu-orders')));
    await tester.pumpAndSettle();
    final logout = find.byKey(const Key('menu-lock'));
    await tester.scrollUntilVisible(logout, 100, scrollable: find.byType(Scrollable).last);
    expect(logout.hitTestable(), findsOneWidget);
    expect(tester.getSize(logout).height, greaterThanOrEqualTo(44));
    await tearDownPos(tester);
  });

  for (final name in ['phone-320', 'phone-portrait', 'phone-landscape', 'tablet-landscape']) {
    testWidgets('keyboard open at $name', (tester) async {
      await _pumpSell(tester, posSizes[name]!);
      final search = find.byKey(const Key('search'));
      await _tapVisible(tester, search);
      final keyboard = posSizes[name]!.height * 0.45;
      tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      await tester.enterText(search, 'dosa');
      await tester.pumpAndSettle();
      await tester.ensureVisible(search);
      await tester.pumpAndSettle();
      expect(search.hitTestable(), findsOneWidget);
      // The filtered products can be scrolled to and tapped above the keyboard.
      final product = find.byKey(const Key('product-p0'), skipOffstage: false);
      await tester.ensureVisible(product);
      await tester.pumpAndSettle();
      expect(product.hitTestable(), findsOneWidget);
      await tearDownPos(tester);
    });
  }
}
