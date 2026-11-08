import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/terminal/terminal_context.dart';
import '../../catalogue/data/catalogue_repository.dart';
import '../../printing/data/printer_service.dart';
import '../../printing/domain/esc_pos.dart';
import '../../printing/domain/ticket_formatter.dart';
import '../../sales/data/home_repository.dart';
import '../../sales/domain/cart.dart';
import '../../sales/domain/checkout_service.dart';
import '../../sales/domain/order_manager.dart';
import '../../sales/domain/order_service.dart';
import '../../sales/presentation/widgets/home_dialogs.dart';
import '../../sales/presentation/widgets/payment_dialog.dart';
import '../../staff/data/staff_repository.dart';
import '../../terminal/terminal_cubit.dart';
import 'order_detail_cubit.dart';

/// Order Details: bill and the actions on it (settle, transfers, split, type change, edit, void,
/// coupon, print).
class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailCubit, OrderDetailState>(
      listenWhen: (a, b) => (b.error != null && a.error != b.error) || (b.info != null && a.info != b.info),
      listener: (context, s) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(s.error ?? s.info!))),
      builder: (context, s) => Scaffold(
        backgroundColor: HomeColors.page,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) => s.loading || s.detail == null
                ? const Center(child: CircularProgressIndicator())
                : c.maxWidth < 700
                ? _DetailBody(state: s, phone: true)
                : scaledForHome(
                    context,
                    Material(
                      color: HomeColors.page,
                      child: _DetailBody(state: s, phone: false),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.state, required this.phone});
  final OrderDetailState state;
  final bool phone;

  @override
  Widget build(BuildContext context) {
    final actions = _Actions(state: state);
    final bill = _Bill(state: state);
    return Column(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          height: 68,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 6,
                child: IconButton(
                  key: const Key('detailBack'),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 30),
                  onPressed: () => context.pop(),
                ),
              ),
              Text('Order Details', style: TextStyle(fontSize: phone ? 22 : 32)),
            ],
          ),
        ),
        Expanded(
          child: phone
              ? ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    SizedBox(height: 520, child: bill),
                    const SizedBox(height: 12),
                    actions,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 380, child: SingleChildScrollView(child: actions)),
                    const SizedBox(width: 36),
                    SizedBox(width: 640, child: bill),
                  ],
                ),
        ),
      ],
    );
  }
}

// ---- left: actions ------------------------------------------------------------------------------

class _Actions extends StatelessWidget {
  const _Actions({required this.state});
  final OrderDetailState state;

  OrderDetailCubit _cubit(BuildContext c) => c.read<OrderDetailCubit>();
  StaffUser get _user => sl<StaffSession>().user;
  TerminalContext get _t => sl<TerminalContextHolder>().ctx;

  void _toast(BuildContext c, String m) => ScaffoldMessenger.of(c)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(m)));

  bool _can(BuildContext c, String permission, String what) {
    if (_user.can(permission)) return true;
    _toast(c, '${_user.name} may not $what (needs $permission).');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final d = state.detail!;
    final open = d.summary.ongoing;
    final dine = d.summary.channel == Channel.dineIn;
    Widget btn(String key, String label, VoidCallback onTap, {IconData? icon}) => Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: SizedBox(
        height: 70,
        child: OutlinedButton(
          key: Key(key),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: HomeColors.navy, width: 1.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          onPressed: state.busy ? null : onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(fontSize: 22, color: HomeColors.navy)),
              if (icon != null) ...[const SizedBox(width: 24), Icon(icon, color: HomeColors.navy, size: 32)],
            ],
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (open && !_t.isCaptain) ...[_settleMenu(context), const SizedBox(height: 22)],
          if (open && dine) btn('tableTransfer', 'Table Transfer', () => _tableTransfer(context)),
          if (open) btn('itemTransfer', 'Item Transfer', () => _itemTransfer(context)),
          if (open) btn('billSplit', 'Bill Split', () => _split(context)),
          if (open) btn('billType', 'Bill Type Change', () => _typeChange(context)),
          if (open) btn('editOrder', 'Edit Order', () => _edit(context)),
          if (open) btn('voidBill', 'Void Bill', () => _void(context)),
          btn('detailHome', 'Home', () => context.go(Routes.sell)),
          if (open) btn('applyCoupon', 'Apply Coupon', () => _coupon(context)),
          btn('printBill', 'Print Bill', () => _printBill(context), icon: Icons.print),
          btn('printKot', 'Print KOT', () => _printKot(context), icon: Icons.print),
        ],
      ),
    );
  }

  // ---- settle -----------------------------------------------------------------------------------

  Widget _settleMenu(BuildContext context) => PopupMenuButton<PaymentMethod?>(
    key: const Key('settle'),
    enabled: !state.busy,
    position: PopupMenuPosition.under,
    onSelected: (m) => _settle(context, m),
    itemBuilder: (_) => [
      for (final m in state.methods.where((m) => m.kind != 'CREDIT'))
        PopupMenuItem(
          key: Key('settle-${m.kind}'),
          value: m,
          height: 56,
          child: Text('Settle by ${m.name}', style: const TextStyle(fontSize: 22)),
        ),
      const PopupMenuItem(
        key: Key('settle-split'),
        value: null,
        height: 56,
        child: Text('Split payment…', style: TextStyle(fontSize: 22)),
      ),
    ],
    child: Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: HomeColors.navy, width: 3),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text('Settle', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Icon(Icons.arrow_drop_down, size: 34),
        ],
      ),
    ),
  );

  Future<void> _settle(BuildContext context, PaymentMethod? method) async {
    if (!_can(context, 'payment.take', 'take payments')) return;
    final d = state.detail!;
    final priced = d.priced;
    if (priced == null) return;
    var tenders = <({PaymentMethod method, int? amountMinor})>[];
    int? cashGiven;
    if (method == null) {
      final r = await showPaymentDialog(
        context,
        t: _t,
        priced: priced,
        methods: state.methods,
        roundingIncrement: state.settings.cashRoundingIncrementMinor,
      );
      if (r == null) return;
      tenders = r.tenders;
      cashGiven = r.cashTendered;
    } else {
      tenders = [(method: method, amountMinor: method.cashLike ? null : priced.totalMinor)];
    }
    if (!context.mounted) return;
    final cubit = _cubit(context);
    CompletedSale? sale;
    final ok = await cubit.run(() async {
      return sale = await cubit.checkout.settleOrder(
        orderId: d.summary.id,
        settings: state.settings,
        tenders: tenders,
        userId: _user.id,
        cashierName: _user.name,
        cashTenderedMinor: cashGiven,
      );
    });
    if (!ok || sale == null || !context.mounted) return;
    context.read<TerminalCubit>().refreshPending();
    final s = sale!;
    final cfg = await sl<PrinterService>().settings();
    String? printError;
    if (cfg.receiptHost != null) {
      try {
        await sl<PrinterService>().send(
          cfg.receiptHost!,
          cfg.port,
          TicketFormatter(_t, width: cfg.width)
              .receipt(
                s,
                header: state.settings.receiptHeader,
                footer: state.settings.receiptFooter,
                openDrawer: cfg.drawer && s.settlement.tenders.any((x) => x.tender.cashLike),
              )
              .bytes,
        );
      } on Object {
        printError = 'Receipt printer not reachable';
      }
    }
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => scaledForHome(
        ctx,
        AlertDialog(
          title: Text('Paid · ${s.orderNo}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_t.currency} ${_t.money(s.priced.totalMinor + s.settlement.roundingMinor)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (s.changeDueMinor > 0)
                Text('Change: ${_t.money(s.changeDueMinor)}', style: const TextStyle(fontSize: 22)),
              if (printError != null) Text(printError, style: const TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            FilledButton(key: const Key('settledOk'), onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
          ],
        ),
      ),
    );
    if (context.mounted) context.pop();
  }

  // ---- transfers ------------------------------------------------------------------------------------

  Future<void> _tableTransfer(BuildContext context) async {
    if (!_can(context, 'order.transfer', 'transfer orders')) return;
    final home = sl<HomeRepository>();
    final tables = await home.tables();
    final open = await sl<OrderService>().openOrders();
    if (!context.mounted) return;
    final choice = await showChooseTable(context, tables: tables, openOrders: open);
    if (choice == null || !context.mounted) return;
    if (choice.running != null) {
      return _toast(context, 'Table ${choice.table.name} is occupied. Use Merge on the dashboard.');
    }
    await _cubit(context).run(
      () => _cubit(context).orders.transferTable(
        orderId: state.detail!.summary.id,
        tableId: choice.table.id,
        guests: choice.guests,
        userId: _user.id,
      ),
      done: 'Moved to table ${choice.table.name}',
    );
  }

  Future<Set<String>?> _pickLines(BuildContext context, String title, {Widget? extra}) {
    final selected = <String>{};
    return showDialog<Set<String>>(
      context: context,
      builder: (ctx) => scaledForHome(
        ctx,
        StatefulBuilder(
          builder: (ctx, set) => AlertDialog(
            backgroundColor: HomeColors.dialog,
            title: Text(title),
            content: SizedBox(
              width: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ?extra,
                  for (final l in state.detail!.lines)
                    CheckboxListTile(
                      key: Key('pick-${l.id}'),
                      value: selected.contains(l.id),
                      activeColor: HomeColors.navy,
                      onChanged: (v) => set(() => v == true ? selected.add(l.id) : selected.remove(l.id)),
                      title: Text('${l.name}  ×${_qty(l.qtyMilli)}'),
                      secondary: Text(_t.money(l.lineTotalMinor)),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              FilledButton(
                key: const Key('pickOk'),
                onPressed: selected.isEmpty ? null : () => Navigator.pop(ctx, selected),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _itemTransfer(BuildContext context) async {
    if (!_can(context, 'order.transfer', 'transfer items')) return;
    final d = state.detail!;
    final targets = (await _cubit(context).orders.summaries()).where((o) => o.ongoing && o.id != d.summary.id).toList();
    if (!context.mounted) return;
    if (targets.isEmpty) return _toast(context, 'No other running order to move items to.');
    OrderSummary? target = targets.first;
    final lines = await _pickLines(
      context,
      'Item Transfer',
      extra: StatefulBuilder(
        builder: (ctx, set) => DropdownButtonFormField<OrderSummary>(
          key: const Key('transferTarget'),
          initialValue: target,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Move to order'),
          items: [for (final o in targets) DropdownMenuItem(value: o, child: Text('${o.orderNo} · ${o.where}'))],
          onChanged: (v) => set(() => target = v),
        ),
      ),
    );
    if (lines == null || target == null || !context.mounted) return;
    await _cubit(context).run(
      () => _cubit(context).orders.transferItems(
        fromId: d.summary.id,
        lineIds: lines,
        toId: target!.id,
        settings: state.settings,
        userId: _user.id,
      ),
      done: 'Items moved to ${target!.orderNo}',
    );
  }

  Future<void> _split(BuildContext context) async {
    final lines = await _pickLines(context, 'Bill Split: items for the new bill');
    if (lines == null || !context.mounted) return;
    final cubit = _cubit(context);
    String? no;
    await cubit.run(
      () async => no = await cubit.orders.split(
        orderId: state.detail!.summary.id,
        lineIds: lines,
        settings: state.settings,
        userId: _user.id,
      ),
    );
    if (no != null && context.mounted) _toast(context, 'New bill $no created');
  }

  Future<void> _typeChange(BuildContext context) async {
    final d = state.detail!;
    final type = await showDialog<String>(
      context: context,
      builder: (ctx) => scaledForHome(
        ctx,
        SimpleDialog(
          backgroundColor: HomeColors.dialog,
          title: const Text('Bill Type Change'),
          children: [
            for (final (v, label) in [
              (Channel.dineIn, 'Dine In'),
              (Channel.takeaway, 'Take Away'),
              (Channel.homeDelivery, 'Home Delivery'),
            ])
              if (v != d.summary.orderType || d.summary.isPartner)
                SimpleDialogOption(
                  key: Key('type-$v'),
                  onPressed: () => Navigator.pop(ctx, v),
                  child: Text(label, style: const TextStyle(fontSize: 20)),
                ),
          ],
        ),
      ),
    );
    if (type == null || !context.mounted) return;
    String? tableId;
    int? guests;
    if (type == Channel.dineIn) {
      final tables = await sl<HomeRepository>().tables();
      final open = await sl<OrderService>().openOrders();
      if (!context.mounted) return;
      final choice = await showChooseTable(context, tables: tables, openOrders: open);
      if (choice == null || !context.mounted) return;
      if (choice.running != null) return _toast(context, 'Table ${choice.table.name} is occupied.');
      tableId = choice.table.id;
      guests = choice.guests;
    }
    await _cubit(context).run(
      () => _cubit(context).orders.changeType(
        orderId: d.summary.id,
        orderType: type,
        tableId: tableId,
        guests: guests,
        settings: state.settings,
        userId: _user.id,
      ),
      done: 'Bill type changed',
    );
  }

  // ---- edit / void / coupon -------------------------------------------------------------------------

  Future<void> _edit(BuildContext context) async {
    final d = state.detail!;
    final qty = {for (final l in d.lines) l.id: l.qtyMilli ~/ 1000};
    final result = await showDialog<Object>(
      context: context,
      builder: (ctx) => scaledForHome(
        ctx,
        StatefulBuilder(
          builder: (ctx, set) => AlertDialog(
            backgroundColor: HomeColors.dialog,
            title: const Text('Edit Order'),
            content: SizedBox(
              width: 560,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final l in d.lines)
                    ListTile(
                      title: Text(l.name, style: const TextStyle(fontSize: 18)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            key: Key('editMinus-${l.id}'),
                            onPressed: qty[l.id]! > 0 ? () => set(() => qty[l.id] = qty[l.id]! - 1) : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          SizedBox(
                            width: 36,
                            child: Text(
                              '${qty[l.id]}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: qty[l.id] == 0 ? Colors.red : null,
                                decoration: qty[l.id] == 0 ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: qty[l.id]! < l.qtyMilli ~/ 1000
                                ? () => set(() => qty[l.id] = qty[l.id]! + 1)
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Lower quantities here. To add items use Add Items.',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                key: const Key('addItems'),
                onPressed: () => Navigator.pop(ctx, 'add'),
                child: const Text('Add Items'),
              ),
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              FilledButton(
                key: const Key('editSave'),
                onPressed: () => Navigator.pop(ctx, Map<String, int>.from(qty)),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
    if (result == null || !context.mounted) return;
    if (result == 'add') {
      sl<OrderManager>().homeIntent = Cart(
        orderType: d.cart.orderType,
        tableId: d.cart.tableId,
        tableName: d.summary.tableName,
        guests: d.cart.guests,
        existingOrderId: d.summary.id,
        existingOrderNo: d.summary.orderNo,
        captainId: d.cart.captainId,
        captainName: d.summary.captainName,
        deliveryPartnerId: d.cart.deliveryPartnerId,
        deliveryPartnerName: d.summary.partnerName,
      );
      context.go(Routes.sell);
      return;
    }
    final newQty = {for (final e in (result as Map<String, int>).entries) e.key: e.value * 1000};
    final reduced = d.lines.any((l) => newQty[l.id]! < l.qtyMilli);
    if (!reduced) return;
    if (!_can(context, 'order.reduce_qty_after_kot', 'reduce items already sent to the kitchen')) return;
    await _cubit(context).run(
      () =>
          _cubit(context).orders.reduce(orderId: d.summary.id, qty: newQty, settings: state.settings, userId: _user.id),
      done: 'Order updated · cancel KOT sent',
    );
  }

  Future<void> _void(BuildContext context) async {
    if (!_can(context, 'order.void', 'void bills')) return;
    final reasonCtl = TextEditingController();
    String? reason;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => scaledForHome(
        ctx,
        StatefulBuilder(
          builder: (ctx, set) => AlertDialog(
            backgroundColor: HomeColors.dialog,
            title: Text('Void ${state.detail!.summary.orderNo}?'),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final r in ['Cancelled by customer', 'Wrong order', 'Duplicate bill'])
                        ChoiceChip(
                          key: Key('reason-$r'),
                          label: Text(r),
                          selected: reason == r,
                          onSelected: (_) => set(() {
                            reason = r;
                            reasonCtl.text = r;
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reasonCtl,
                    onChanged: (v) => set(() => reason = v),
                    decoration: const InputDecoration(labelText: 'Reason*', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  const Text('This cannot be undone.', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              FilledButton(
                key: const Key('voidConfirm'),
                style: FilledButton.styleFrom(backgroundColor: HomeColors.red),
                onPressed: (reason ?? '').trim().isEmpty ? null : () => Navigator.pop(ctx, true),
                child: const Text('Void Bill'),
              ),
            ],
          ),
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    final done = await _cubit(context).run(
      () =>
          _cubit(context).orders
              .voidOrder(orderId: state.detail!.summary.id, reason: reasonCtl.text.trim(), userId: _user.id),
      done: 'Bill voided',
    );
    if (done && context.mounted) context.pop();
  }

  Future<void> _coupon(BuildContext context) async {
    final code = TextEditingController();
    final pct = TextEditingController();
    final r = await showDialog<(String, String)>(
      context: context,
      builder: (ctx) => scaledForHome(
        ctx,
        AlertDialog(
          backgroundColor: HomeColors.dialog,
          title: const Text('Apply Coupon'),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  key: const Key('couponCode'),
                  controller: code,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: 'Coupon code', border: OutlineInputBorder()),
                ),
                const Padding(padding: EdgeInsets.all(10), child: Text('or')),
                TextField(
                  key: const Key('couponPercent'),
                  controller: pct,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Discount %', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              key: const Key('couponApply'),
              onPressed: () => Navigator.pop(ctx, (code.text, pct.text)),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
    if (r == null || !context.mounted) return;
    final cubit = _cubit(context);
    int? bp;
    if (r.$1.trim().isNotEmpty) {
      bp = await cubit.orders.couponBp(r.$1);
      if (bp == null) {
        if (context.mounted) _toast(context, 'Coupon ${r.$1.trim().toUpperCase()} not found.');
        return;
      }
    } else {
      if (!_can(context, 'discount.apply', 'give discounts')) return;
      final v = double.tryParse(r.$2.trim());
      if (v == null || v < 0 || v > 100) {
        if (context.mounted) _toast(context, 'Enter a coupon code or 0 to 100 %.');
        return;
      }
      bp = (v * 100).round();
      if (bp > _user.maxDiscountBp) {
        if (context.mounted) _toast(context, 'Your limit is ${(_user.maxDiscountBp / 100).toStringAsFixed(0)}%.');
        return;
      }
    }
    if (!context.mounted) return;
    await cubit.run(
      () => cubit.orders.applyDiscount(
        orderId: state.detail!.summary.id,
        bp: bp!,
        settings: state.settings,
        userId: _user.id,
      ),
      done: 'Discount ${(bp / 100).toStringAsFixed(bp % 100 == 0 ? 0 : 2)}% applied',
    );
  }

  // ---- printing --------------------------------------------------------------------------------------

  Future<void> _printBill(BuildContext context) async {
    final d = state.detail!;
    if (d.priced == null) return;
    final cfg = await sl<PrinterService>().settings();
    final ticket = TicketFormatter(_t, width: cfg.width).bill(
      orderNo: d.summary.orderNo,
      tokenNo: d.summary.tokenNo,
      cart: d.cart,
      priced: d.priced!,
      header: state.settings.receiptHeader,
      footer: state.settings.receiptFooter,
    );
    if (!context.mounted) return;
    await _send(context, cfg.receiptHost, cfg.port, ticket, 'Bill');
    if (d.summary.status == 'OPEN' && context.mounted) {
      await _cubit(context).run(() => _cubit(context).orders.markBilled(d.summary.id, _user.id));
    }
  }

  Future<void> _printKot(BuildContext context) async {
    final d = state.detail!;
    final cfg = await sl<PrinterService>().settings();
    final ticket = TicketFormatter(
      _t,
      width: cfg.width,
    ).kotTicket(tokenNo: d.summary.tokenNo, orderNo: d.summary.orderNo, cart: d.cart, lines: d.cart.lines);
    if (context.mounted) await _send(context, cfg.kitchenHost, cfg.port, ticket, 'KOT');
  }

  /// Sends to the printer, or shows the ticket on screen when no printer is set up.
  Future<void> _send(BuildContext context, String? host, int port, EscPos ticket, String what) async {
    if (host != null) {
      try {
        await sl<PrinterService>().send(host, port, ticket.bytes);
        if (context.mounted) _toast(context, '$what sent to the printer');
        return;
      } on Object {
        if (context.mounted) _toast(context, '$what printer not reachable — showing it on screen');
      }
    }
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => scaledForHome(
        ctx,
        AlertDialog(
          title: Text('$what preview${host == null ? ' (no printer set up)' : ''}'),
          content: SingleChildScrollView(
            child: Text(ticket.preview, style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
        ),
      ),
    );
  }

  static String _qty(int milli) => milli % 1000 == 0 ? '${milli ~/ 1000}' : (milli / 1000).toStringAsFixed(3);
}

// ---- right: bill -------------------------------------------------------------------------------------

class _Bill extends StatelessWidget {
  const _Bill({required this.state});
  final OrderDetailState state;

  @override
  Widget build(BuildContext context) {
    final t = sl<TerminalContextHolder>().ctx;
    final d = state.detail!;
    final o = d.summary;
    final priced = d.priced;
    final at = o.openedAt;
    final type = switch (o.channel) {
      Channel.dineIn => 'Dine in${o.tableName != null ? ' · Table ${o.tableName}' : ''}',
      Channel.takeaway => 'Take away',
      Channel.homeDelivery => 'Home delivery${o.customerName != null ? ' · ${o.customerName}' : ''}',
      _ => 'Delivery partner · ${o.partnerName}',
    };
    final vat = d.cart.lines.isEmpty ? 0 : d.cart.lines.first.taxRateBp;
    final inclusive = d.cart.lines.isEmpty || d.cart.lines.first.priceIncludesTax;
    const big = TextStyle(fontSize: 26);
    Widget sum(String a, String b, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(a, style: bold ? big.copyWith(fontWeight: FontWeight.bold, fontSize: 28) : big),
          ),
          Text(b, style: bold ? big.copyWith(fontWeight: FontWeight.bold, fontSize: 28) : big),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bill No :  #${o.orderNo}', style: const TextStyle(fontSize: 20)),
                    Text('Bill Type: $type', style: const TextStyle(fontSize: 20)),
                    Text(
                      'Date & Time : ${at == null ? '' : '${at.year}-${_two(at.month)}-${_two(at.day)} / ${_two(at.hour)}:${_two(at.minute)}:${_two(at.second)}'}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    if (o.status != 'OPEN')
                      Text(
                        'Status: ${o.state == 'ongoing' ? 'Billed' : o.state}${o.voidReason != null ? ' · ${o.voidReason}' : ''}',
                        style: const TextStyle(fontSize: 20, color: Colors.deepOrange),
                      ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('toggleDetails'),
                onPressed: context.read<OrderDetailCubit>().toggleDetails,
                icon: Icon(state.showDetails ? Icons.visibility : Icons.visibility_off, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(color: HomeColors.navy, borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text('items(${d.lines.length})', style: const TextStyle(color: Colors.white, fontSize: 19)),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Price (${t.currency})',
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final l in d.lines)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.name, style: const TextStyle(fontSize: 22)),
                              if (state.showDetails)
                                Text(t.money(l.unitPriceMinor), style: const TextStyle(fontSize: 20)),
                              if (state.showDetails && l.note != null)
                                Text('* ${l.note}', style: const TextStyle(color: Colors.deepOrange)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            l.qtyMilli % 1000 == 0 ? '${l.qtyMilli ~/ 1000}' : (l.qtyMilli / 1000).toStringAsFixed(3),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            t.money(l.lineTotalMinor),
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
            decoration: BoxDecoration(
              color: HomeColors.page,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                sum('Subtotal', t.money(priced?.subtotalMinor ?? o.totalMinor)),
                Divider(color: Colors.grey.shade400, height: 22),
                if ((priced?.discountMinor ?? 0) > 0) sum('Discount', '-${t.money(priced!.discountMinor)}'),
                if ((priced?.chargeMinor ?? 0) > 0) sum('Service charge', t.money(priced!.chargeMinor)),
                sum('Subtotal before VAT', t.money((priced?.totalMinor ?? 0) - (priced?.taxMinor ?? 0))),
                sum(
                  'VAT ${inclusive ? 'inclusive' : 'exclusive'} (${(vat / 100).toStringAsFixed(vat % 100 == 0 ? 0 : 2)}%)',
                  t.money(priced?.taxMinor ?? 0),
                ),
                const Divider(),
                sum('Net Total', '${t.currency} ${t.money(priced?.totalMinor ?? o.totalMinor)}', bold: true),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}
