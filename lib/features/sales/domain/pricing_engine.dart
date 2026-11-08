/// Order totals per SRS section 10 (BR-01..BR-13), integer minor units only.
/// Line-for-line port of the backend `App\Domain\Pricing\PricingEngine`; the tests use the same vectors.
library;

class PricingException implements Exception {
  const PricingException(this.code, this.message);
  final String code;
  final String message;
  @override
  String toString() => '$code: $message';
}

abstract final class IntMath {
  /// num / den rounded half-up, away from zero (BR-01).
  static int divRound(int num, int den) {
    if (den == 0) throw ArgumentError('Division by zero.');
    if (den < 0) {
      num = -num;
      den = -den;
    }
    if (num < 0) return -((2 * -num + den) ~/ (2 * den));
    return (2 * num + den) ~/ (2 * den);
  }

  static int mulDivRound(int a, int b, int den) => divRound(a * b, den);

  static int roundToIncrement(int amount, int increment) =>
      increment <= 1 ? amount : divRound(amount, increment) * increment;
}

class PriceLineInput {
  const PriceLineInput({
    required this.key,
    required this.qtyMilli,
    required this.unitPriceMinor,
    required this.priceIncludesTax,
    required this.taxRateBp,
    this.lineDiscountMinor = 0,
  });
  final String key;
  final int qtyMilli;
  final int unitPriceMinor;
  final bool priceIncludesTax;
  final int taxRateBp;
  final int lineDiscountMinor;
}

/// `PERCENT` with [valueBp] (1000 = 10 %) or `AMOUNT` with [amountMinor].
class OrderDiscount {
  const OrderDiscount.percent(int this.valueBp) : type = 'PERCENT', amountMinor = null;
  const OrderDiscount.amount(int this.amountMinor) : type = 'AMOUNT', valueBp = null;
  final String type;
  final int? valueBp;
  final int? amountMinor;
}

class PricedLine {
  const PricedLine(
    this.key,
    this.gross,
    this.discount,
    this.grossAfterDiscount,
    this.tax,
    this.net,
    this.lineTotal,
    this.discountNet,
    this.taxRateBp,
    this.inclusive,
  );
  final String key;
  final int gross, discount, grossAfterDiscount, tax, net, lineTotal, discountNet, taxRateBp;
  final bool inclusive;
}

class PricedCharge {
  const PricedCharge(this.code, this.net, this.tax);
  final String code;
  final int net, tax;
}

class PricedOrder {
  const PricedOrder({
    required this.lines,
    required this.charges,
    required this.subtotalMinor,
    required this.discountMinor,
    required this.chargeMinor,
    required this.taxMinor,
    required this.totalMinor,
  });
  final List<PricedLine> lines;
  final List<PricedCharge> charges;
  final int subtotalMinor, discountMinor, chargeMinor, taxMinor, totalMinor;

  int get netMinor => lines.fold(0, (s, l) => s + l.net);
}

class Tender {
  const Tender(this.kind, this.amountMinor, {this.cashLike = false, this.paymentMethodId});
  final String kind;

  /// null = "the rest of the bill".
  final int? amountMinor;
  final bool cashLike;
  final String? paymentMethodId;
}

class SettledTender {
  const SettledTender(this.tender, this.amountMinor, {this.dueMinor});
  final Tender tender;
  final int amountMinor;
  final int? dueMinor;
}

class Settlement {
  const Settlement(this.tenders, this.roundingMinor, this.paidMinor, this.cashDueMinor);
  final List<SettledTender> tenders;
  final int roundingMinor, paidMinor, cashDueMinor;
}

class PricingEngine {
  const PricingEngine();

  PricedOrder price(
    List<PriceLineInput> lines, {
    OrderDiscount? orderDiscount,
    ({int rateBp, int taxRateBp})? serviceCharge,
    List<({String code, int amountMinor, int taxRateBp})> fixedCharges = const [],
  }) {
    if (lines.isEmpty) throw const PricingException('EMPTY_ORDER', 'An order needs at least one line.');
    final computed = <({String key, int gross, int lineDiscount, bool inclusive, int rate})>[];
    for (var i = 0; i < lines.length; i++) {
      final l = lines[i];
      if (l.qtyMilli <= 0 || l.unitPriceMinor < 0 || l.taxRateBp < 0) {
        throw PricingException('INVALID_LINE', 'Line $i has an invalid quantity, price or tax rate.');
      }
      final gross = IntMath.mulDivRound(l.unitPriceMinor, l.qtyMilli, 1000);
      if (l.lineDiscountMinor < 0 || l.lineDiscountMinor > gross) {
        throw PricingException('INVALID_DISCOUNT', 'Line $i discount exceeds its amount.');
      }
      computed.add((
        key: l.key,
        gross: gross,
        lineDiscount: l.lineDiscountMinor,
        inclusive: l.priceIncludesTax,
        rate: l.taxRateBp,
      ));
    }

    // BR-08: allocate the order discount in proportion to gross after line discounts.
    final base = computed.fold(0, (s, l) => s + l.gross - l.lineDiscount);
    var orderDiscountTotal = 0;
    if (orderDiscount != null) {
      orderDiscountTotal = orderDiscount.type == 'PERCENT'
          ? IntMath.mulDivRound(base, orderDiscount.valueBp!, 10000)
          : orderDiscount.amountMinor!;
      if (orderDiscountTotal < 0 || orderDiscountTotal > base) {
        throw const PricingException('INVALID_DISCOUNT', 'Order discount exceeds the order amount.');
      }
    }

    var allocated = 0, taxTotal = 0, netTotal = 0, lineTotalSum = 0;
    final priced = <PricedLine>[];
    for (var idx = 0; idx < computed.length; idx++) {
      final l = computed[idx];
      final after = l.gross - l.lineDiscount;
      final share = idx == computed.length - 1
          ? orderDiscountTotal - allocated
          : (base > 0 ? IntMath.mulDivRound(orderDiscountTotal, after, base) : 0);
      allocated += share;
      final discount = l.lineDiscount + share;
      final gad = l.gross - discount;
      final int tax, net, lineTotal;
      if (l.inclusive) {
        tax = IntMath.mulDivRound(gad, l.rate, 10000 + l.rate);
        net = gad - tax;
        lineTotal = gad;
      } else {
        net = gad;
        tax = IntMath.mulDivRound(net, l.rate, 10000);
        lineTotal = net + tax;
      }
      final discountNet = l.inclusive ? IntMath.mulDivRound(discount, 10000, 10000 + l.rate) : discount;
      priced.add(PricedLine(l.key, l.gross, discount, gad, tax, net, lineTotal, discountNet, l.rate, l.inclusive));
      taxTotal += tax;
      netTotal += net;
      lineTotalSum += lineTotal;
    }

    final charges = <PricedCharge>[];
    if (serviceCharge != null && serviceCharge.rateBp > 0) {
      final scNet = IntMath.mulDivRound(netTotal, serviceCharge.rateBp, 10000);
      charges.add(PricedCharge('SERVICE', scNet, IntMath.mulDivRound(scNet, serviceCharge.taxRateBp, 10000)));
    }
    for (final c in fixedCharges) {
      if (c.amountMinor < 0) throw const PricingException('INVALID_CHARGE', 'Charges cannot be negative.');
      charges.add(PricedCharge(c.code, c.amountMinor, IntMath.mulDivRound(c.amountMinor, c.taxRateBp, 10000)));
    }
    final chargeTotal = charges.fold(0, (s, c) => s + c.net + c.tax);
    final chargeTax = charges.fold(0, (s, c) => s + c.tax);

    return PricedOrder(
      lines: priced,
      charges: charges,
      subtotalMinor: priced.fold(0, (s, l) => s + l.gross),
      discountMinor: priced.fold(0, (s, l) => s + l.discount),
      chargeMinor: chargeTotal,
      taxMinor: taxTotal + chargeTax, // BR-02
      totalMinor: lineTotalSum + chargeTotal,
    );
  }

  /// Tenders with cash rounding (BR-03): only the cash part is rounded; no non-cash overpayment.
  Settlement settle(PricedOrder order, List<Tender> tenders, int cashRoundingIncrement) {
    var nonCash = 0;
    int? restIndex;
    for (var i = 0; i < tenders.length; i++) {
      final t = tenders[i];
      if (t.amountMinor == null) {
        if (restIndex != null) {
          throw const PricingException('INVALID_TENDER', 'Only one tender may take the remaining balance.');
        }
        restIndex = i;
        continue;
      }
      if (t.amountMinor! <= 0) throw const PricingException('INVALID_TENDER', 'Tender amounts must be positive.');
      if (!t.cashLike) nonCash += t.amountMinor!;
    }
    if (nonCash > order.totalMinor) {
      throw const PricingException('OVERPAYMENT_NON_CASH', 'Overpayment by a non-cash method is not allowed.');
    }
    final known = tenders.fold(0, (s, t) => s + (t.amountMinor ?? 0));
    var cashDue = 0, rounding = 0, paid = 0;
    final result = <SettledTender>[];
    for (var i = 0; i < tenders.length; i++) {
      final t = tenders[i];
      if (i == restIndex) {
        final due = order.totalMinor - known;
        if (due < 0) throw const PricingException('INVALID_TENDER', 'Tenders exceed the total.');
        var amount = due;
        if (t.cashLike) {
          cashDue = due;
          amount = IntMath.roundToIncrement(due, cashRoundingIncrement);
          rounding = amount - due;
        }
        result.add(SettledTender(t, amount, dueMinor: due));
        paid += amount;
      } else {
        result.add(SettledTender(t, t.amountMinor!));
        paid += t.amountMinor!;
      }
    }
    return Settlement(result, rounding, paid, cashDue);
  }
}
