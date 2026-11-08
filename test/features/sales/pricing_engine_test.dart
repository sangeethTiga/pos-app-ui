import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/features/sales/domain/pricing_engine.dart';

/// Same vectors as the backend's tests/Unit/Domain/PricingEngineTest.php.
void main() {
  const engine = PricingEngine();

  test('AC-25 / SRS 10.5 dine-in bill and AC-28 cash rounding', () {
    final order = engine.price(
      const [
        PriceLineInput(key: 'biryani', qtyMilli: 2000, unitPriceMinor: 2800, priceIncludesTax: true, taxRateBp: 500),
        PriceLineInput(key: 'lime', qtyMilli: 3000, unitPriceMinor: 800, priceIncludesTax: true, taxRateBp: 500),
      ],
      orderDiscount: const OrderDiscount.percent(1000),
      serviceCharge: (rateBp: 500, taxRateBp: 500),
    );
    final [b, l] = order.lines;
    expect([b.gross, b.discount, b.grossAfterDiscount, b.tax, b.net], [5600, 560, 5040, 240, 4800]);
    expect([l.gross, l.discount, l.grossAfterDiscount, l.tax, l.net], [2400, 240, 2160, 103, 2057]);
    expect([order.charges[0].net, order.charges[0].tax], [343, 17]);
    expect(
      [order.subtotalMinor, order.discountMinor, order.chargeMinor, order.taxMinor, order.totalMinor],
      [8000, 800, 360, 360, 7560],
    );
    expect(b.discountNet + l.discountNet, 762);

    final s = engine.settle(order, const [Tender('CARD', 5000), Tender('CASH', null, cashLike: true)], 25);
    expect(s.roundingMinor, -10);
    expect(s.paidMinor, 7550);
    expect(s.tenders[1].dueMinor, 2560);
    expect(s.tenders[1].amountMinor, 2550);
    expect(s.tenders[0].amountMinor, 5000);
  });

  test('AC-26 exclusive price: 20.00 x 3 = net 60.00, VAT 3.00, total 63.00', () {
    final o = engine.price(const [
      PriceLineInput(key: 'x', qtyMilli: 3000, unitPriceMinor: 2000, priceIncludesTax: false, taxRateBp: 500),
    ]);
    expect([o.lines[0].net, o.taxMinor, o.totalMinor], [6000, 300, 6300]);
  });

  test('discount allocation sums exactly, remainder on the last line', () {
    final o = engine.price(const [
      PriceLineInput(key: 'a', qtyMilli: 1000, unitPriceMinor: 333, priceIncludesTax: true, taxRateBp: 500),
      PriceLineInput(key: 'b', qtyMilli: 1000, unitPriceMinor: 333, priceIncludesTax: true, taxRateBp: 500),
      PriceLineInput(key: 'c', qtyMilli: 1000, unitPriceMinor: 334, priceIncludesTax: true, taxRateBp: 500),
    ], orderDiscount: const OrderDiscount.amount(100));
    expect(o.lines.fold(0, (s, l) => s + l.discount), 100);
    expect(o.totalMinor, 900);
  });

  test('non-cash overpayment refused; rounding half-up away from zero', () {
    final o = engine.price(const [
      PriceLineInput(key: 'a', qtyMilli: 1000, unitPriceMinor: 1000, priceIncludesTax: true, taxRateBp: 500),
    ]);
    expect(() => engine.settle(o, const [Tender('CARD', 1100)], 25), throwsA(isA<PricingException>()));
    expect(IntMath.divRound(5, 2), 3);
    expect(IntMath.divRound(-5, 2), -3);
  });
}
