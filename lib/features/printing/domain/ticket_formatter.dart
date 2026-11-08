import '../../../core/terminal/terminal_context.dart';
import '../../sales/domain/checkout_service.dart';
import 'esc_pos.dart';

/// Customer receipt and kitchen ticket (KOT) layouts.
class TicketFormatter {
  const TicketFormatter(this.ctx, {this.width = 48});

  final TerminalContext ctx;
  final int width;

  String _qty(int milli) => milli % 1000 == 0 ? '${milli ~/ 1000}' : (milli / 1000).toStringAsFixed(3);

  EscPos receipt(CompletedSale s, {String header = '', String footer = '', bool openDrawer = false}) {
    final p = EscPos(width: width)
      ..align('center')
      ..bold(true)
      ..big(true)
      ..text(ctx.storeName)
      ..big(false)
      ..bold(false);
    for (final h in header.split('\n').where((l) => l.trim().isNotEmpty)) {
      p.text(h);
    }
    final local = ctx.localNow(s.settledAt);
    p
      ..text('Bill ${s.orderNo}   Token ${s.tokenNo}')
      ..text(
        '${s.businessDate}  ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}'
        '  ${s.cart.orderType.replaceAll('_', ' ')}',
      )
      ..text('Cashier: ${s.cashierName}')
      ..align('left')
      ..line();
    for (var i = 0; i < s.cart.lines.length; i++) {
      final l = s.cart.lines[i];
      p
        ..text(l.name)
        ..row('  ${_qty(l.qtyMilli)} x ${ctx.money(l.unitPriceMinor)}', ctx.money(s.priced.lines[i].gross));
    }
    p
      ..line()
      ..row('Subtotal', ctx.money(s.priced.subtotalMinor));
    if (s.priced.discountMinor > 0) p.row('Discount', '-${ctx.money(s.priced.discountMinor)}');
    for (final c in s.priced.charges) {
      p.row(c.code == 'SERVICE' ? 'Service charge' : c.code, ctx.money(c.net + c.tax));
    }
    p.row('VAT', ctx.money(s.priced.taxMinor));
    if (s.settlement.roundingMinor != 0) p.row('Rounding', ctx.money(s.settlement.roundingMinor));
    p
      ..bold(true)
      ..row('TOTAL ${ctx.currency}', ctx.money(s.priced.totalMinor + s.settlement.roundingMinor))
      ..bold(false);
    for (final t in s.settlement.tenders) {
      p.row(t.tender.kind, ctx.money(t.amountMinor));
    }
    if (s.changeDueMinor > 0) p.row('Change', ctx.money(s.changeDueMinor));
    p
      ..line()
      ..align('center');
    for (final f in footer.split('\n').where((l) => l.trim().isNotEmpty)) {
      p.text(f);
    }
    p
      ..text('Thank you')
      ..feed(3)
      ..cut();
    if (openDrawer) p.openDrawer();
    return p;
  }

  EscPos kot(CompletedSale s) {
    final p = EscPos(width: width)
      ..align('center')
      ..bold(true)
      ..big(true)
      ..text('KOT ${s.tokenNo}')
      ..big(false)
      ..text(s.cart.orderType.replaceAll('_', ' ') + (s.cart.tableName != null ? '  Table ${s.cart.tableName}' : ''))
      ..bold(false)
      ..text('Bill ${s.orderNo}  ${ctx.deviceCode}')
      ..align('left')
      ..line();
    for (final l in s.cart.lines) {
      p
        ..bold(true)
        ..text('${_qty(l.qtyMilli)}  x  ${l.name}')
        ..bold(false);
      if (l.note != null && l.note!.isNotEmpty) p.text('     * ${l.note}');
    }
    return p
      ..line()
      ..feed(3)
      ..cut();
  }
}
