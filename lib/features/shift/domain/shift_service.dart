import '../../../core/sync/local_store.dart';
import '../../../core/terminal/terminal_context.dart';

class ShiftSummary {
  const ShiftSummary({
    required this.openingFloatMinor,
    required this.cashSalesMinor,
    required this.cashRefundsMinor,
    required this.cashInMinor,
    required this.cashOutMinor,
    required this.orders,
    required this.salesMinor,
  });
  final int openingFloatMinor, cashSalesMinor, cashRefundsMinor, cashInMinor, cashOutMinor, orders, salesMinor;

  /// BR-25: opening float + cash sales − cash refunds + cash in − cash out.
  int get expectedCashMinor => openingFloatMinor + cashSalesMinor - cashRefundsMinor + cashInMinor - cashOutMinor;
}

/// Business day and shift life cycle on this terminal (FR-CLS-01..06). Every step is one local
/// transaction that syncs like any sale.
class ShiftService {
  ShiftService(this._store, this._ctx, [this._onCommit]);

  final LocalStore _store;
  final TerminalContextHolder _ctx;
  final void Function()? _onCommit;

  String _nowIso() => DateTime.now().toUtc().toIso8601String();

  Future<LocalRecord?> openDay() async {
    final rows = (await _store.all('business_day')).where((r) => r.data['status'] == 'OPEN').toList()
      ..sort((a, b) => (b.data['business_date'] as String).compareTo(a.data['business_date'] as String));
    return rows.isEmpty ? null : rows.first;
  }

  Future<LocalRecord?> openShift() async {
    final rows = await _store.all('shift');
    for (final r in rows) {
      if (r.data['status'] == 'OPEN' && r.data['device_code'] == _ctx.ctx.deviceCode) return r;
    }
    return null;
  }

  /// Opens today's business day if needed, then a shift for [userId] with [openingFloatMinor].
  /// [name]: shift picked on the login screen (Morning Shift ...).
  Future<String> startShift({required String userId, required int openingFloatMinor, String? name}) async {
    if (await openShift() != null) throw StateError('A shift is already open on this terminal.');
    final changes = <LocalChange>[];
    final day = await openDay();
    String dayId;
    if (day == null) {
      final insert = LocalChange.insert('business_day', {
        'business_date': _ctx.ctx.businessDate(),
        'opened_at': _nowIso(),
        'opened_by': userId,
        'status': 'OPEN',
      });
      changes.add(insert);
      dayId = insert.entityId;
    } else {
      dayId = day.id;
    }
    final shift = LocalChange.insert('shift', {
      'business_day_id': dayId,
      'device_code': _ctx.ctx.deviceCode,
      'user_id': userId,
      'name': ?name,
      'opened_at': _nowIso(),
      'opening_float_minor': openingFloatMinor,
      'status': 'OPEN',
    });
    changes.add(shift);
    await _store.commit(changes, userId: userId);
    _onCommit?.call();
    return shift.entityId;
  }

  Future<void> cashMovement({
    required String userId,
    required String direction,
    required int amountMinor,
    required String reason,
  }) async {
    final shift = await openShift() ?? (throw StateError('Open a shift first.'));
    if (amountMinor <= 0) throw ArgumentError('Amount must be positive.');
    await _store.commit([
      LocalChange.insert('cash_movement', {
        'shift_id': shift.id,
        'direction': direction, // IN / OUT
        'amount_minor': amountMinor,
        'reason': reason,
        'user_id': userId,
      }),
    ], userId: userId);
    _onCommit?.call();
  }

  Future<ShiftSummary> summary(String shiftId) async {
    final shift = await _store.find('shift', shiftId);
    final payments = (await _store.all('payment')).where((p) => p.data['shift_id'] == shiftId);
    final movements = (await _store.all('cash_movement')).where((m) => m.data['shift_id'] == shiftId);
    final orderIds = {for (final p in payments) p.data['order_id']};
    var cashSales = 0, sales = 0;
    for (final p in payments) {
      final amt = (p.data['amount_minor'] as num).toInt();
      sales += amt;
      if (p.data['is_cash_like'] == true) cashSales += amt;
    }
    int sum(String dir) => movements
        .where((m) => m.data['direction'] == dir)
        .fold(0, (s, m) => s + (m.data['amount_minor'] as num).toInt());
    return ShiftSummary(
      openingFloatMinor: (shift?.data['opening_float_minor'] as num?)?.toInt() ?? 0,
      cashSalesMinor: cashSales,
      cashRefundsMinor: 0,
      cashInMinor: sum('IN'),
      cashOutMinor: sum('OUT'),
      orders: orderIds.length,
      salesMinor: sales,
    );
  }

  /// Blind count: the cashier enters [countedCashMinor]; difference is recorded, not hidden.
  Future<ShiftSummary> closeShift({required String userId, required int countedCashMinor, String? note}) async {
    final shift = await openShift() ?? (throw StateError('No open shift.'));
    final s = await summary(shift.id);
    await _store.commit([
      LocalChange.update('shift', shift.id, {
        'status': 'CLOSED',
        'closed_at': _nowIso(),
        'expected_cash_minor': s.expectedCashMinor,
        'counted_cash_minor': countedCashMinor,
        'difference_minor': countedCashMinor - s.expectedCashMinor,
        'close_note': ?note,
      }),
    ], userId: userId);
    _onCommit?.call();
    return s;
  }

  /// Day close (needs `day.close`): totals snapshot + business day CLOSED. All shifts on this
  /// terminal must be closed first; other terminals' shifts are the manager's call (C-11).
  Future<Map<String, dynamic>> closeDay({required String userId}) async {
    final day = await openDay() ?? (throw StateError('No open business day.'));
    if (await openShift() != null) throw StateError('Close the shift on this terminal first.');
    final orders = (await _store.all('orders')).where((o) => o.data['business_day_id'] == day.id).toList();
    final settled = orders.where((o) => o.data['status'] == 'SETTLED');
    // Payments of this day's orders only (other terminals' orders and payments are on this
    // terminal too, under their own business day).
    final orderIds = {for (final o in orders) o.id};
    final payments = (await _store.all('payment')).where((p) => orderIds.contains(p.data['order_id']));
    final byKind = <String, int>{};
    for (final p in payments) {
      byKind.update(
        p.data['method_kind'] as String,
        (v) => v + (p.data['amount_minor'] as num).toInt(),
        ifAbsent: () => (p.data['amount_minor'] as num).toInt(),
      );
    }
    int total(String f) => settled.fold(0, (s, o) => s + ((o.data[f] as num?)?.toInt() ?? 0));
    final totals = {
      'orders': settled.length,
      'voided_orders': orders.where((o) => o.data['status'] == 'VOIDED').length,
      'gross_minor': total('subtotal_minor'),
      'discount_minor': total('discount_minor'),
      'tax_minor': total('tax_minor'),
      'total_minor': total('total_minor'),
      'payments_by_kind': byKind,
      'closed_on_device': _ctx.ctx.deviceCode,
    };
    await _store.commit([
      LocalChange.insert('day_close', {
        'business_day_id': day.id,
        'closed_by': userId,
        'closed_at': _nowIso(),
        'totals': totals,
      }),
      LocalChange.update('business_day', day.id, {'status': 'CLOSED', 'closed_at': _nowIso(), 'closed_by': userId}),
    ], userId: userId);
    _onCommit?.call();
    return totals;
  }
}
