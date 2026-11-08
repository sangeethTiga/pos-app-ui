import '../../../core/sync/local_store.dart';
import '../../../core/terminal/terminal_context.dart';
import '../../sales/domain/cart.dart';
import '../../sales/domain/checkout_service.dart';
import '../../sales/domain/order_service.dart';
import '../../sales/domain/pricing_engine.dart';
import '../domain/esc_pos.dart';
import '../domain/printer_device.dart';
import '../domain/ticket_formatter.dart';
import 'printer_service.dart';
import 'printer_transport.dart';

enum PrintStatus { printed, queued, skipped, noPrinter, failed }

/// What happened to a print request; [tickets] lets the screen show the ticket when nothing printed.
class PrintOutcome {
  const PrintOutcome(this.status, {this.tickets = const [], this.error});
  final PrintStatus status;
  final List<EscPos> tickets;
  final String? error;

  bool get ok => status == PrintStatus.printed || status == PrintStatus.queued || status == PrintStatus.skipped;

  /// Short line for a snackbar, null when it printed.
  String? message(String what) => switch (status) {
    PrintStatus.printed || PrintStatus.skipped => null,
    PrintStatus.queued => '$what printer not reachable — kept in the print queue',
    PrintStatus.noPrinter => 'No $what printer set up (Settings > Printer Settings)',
    PrintStatus.failed => '$what printer not reachable${error != null ? ': $error' : ''}',
  };

  static PrintOutcome merge(List<PrintOutcome> all) {
    if (all.isEmpty) return const PrintOutcome(PrintStatus.skipped);
    final worst = all.map((o) => o.status).reduce((a, b) => a.index >= b.index ? a : b);
    return PrintOutcome(
      worst,
      tickets: [for (final o in all) ...o.tickets],
      error: all.map((o) => o.error).whereType<String>().firstOrNull,
    );
  }
}

/// Kitchen station shown in Printer Settings.
class StationInfo {
  const StationInfo(this.id, this.name);
  final String id, name;
}

/// What to print where: KOTs to the kitchen station printers, bills and receipts (with the copies
/// set per order type) to the kiosk printer, drawer kicks.
class PrintCenter {
  PrintCenter(this._printer, this._store, this._ctx);

  final PrinterService _printer;
  final LocalStore _store;
  final TerminalContextHolder _ctx;

  TicketFormatter _f(PrinterSettings s) => TicketFormatter(_ctx.ctx, width: s.width);

  Future<List<StationInfo>> stations() async {
    final list = [
      for (final r in await _store.all('kitchen_station'))
        if (r.data['active'] != false) StationInfo(r.id, r.data['name'] as String? ?? 'Kitchen'),
    ];
    return list..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Name of this terminal's kiosk ("U Kiosk"), null when the terminal has none.
  Future<String?> kioskName() async {
    final id = _ctx.ctx.kioskId;
    if (id == null) return null;
    return (await _store.find('kiosk', id))?.data['name'] as String?;
  }

  Future<PrintOutcome> _send(PrinterDevice? device, EscPos ticket, String label, {int copies = 1}) async {
    if (copies <= 0) return const PrintOutcome(PrintStatus.skipped);
    if (device == null) return PrintOutcome(PrintStatus.noPrinter, tickets: [ticket]);
    try {
      final r = await _printer.print(device, ticket, label: label, copies: copies);
      return PrintOutcome(r == SendResult.printed ? PrintStatus.printed : PrintStatus.queued, tickets: [ticket]);
    } on PrinterException catch (e) {
      return PrintOutcome(PrintStatus.failed, tickets: [ticket], error: e.message);
    } on Object catch (e) {
      return PrintOutcome(PrintStatus.failed, tickets: [ticket], error: '$e');
    }
  }

  /// Kitchen station of each product: the product's own, else its category's.
  Future<Map<String, String>> _productStations() async {
    final categories = {
      for (final c in await _store.all('category'))
        if (c.data['kitchen_station_id'] is String) c.id: c.data['kitchen_station_id'] as String,
    };
    return {
      for (final p in await _store.all('product'))
        p.id: ?((p.data['kitchen_station_id'] as String?) ?? categories[p.data['category_id']]),
    };
  }

  /// KOT lines split by kitchen station, each part to that station's printer.
  Future<PrintOutcome> kotLines({
    required String tokenNo,
    required String orderNo,
    required Cart cart,
    required List<CartLine> lines,
    String kind = 'NEW',
  }) async {
    if (lines.isEmpty) return const PrintOutcome(PrintStatus.skipped);
    final s = await _printer.settings();
    final stationOf = await _productStations();
    final names = {for (final st in await stations()) st.id: st.name};
    final groups = <String?, List<CartLine>>{};
    for (final l in lines) {
      final st = l.kitchenStationId ?? stationOf[l.productId];
      groups.putIfAbsent(names.containsKey(st) ? st : null, () => []).add(l);
    }
    return PrintOutcome.merge([
      for (final MapEntry(key: st, value: part) in groups.entries)
        await _send(
          s.kotFor(st),
          _f(s).kotTicket(
            tokenNo: tokenNo,
            orderNo: orderNo,
            cart: cart,
            lines: part,
            kind: kind,
            station: groups.length > 1 ? names[st] : null,
          ),
          'KOT $orderNo',
        ),
    ]);
  }

  /// KOT for a placed order; for an updated order an ADD-ON for added items and a CANCEL for removed.
  Future<PrintOutcome> kot(PlacedOrder p) async => PrintOutcome.merge([
    await kotLines(
      tokenNo: p.tokenNo,
      orderNo: p.orderNo,
      cart: p.cart,
      lines: p.newLines,
      kind: p.kind == 'UPDATE' ? 'NEW_ITEMS' : 'NEW',
    ),
    await kotLines(tokenNo: p.tokenNo, orderNo: p.orderNo, cart: p.cart, lines: p.cancelledLines, kind: 'CANCEL'),
  ]);

  /// Guest bill of a running order (one copy).
  Future<PrintOutcome> bill({
    required String orderNo,
    required String tokenNo,
    required Cart cart,
    required PricedOrder priced,
    String header = '',
    String footer = '',
  }) async {
    final s = await _printer.settings();
    final ticket = _f(s)
        .bill(orderNo: orderNo, tokenNo: tokenNo, cart: cart, priced: priced, header: header, footer: footer);
    return _send(s.bill, ticket, 'Bill $orderNo');
  }

  /// Receipt after payment: the copies set for the order type; the drawer opens on cash even when
  /// the order type prints no copy.
  Future<PrintOutcome> receipt(CompletedSale sale, {String header = '', String footer = ''}) async {
    final s = await _printer.settings();
    final cash = s.drawer && sale.settlement.tenders.any((x) => x.tender.cashLike);
    final copies = s.copiesFor(sale.cart.channel);
    if (copies == 0) return cash && s.bill != null ? openDrawer() : const PrintOutcome(PrintStatus.skipped);
    final first = _f(s).receipt(sale, header: header, footer: footer, openDrawer: cash);
    final out = [await _send(s.bill, first, 'Receipt ${sale.orderNo}')];
    if (copies > 1) {
      out.add(
        await _send(
          s.bill,
          _f(s).receipt(sale, header: header, footer: footer),
          'Receipt ${sale.orderNo}',
          copies: copies - 1,
        ),
      );
    }
    return PrintOutcome.merge(out);
  }

  /// OPEN DRAWER: kick the cash drawer on the bill printer.
  Future<PrintOutcome> openDrawer() async {
    final s = await _printer.settings();
    if (s.bill == null) return const PrintOutcome(PrintStatus.noPrinter);
    try {
      await _printer.sendRaw(s.bill!, (EscPos()..openDrawer()).bytes);
      return const PrintOutcome(PrintStatus.printed);
    } on Object catch (e) {
      return PrintOutcome(PrintStatus.failed, error: e is PrinterException ? e.message : '$e');
    }
  }

  /// Print test ticket on [device] (style from the settings, no queue).
  Future<void> test(PrinterDevice device) async {
    final s = await _printer.settings();
    await _printer.sendRaw(device, await _printer.render(_f(s).test(device.name), s));
  }
}
