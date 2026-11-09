import 'package:uuid/uuid.dart';

import '../../../core/sync/local_store.dart';
import '../../../core/terminal/terminal_context.dart';
import '../../catalogue/data/catalogue_repository.dart';
import '../../shift/domain/shift_service.dart';
import 'cart.dart';
import 'pricing_engine.dart';

/// What the receipt and kitchen ticket need after a sale.
class CompletedSale {
  const CompletedSale({
    required this.orderId,
    required this.orderNo,
    required this.tokenNo,
    required this.businessDate,
    required this.cart,
    required this.priced,
    required this.settlement,
    required this.changeDueMinor,
    required this.cashierName,
    required this.settledAt,
  });
  final String orderId, orderNo, tokenNo, businessDate, cashierName;
  final Cart cart;
  final PricedOrder priced;
  final Settlement settlement;
  final int changeDueMinor;
  final DateTime settledAt;
}

/// Kitchen ticket lines; the kitchen note rides on the first line.
List<Map<String, dynamic>> kotLines(List<CartLine> lines, String? kitchenNote) => [
  for (final l in lines) {'name': l.name, 'qty_milli': l.qtyMilli, 'note': ?l.note},
  if (kitchenNote != null && kitchenNote.trim().isNotEmpty)
    {'name': 'NOTE', 'qty_milli': 0, 'note': kitchenNote.trim()},
];

class SaleException implements Exception {
  const SaleException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Turns a paid cart into one local transaction (orders, lines, charges, discount, payments, stock
/// movements, balanced ledger postings, order event, KOT) exactly as the backend expects it
/// (SRS 10.8 postings, C-26: SALE stock movement at settlement).
class CheckoutService {
  CheckoutService(this._store, this._ctx, this._shifts, [this._onCommit]);

  final LocalStore _store;
  final TerminalContextHolder _ctx;
  final ShiftService _shifts;
  final void Function()? _onCommit;
  static const _engine = PricingEngine();

  static const tenderAccount = {
    'CASH': 'CASH_ON_HAND',
    'CARD': 'CARD_CLEARING',
    'WALLET': 'WALLET_CLEARING',
    'CREDIT': 'CUSTOMER_RECEIVABLE',
    'VOUCHER': 'VOUCHER_LIABILITY',
  };

  PricedOrder price(Cart cart, SalesSettings settings) => _engine.price(
    [
      for (final l in cart.lines)
        PriceLineInput(
          key: l.key,
          qtyMilli: l.qtyMilli,
          unitPriceMinor: l.unitPriceMinor,
          priceIncludesTax: l.priceIncludesTax,
          taxRateBp: l.taxRateBp,
        ),
    ],
    orderDiscount: cart.discountBp > 0 ? OrderDiscount.percent(cart.discountBp) : null,
    serviceCharge: cart.orderType == 'DINE_IN' && settings.serviceChargeBp > 0
        ? (
            rateBp: settings.serviceChargeBp,
            taxRateBp: settings.serviceChargeTaxable && cart.lines.isNotEmpty ? cart.lines.first.taxRateBp : 0,
          )
        : null,
    fixedCharges: [?_deliveryCharge(cart)],
  );

  /// Delivery charge as a priced charge: the amount entered is what the guest pays, so with VAT-inclusive
  /// prices the VAT is taken out of it.
  static ({String code, int amountMinor, int taxRateBp})? _deliveryCharge(Cart cart) {
    final gross = cart.deliveryChargeMinor;
    if (gross <= 0) return null;
    final rate = cart.lines.isEmpty ? 0 : cart.lines.first.taxRateBp;
    final inclusive = cart.lines.isEmpty || cart.lines.first.priceIncludesTax;
    return (
      code: 'DELIVERY',
      amountMinor: inclusive ? IntMath.mulDivRound(gross, 10000, 10000 + rate) : gross,
      taxRateBp: rate,
    );
  }

  /// Next number of a per-terminal counter (order numbers, daily tokens).
  Future<String> nextNumber(String key, String Function(int) format) async {
    final n = int.parse(await _store.getValue(key) ?? '0') + 1;
    await _store.setValue(key, '$n');
    return format(n);
  }

  /// [tenders]: payment methods with amounts; one cash tender may be `null` = rest (rounded).
  /// [cashTenderedMinor]: what the customer handed over in cash (for change), optional.
  Future<CompletedSale> settle({
    required Cart cart,
    required SalesSettings settings,
    required List<({PaymentMethod method, int? amountMinor})> tenders,
    required String userId,
    required String cashierName,
    int? cashTenderedMinor,

    /// false = "Quick Order (No KOT)": settled at once, nothing goes to the kitchen.
    bool sendKot = true,
  }) async {
    if (cart.isEmpty) throw const SaleException('The cart is empty.');
    if (cart.existingOrderId != null) throw const SaleException('Settle the running table order from Orders.');
    if (!_ctx.newOrdersAllowed()) throw const SaleException(TerminalContextHolder.notActivatedMessage);
    final shift = await _shifts.openShift() ?? (throw const SaleException('Open a shift before selling.'));
    final dayId = shift.data['business_day_id'] as String;
    final day = await _store.find('business_day', dayId);
    final businessDate = day?.data['business_date'] as String? ?? _ctx.ctx.businessDate();
    final ctx = _ctx.ctx;

    final priced = price(cart, settings);
    final Settlement settlement;
    try {
      settlement = _engine.settle(priced, [
        for (final t in tenders)
          Tender(t.method.kind, t.amountMinor, cashLike: t.method.cashLike, paymentMethodId: t.method.id),
      ], settings.cashRoundingIncrementMinor);
    } on PricingException catch (e) {
      throw SaleException(e.message);
    }
    if (settlement.paidMinor < priced.totalMinor + settlement.roundingMinor) {
      throw const SaleException('The payment does not cover the bill.');
    }

    final orderNo = await nextNumber('doc_order_no', (n) => '${ctx.deviceCode}-${n.toString().padLeft(6, '0')}');
    final tokenNo = await nextNumber(
      'doc_token_$businessDate',
      (n) => '${ctx.tokenLetter}-${n.toString().padLeft(3, '0')}',
    );
    final now = DateTime.now().toUtc();
    final nowIso = now.toIso8601String();
    final orderId = const Uuid().v7();
    final changes = <LocalChange>[];

    changes.add(
      LocalChange.insert('orders', {
        'business_day_id': dayId,
        'business_date': businessDate,
        'shift_id': shift.id,
        'kiosk_id': ?_ctx.ctx.kioskId,
        'order_no': orderNo,
        'token_no': tokenNo,
        ...cart.orderFields(),
        'status': 'SETTLED',
        'payment_status': 'PAID',
        'created_by': userId,
        'settled_by': userId,
        'subtotal_minor': priced.subtotalMinor,
        'discount_minor': priced.discountMinor,
        'charge_minor': priced.chargeMinor,
        'tax_minor': priced.taxMinor,
        'rounding_minor': settlement.roundingMinor,
        'total_minor': priced.totalMinor,
        'paid_minor': settlement.paidMinor,
        'settled_at': nowIso,
        'device_code': ctx.deviceCode,
      }, id: orderId),
    );

    for (var i = 0; i < cart.lines.length; i++) {
      final l = cart.lines[i];
      final p = priced.lines[i];
      changes.add(
        LocalChange.insert('order_line', {
          'order_id': orderId,
          'product_id': ?l.productId,
          'name_snapshot': l.name,
          'qty_milli': l.qtyMilli,
          'unit_price_minor': l.unitPriceMinor,
          'discount_minor': p.discount,
          'tax_rate_bp': l.taxRateBp,
          'price_includes_tax': l.priceIncludesTax,
          'tax_minor': p.tax,
          'line_total_minor': p.lineTotal,
          'kot_status': sendKot ? 'SENT' : 'NEW',
          'note': ?l.note,
          'added_by_device': ctx.deviceCode,
        }),
      );
    }
    if (cart.discountBp > 0) {
      changes.add(
        LocalChange.insert('order_discount', {
          'order_id': orderId,
          'kind': 'PERCENT',
          'value_bp': cart.discountBp,
          'amount_minor': priced.discountMinor,
          'applied_by': userId,
        }),
      );
    }
    for (final c in priced.charges) {
      changes.add(
        LocalChange.insert('order_charge', {
          'order_id': orderId,
          'code': c.code,
          'net_minor': c.net,
          'tax_minor': c.tax,
        }),
      );
    }

    final (paymentChanges, changeDue) = _settlementChanges(
      orderId: orderId,
      lines: cart.lines,
      priced: priced,
      settlement: settlement,
      shiftId: shift.id,
      businessDate: businessDate,
      userId: userId,
      cashTenderedMinor: cashTenderedMinor,
    );
    changes.addAll(paymentChanges);

    changes.add(
      LocalChange.insert('order_event', {
        'order_id': orderId,
        'type': 'SETTLED',
        'user_id': userId,
        'device_code': ctx.deviceCode,
        'occurred_at': nowIso,
      }),
    );
    if (sendKot) {
      changes.add(
        LocalChange.insert('kot', {
          'order_id': orderId,
          'kind': 'NEW',
          'token_no': tokenNo,
          'lines': kotLines(cart.lines, cart.kitchenNote),
          'device_code': ctx.deviceCode,
        }),
      );
    }

    await _store.commit(changes, userId: userId);
    _onCommit?.call();
    return CompletedSale(
      orderId: orderId,
      orderNo: orderNo,
      tokenNo: tokenNo,
      businessDate: businessDate,
      cart: cart,
      priced: priced,
      settlement: settlement,
      changeDueMinor: changeDue,
      cashierName: cashierName,
      settledAt: now,
    );
  }

  /// The running order as a cart: active lines (cancelled ones left out), order type, table,
  /// partner and the order discount. Stock tracking comes from the product.
  Future<Cart> loadOrderCart(String orderId) async {
    final order = await _store.find('orders', orderId) ?? (throw const SaleException('Order not found.'));
    final tracked = {
      for (final p in await _store.all('product'))
        if (p.data['track_stock'] == true || p.data['track_stock'] == 1) p.id,
    };
    final lineRows = [
      for (final r in await _store.all('order_line'))
        if (r.data['order_id'] == orderId && r.data['kot_status'] != 'CANCELLED') r,
    ];
    var deliveryMinor = 0;
    for (final c in await _store.all('order_charge')) {
      if (c.data['order_id'] == orderId && c.data['code'] == 'DELIVERY') {
        deliveryMinor = ((c.data['net_minor'] as num?) ?? 0).toInt() + ((c.data['tax_minor'] as num?) ?? 0).toInt();
      }
    }
    var discountBp = 0;
    for (final d in await _store.all('order_discount')) {
      if (d.data['order_id'] == orderId && d.data['kind'] == 'PERCENT') {
        discountBp = (d.data['value_bp'] as num?)?.toInt() ?? discountBp;
      }
    }
    final o = order.data;
    return Cart(
      lines: [
        for (final r in lineRows)
          CartLine(
            key: r.id,
            productId: r.data['product_id'] as String?,
            name: r.data['name_snapshot'] as String? ?? '',
            unitPriceMinor: (r.data['unit_price_minor'] as num).toInt(),
            qtyMilli: (r.data['qty_milli'] as num).toInt(),
            taxRateBp: (r.data['tax_rate_bp'] as num?)?.toInt() ?? 0,
            priceIncludesTax: r.data['price_includes_tax'] as bool? ?? true,
            trackStock: tracked.contains(r.data['product_id']),
            note: r.data['note'] as String?,
          ),
      ],
      orderType: o['order_type'] as String? ?? 'TAKEAWAY',
      tableId: o['table_id'] as String?,
      guests: (o['guests'] as num?)?.toInt(),
      existingOrderId: orderId,
      existingOrderNo: o['order_no'] as String?,
      captainId: o['captain_id'] as String?,
      customerId: o['customer_id'] as String?,
      carhop: o['carhop'] == true || o['carhop'] == 1,
      carNo: o['car_no'] as String?,
      deliveryPartnerId: o['delivery_partner_id'] as String?,
      partnerOrderNo: o['partner_order_no'] as String?,
      kitchenNote: o['note'] as String?,
      discountBp: discountBp,
      deliveryChargeMinor: deliveryMinor,
    );
  }

  /// Settle a placed (OPEN or BILLED) order: payments, stock, ledger, status SETTLED.
  Future<CompletedSale> settleOrder({
    required String orderId,
    required SalesSettings settings,
    required List<({PaymentMethod method, int? amountMinor})> tenders,
    required String userId,
    required String cashierName,
    int? cashTenderedMinor,
  }) async {
    final order = await _store.find('orders', orderId) ?? (throw const SaleException('Order not found.'));
    final status = order.data['status'];
    if (status != 'OPEN' && status != 'BILLED') throw const SaleException('This order is already closed.');
    final shift = await _shifts.openShift() ?? (throw const SaleException('Open a shift before taking payment.'));
    final cart = await loadOrderCart(orderId);
    if (cart.isEmpty) throw const SaleException('The order has no items.');
    final businessDate = order.data['business_date'] as String? ?? _ctx.ctx.businessDate();
    final priced = price(cart, settings);
    final Settlement settlement;
    try {
      settlement = _engine.settle(priced, [
        for (final t in tenders)
          Tender(t.method.kind, t.amountMinor, cashLike: t.method.cashLike, paymentMethodId: t.method.id),
      ], settings.cashRoundingIncrementMinor);
    } on PricingException catch (e) {
      throw SaleException(e.message);
    }
    if (settlement.paidMinor < priced.totalMinor + settlement.roundingMinor) {
      throw const SaleException('The payment does not cover the bill.');
    }
    final now = DateTime.now().toUtc();
    final (paymentChanges, changeDue) = _settlementChanges(
      orderId: orderId,
      lines: cart.lines,
      priced: priced,
      settlement: settlement,
      shiftId: shift.id,
      businessDate: businessDate,
      userId: userId,
      cashTenderedMinor: cashTenderedMinor,
    );
    final changes = <LocalChange>[
      LocalChange.update('orders', orderId, {
        'status': 'SETTLED',
        'payment_status': 'PAID',
        'subtotal_minor': priced.subtotalMinor,
        'discount_minor': priced.discountMinor,
        'charge_minor': priced.chargeMinor,
        'tax_minor': priced.taxMinor,
        'rounding_minor': settlement.roundingMinor,
        'total_minor': priced.totalMinor,
        'paid_minor': settlement.paidMinor,
        'settled_by': userId,
        'settled_at': now.toIso8601String(),
      }),
      ...paymentChanges,
      LocalChange.insert('order_event', {
        'order_id': orderId,
        'type': 'SETTLED',
        'user_id': userId,
        'device_code': _ctx.ctx.deviceCode,
        'occurred_at': now.toIso8601String(),
      }),
    ];
    await _store.commit(changes, userId: userId);
    _onCommit?.call();
    return CompletedSale(
      orderId: orderId,
      orderNo: order.data['order_no'] as String? ?? '',
      tokenNo: order.data['token_no'] as String? ?? '',
      businessDate: businessDate,
      cart: cart,
      priced: priced,
      settlement: settlement,
      changeDueMinor: changeDue,
      cashierName: cashierName,
      settledAt: now,
    );
  }

  /// Payments, SALE stock movements and the balanced ledger of a settlement (SRS 10.8).
  (List<LocalChange>, int) _settlementChanges({
    required String orderId,
    required List<CartLine> lines,
    required PricedOrder priced,
    required Settlement settlement,
    required String shiftId,
    required String businessDate,
    required String userId,
    int? cashTenderedMinor,
  }) {
    final changes = <LocalChange>[];
    var changeDue = 0;
    for (final t in settlement.tenders) {
      final isCashRest = t.tender.cashLike && t.dueMinor != null;
      final tendered = isCashRest && cashTenderedMinor != null && cashTenderedMinor > t.amountMinor
          ? cashTenderedMinor
          : null;
      if (tendered != null) changeDue = tendered - t.amountMinor;
      changes.add(
        LocalChange.insert('payment', {
          'order_id': orderId,
          'payment_method_id': ?t.tender.paymentMethodId,
          'method_kind': t.tender.kind,
          'is_cash_like': t.tender.cashLike,
          'amount_minor': t.amountMinor,
          'tendered_minor': ?tendered,
          'change_minor': ?(tendered == null ? null : changeDue),
          'rounding_minor': isCashRest ? settlement.roundingMinor : 0,
          'shift_id': shiftId,
          'received_by': userId,
          'device_code': _ctx.ctx.deviceCode,
          'business_date': businessDate,
        }),
      );
    }

    for (final l in lines.where((l) => l.trackStock && l.productId != null)) {
      changes.add(
        LocalChange.insert('stock_movement', {
          'product_id': l.productId,
          'qty_milli': -l.qtyMilli,
          'reason': 'SALE',
          'ref_type': 'orders',
          'ref_id': orderId,
          'business_date': businessDate,
          'user_id': userId,
        }),
      );
    }

    // ---- ledger (SRS 10.8): debits = tenders + discounts allowed (+ rounding down) --------
    final txRef = const Uuid().v7();
    final postings = <(String, int, int)>[];
    for (final t in settlement.tenders) {
      postings.add((tenderAccount[t.tender.kind] ?? 'OTHER_TENDER_CLEARING', t.amountMinor, 0));
    }
    final discountsAllowed = priced.lines.fold(0, (s, l) => s + l.discountNet);
    if (discountsAllowed > 0) postings.add(('DISCOUNTS_ALLOWED', discountsAllowed, 0));
    if (settlement.roundingMinor < 0) postings.add(('ROUNDING', -settlement.roundingMinor, 0));
    if (settlement.roundingMinor > 0) postings.add(('ROUNDING', 0, settlement.roundingMinor));
    postings.add(('SALES_REVENUE', 0, priced.netMinor + discountsAllowed));
    for (final c in priced.charges) {
      if (c.net > 0) postings.add((c.code == 'SERVICE' ? 'SERVICE_CHARGE_INCOME' : 'DELIVERY_INCOME', 0, c.net));
    }
    if (priced.taxMinor > 0) postings.add(('VAT_OUTPUT', 0, priced.taxMinor));
    final debit = postings.fold(0, (s, p) => s + p.$2);
    final credit = postings.fold(0, (s, p) => s + p.$3);
    if (debit != credit) throw SaleException('Ledger does not balance ($debit / $credit).');
    for (final (account, dr, cr) in postings) {
      changes.add(
        LocalChange.insert('ledger_entry', {
          'tx_ref': txRef,
          'account_code': account,
          'debit_minor': dr,
          'credit_minor': cr,
          'ref_type': 'orders',
          'ref_id': orderId,
          'business_date': businessDate,
        }),
      );
    }

    return (changes, changeDue);
  }
}
