import 'package:uuid/uuid.dart';

import '../../../core/sync/local_store.dart';
import '../../../core/terminal/terminal_context.dart';
import '../../catalogue/data/catalogue_repository.dart';
import '../../shift/domain/shift_service.dart';
import 'cart.dart';
import 'checkout_service.dart';
import 'pricing_engine.dart';

/// An order sent to the kitchen and left open for payment later (Place Order).
class PlacedOrder {
  const PlacedOrder({
    required this.orderId,
    required this.orderNo,
    required this.tokenNo,
    required this.cart,
    required this.newLines,
    required this.kind,
    this.cancelledLines = const [],
  });
  final String orderId, orderNo, tokenNo;
  final Cart cart;

  /// Lines on this KOT (all lines for a new order, only the added quantities for an edited order).
  final List<CartLine> newLines;

  /// Quantities taken off an edited order (CANCEL KOT).
  final List<CartLine> cancelledLines;

  /// NEW, or UPDATE for an edited order.
  final String kind;
}

/// A cart parked with Hold.
class HeldCart {
  const HeldCart({
    required this.id,
    required this.label,
    required this.cart,
    required this.totalMinor,
    required this.heldAt,
  });
  final String id, label;
  final Cart cart;
  final int totalMinor;
  final DateTime heldAt;
}

/// An open (unpaid) order on this terminal, e.g. a running table.
class OpenOrder {
  const OpenOrder({
    required this.id,
    required this.orderNo,
    required this.orderType,
    required this.tableId,
    required this.guests,
    required this.totalMinor,
  });
  final String id, orderNo, orderType;
  final String? tableId;
  final int guests, totalMinor;
}

/// Place Order (KOT, pay later), add items to a running table, Hold and recall. Each action is one
/// local transaction that syncs like any sale.
class OrderService {
  OrderService(this._store, this._ctx, this._shifts, this._checkout, [this._onCommit]);

  final LocalStore _store;
  final TerminalContextHolder _ctx;
  final ShiftService _shifts;
  final CheckoutService _checkout;
  final void Function()? _onCommit;

  String _nowIso() => DateTime.now().toUtc().toIso8601String();

  /// Unpaid orders on this terminal (OPEN or BILLED).
  Future<List<OpenOrder>> openOrders() async => [
    for (final r in await _store.all('orders'))
      if (r.data['status'] == 'OPEN' || r.data['status'] == 'BILLED')
        OpenOrder(
          id: r.id,
          orderNo: r.data['order_no'] as String? ?? '',
          orderType: r.data['order_type'] as String? ?? '',
          tableId: r.data['table_id'] as String?,
          guests: (r.data['guests'] as num?)?.toInt() ?? 0,
          totalMinor: (r.data['total_minor'] as num?)?.toInt() ?? 0,
        ),
  ];

  Future<PlacedOrder> place({required Cart cart, required SalesSettings settings, required String userId}) async {
    if (cart.isEmpty) throw const SaleException('The cart is empty.');
    if (cart.existingOrderId != null) return update(cart: cart, settings: settings, userId: userId);
    if (!_ctx.newOrdersAllowed()) throw const SaleException(TerminalContextHolder.notActivatedMessage);
    final day =
        await _shifts.openDay() ??
        (throw const SaleException('No business day is open. A cashier must open a shift first.'));
    final shift = await _shifts.openShift();
    final ctx = _ctx.ctx;
    final businessDate = day.data['business_date'] as String? ?? ctx.businessDate();
    final priced = _checkout.price(cart, settings);
    final orderNo = await _checkout.nextNumber(
      'doc_order_no',
      (n) => '${ctx.deviceCode}-${n.toString().padLeft(6, '0')}',
    );
    final tokenNo = await _checkout.nextNumber(
      'doc_token_$businessDate',
      (n) => '${ctx.tokenLetter}-${n.toString().padLeft(3, '0')}',
    );
    final orderId = const Uuid().v7();
    final now = _nowIso();
    final changes = <LocalChange>[
      LocalChange.insert('orders', {
        'business_day_id': day.id,
        'business_date': businessDate,
        'shift_id': ?shift?.id,
        'kiosk_id': ?ctx.kioskId,
        'order_no': orderNo,
        'token_no': tokenNo,
        ...cart.orderFields(),
        'status': 'OPEN',
        'payment_status': 'UNPAID',
        'created_by': userId,
        'subtotal_minor': priced.subtotalMinor,
        'discount_minor': priced.discountMinor,
        'charge_minor': priced.chargeMinor,
        'tax_minor': priced.taxMinor,
        'total_minor': priced.totalMinor,
        'paid_minor': 0,
        'device_code': ctx.deviceCode,
      }, id: orderId),
      ..._lineChanges(orderId, cart.lines, priced, 0),
      if (cart.discountBp > 0)
        LocalChange.insert('order_discount', {
          'order_id': orderId,
          'kind': 'PERCENT',
          'value_bp': cart.discountBp,
          'amount_minor': priced.discountMinor,
          'applied_by': userId,
        }),
      for (final c in priced.charges)
        LocalChange.insert('order_charge', {
          'order_id': orderId,
          'code': c.code,
          'net_minor': c.net,
          'tax_minor': c.tax,
        }),
      LocalChange.insert('order_event', {
        'order_id': orderId,
        'type': 'PLACED',
        'user_id': userId,
        'device_code': ctx.deviceCode,
        'occurred_at': now,
      }),
      LocalChange.insert('kot', {
        'order_id': orderId,
        'kind': 'NEW',
        'token_no': tokenNo,
        'lines': kotLines(cart.lines, cart.kitchenNote),
        'device_code': ctx.deviceCode,
      }),
    ];
    if (cart.heldCartId != null) changes.add(_recalledChange(cart.heldCartId!));
    await _store.commit(changes, userId: userId);
    _onCommit?.call();
    return PlacedOrder(
      orderId: orderId,
      orderNo: orderNo,
      tokenNo: tokenNo,
      cart: cart,
      newLines: cart.lines,
      kind: 'NEW',
    );
  }

  /// Update Order: the cart holds the whole running order (lines keyed by order_line id) as edited
  /// on the home screen. Added quantities go on a NEW_ITEMS KOT, lowered or removed ones on a CANCEL
  /// KOT, and the order is re-priced. [sendKot] false (Quick Update Order) records no KOT.
  /// [canReduce] false rejects any reduction (permission order.reduce_qty_after_kot).
  Future<PlacedOrder> update({
    required Cart cart,
    required SalesSettings settings,
    required String userId,
    bool sendKot = true,
    bool canReduce = true,
  }) async {
    final ctx = _ctx.ctx;
    final order =
        await _store.find('orders', cart.existingOrderId!) ??
        (throw const SaleException('The running order was not found.'));
    final status = order.data['status'];
    if (status != 'OPEN' && status != 'BILLED') throw const SaleException('That order is already closed.');
    if (cart.isEmpty) throw const SaleException('To remove every item use Void Bill.');
    final stored = await _checkout.loadOrderCart(order.id);
    final current = {for (final l in stored.lines) l.key: l};
    final priced = _checkout.price(cart, settings);
    final added = <CartLine>[];
    final cancelled = <CartLine>[];
    final changes = <LocalChange>[];
    for (var i = 0; i < cart.lines.length; i++) {
      final l = cart.lines[i];
      final old = current[l.key];
      if (old == null) {
        added.add(l);
        changes.add(_lineInsert(order.id, l, priced, i));
        continue;
      }
      if (l.qtyMilli > old.qtyMilli) added.add(l.copyWith(qtyMilli: l.qtyMilli - old.qtyMilli));
      if (l.qtyMilli < old.qtyMilli) cancelled.add(l.copyWith(qtyMilli: old.qtyMilli - l.qtyMilli));
      changes.add(
        LocalChange.update('order_line', l.key, {
          'order_id': order.id,
          'qty_milli': l.qtyMilli,
          'discount_minor': priced.lines[i].discount,
          'tax_minor': priced.lines[i].tax,
          'line_total_minor': priced.lines[i].lineTotal,
          'note': l.note,
        }),
      );
    }
    final kept = {for (final l in cart.lines) l.key};
    for (final old in stored.lines) {
      if (kept.contains(old.key)) continue;
      cancelled.add(old);
      changes.add(LocalChange.update('order_line', old.key, {'kot_status': 'CANCELLED'}));
    }
    if (cancelled.isNotEmpty && !canReduce) {
      throw const SaleException('You may not reduce items already sent to the kitchen.');
    }
    // charges (delivery, service) follow the new totals: update by code, zero the ones gone
    final chargeRows = {
      for (final r in await _store.all('order_charge'))
        if (r.data['order_id'] == order.id) r.data['code'] as String? ?? '': r.id,
    };
    for (final c in priced.charges) {
      final values = {'net_minor': c.net, 'tax_minor': c.tax};
      final id = chargeRows[c.code];
      changes.add(
        id != null
            ? LocalChange.update('order_charge', id, values)
            : LocalChange.insert('order_charge', {'order_id': order.id, 'code': c.code, ...values}),
      );
    }
    for (final MapEntry(key: code, value: id) in chargeRows.entries) {
      if (!priced.charges.any((c) => c.code == code)) {
        changes.add(LocalChange.update('order_charge', id, {'net_minor': 0, 'tax_minor': 0}));
      }
    }
    final tokenNo = order.data['token_no'] as String? ?? '';
    changes.addAll([
      LocalChange.update('orders', order.id, {
        ...cart.orderFields(),
        'subtotal_minor': priced.subtotalMinor,
        'discount_minor': priced.discountMinor,
        'charge_minor': priced.chargeMinor,
        'tax_minor': priced.taxMinor,
        'total_minor': priced.totalMinor,
        'updated_by': userId,
        if (status == 'BILLED') 'status': 'OPEN',
      }),
      if (cart.discountBp != stored.discountBp)
        LocalChange.insert('order_discount', {
          'order_id': order.id,
          'kind': 'PERCENT',
          'value_bp': cart.discountBp,
          'amount_minor': priced.discountMinor,
          'applied_by': userId,
        }),
      LocalChange.insert('order_event', {
        'order_id': order.id,
        'type': 'ORDER_UPDATED',
        'user_id': userId,
        'device_code': ctx.deviceCode,
        'occurred_at': _nowIso(),
      }),
      if (sendKot && added.isNotEmpty)
        LocalChange.insert('kot', {
          'order_id': order.id,
          'kind': 'NEW_ITEMS',
          'token_no': tokenNo,
          'lines': kotLines(added, cart.kitchenNote),
          'device_code': ctx.deviceCode,
        }),
      if (sendKot && cancelled.isNotEmpty)
        LocalChange.insert('kot', {
          'order_id': order.id,
          'kind': 'CANCEL',
          'token_no': tokenNo,
          'lines': [
            for (final l in cancelled) {'name': l.name, 'qty_milli': l.qtyMilli, 'note': 'CANCEL'},
          ],
          'device_code': ctx.deviceCode,
        }),
      if (cart.heldCartId != null) _recalledChange(cart.heldCartId!),
    ]);
    await _store.commit(changes, userId: userId);
    _onCommit?.call();
    return PlacedOrder(
      orderId: order.id,
      orderNo: order.data['order_no'] as String? ?? '',
      tokenNo: tokenNo,
      cart: cart,
      newLines: added,
      cancelledLines: cancelled,
      kind: 'UPDATE',
    );
  }

  List<LocalChange> _lineChanges(String orderId, List<CartLine> lines, PricedOrder priced, int offset) => [
    for (var i = 0; i < lines.length; i++) _lineInsert(orderId, lines[i], priced, offset + i),
  ];

  LocalChange _lineInsert(String orderId, CartLine l, PricedOrder priced, int i) => LocalChange.insert('order_line', {
    'order_id': orderId,
    'product_id': ?l.productId,
    'name_snapshot': l.name,
    'qty_milli': l.qtyMilli,
    'unit_price_minor': l.unitPriceMinor,
    'discount_minor': priced.lines[i].discount,
    'tax_rate_bp': l.taxRateBp,
    'price_includes_tax': l.priceIncludesTax,
    'tax_minor': priced.lines[i].tax,
    'line_total_minor': priced.lines[i].lineTotal,
    'kot_status': 'SENT',
    'note': ?l.note,
    'added_by_device': _ctx.ctx.deviceCode,
  });

  // ---- Hold -----------------------------------------------------------------------------

  Future<String> hold({required Cart cart, required SalesSettings settings, required String userId}) async {
    if (cart.isEmpty) throw const SaleException('The cart is empty.');
    final ctx = _ctx.ctx;
    final n = await _checkout.nextNumber('doc_hold_no', (n) => '$n');
    final label = [
      'Hold $n',
      if (cart.tableName != null) 'Table ${cart.tableName}',
      ?cart.customerName,
      ?cart.deliveryPartnerName,
    ].join(' · ');
    final changes = [
      LocalChange.insert('held_cart', {
        'label': label.length > 64 ? label.substring(0, 64) : label,
        'device_code': ctx.deviceCode,
        'user_id': userId,
        'order_type': cart.orderType,
        'table_id': ?cart.tableId,
        'customer_id': ?cart.customerId,
        'cart': cart.copyWith(heldCartId: null).toMap(),
        'total_minor': _checkout.price(cart, settings).totalMinor,
        'held_at': _nowIso(),
      }),
      if (cart.heldCartId != null) _recalledChange(cart.heldCartId!),
    ];
    await _store.commit(changes, userId: userId);
    _onCommit?.call();
    return label;
  }

  Future<List<HeldCart>> heldCarts() async {
    final list = [
      for (final r in await _store.all('held_cart'))
        if (r.data['recalled_at'] == null && r.data['device_code'] == _ctx.ctx.deviceCode)
          HeldCart(
            id: r.id,
            label: r.data['label'] as String? ?? '',
            cart: Cart.fromMap(Map<String, dynamic>.from(r.data['cart'] as Map? ?? const {})),
            totalMinor: (r.data['total_minor'] as num?)?.toInt() ?? 0,
            heldAt: DateTime.tryParse(r.data['held_at'] as String? ?? '') ?? DateTime.now(),
          ),
    ];
    return list..sort((a, b) => b.heldAt.compareTo(a.heldAt));
  }

  /// The cart back on screen; the held row is closed when the cart is placed, paid or held again.
  Cart recall(HeldCart h) => h.cart.copyWith(heldCartId: h.id);

  /// Drop a held cart without using it.
  Future<void> discardHeld(String id, String userId) async {
    await _store.commit([_recalledChange(id)], userId: userId);
    _onCommit?.call();
  }

  /// Closes a held cart after it was paid with Quick Order.
  Future<void> closeHeld(String id, String userId) => discardHeld(id, userId);

  LocalChange _recalledChange(String id) =>
      LocalChange.update('held_cart', id, {'recalled_at': _nowIso(), 'recalled_by_device': _ctx.ctx.deviceCode});
}
