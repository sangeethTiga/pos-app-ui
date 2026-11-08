import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/terminal/terminal_context.dart';
import '../../catalogue/data/catalogue_repository.dart';
import '../../printing/data/print_center.dart';
import '../../sales/data/home_repository.dart';
import '../../sales/domain/cart.dart';
import '../../sales/domain/checkout_service.dart';
import '../../sales/domain/order_manager.dart';
import '../../sales/domain/order_service.dart';
import '../../sales/presentation/widgets/home_dialogs.dart' show HomeColors, showChooseTable;
import '../../sales/presentation/widgets/payment_dialog.dart';
import '../../staff/data/staff_repository.dart';
import '../../terminal/terminal_cubit.dart';
import 'order_detail_cubit.dart';

/// Order Details: bill and the actions on it (settle, transfers, split, type change, edit, void,
/// coupon, print).
///
/// From [Breakpoints.splitPane] up the actions are a scrolling column beside the bill; below it the
/// bill comes first and the actions follow as a grid of buttons, all in one scroll view.
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
          child: s.loading || s.detail == null
              ? const Center(child: CircularProgressIndicator())
              : ResponsiveBuilder(
                  builder: (context, r) => _DetailBody(state: s, r: r),
                ),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.state, required this.r});
  final OrderDetailState state;
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    final g = r.gutter;
    final back = IconButton(
      key: const Key('detailBack'),
      iconSize: r.f(30),
      constraints: BoxConstraints(minWidth: r.minTap, minHeight: r.minTap),
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () => context.pop(),
    );
    return Column(
      children: [
        Container(
          color: Colors.white,
          constraints: BoxConstraints(minHeight: r.tap(68)),
          padding: EdgeInsets.symmetric(horizontal: r.s(6)),
          child: Row(
            children: [
              back,
              Expanded(
                child: Text(
                  'Order Details',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: r.f(32)),
                ),
              ),
              SizedBox(width: r.minTap),
            ],
          ),
        ),
        Expanded(
          child: r.splitPane
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: g),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: r.s(380),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: g),
                          child: _Actions(state: state, r: r, grid: false),
                        ),
                      ),
                      SizedBox(width: r.s(36)),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: r.s(1100)),
                          child: LayoutBuilder(
                            builder: (context, c) {
                              final ts = MediaQuery.textScalerOf(context);
                              // Enough height for the fixed parts plus a few item rows: the item
                              // list scrolls by itself; otherwise the whole bill scrolls.
                              final fill = c.maxHeight >= r.s(320) + ts.scale(r.s(340));
                              return fill
                                  ? _Bill(state: state, r: r, fill: true)
                                  : SingleChildScrollView(
                                      child: _Bill(state: state, r: r, fill: false),
                                    );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(g, 0, g, g),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Bill(state: state, r: r, fill: false),
                      SizedBox(height: r.s(16)),
                      _Actions(state: state, r: r, grid: true),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

// ---- actions ------------------------------------------------------------------------------------

class _Actions extends StatelessWidget {
  const _Actions({required this.state, required this.r, required this.grid});
  final OrderDetailState state;
  final Responsive r;

  /// A grid of buttons as wide as the screen (narrow layout); otherwise a single column.
  final bool grid;

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
    Widget btn(String key, String label, VoidCallback onTap, {IconData? icon}) => OutlinedButton(
      key: Key(key),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(0, r.tap(70)),
        padding: EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(6)),
        side: const BorderSide(color: HomeColors.navy, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: state.busy ? null : onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: r.f(22), color: HomeColors.navy),
            ),
          ),
          if (icon != null) ...[SizedBox(width: r.s(24)), Icon(icon, color: HomeColors.navy, size: r.f(32))],
        ],
      ),
    );
    final buttons = [
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
    ];
    final gap = r.s(grid ? 14 : 18);
    final Widget list;
    if (grid) {
      final width = r.width - 2 * r.gutter;
      final cols = r.columns(width + gap, minTileWidth: 220, min: 2, max: 4);
      final tile = ((width - gap * (cols - 1)) / cols).floorToDouble();
      list = Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (final b in buttons) SizedBox(width: tile, child: b)],
      );
    } else {
      list = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final b in buttons)
            Padding(
              padding: EdgeInsets.only(bottom: gap),
              child: b,
            ),
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: r.s(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (open && !_t.isCaptain) ...[_settleMenu(context), SizedBox(height: r.s(grid ? 14 : 22))],
          list,
        ],
      ),
    );
  }

  // ---- dialogs ----------------------------------------------------------------------------------

  /// Dialog in a [PosDialogFrame]: sized for the screen, clear of the keyboard, content scrolls,
  /// buttons at least a finger high.
  Future<T?> _dialog<T>(
    BuildContext context, {
    required Widget Function(BuildContext ctx, Responsive r) builder,
    double maxWidth = 640,
  }) => showPosDialog<T>(
    context: context,
    maxWidth: maxWidth,
    builder: (ctx) {
      final r = ctx.r;
      final theme = Theme.of(ctx);
      final buttons = ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(r.s(96), r.minTap)),
        textStyle: WidgetStatePropertyAll(theme.textTheme.labelLarge?.copyWith(fontSize: r.f(20))),
      );
      return Theme(
        data: theme.copyWith(
          textButtonTheme: TextButtonThemeData(style: buttons),
          filledButtonTheme: FilledButtonThemeData(style: buttons),
          dialogTheme: theme.dialogTheme.copyWith(
            insetPadding: EdgeInsets.zero,
            titleTextStyle: theme.textTheme.headlineSmall?.copyWith(fontSize: r.f(26)),
            contentTextStyle: theme.textTheme.bodyLarge?.copyWith(fontSize: r.f(18)),
          ),
        ),
        child: Builder(builder: (ctx) => builder(ctx, r)),
      );
    },
  );

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
          height: r.tap(56),
          child: Text('Settle by ${m.name}', style: TextStyle(fontSize: r.f(22))),
        ),
      PopupMenuItem(
        key: const Key('settle-split'),
        value: null,
        height: r.tap(56),
        child: Text('Split payment…', style: TextStyle(fontSize: r.f(22))),
      ),
    ],
    child: Container(
      constraints: BoxConstraints(minHeight: r.tap(74)),
      padding: EdgeInsets.symmetric(horizontal: r.s(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: HomeColors.navy, width: 3),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Settle',
              style: TextStyle(fontSize: r.f(24), fontWeight: FontWeight.bold),
            ),
          ),
          Icon(Icons.arrow_drop_down, size: r.f(34)),
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
    final r = await sl<PrintCenter>().receipt(
      s,
      header: state.settings.receiptHeader,
      footer: state.settings.receiptFooter,
    );
    final printError = r.status == PrintStatus.noPrinter ? null : r.message('Receipt');
    if (!context.mounted) return;
    await _dialog<void>(
      context,
      maxWidth: 520,
      builder: (ctx, r) => AlertDialog(
        scrollable: true,
        title: Text('Paid · ${s.orderNo}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_t.currency} ${_t.money(s.priced.totalMinor + s.settlement.roundingMinor)}',
              style: TextStyle(fontSize: r.f(24), fontWeight: FontWeight.bold),
            ),
            if (s.changeDueMinor > 0)
              Text('Change: ${_t.money(s.changeDueMinor)}', style: TextStyle(fontSize: r.f(22))),
            if (printError != null) Text(printError, style: const TextStyle(color: Colors.red)),
          ],
        ),
        actions: [
          FilledButton(key: const Key('settledOk'), onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
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
    return _dialog<Set<String>>(
      context,
      builder: (ctx, r) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          backgroundColor: HomeColors.dialog,
          scrollable: true,
          title: Text(title),
          content: SizedBox(
            width: r.s(520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ?extra,
                for (final l in state.detail!.lines)
                  CheckboxListTile(
                    key: Key('pick-${l.id}'),
                    value: selected.contains(l.id),
                    activeColor: HomeColors.navy,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => set(() => v == true ? selected.add(l.id) : selected.remove(l.id)),
                    title: Text('${l.name}  ×${_qty(l.qtyMilli)}', style: TextStyle(fontSize: r.f(18))),
                    secondary: Text(_t.money(l.lineTotalMinor), style: TextStyle(fontSize: r.f(18))),
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
          items: [
            for (final o in targets)
              DropdownMenuItem(
                value: o,
                child: Text('${o.orderNo} · ${o.where}', maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
          ],
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
    final type = await _dialog<String>(
      context,
      maxWidth: 520,
      builder: (ctx, r) => SimpleDialog(
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: r.minTap),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(label, style: TextStyle(fontSize: r.f(20))),
                  ),
                ),
              ),
        ],
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

  /// Edit Order: the order opens on the home screen with all its items; Update Order sends the changes.
  Future<void> _edit(BuildContext context) async {
    final manager = sl<OrderManager>();
    try {
      manager.openOnHome(await manager.editCart(state.detail!.summary.id));
    } on SaleException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      return;
    }
    if (context.mounted) context.go(Routes.sell);
  }

  Future<void> _void(BuildContext context) async {
    if (!_can(context, 'order.void', 'void bills')) return;
    final reasonCtl = TextEditingController();
    String? reason;
    final ok = await _dialog<bool>(
      context,
      builder: (ctx, r) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          backgroundColor: HomeColors.dialog,
          scrollable: true,
          title: Text('Void ${state.detail!.summary.orderNo}?'),
          content: SizedBox(
            width: r.s(480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: r.s(10),
                  runSpacing: r.s(10),
                  children: [
                    for (final r0 in ['Cancelled by customer', 'Wrong order', 'Duplicate bill'])
                      ChoiceChip(
                        key: Key('reason-$r0'),
                        label: Text(r0, style: TextStyle(fontSize: r.f(18))),
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        selected: reason == r0,
                        onSelected: (_) => set(() {
                          reason = r0;
                          reasonCtl.text = r0;
                        }),
                      ),
                  ],
                ),
                SizedBox(height: r.s(12)),
                TextField(
                  controller: reasonCtl,
                  onChanged: (v) => set(() => reason = v),
                  style: TextStyle(fontSize: r.f(18)),
                  decoration: const InputDecoration(labelText: 'Reason*', border: OutlineInputBorder()),
                ),
                SizedBox(height: r.s(8)),
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
    final r = await _dialog<(String, String)>(
      context,
      maxWidth: 560,
      builder: (ctx, r) => AlertDialog(
        backgroundColor: HomeColors.dialog,
        scrollable: true,
        title: const Text('Apply Coupon'),
        content: SizedBox(
          width: r.s(440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('couponCode'),
                controller: code,
                textCapitalization: TextCapitalization.characters,
                style: TextStyle(fontSize: r.f(18)),
                decoration: const InputDecoration(labelText: 'Coupon code', border: OutlineInputBorder()),
              ),
              Padding(padding: EdgeInsets.all(r.s(10)), child: const Text('or')),
              TextField(
                key: const Key('couponPercent'),
                controller: pct,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: r.f(18)),
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
    final r = await sl<PrintCenter>().bill(
      orderNo: d.summary.orderNo,
      tokenNo: d.summary.tokenNo,
      cart: d.cart,
      priced: d.priced!,
      header: state.settings.receiptHeader,
      footer: state.settings.receiptFooter,
    );
    if (!context.mounted) return;
    await _shown(context, r, 'Bill');
    if (d.summary.status == 'OPEN' && context.mounted) {
      await _cubit(context).run(() => _cubit(context).orders.markBilled(d.summary.id, _user.id));
    }
  }

  Future<void> _printKot(BuildContext context) async {
    final d = state.detail!;
    final r = await sl<PrintCenter>().kotLines(
      tokenNo: d.summary.tokenNo,
      orderNo: d.summary.orderNo,
      cart: d.cart,
      lines: d.cart.lines,
    );
    if (context.mounted) await _shown(context, r, 'KOT');
  }

  /// Toast for the print result; shows the ticket on screen when it did not print.
  Future<void> _shown(BuildContext context, PrintOutcome r, String what) async {
    if (r.status == PrintStatus.printed) return _toast(context, '$what sent to the printer');
    if (r.status == PrintStatus.queued) return _toast(context, r.message(what)!);
    if (r.status == PrintStatus.failed) _toast(context, '${r.message(what)} — showing it on screen');
    if (r.tickets.isEmpty || !context.mounted) return;
    await _dialog<void>(
      context,
      builder: (ctx, rs) => AlertDialog(
        scrollable: true,
        title: Text('$what preview${r.status == PrintStatus.noPrinter ? ' (no printer set up)' : ''}'),
        // Tickets keep their printed line width; on narrow screens they scroll sideways.
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            r.tickets.map((t) => t.preview).join('\n'),
            style: TextStyle(fontFamily: 'monospace', fontSize: rs.f(16)),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  static String _qty(int milli) => milli % 1000 == 0 ? '${milli ~/ 1000}' : (milli / 1000).toStringAsFixed(3);
}

// ---- bill ----------------------------------------------------------------------------------------------

class _Bill extends StatelessWidget {
  const _Bill({required this.state, required this.r, required this.fill});
  final OrderDetailState state;
  final Responsive r;

  /// Fill the given height with the item list scrolling inside; otherwise size to the content
  /// (the parent scrolls).
  final bool fill;

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
    final big = TextStyle(fontSize: r.f(26));
    final bold = big.copyWith(fontWeight: FontWeight.bold, fontSize: r.f(28));
    final info = TextStyle(fontSize: r.f(20));
    final pad = r.s(24);
    // [w]: width of the totals box; an amount wider than 60 % of it shrinks instead of overflowing.
    Widget sum(double w, String a, String b, {bool strong = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(a, style: strong ? bold : big)),
          SizedBox(width: r.s(12)),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: w * 0.6),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(b, maxLines: 1, style: strong ? bold : big),
            ),
          ),
        ],
      ),
    );
    final lines = [
      for (final l in d.lines)
        Container(
          margin: EdgeInsets.only(top: r.s(10)),
          padding: EdgeInsets.fromLTRB(pad, r.s(14), pad, r.s(14)),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.name, style: TextStyle(fontSize: r.f(22))),
                    if (state.showDetails) Text(t.money(l.unitPriceMinor), style: info),
                    if (state.showDetails && l.note != null)
                      Text(
                        '* ${l.note}',
                        style: TextStyle(color: Colors.deepOrange, fontSize: r.f(18)),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  l.qtyMilli % 1000 == 0 ? '${l.qtyMilli ~/ 1000}' : (l.qtyMilli / 1000).toStringAsFixed(3),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: r.f(24)),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  t.money(l.lineTotalMinor),
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: r.f(24)),
                ),
              ),
            ],
          ),
        ),
    ];
    final head = TextStyle(color: Colors.white, fontSize: r.f(19));
    return Padding(
      padding: EdgeInsets.only(top: r.s(12)),
      child: Column(
        mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bill No :  #${o.orderNo}', style: info),
                    Text('Bill Type: $type', style: info),
                    Text(
                      'Date & Time : ${at == null ? '' : '${at.year}-${_two(at.month)}-${_two(at.day)} / ${_two(at.hour)}:${_two(at.minute)}:${_two(at.second)}'}',
                      style: info,
                    ),
                    if (o.status != 'OPEN')
                      Text(
                        'Status: ${o.state == 'ongoing' ? 'Billed' : o.state}${o.voidReason != null ? ' · ${o.voidReason}' : ''}',
                        style: info.copyWith(color: Colors.deepOrange),
                      ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('toggleDetails'),
                iconSize: r.f(32),
                constraints: BoxConstraints(minWidth: r.minTap, minHeight: r.minTap),
                onPressed: context.read<OrderDetailCubit>().toggleDetails,
                icon: Icon(state.showDetails ? Icons.visibility : Icons.visibility_off),
              ),
            ],
          ),
          SizedBox(height: r.s(12)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: r.s(14)),
            decoration: BoxDecoration(color: HomeColors.navy, borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                Expanded(flex: 5, child: Text('items(${d.lines.length})', style: head)),
                Expanded(
                  flex: 2,
                  child: Text('Qty', textAlign: TextAlign.center, style: head),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Price (${t.currency})', textAlign: TextAlign.end, style: head),
                ),
              ],
            ),
          ),
          if (fill) Expanded(child: ListView(children: lines)) else ...lines,
          SizedBox(height: r.s(fill ? 0 : 12)),
          Container(
            padding: EdgeInsets.fromLTRB(pad, r.s(18), pad, r.s(22)),
            decoration: BoxDecoration(
              color: HomeColors.page,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: LayoutBuilder(
              builder: (context, c) => Column(
                children: [
                  sum(c.maxWidth, 'Subtotal', t.money(priced?.subtotalMinor ?? o.totalMinor)),
                  Divider(color: Colors.grey.shade400, height: r.s(22)),
                  if ((priced?.discountMinor ?? 0) > 0)
                    sum(c.maxWidth, 'Discount', '-${t.money(priced!.discountMinor)}'),
                  if ((priced?.chargeMinor ?? 0) > 0) sum(c.maxWidth, 'Service charge', t.money(priced!.chargeMinor)),
                  sum(c.maxWidth, 'Subtotal before VAT', t.money((priced?.totalMinor ?? 0) - (priced?.taxMinor ?? 0))),
                  sum(
                    c.maxWidth,
                    'VAT ${inclusive ? 'inclusive' : 'exclusive'} (${(vat / 100).toStringAsFixed(vat % 100 == 0 ? 0 : 2)}%)',
                    t.money(priced?.taxMinor ?? 0),
                  ),
                  const Divider(),
                  sum(
                    c.maxWidth,
                    'Net Total',
                    '${t.currency} ${t.money(priced?.totalMinor ?? o.totalMinor)}',
                    strong: true,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: r.s(12)),
        ],
      ),
    );
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}
