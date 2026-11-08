import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/terminal/terminal_context.dart';
import '../../../printing/data/printer_service.dart';
import '../../../printing/domain/ticket_formatter.dart';
import '../../../shift/domain/shift_service.dart';
import '../../../shift/presentation/shift_dialogs.dart';
import '../../../staff/data/staff_repository.dart';
import '../../../terminal/terminal_cubit.dart';
import '../../../terminal/widgets/sync_chip.dart';
import '../../domain/checkout_service.dart';
import '../cubit/sell_cubit.dart';
import '../widgets/payment_dialog.dart';

class SellPage extends StatelessWidget {
  const SellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = sl<TerminalContextHolder>().ctx;
    final staff = sl<StaffSession>();
    return BlocConsumer<SellCubit, SellState>(
      listenWhen: (a, b) => b.error != null && a.error != b.error,
      listener: (context, s) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.error!))),
      builder: (context, s) {
        final cubit = context.read<SellCubit>();
        return Scaffold(
          appBar: AppBar(
            title: Text('${t.storeName} · ${t.deviceCode} · ${staff.value?.name ?? ''}'),
            actions: [
              const SyncChip(),
              _ShiftMenu(onChanged: cubit.refreshShift),
              IconButton(
                key: const Key('lock'),
                tooltip: 'Lock',
                icon: const Icon(Icons.lock_outline),
                onPressed: () {
                  staff.value = null;
                  context.go(Routes.lock);
                },
              ),
            ],
          ),
          body: s.loading
              ? const Center(child: CircularProgressIndicator())
              : !s.shiftOpen
              ? _OpenShift(onOpened: cubit.refreshShift)
              : Row(
                  children: [
                    Expanded(
                      child: _Catalogue(state: s, cubit: cubit),
                    ),
                    const VerticalDivider(width: 1),
                    SizedBox(
                      width: 400,
                      child: _CartPanel(state: s, cubit: cubit, t: t),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _OpenShift extends StatelessWidget {
  const _OpenShift({required this.onOpened});
  final VoidCallback onOpened;

  @override
  Widget build(BuildContext context) {
    final t = sl<TerminalContextHolder>().ctx;
    return Center(
      child: FilledButton.icon(
        key: const Key('openShift'),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Open shift'),
        onPressed: () async {
          final float = await askAmount(context, title: 'Opening cash float', decimals: t.currencyDecimals);
          if (float == null) return;
          try {
            await sl<ShiftService>().startShift(userId: sl<StaffSession>().user.id, openingFloatMinor: float);
            onOpened();
          } on StateError catch (e) {
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
          }
        },
      ),
    );
  }
}

class _Catalogue extends StatelessWidget {
  const _Catalogue({required this.state, required this.cubit});
  final SellState state;
  final SellCubit cubit;

  @override
  Widget build(BuildContext context) {
    final t = sl<TerminalContextHolder>().ctx;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            key: const Key('search'),
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search or scan barcode'),
            onChanged: cubit.searchFor,
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: state.categoryId == null,
                onSelected: (_) => cubit.category(null),
              ),
              for (final c in state.categories)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(c.name),
                    selected: state.categoryId == c.id,
                    onSelected: (_) => cubit.category(c.id),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: GridView.extent(
            padding: const EdgeInsets.all(12),
            maxCrossAxisExtent: 180,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.3,
            children: [
              for (final p in state.visibleProducts)
                Card(
                  key: Key('product-${p.id}'),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => cubit.add(p),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(p.name, maxLines: 3, style: const TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          Text(t.money(p.priceMinor)),
                          if (p.outOfStock) const Text('Out of stock', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartPanel extends StatelessWidget {
  const _CartPanel({required this.state, required this.cubit, required this.t});
  final SellState state;
  final SellCubit cubit;
  final TerminalContext t;

  @override
  Widget build(BuildContext context) {
    final p = state.priced;
    final user = sl<StaffSession>().user;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'TAKEAWAY', label: Text('Takeaway')),
              ButtonSegment(value: 'DINE_IN', label: Text('Dine in')),
            ],
            selected: {state.cart.orderType},
            onSelectionChanged: (v) => cubit.orderType(v.first),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              for (final l in state.cart.lines)
                ListTile(
                  dense: true,
                  title: Text(l.name),
                  subtitle: Text('${t.money(l.unitPriceMinor)} each'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.remove), onPressed: () => cubit.changeQty(l.key, -1)),
                      Text('${l.qtyMilli ~/ 1000}'),
                      IconButton(icon: const Icon(Icons.add), onPressed: () => cubit.changeQty(l.key, 1)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _line('Subtotal', t.money(p?.subtotalMinor ?? 0)),
              if ((p?.discountMinor ?? 0) > 0) _line('Discount', '-${t.money(p!.discountMinor)}'),
              if ((p?.chargeMinor ?? 0) > 0) _line('Service charge', t.money(p!.chargeMinor)),
              _line('VAT', t.money(p?.taxMinor ?? 0)),
              _line('Total ${t.currency}', t.money(p?.totalMinor ?? 0), bold: true),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (user.can('discount.apply'))
                    PopupMenuButton<int>(
                      tooltip: 'Discount',
                      icon: const Icon(Icons.percent),
                      onSelected: cubit.discount,
                      itemBuilder: (_) => [
                        for (final bp in [0, 500, 1000, 1500, 2000])
                          if (bp <= user.maxDiscountBp || bp == 0)
                            PopupMenuItem(value: bp, child: Text(bp == 0 ? 'No discount' : '${bp ~/ 100} %')),
                      ],
                    ),
                  TextButton(onPressed: state.cart.isEmpty ? null : cubit.clear, child: const Text('Clear')),
                  const Spacer(),
                  FilledButton(
                    key: const Key('pay'),
                    onPressed: p == null ? null : () => _pay(context, p.totalMinor),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('PAY', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _line(String a, String b, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : null, fontSize: bold ? 18 : null);
    return Row(
      children: [
        Text(a, style: style),
        const Spacer(),
        Text(b, style: style),
      ],
    );
  }

  Future<void> _pay(BuildContext context, int total) async {
    final priced = state.priced!;
    final result = await showPaymentDialog(
      context,
      t: t,
      priced: priced,
      methods: state.paymentMethods,
      roundingIncrement: state.settings.cashRoundingIncrementMinor,
    );
    if (result == null || !context.mounted) return;
    final user = sl<StaffSession>().user;
    final sale = await cubit.pay(
      tenders: result.tenders,
      userId: user.id,
      cashierName: user.name,
      cashTenderedMinor: result.cashTendered,
    );
    if (sale == null || !context.mounted) return;
    context.read<TerminalCubit>().refreshPending();
    final printError = await _print(sale);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Paid · ${sale.orderNo}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Token ${sale.tokenNo}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            if (sale.changeDueMinor > 0)
              Text('Change: ${t.money(sale.changeDueMinor)}', style: const TextStyle(fontSize: 22)),
            if (printError != null) Text(printError, style: const TextStyle(color: Colors.red)),
          ],
        ),
        actions: [
          FilledButton(key: const Key('nextSale'), onPressed: () => Navigator.pop(ctx), child: const Text('Next sale')),
        ],
      ),
    );
  }

  /// Receipt (+ drawer on cash) and KOT. Returns an error text, or null.
  Future<String?> _print(CompletedSale sale) async {
    final printer = sl<PrinterService>();
    final cfg = await printer.settings();
    final fmt = TicketFormatter(t, width: cfg.width);
    final errors = <String>[];
    final cashUsed = sale.settlement.tenders.any((x) => x.tender.cashLike);
    if (cfg.receiptHost != null) {
      try {
        await printer.send(
          cfg.receiptHost!,
          cfg.port,
          fmt
              .receipt(
                sale,
                header: state.settings.receiptHeader,
                footer: state.settings.receiptFooter,
                openDrawer: cfg.drawer && cashUsed,
              )
              .bytes,
        );
      } on Object {
        errors.add('Receipt printer not reachable');
      }
    }
    if (cfg.kitchenHost != null) {
      try {
        await printer.send(cfg.kitchenHost!, cfg.port, fmt.kot(sale).bytes);
      } on Object {
        errors.add('Kitchen printer not reachable');
      }
    }
    return errors.isEmpty ? null : errors.join(' · ');
  }
}

class _ShiftMenu extends StatelessWidget {
  const _ShiftMenu({required this.onChanged});
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final t = sl<TerminalContextHolder>().ctx;
    final shifts = sl<ShiftService>();
    final user = sl<StaffSession>().user;
    void toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
    return PopupMenuButton<String>(
      key: const Key('shiftMenu'),
      icon: const Icon(Icons.menu),
      onSelected: (v) async {
        try {
          switch (v) {
            case 'cash':
              final m = await askCashMovement(context, t.currencyDecimals);
              if (m == null) return;
              await shifts.cashMovement(
                userId: user.id,
                direction: m.direction,
                amountMinor: m.amount,
                reason: m.reason,
              );
              toast('Saved');
            case 'close':
              final counted = await askAmount(
                context,
                title: 'Count the cash in the drawer',
                decimals: t.currencyDecimals,
              );
              if (counted == null) return;
              final s = await shifts.closeShift(userId: user.id, countedCashMinor: counted);
              onChanged();
              if (context.mounted) await showShiftClosed(context, t, s, counted);
            case 'day':
              final totals = await shifts.closeDay(userId: user.id);
              toast('Day closed: ${totals['orders']} orders, ${t.money(totals['total_minor'] as int)}');
            case 'printers':
              if (context.mounted) await context.push(Routes.printers);
          }
        } on StateError catch (e) {
          toast(e.message);
        }
      },
      itemBuilder: (_) => [
        if (user.can('cash.in_out')) const PopupMenuItem(value: 'cash', child: Text('Cash in / paid out')),
        if (user.can('shift.open_close')) const PopupMenuItem(value: 'close', child: Text('Close shift')),
        if (user.can('day.close')) const PopupMenuItem(value: 'day', child: Text('Close business day')),
        const PopupMenuItem(value: 'printers', child: Text('Printers')),
      ],
    );
  }
}
