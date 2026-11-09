import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../../core/sync/local_store.dart';
import '../../../core/terminal/terminal_context.dart';
import '../../catalogue/data/catalogue_repository.dart';
import '../../staff/data/staff_repository.dart';
import 'cart.dart';
import 'checkout_service.dart';
import 'pricing_engine.dart';

/// One card of the Orders Dashboard.
class OrderSummary {
  const OrderSummary({
    required this.id,
    required this.orderNo,
    required this.tokenNo,
    required this.orderType,
    required this.status,
    required this.totalMinor,
    required this.synced,
    this.tableId,
    this.tableName,
    this.guests,
    this.captainName,
    this.customerName,
    this.partnerName,
    this.partnerOrderNo,
    this.openedAt,
    this.closedAt,
    this.voidReason,
  });
  final String id, orderNo, tokenNo, orderType, status;
  final int totalMinor;
  final bool synced;
  final String? tableId, tableName, captainName, customerName, partnerName, partnerOrderNo, voidReason;
  final int? guests;
  final DateTime? openedAt, closedAt;

  bool get isPartner => partnerName != null;

  /// Dine In / Take Away / Home Delivery / Delivery Partner tab.
  String get channel => isPartner ? Channel.partner : orderType;
  bool get ongoing => status == 'OPEN' || status == 'BILLED';

  /// ongoing | paid | cancelled | void (legend colours).
  String get state => switch (status) {
    'SETTLED' => 'paid',
    'VOIDED' => (voidReason ?? '').toLowerCase().startsWith('cancel') ? 'cancelled' : 'void',
    _ => 'ongoing',
  };

  /// "Table B4/1", the partner, the customer or the token.
  String get where => switch (channel) {
    Channel.dineIn => tableName != null ? 'Table $tableName/${guests ?? 1}' : 'Dine in',
    Channel.partner => '$partnerName${partnerOrderNo != null ? ' #$partnerOrderNo' : ''}',
    Channel.homeDelivery => customerName ?? 'Delivery',
    _ => 'Token $tokenNo',
  };
}

class OrderLineInfo {
  const OrderLineInfo({
    required this.id,
    required this.name,
    required this.qtyMilli,
    required this.unitPriceMinor,
    required this.lineTotalMinor,
    this.note,
  });
  final String id, name;
  final int qtyMilli, unitPriceMinor, lineTotalMinor;
  final String? note;
}

class OrderDetail {
  const OrderDetail({required this.summary, required this.cart, required this.lines, required this.priced});
  final OrderSummary summary;

  /// Active lines as a cart (pricing, KOT, receipt).
  final Cart cart;
  final List<OrderLineInfo> lines;
  final PricedOrder? priced;
}

/// Orders Dashboard and Order Details: lists, settle, table / item transfer, bill split, bill type
/// change, edit, void, merge, coupon and bill status. Every action is one local transaction.
class OrderManager {
  OrderManager(this._store, this._ctx, this._checkout, this._staff, [this._onCommit]);

  final LocalStore _store;
  final TerminalContextHolder _ctx;
  final CheckoutService _checkout;
  final StaffRepository _staff;
  final void Function()? _onCommit;

  /// Entities of an order: a change to any of them (from another terminal, through sync) means the
  /// order screens should reload.
  static const orderEntities = {
    'orders',
    'order_line',
    'order_discount',
    'order_charge',
    'order_event',
    'kot',
    'payment',
    'refund',
    'customer',
    'dining_table',
  };

  /// Fires when orders changed on another terminal (applied by sync).
  Stream<void> get remoteChanges => _store.incoming.where((e) => e.any(orderEntities.contains)).map((_) {});

  /// Set by Edit Order: the home screen opens with this running order (see [openOnHome]).
  Cart? homeIntent;

  final _intents = StreamController<void>.broadcast();

  /// Fires when [openOnHome] is called, so a home screen already in the navigation stack picks it up.
  Stream<void> get intents => _intents.stream;

  /// Hand [cart] to the home screen (taken once, by whichever home screen sees it first).
  void openOnHome(Cart cart) {
    homeIntent = cart;
    _intents.add(null);
  }

  String _now() => DateTime.now().toUtc().toIso8601String();

  Future<void> _commit(List<LocalChange> changes, String userId) async {
    await _store.commit(changes, userId: userId);
    _onCommit?.call();
  }

  LocalChange _event(String orderId, String type, String userId) => LocalChange.insert('order_event', {
    'order_id': orderId,
    'type': type,
    'user_id': userId,
    'device_code': _ctx.ctx.deviceCode,
    'occurred_at': _now(),
  });

  // ---- queries -----------------------------------------------------------------------------

  Future<List<OrderSummary>> summaries() async {
    final tables = {for (final t in await _store.all('dining_table')) t.id: t.data['name'] as String?};
    final partners = {for (final p in await _store.all('delivery_partner')) p.id: p.data['name'] as String?};
    final customers = {for (final c in await _store.all('customer')) c.id: c.data['name'] as String?};
    final staff = {for (final u in await _staff.users()) u.id: u.name};
    final opened = <String, DateTime>{};
    final closed = <String, DateTime>{};
    for (final e in await _store.all('order_event')) {
      final id = e.data['order_id'] as String?;
      final at = DateTime.tryParse(e.data['occurred_at'] as String? ?? '');
      if (id == null || at == null) continue;
      if (opened[id] == null || at.isBefore(opened[id]!)) opened[id] = at;
      if (e.data['type'] == 'SETTLED' || e.data['type'] == 'VOIDED') closed[id] = at;
    }
    final pending = <String>{};
    for (final tx in await _store.pendingTransactions(maxChanges: 100000)) {
      for (final c in tx) {
        if (c.entity == 'orders') pending.add(c.entityId);
        final o = c.fields['order_id'];
        if (o is String) pending.add(o);
      }
    }
    final list = [
      for (final r in await _store.all('orders'))
        OrderSummary(
          id: r.id,
          orderNo: r.data['order_no'] as String? ?? '',
          tokenNo: r.data['token_no'] as String? ?? '',
          orderType: r.data['order_type'] as String? ?? 'TAKEAWAY',
          status: r.data['status'] as String? ?? 'OPEN',
          totalMinor: (r.data['total_minor'] as num?)?.toInt() ?? 0,
          synced: !pending.contains(r.id),
          tableId: r.data['table_id'] as String?,
          tableName: tables[r.data['table_id']],
          guests: (r.data['guests'] as num?)?.toInt(),
          captainName: staff[r.data['captain_id']],
          customerName: customers[r.data['customer_id']],
          // A partner order stays on the partner tab even if the partner row is gone or not synced yet.
          partnerName: r.data['delivery_partner_id'] == null
              ? null
              : partners[r.data['delivery_partner_id']] ?? 'Partner',
          partnerOrderNo: r.data['partner_order_no'] as String?,
          openedAt: opened[r.id]?.toLocal(),
          closedAt: closed[r.id]?.toLocal(),
          voidReason: r.data['void_reason'] as String?,
        ),
    ];
    return list..sort((a, b) => b.orderNo.compareTo(a.orderNo));
  }

  Future<OrderDetail> detail(String orderId, SalesSettings settings) async {
    final summary = (await summaries()).firstWhere((o) => o.id == orderId);
    final cart = await _checkout.loadOrderCart(orderId);
    final priced = cart.isEmpty ? null : _checkout.price(cart, settings);
    return OrderDetail(
      summary: summary,
      cart: cart.copyWith(tableName: summary.tableName, deliveryPartnerName: summary.partnerName),
      priced: priced,
      lines: [
        for (var i = 0; i < cart.lines.length; i++)
          OrderLineInfo(
            id: cart.lines[i].key,
            name: cart.lines[i].name,
            qtyMilli: cart.lines[i].qtyMilli,
            unitPriceMinor: cart.lines[i].unitPriceMinor,
            lineTotalMinor: priced?.lines[i].lineTotal ?? 0,
            note: cart.lines[i].note,
          ),
      ],
    );
  }

  /// Edit Order: the whole running order as a home-screen cart, names filled in for display.
  Future<Cart> editCart(String orderId) async {
    final cart = await _openCart(orderId);
    final s = (await summaries()).firstWhere((o) => o.id == orderId);
    return cart.copyWith(
      tableName: s.tableName,
      captainName: s.captainName,
      customerName: s.customerName,
      deliveryPartnerName: s.partnerName,
    );
  }

  /// Coupon code -> discount in basis points (offer of type PERCENT_OFF with rules.code).
  Future<int?> couponBp(String code) async {
    final c = code.trim().toUpperCase();
    for (final o in await _store.all('offer')) {
      final rules = o.data['rules'];
      if (o.data['active'] == false || o.data['type'] != 'PERCENT_OFF' || rules is! Map) continue;
      if ((rules['code'] as String?)?.toUpperCase() != c) continue;
      final pct = rules['percent'] ?? rules['value'];
      if (pct is num) return (pct * 100).round();
      final bp = rules['percent_bp'];
      if (bp is num) return bp.toInt();
    }
    return null;
  }

  // ---- re-pricing ------------------------------------------------------------------------------

  /// Line amounts and order totals for [cart] (lines keyed by their order_line id).
  List<LocalChange> _reprice(
    String orderId,
    Cart cart,
    SalesSettings settings,
    String userId, [
    Map<String, dynamic>? extra,
  ]) {
    final priced = _checkout.price(cart, settings);
    return [
      for (var i = 0; i < cart.lines.length; i++)
        LocalChange.update('order_line', cart.lines[i].key, {
          'order_id': orderId,
          'discount_minor': priced.lines[i].discount,
          'tax_minor': priced.lines[i].tax,
          'line_total_minor': priced.lines[i].lineTotal,
        }),
      LocalChange.update('orders', orderId, {
        'subtotal_minor': priced.subtotalMinor,
        'discount_minor': priced.discountMinor,
        'charge_minor': priced.chargeMinor,
        'tax_minor': priced.taxMinor,
        'total_minor': priced.totalMinor,
        'updated_by': userId,
        ...?extra,
      }),
    ];
  }

  Future<Cart> _openCart(String orderId) async {
    final o = await _store.find('orders', orderId);
    if (o == null) throw const SaleException('Order not found.');
    if (o.data['status'] != 'OPEN' && o.data['status'] != 'BILLED') {
      throw const SaleException('This order is already closed.');
    }
    return _checkout.loadOrderCart(orderId);
  }

  // ---- actions ---------------------------------------------------------------------------------

  Future<void> transferTable({
    required String orderId,
    required String tableId,
    required int guests,
    required String userId,
  }) async {
    await _openCart(orderId);
    await _commit([
      LocalChange.update('orders', orderId, {'table_id': tableId, 'guests': guests, 'updated_by': userId}),
      _event(orderId, 'TABLE_TRANSFER', userId),
    ], userId);
  }

  /// Moves whole lines to another running order; both orders are re-priced.
  Future<void> transferItems({
    required String fromId,
    required Set<String> lineIds,
    required String toId,
    required SalesSettings settings,
    required String userId,
  }) async {
    if (fromId == toId) throw const SaleException('Choose another order.');
    final from = await _openCart(fromId);
    final to = await _openCart(toId);
    final moving = from.lines.where((l) => lineIds.contains(l.key)).toList();
    if (moving.isEmpty) throw const SaleException('Select items to move.');
    if (moving.length == from.lines.length) throw const SaleException('To move every item use Merge.');
    await _commit([
      ..._reprice(
        fromId,
        from.copyWith(lines: from.lines.where((l) => !lineIds.contains(l.key)).toList()),
        settings,
        userId,
      ),
      ..._reprice(toId, to.copyWith(lines: [...to.lines, ...moving]), settings, userId),
      _event(fromId, 'ITEMS_TRANSFERRED', userId),
      _event(toId, 'ITEMS_TRANSFERRED', userId),
    ], userId);
  }

  /// Bill Split: the selected lines become a new bill (same table, captain and customer).
  Future<String> split({
    required String orderId,
    required Set<String> lineIds,
    required SalesSettings settings,
    required String userId,
  }) async {
    final cart = await _openCart(orderId);
    final moving = cart.lines.where((l) => lineIds.contains(l.key)).toList();
    if (moving.isEmpty) throw const SaleException('Select items for the new bill.');
    if (moving.length == cart.lines.length) throw const SaleException('Leave at least one item on this bill.');
    if (!_ctx.newOrdersAllowed()) throw const SaleException(TerminalContextHolder.notActivatedMessage);
    final o = (await _store.find('orders', orderId))!.data;
    final ctx = _ctx.ctx;
    final orderNo = await _checkout.nextNumber(
      'doc_order_no',
      (n) => '${ctx.deviceCode}-${n.toString().padLeft(6, '0')}',
    );
    final newId = const Uuid().v7();
    final newCart = cart.copyWith(lines: moving, discountBp: 0, existingOrderId: newId);
    final priced = _checkout.price(newCart, settings);
    const copy = [
      'business_day_id',
      'business_date',
      'shift_id',
      'kiosk_id',
      'token_no',
      'order_type',
      'table_id',
      'guests',
      'captain_id',
      'customer_id',
      'carhop',
      'car_no',
      'delivery_partner_id',
      'partner_order_no',
      'note',
    ];
    await _commit([
      LocalChange.insert('orders', {
        for (final k in copy)
          if (o[k] != null) k: o[k],
        'order_no': orderNo,
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
      }, id: newId),
      ..._reprice(newId, newCart, settings, userId),
      ..._reprice(
        orderId,
        cart.copyWith(lines: cart.lines.where((l) => !lineIds.contains(l.key)).toList()),
        settings,
        userId,
      ),
      _event(newId, 'SPLIT_FROM', userId),
      _event(orderId, 'SPLIT', userId),
    ], userId);
    return orderNo;
  }

  /// Bill Type Change; only dine-in keeps a table.
  Future<void> changeType({
    required String orderId,
    required String orderType,
    String? tableId,
    int? guests,
    required SalesSettings settings,
    required String userId,
  }) async {
    final cart = await _openCart(orderId);
    final dine = orderType == Channel.dineIn;
    if (dine && tableId == null) throw const SaleException('Choose a table for dine-in.');
    await _commit([
      ..._reprice(orderId, cart.copyWith(orderType: orderType), settings, userId, {
        'order_type': orderType,
        'table_id': dine ? tableId : null,
        'guests': dine ? guests : null,
        if (orderType != Channel.homeDelivery) 'delivery_partner_id': null,
        if (orderType != Channel.homeDelivery) 'partner_order_no': null,
      }),
      _event(orderId, 'TYPE_CHANGED', userId),
    ], userId);
  }

  /// Edit Order: lower quantities or remove items ([qty] = new qty in milli, 0 = remove). A CANCEL
  /// KOT tells the kitchen.
  Future<void> reduce({
    required String orderId,
    required Map<String, int> qty,
    required SalesSettings settings,
    required String userId,
  }) async {
    final cart = await _openCart(orderId);
    final kept = <CartLine>[];
    final changes = <LocalChange>[];
    final cancelled = <Map<String, dynamic>>[];
    for (final l in cart.lines) {
      final q = qty[l.key];
      if (q == null || q >= l.qtyMilli) {
        kept.add(l);
        continue;
      }
      cancelled.add({'name': l.name, 'qty_milli': l.qtyMilli - q, 'note': 'CANCEL'});
      if (q <= 0) {
        changes.add(LocalChange.update('order_line', l.key, {'kot_status': 'CANCELLED'}));
      } else {
        kept.add(l.copyWith(qtyMilli: q));
        changes.add(LocalChange.update('order_line', l.key, {'qty_milli': q}));
      }
    }
    if (cancelled.isEmpty) return;
    if (kept.isEmpty) throw const SaleException('To remove every item use Void Bill.');
    final o = (await _store.find('orders', orderId))!.data;
    await _commit([
      ...changes,
      ..._reprice(orderId, cart.copyWith(lines: kept), settings, userId),
      LocalChange.insert('kot', {
        'order_id': orderId,
        'kind': 'CANCEL',
        'token_no': ?o['token_no'],
        'lines': cancelled,
        'device_code': _ctx.ctx.deviceCode,
      }),
      _event(orderId, 'ITEMS_REDUCED', userId),
    ], userId);
  }

  Future<void> voidOrder({required String orderId, required String reason, required String userId}) async {
    await _openCart(orderId);
    await _commit([
      LocalChange.update('orders', orderId, {
        'status': 'VOIDED',
        'void_reason': reason,
        'voided_by': userId,
        'voided_at': _now(),
      }),
      _event(orderId, 'VOIDED', userId),
    ], userId);
  }

  /// Merge: every item of [sourceId] moves to [targetId]; the source bill is voided.
  Future<void> merge({
    required String sourceId,
    required String targetId,
    required SalesSettings settings,
    required String userId,
  }) async {
    if (sourceId == targetId) throw const SaleException('Choose another order.');
    final source = await _openCart(sourceId);
    final target = await _openCart(targetId);
    final targetNo = target.existingOrderNo ?? '';
    await _commit([
      ..._reprice(targetId, target.copyWith(lines: [...target.lines, ...source.lines]), settings, userId),
      LocalChange.update('orders', sourceId, {
        'status': 'VOIDED',
        'void_reason': 'Merged into $targetNo',
        'voided_by': userId,
        'voided_at': _now(),
        'subtotal_minor': 0,
        'discount_minor': 0,
        'charge_minor': 0,
        'tax_minor': 0,
        'total_minor': 0,
      }),
      _event(sourceId, 'VOIDED', userId),
      _event(targetId, 'MERGED', userId),
    ], userId);
  }

  /// Apply Coupon / discount on a running order.
  Future<void> applyDiscount({
    required String orderId,
    required int bp,
    required SalesSettings settings,
    required String userId,
  }) async {
    final cart = await _openCart(orderId);
    final priced = _checkout.price(cart.copyWith(discountBp: bp), settings);
    await _commit([
      LocalChange.insert('order_discount', {
        'order_id': orderId,
        'kind': 'PERCENT',
        'value_bp': bp,
        'amount_minor': priced.discountMinor,
        'applied_by': userId,
      }),
      ..._reprice(orderId, cart.copyWith(discountBp: bp), settings, userId),
    ], userId);
  }

  /// Print Bill: an OPEN order becomes BILLED (bill handed to the guest).
  Future<void> markBilled(String orderId, String userId) async {
    final o = await _store.find('orders', orderId);
    if (o == null || o.data['status'] != 'OPEN') return;
    await _commit([
      LocalChange.update('orders', orderId, {'status': 'BILLED', 'billed_at': _now()}),
      _event(orderId, 'BILLED', userId),
    ], userId);
  }
}
