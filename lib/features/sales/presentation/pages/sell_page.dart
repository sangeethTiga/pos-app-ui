import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/terminal/terminal_context.dart';
import '../../../catalogue/data/catalogue_repository.dart';
import '../../../printing/data/print_center.dart';
import '../../../printing/data/printer_service.dart';
import '../../../shift/domain/shift_service.dart';
import '../../../shift/presentation/shift_dialogs.dart';
import '../../../staff/data/staff_repository.dart';
import '../../../sync/domain/sync_engine.dart';
import '../../../terminal/terminal_cubit.dart';
import '../../data/home_repository.dart';
import '../../domain/cart.dart';
import '../../domain/checkout_service.dart';
import '../../domain/order_service.dart';
import '../../domain/pricing_engine.dart';
import '../cubit/sell_cubit.dart';
import '../widgets/home_dialogs.dart';
import '../widgets/payment_dialog.dart';

/// Terminal home screen: categories, products, order types, cart, Hold / Quick Order / Place Order.
/// Wide (≥ 1100): categories | products | cart. Medium: category strip on top. Narrow (< 700): one
/// column with a cart bar that opens the cart.
class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  final _scaffold = GlobalKey<ScaffoldState>();
  final _search = TextEditingController();
  final _barcode = TextEditingController();
  bool? _kotPrinterMissing;

  TerminalContext get t => sl<TerminalContextHolder>().ctx;
  StaffUser get user => sl<StaffSession>().user;

  @override
  void initState() {
    super.initState();
    sl<PrinterService>()
      ..startAutoQueue()
      ..settings().then((s) {
        if (mounted) setState(() => _kotPrinterMissing = !s.hasKot);
      });
  }

  @override
  void dispose() {
    _search.dispose();
    _barcode.dispose();
    super.dispose();
  }

  /// Snackbar; on wide screens it floats bottom-left so it never covers the cart buttons.
  void _toast(String m) {
    final w = MediaQuery.sizeOf(context).width;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(m),
          duration: const Duration(seconds: 3),
          behavior: w < 700 ? null : SnackBarBehavior.floating,
          margin: w < 700 ? null : EdgeInsets.only(left: 12, bottom: 12, right: w - 12 - 440),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellCubit, SellState>(
      listenWhen: (a, b) => (b.error != null && a.error != b.error) || (b.info != null && a.info != b.info),
      listener: (context, s) => _toast(s.error ?? s.info!),
      builder: (context, s) {
        final cubit = context.read<SellCubit>();
        final captainDevice = t.isCaptain;
        return Scaffold(
          key: _scaffold,
          backgroundColor: HomeColors.page,
          drawer: _HomeDrawer(onShiftChanged: cubit.refreshShift),
          body: SafeArea(
            child: s.loading
                ? const Center(child: CircularProgressIndicator())
                : !s.shiftOpen && !captainDevice
                ? Column(
                    children: [
                      _TopBar(
                        state: s,
                        cubit: cubit,
                        compact: true,
                        kotPrinterMissing: false,
                        onMenu: () => _scaffold.currentState?.openDrawer(),
                        onRecall: (h) => cubit.recall(h),
                      ),
                      Expanded(child: _OpenShift(onOpened: cubit.refreshShift)),
                    ],
                  )
                : LayoutBuilder(builder: (context, c) => _scaled(context, c, s, cubit)),
          ),
        );
      },
    );
  }

  /// Width the home screen is designed at. Wider and narrower screens (≥ 700) get the same
  /// layout scaled, so it looks the same on a 10" tablet and a 27" monitor.
  static const designWidth = 1780.0;

  Widget _scaled(BuildContext context, BoxConstraints c, SellState s, SellCubit cubit) {
    if (c.maxWidth < 700) return _layout(context, c, s, cubit);
    final scale = (c.maxWidth / designWidth).clamp(0.6, 1.6);
    final size = Size(c.maxWidth / scale, c.maxHeight / scale);
    final mq = MediaQuery.of(context);
    return SizedBox(
      width: c.maxWidth,
      height: c.maxHeight,
      child: FittedBox(
        fit: BoxFit.fill,
        alignment: Alignment.topLeft,
        child: SizedBox.fromSize(
          size: size,
          child: MediaQuery(
            data: mq.copyWith(size: size),
            child: _layout(context, BoxConstraints.tight(size), s, cubit),
          ),
        ),
      ),
    );
  }

  Widget _layout(BuildContext context, BoxConstraints c, SellState s, SellCubit cubit) {
    final w = c.maxWidth;
    final cartWidth = w >= 1100 ? (w * 0.33).clamp(360.0, 700.0) : 360.0;
    final top = _TopBar(
      state: s,
      cubit: cubit,
      compact: w < 700 || w - cartWidth < 980,
      kotPrinterMissing: _kotPrinterMissing ?? false,
      onMenu: () => _scaffold.currentState?.openDrawer(),
      onRecall: (h) => cubit.recall(h),
    );
    final searchRow = _SearchRow(
      search: _search,
      barcode: _barcode,
      compact: w < 700,
      onSearch: cubit.searchFor,
      onBarcode: (code) async {
        if (await cubit.addBarcode(code)) _barcode.clear();
      },
    );
    final actions = _ActionButtons(
      compact: w < 700,
      onKitchenNote: () => _kitchenNote(s, cubit),
      onDiscount: () => _discount(s, cubit),
      onOpenFood: () => _openFood(cubit),
      onNewOrder: () => _newOrder(s, cubit),
      onOrders: () async {
        await context.push(Routes.orders);
        if (mounted) cubit.load();
      },
    );
    final cart = _CartPanel(
      state: s,
      t: t,
      captainDevice: t.isCaptain,
      onChannel: (ch) => _channel(ch, s, cubit),
      onEditLine: (l) => _editLine(l, cubit),
      onQty: cubit.changeQty,
      onHold: () => cubit.hold(user.id),
      onQuick: () => _quickOrder(s, cubit),
      onPlace: () => _place(cubit),
      onDeliveryCharge: () => _deliveryCharge(s, cubit),
    );

    if (w < 700) {
      return Column(
        children: [
          top,
          searchRow,
          _CategoryStrip(state: s, cubit: cubit),
          Expanded(
            child: _ProductGrid(state: s, cubit: cubit, paged: false),
          ),
          actions,
          _CartBar(state: s, t: t, onOpen: () => _openCartSheet(cubit)),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              top,
              searchRow,
              if (w < 1100) _CategoryStrip(state: s, cubit: cubit),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (w >= 1100)
                      SizedBox(
                        width: (w * 0.2).clamp(260.0, 400.0),
                        child: _CategoryGrid(state: s, cubit: cubit),
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _ProductGrid(state: s, cubit: cubit, paged: true),
                          ),
                          actions,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: cartWidth, child: cart),
      ],
    );
  }

  Future<void> _openCartSheet(SellCubit cubit) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: HomeColors.page,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: FractionallySizedBox(
        heightFactor: 0.92,
        child: BlocBuilder<SellCubit, SellState>(
          builder: (ctx, s) => _CartPanel(
            state: s,
            t: t,
            captainDevice: t.isCaptain,
            onChannel: (ch) => _channel(ch, s, cubit),
            onEditLine: (l) => _editLine(l, cubit),
            onQty: cubit.changeQty,
            onHold: () => cubit.hold(user.id),
            onQuick: () => _quickOrder(s, cubit),
            onPlace: () => _place(cubit),
            onDeliveryCharge: () => _deliveryCharge(s, cubit),
          ),
        ),
      ),
    ),
  );

  // ---- order type popups ---------------------------------------------------------------------

  Future<void> _channel(String ch, SellState s, SellCubit cubit) async {
    final home = sl<HomeRepository>();
    switch (ch) {
      case Channel.takeaway:
        cubit.takeaway();
      case Channel.dineIn:
        final tables = await home.tables();
        final open = await sl<OrderService>().openOrders();
        if (!mounted) return;
        final choice = await showChooseTable(
          context,
          tables: tables,
          openOrders: open,
          selectedTableId: s.cart.tableId,
        );
        if (choice == null || !mounted) return;
        CaptainInfo? captain;
        if (t.isCaptain) {
          captain = CaptainInfo(user.id, user.name);
        } else {
          final captains = await home.captains();
          if (!mounted) return;
          if (captains.isNotEmpty) {
            captain = await showSelectCaptain(context, captains, selectedId: s.cart.captainId);
            if (captain == null) return;
          }
        }
        await cubit.dineIn(table: choice.table, guests: choice.guests, running: choice.running, captain: captain);
      case Channel.homeDelivery:
        final choice = await showCustomerDetails(context, repo: home, userId: user.id, selectedId: s.cart.customerId);
        if (choice == null) return;
        cubit.homeDelivery(customer: choice.customer, carhop: choice.carhop, carNo: choice.carNo);
      case Channel.partner:
        final partners = await home.deliveryPartners();
        if (!mounted) return;
        final choice = await showDeliveryPartners(
          context,
          partners,
          selectedId: s.cart.deliveryPartnerId,
          orderNo: s.cart.partnerOrderNo,
        );
        if (choice == null) return;
        cubit.partner(partner: choice.partner, orderNo: choice.orderNo);
    }
  }

  // ---- actions -----------------------------------------------------------------------------------

  Future<void> _kitchenNote(SellState s, SellCubit cubit) async {
    final note = await showKitchenNote(context, s.cart.kitchenNote);
    if (note != null) cubit.kitchenNote(note);
  }

  Future<void> _discount(SellState s, SellCubit cubit) async {
    if (!user.can('discount.apply')) return _toast('${user.name} may not give discounts.');
    final bp = await showDiscount(context, currentBp: s.cart.discountBp, maxBp: user.maxDiscountBp);
    if (bp != null) cubit.discount(bp);
  }

  Future<void> _deliveryCharge(SellState s, SellCubit cubit) async {
    final minor = await askAmount(context, title: 'Delivery charge', decimals: t.currencyDecimals);
    if (minor != null) cubit.deliveryCharge(minor);
  }

  Future<void> _openFood(SellCubit cubit) async {
    final item = await showOpenFood(context, decimals: t.currencyDecimals);
    if (item != null) cubit.openFood(name: item.name, priceMinor: item.priceMinor, qtyUnits: item.qty);
  }

  Future<void> _newOrder(SellState s, SellCubit cubit) async {
    if (s.cart.isEmpty) return cubit.newOrder();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New order?'),
        content: const Text('The current items will be cleared. Use Hold to keep them.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            key: const Key('confirmNewOrder'),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (ok == true) cubit.newOrder();
  }

  Future<void> _editLine(CartLine l, SellCubit cubit) async {
    final edit = await showLineEdit(context, l);
    if (edit != null) cubit.updateLine(l.key, qtyMilli: edit.qtyMilli, note: edit.note);
  }

  Future<void> _place(SellCubit cubit) async {
    final placed = await cubit.place(user.id, canReduce: user.can('order.reduce_qty_after_kot'));
    if (placed == null || !mounted) return;
    context.read<TerminalCubit>().refreshPending();
    // Print the KOT in the background so the dashboard opens at once.
    unawaited(_printKot(placed));
    await context.push(Routes.ordersFor(placed.cart.channel));
    if (mounted) cubit.load();
  }

  /// KOT for a new order; for an updated order an ADD-ON ticket for added items and a CANCEL ticket
  /// for removed ones (split by kitchen station).
  Future<void> _printKot(PlacedOrder placed) async {
    final r = await sl<PrintCenter>().kot(placed);
    // "KOT printer not configured" is already shown in the top bar.
    if (r.status != PrintStatus.noPrinter && mounted) {
      if (r.message('Kitchen') case final m?) _toast(m);
    }
  }

  Future<void> _quickOrder(SellState s, SellCubit cubit) async {
    final priced = s.priced;
    if (priced == null) return;
    if (!user.can('payment.take')) return _toast('${user.name} may not take payments.');
    final result = await showPaymentDialog(
      context,
      t: t,
      priced: priced,
      methods: s.paymentMethods,
      roundingIncrement: s.settings.cashRoundingIncrementMinor,
    );
    if (result == null || !mounted) return;
    final sale = s.cart.existingOrderId != null
        ? await cubit.quickUpdate(
            tenders: result.tenders,
            userId: user.id,
            cashierName: user.name,
            cashTenderedMinor: result.cashTendered,
            canReduce: user.can('order.reduce_qty_after_kot'),
          )
        : await cubit.pay(
            tenders: result.tenders,
            userId: user.id,
            cashierName: user.name,
            cashTenderedMinor: result.cashTendered,
          );
    if (sale == null || !mounted) return;
    context.read<TerminalCubit>().refreshPending();
    final printError = await _printReceipt(sale, s);
    if (!mounted) return;
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

  /// Receipt copies for the order type (+ drawer on cash). Quick Order sends nothing to the kitchen.
  Future<String?> _printReceipt(CompletedSale sale, SellState s) async {
    final r = await sl<PrintCenter>().receipt(sale, header: s.settings.receiptHeader, footer: s.settings.receiptFooter);
    return r.status == PrintStatus.noPrinter ? null : r.message('Receipt');
  }
}

// ---- top bar ---------------------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.state,
    required this.cubit,
    required this.compact,
    required this.kotPrinterMissing,
    required this.onMenu,
    required this.onRecall,
  });
  final SellState state;
  final SellCubit cubit;
  final bool compact, kotPrinterMissing;
  final VoidCallback onMenu;
  final ValueChanged<HeldCart> onRecall;

  @override
  Widget build(BuildContext context) {
    final term = context.watch<TerminalCubit>().state;
    final online = term.lastReport?.result != SyncResult.failed;
    final t = sl<TerminalContextHolder>().ctx;
    final phone = MediaQuery.sizeOf(context).width < 700;
    final fs = phone ? 15.0 : 22.0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
      child: Row(
        children: [
          IconButton(
            key: const Key('homeMenu'),
            onPressed: onMenu,
            icon: Icon(Icons.menu, size: phone ? 24 : 30),
          ),
          SizedBox(width: phone ? 0 : 8),
          FilledButton.icon(
            key: const Key('onlineChip'),
            style: FilledButton.styleFrom(
              backgroundColor: online ? HomeColors.green : Colors.red.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 18, vertical: phone ? 10 : 16),
            ),
            onPressed: term.syncing ? null : () => context.read<TerminalCubit>().syncNow(),
            icon: Icon(online ? Icons.wifi : Icons.wifi_off, size: phone ? 20 : 28),
            label: Text(term.syncing ? 'Syncing' : (online ? 'Online' : 'Offline'), style: TextStyle(fontSize: fs)),
          ),
          if (kotPrinterMissing && !compact) ...[
            const SizedBox(width: 6),
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            const Flexible(
              child: Text(
                'KOT printer not configured',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.redAccent, fontSize: 21),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              key: const Key('fixPrinter'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
              onPressed: () => context.push(Routes.printers),
              child: const Text(
                'Fix it',
                style: TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          const Spacer(),
          PopupMenuButton<HeldCart>(
            key: const Key('heldOrders'),
            tooltip: 'Held orders',
            onSelected: onRecall,
            itemBuilder: (_) => state.held.isEmpty
                ? [const PopupMenuItem(enabled: false, child: Text('No held orders'))]
                : [
                    for (final h in state.held)
                      PopupMenuItem(
                        value: h,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(h.label),
                          subtitle: Text('${h.cart.itemCount} items · ${t.money(h.totalMinor)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              Navigator.pop(context);
                              cubit.discardHeld(h, sl<StaffSession>().user.id);
                            },
                          ),
                        ),
                      ),
                  ],
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 14, vertical: phone ? 9 : 12),
              decoration: BoxDecoration(color: HomeColors.navy, borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    compact ? 'Held(${state.held.length})' : 'Held Orders(${state.held.length})',
                    style: TextStyle(color: Colors.white, fontSize: fs),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
          SizedBox(width: phone ? 4 : 12),
          OutlinedButton(
            key: const Key('refresh'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 22, vertical: phone ? 10 : 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () {
              context.read<TerminalCubit>().syncNow();
              cubit.refresh();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!compact)
                  const Text(
                    'Refresh ',
                    style: TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                const Icon(Icons.refresh, color: Colors.black87),
              ],
            ),
          ),
          IconButton(
            key: const Key('togglePrices'),
            tooltip: state.showPrices ? 'Hide prices' : 'Show prices',
            onPressed: cubit.togglePrices,
            icon: Icon(state.showPrices ? Icons.visibility : Icons.visibility_off, size: phone ? 22 : 28),
          ),
        ],
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.search,
    required this.barcode,
    required this.compact,
    required this.onSearch,
    required this.onBarcode,
  });
  final TextEditingController search, barcode;
  final bool compact;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onBarcode;

  InputDecoration _dec(String hint, TextEditingController c, VoidCallback onClear) => InputDecoration(
    hintText: hint,
    prefixIcon: const Icon(Icons.search, size: 28),
    suffixIcon: IconButton(icon: const Icon(Icons.close), onPressed: onClear),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final searchField = TextField(
      key: const Key('search'),
      controller: search,
      onChanged: onSearch,
      style: const TextStyle(fontSize: 20),
      decoration: _dec('Search products', search, () {
        search.clear();
        onSearch('');
      }),
    );
    final barcodeField = TextField(
      key: const Key('barcode'),
      controller: barcode,
      onSubmitted: onBarcode,
      style: const TextStyle(fontSize: 20),
      decoration: _dec('Search by Barcode', barcode, barcode.clear),
    );
    final enter = FilledButton(
      key: const Key('barcodeEnter'),
      style: FilledButton.styleFrom(
        backgroundColor: HomeColors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
      ),
      onPressed: () => onBarcode(barcode.text),
      child: const Text('Enter', style: TextStyle(fontSize: 18)),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: compact
          ? Column(
              children: [
                searchField,
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: barcodeField),
                    const SizedBox(width: 8),
                    enter,
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: searchField),
                const SizedBox(width: 18),
                Expanded(child: barcodeField),
                const SizedBox(width: 18),
                enter,
              ],
            ),
    );
  }
}

// ---- categories ---------------------------------------------------------------------------------------

List<(String?, String)> _categoryTiles(SellState s) => [
  (fastMovingId, 'Fast Moving'),
  for (final c in s.categories) (c.id, c.name),
];

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.state, required this.cubit});
  final SellState state;
  final SellCubit cubit;

  @override
  Widget build(BuildContext context) {
    final tiles = _categoryTiles(state);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 6, 8, 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 82,
        crossAxisSpacing: 14,
        mainAxisSpacing: 7,
      ),
      itemCount: tiles.length,
      itemBuilder: (_, i) => _CategoryTile(
        id: tiles[i].$1,
        name: tiles[i].$2,
        selected: state.search.isEmpty && state.categoryId == tiles[i].$1,
        onTap: () => cubit.category(tiles[i].$1),
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({required this.state, required this.cubit});
  final SellState state;
  final SellCubit cubit;

  @override
  Widget build(BuildContext context) {
    final tiles = _categoryTiles(state);
    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: tiles.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) => SizedBox(
          width: 150,
          child: _CategoryTile(
            id: tiles[i].$1,
            name: tiles[i].$2,
            selected: state.search.isEmpty && state.categoryId == tiles[i].$1,
            onTap: () => cubit.category(tiles[i].$1),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.id,
    required this.name,
    required this.selected,
    required this.onTap,
    this.fontSize = 22,
  });
  final String? id;
  final String name;
  final bool selected;
  final VoidCallback onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? Colors.white : HomeColors.navy,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
      side: BorderSide(color: selected ? Colors.black45 : HomeColors.navy),
    ),
    child: InkWell(
      key: Key('category-$id'),
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: fontSize, color: selected ? Colors.black : Colors.white),
          ),
        ),
      ),
    ),
  );
}

// ---- products -------------------------------------------------------------------------------------------

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.state, required this.cubit, required this.paged});
  final SellState state;
  final SellCubit cubit;

  /// Prev / Next pages (wide screens); otherwise one scrolling grid.
  final bool paged;

  @override
  Widget build(BuildContext context) {
    final products = state.visibleProducts;
    return LayoutBuilder(
      builder: (context, c) {
        final tileHeight = paged ? 196.0 : 128.0;
        final gap = paged ? 12.0 : 10.0;
        final cols = (c.maxWidth / (paged ? 200 : 170)).floor().clamp(2, 6);
        if (!paged) {
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisExtent: tileHeight,
              crossAxisSpacing: gap,
              mainAxisSpacing: gap,
            ),
            itemCount: products.length,
            itemBuilder: (_, i) =>
                _ProductTile(product: products[i], state: state, big: false, onTap: () => cubit.add(products[i])),
          );
        }
        const pagerHeight = 78.0;
        final rows = ((c.maxHeight - pagerHeight - 12) / (tileHeight + gap)).floor().clamp(1, 20);
        final perPage = rows * cols;
        final pages = (products.length / perPage).ceil().clamp(1, 1 << 20);
        final page = state.page.clamp(0, pages - 1);
        final shown = products.skip(page * perPage).take(perPage).toList();
        return Column(
          children: [
            SizedBox(
              height: pagerHeight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _PagerButton(
                      key: const Key('prevPage'),
                      label: 'Prev',
                      onTap: page > 0 ? () => cubit.setPage(page - 1) : null,
                    ),
                    const SizedBox(width: 24),
                    _PagerButton(
                      key: const Key('nextPage'),
                      label: 'Next',
                      onTap: page < pages - 1 ? () => cubit.setPage(page + 1) : null,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('No products', style: TextStyle(fontSize: 18)))
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(4, 0, 12, 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisExtent: tileHeight,
                        crossAxisSpacing: gap,
                        mainAxisSpacing: gap,
                      ),
                      itemCount: shown.length,
                      itemBuilder: (_, i) =>
                          _ProductTile(product: shown[i], state: state, big: true, onTap: () => cubit.add(shown[i])),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _PagerButton extends StatelessWidget {
  const _PagerButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 176,
    height: 55,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: HomeColors.navy,
        disabledBackgroundColor: HomeColors.grey,
        disabledForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
      child: Text(label, style: const TextStyle(fontSize: 18)),
    ),
  );
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.state, required this.big, required this.onTap});
  final Product product;
  final SellState state;
  final bool big;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = sl<TerminalContextHolder>().ctx;
    return Material(
      color: product.outOfStock ? Colors.grey.shade200 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: Colors.black87, width: 1.2),
      ),
      child: InkWell(
        key: Key('product-${product.id}'),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(big ? 16 : 12, big ? 12 : 8, 10, big ? 12 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: big ? 23 : 16, fontWeight: FontWeight.w500, height: 1.4),
                ),
              ),
              if (product.outOfStock)
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  color: Colors.orange,
                  child: const Text(
                    'OUT OF STOCK',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              if (state.showPrices)
                Text(
                  '${t.currency}  ${t.money(product.priceMinor)}',
                  style: TextStyle(fontSize: big ? 22 : 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.compact,
    required this.onKitchenNote,
    required this.onDiscount,
    required this.onOpenFood,
    required this.onNewOrder,
    required this.onOrders,
  });
  final bool compact;
  final VoidCallback onKitchenNote, onDiscount, onOpenFood, onNewOrder, onOrders;

  Widget _btn(String key, String label, VoidCallback onTap, {double height = 100}) => Padding(
    padding: const EdgeInsets.all(2),
    child: SizedBox(
      height: height,
      child: FilledButton(
        key: Key(key),
        style: FilledButton.styleFrom(
          backgroundColor: HomeColors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        onPressed: onTap,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: compact ? 15 : 23, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return SizedBox(
        height: 56,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          children: [
            for (final (k, l, f) in [
              ('kitchenNote', 'Kitchen Note', onKitchenNote),
              ('discount', 'Discount', onDiscount),
              ('openFood', 'Open Food', onOpenFood),
              ('newOrder', 'New Order', onNewOrder),
              ('orders', 'Orders', onOrders),
            ])
              SizedBox(width: 130, child: _btn(k, l, f, height: 50)),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _btn('kitchenNote', 'Kitchen Note', onKitchenNote)),
              Expanded(child: _btn('discount', 'Discount', onDiscount)),
              Expanded(child: _btn('openFood', 'Open Food', onOpenFood)),
            ],
          ),
          Row(
            children: [
              Expanded(child: _btn('newOrder', 'New Order', onNewOrder)),
              Expanded(child: _btn('orders', 'Orders', onOrders)),
            ],
          ),
        ],
      ),
    );
  }
}

// ---- cart -------------------------------------------------------------------------------------------------

class _CartPanel extends StatelessWidget {
  const _CartPanel({
    required this.state,
    required this.t,
    required this.captainDevice,
    required this.onChannel,
    required this.onEditLine,
    required this.onQty,
    required this.onHold,
    required this.onQuick,
    required this.onPlace,
    required this.onDeliveryCharge,
  });
  final SellState state;
  final TerminalContext t;
  final bool captainDevice;
  final ValueChanged<String> onChannel;
  final ValueChanged<CartLine> onEditLine;
  final void Function(String key, int delta) onQty;
  final VoidCallback onHold, onQuick, onPlace, onDeliveryCharge;

  @override
  Widget build(BuildContext context) {
    final cart = state.cart;
    final priced = state.priced;
    final empty = cart.isEmpty;
    final ch = cart.channel;
    final vatRate = cart.lines.isEmpty ? 0 : cart.lines.first.taxRateBp;
    final inclusive = cart.lines.isEmpty || cart.lines.first.priceIncludesTax;
    final editing = cart.existingOrderId != null;
    final showDelivery = editing || ch == Channel.homeDelivery || ch == Channel.partner;
    final service = (priced?.charges ?? const <PricedCharge>[])
        .where((c) => c.code == 'SERVICE')
        .fold(0, (sum, c) => sum + c.net + c.tax);
    return Container(
      color: editing ? HomeColors.page : Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (editing)
            Padding(
              key: const Key('editHeader'),
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 2),
              child: Text(
                'Bill No :  #${cart.existingOrderNo ?? ''}    Bill Type : ${_typeLabel(ch)}',
                style: const TextStyle(fontSize: 21, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            Row(
              children: [
                for (final (key, label, value) in [
                  ('chDineIn', 'Dine In', Channel.dineIn),
                  ('chTakeaway', 'Take away', Channel.takeaway),
                  ('chDelivery', 'Home Delivery', Channel.homeDelivery),
                  ('chPartner', 'Delivery Partner', Channel.partner),
                ])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: SizedBox(
                        height: 56,
                        child: FilledButton(
                          key: Key(key),
                          style: FilledButton.styleFrom(
                            backgroundColor: ch == value ? HomeColors.navy : HomeColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(color: HomeColors.navy),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          onPressed: () => onChannel(value),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(label, style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          if (!editing && _details(cart) != null)
            InkWell(
              key: const Key('orderDetails'),
              onTap: () => onChannel(ch),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 10, 6, 0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18, color: HomeColors.navy),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _details(cart)!,
                        style: const TextStyle(color: HomeColors.navy, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Icon(Icons.edit, size: 18, color: HomeColors.navy),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(color: HomeColors.navy, borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text('items(${cart.itemCount})', style: const TextStyle(color: Colors.white, fontSize: 19)),
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
            child: ListView.builder(
              itemCount: cart.lines.length,
              itemBuilder: (_, i) => _LineRow(
                line: cart.lines[i],
                total: priced?.lines[i].lineTotal,
                t: t,
                editing: editing,
                selected: editing && cart.lines[i].key == state.selectedKey,
                onTap: () => onEditLine(cart.lines[i]),
                onQty: (d) => onQty(cart.lines[i].key, d),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
            decoration: BoxDecoration(
              color: HomeColors.page,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                _sum('Subtotal', t.money(priced?.subtotalMinor ?? 0)),
                if (showDelivery) _delivery(cart.deliveryChargeMinor),
                Divider(color: Colors.grey.shade400, height: 20),
                if ((priced?.discountMinor ?? 0) > 0)
                  _sum(
                    'Discount (${(cart.discountBp / 100).toStringAsFixed(cart.discountBp % 100 == 0 ? 0 : 2)}%)',
                    '-${t.money(priced!.discountMinor)}',
                  ),
                if (service > 0) _sum('Service charge', t.money(service)),
                _sum('Subtotal before VAT', t.money((priced?.totalMinor ?? 0) - (priced?.taxMinor ?? 0))),
                _sum(
                  'VAT ${inclusive ? 'inclusive' : 'exclusive'} (${(vatRate / 100).toStringAsFixed(vatRate % 100 == 0 ? 0 : 2)}%)',
                  t.money(priced?.taxMinor ?? 0),
                ),
                const _Dashed(),
                _sum('Net Total', '${t.currency} ${t.money(priced?.totalMinor ?? 0)}', bold: true),
                Divider(color: Colors.grey.shade400, height: 16),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _bottomButton('hold', 'Hold', HomeColors.green, empty || state.busy ? null : onHold),
                    ),
                    if (!captainDevice) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 4,
                        child: _bottomButton(
                          'pay',
                          editing ? 'Quick Update Order' : 'Quick Order(No KOT)',
                          editing ? HomeColors.navy : HomeColors.quick,
                          empty || state.busy ? null : onQuick,
                        ),
                      ),
                    ],
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: _bottomButton(
                        'placeOrder',
                        editing ? 'Update Order' : 'Place Order',
                        HomeColors.place,
                        empty || state.busy ? null : onPlace,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _typeLabel(String channel) => switch (channel) {
    Channel.dineIn => 'Dine in',
    Channel.takeaway => 'Take away',
    Channel.homeDelivery => 'Home Delivery',
    _ => 'Delivery Partner',
  };

  static String? _details(Cart c) => switch (c.channel) {
    Channel.dineIn when c.tableName != null => [
      'Table ${c.tableName}',
      if (c.guests != null) 'PAX ${c.guests}',
      if (c.captainName != null) 'Captain ${c.captainName}',
    ].join(' · '),
    Channel.homeDelivery when c.customerName != null => [
      c.customerName!,
      ?c.customerMobile,
      if (c.carhop) 'Carhop ${c.carNo ?? ''}'.trim(),
    ].join(' · '),
    Channel.partner => [
      c.deliveryPartnerName ?? 'Partner',
      if (c.partnerOrderNo != null) '#${c.partnerOrderNo}',
    ].join(' · '),
    _ => c.kitchenNote != null ? 'Note: ${c.kitchenNote}' : null,
  };

  /// "Delivery charge  Edit✎        0.00" in red.
  Widget _delivery(int minor) {
    const red = TextStyle(fontSize: 26, color: Color(0xFFE5574B));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Delivery charge', style: red),
                  ),
                ),
                const SizedBox(width: 22),
                InkWell(
                  key: const Key('deliveryChargeEdit'),
                  onTap: onDeliveryCharge,
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Edit', style: TextStyle(fontSize: 19, color: Color(0xFF4CAF50))),
                        Icon(Icons.edit, size: 18, color: Colors.black87),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(t.money(minor), style: red),
        ],
      ),
    );
  }

  Widget _sum(String a, String b, {bool bold = false}) {
    final style = TextStyle(fontSize: bold ? 28 : 26, fontWeight: bold ? FontWeight.bold : FontWeight.w400);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(a, style: style)),
          Text(b, style: style),
        ],
      ),
    );
  }

  Widget _bottomButton(String key, String label, Color color, VoidCallback? onTap) => SizedBox(
    height: 68,
    child: FilledButton(
      key: Key(key),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: color.withValues(alpha: 0.45),
        disabledForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 6),
      ),
      onPressed: onTap,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    ),
  );
}

class _Dashed extends StatelessWidget {
  const _Dashed();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, c) => Row(
      children: [
        for (var i = 0; i < (c.maxWidth / 18).floor(); i++)
          Container(width: 10, height: 1.4, margin: const EdgeInsets.only(right: 8), color: Colors.grey.shade500),
      ],
    ),
  );
}

class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.line,
    required this.total,
    required this.t,
    required this.onTap,
    required this.onQty,
    this.editing = false,
    this.selected = false,
  });
  final CartLine line;
  final int? total;
  final TerminalContext t;
  final VoidCallback onTap;
  final ValueChanged<int> onQty;

  /// Edit Order layout: qty and price columns with stacked + / - on the right.
  final bool editing;
  final bool selected;

  String get _qty => line.qtyMilli % 1000 == 0 ? '${line.qtyMilli ~/ 1000}' : (line.qtyMilli / 1000).toStringAsFixed(3);

  @override
  Widget build(BuildContext context) => editing ? _editRow() : _row();

  Widget _editRow() {
    final fg = selected ? Colors.white : Colors.black87;
    return InkWell(
      key: Key('line-${line.key}'),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.fromLTRB(18, 8, 14, 8),
        decoration: BoxDecoration(
          color: selected ? HomeColors.blue : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(line.name, style: TextStyle(fontSize: 21, color: fg)),
                  Text(t.money(line.unitPriceMinor), style: TextStyle(fontSize: 19, color: fg)),
                  if (line.note != null)
                    Text(
                      '* ${line.note}',
                      style: TextStyle(fontSize: 13, color: selected ? Colors.white : Colors.deepOrange),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _qty,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, color: fg),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                t.money(total ?? line.unitPriceMinor * line.qtyMilli ~/ 1000),
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 23, color: fg),
              ),
            ),
            const SizedBox(width: 6),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _stackButton(Icons.add, () => onQty(1), 'plus-${line.key}'),
                const SizedBox(height: 8),
                _stackButton(Icons.remove, () => onQty(-1), 'minus-${line.key}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stackButton(IconData icon, VoidCallback onTap, String key) => Material(
    color: selected ? Colors.white : const Color(0xFFE8E6EC),
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      key: Key(key),
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(width: 84, height: 50, child: Icon(icon, size: 26, color: Colors.black)),
    ),
  );

  Widget _row() => InkWell(
    key: Key('line-${line.key}'),
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      decoration: BoxDecoration(color: HomeColors.page, borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.name, style: const TextStyle(fontSize: 21)),
                Text(t.money(line.unitPriceMinor), style: const TextStyle(fontSize: 17, color: Colors.black54)),
                if (line.note != null)
                  Text('* ${line.note}', style: const TextStyle(fontSize: 13, color: Colors.deepOrange)),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _qtyButton(Icons.remove, () => onQty(-1), 'minus-${line.key}'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(_qty, style: const TextStyle(fontSize: 18)),
                ),
                _qtyButton(Icons.add, () => onQty(1), 'plus-${line.key}'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.money(total ?? line.unitPriceMinor * line.qtyMilli ~/ 1000),
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _qtyButton(IconData icon, VoidCallback onTap, String key) => InkWell(
    key: Key(key),
    onTap: onTap,
    customBorder: const CircleBorder(),
    child: Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: HomeColors.navy),
      ),
      child: Icon(icon, size: 16, color: HomeColors.navy),
    ),
  );
}

class _CartBar extends StatelessWidget {
  const _CartBar({required this.state, required this.t, required this.onOpen});
  final SellState state;
  final TerminalContext t;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Material(
    color: HomeColors.navy,
    child: InkWell(
      key: const Key('openCart'),
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              '${state.cart.itemCount} items · ${state.cart.channel.replaceAll('_', ' ')}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            Text(
              '${t.currency} ${t.money(state.priced?.totalMinor ?? 0)}',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.keyboard_arrow_up, color: Colors.white),
          ],
        ),
      ),
    ),
  );
}

// ---- drawer and shift -----------------------------------------------------------------------------------

/// Side menu: Cloud Sync, Finance, Orders, Settings (printers, activation, contact), Open Drawer,
/// Shift Close, Logout.
class _HomeDrawer extends StatefulWidget {
  const _HomeDrawer({required this.onShiftChanged});
  final VoidCallback onShiftChanged;

  @override
  State<_HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<_HomeDrawer> {
  final _open = <String>{'settings'};

  static const _ink = Color(0xFF22406A);

  @override
  Widget build(BuildContext context) {
    final t = sl<TerminalContextHolder>().ctx;
    final shifts = sl<ShiftService>();
    final user = sl<StaffSession>().user;
    final messenger = ScaffoldMessenger.of(context);
    void toast(String m) => messenger.showSnackBar(SnackBar(content: Text(m)));
    Future<void> run(Future<void> Function() f) async {
      Navigator.pop(context);
      try {
        await f();
      } on StateError catch (e) {
        toast(e.message);
      }
    }

    void push(String route) {
      Navigator.pop(context);
      context.push(route);
    }

    Widget top(String key, IconData icon, String label, {VoidCallback? onTap, bool group = false}) {
      final open = _open.contains(key);
      return Material(
        color: group && open ? const Color(0xFFE9E7EE) : Colors.transparent,
        child: InkWell(
          key: Key('menu-$key'),
          onTap: group ? () => setState(() => open ? _open.remove(key) : _open.add(key)) : onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 17, 22, 17),
            child: Row(
              children: [
                Icon(icon, color: _ink, size: 28),
                const SizedBox(width: 22),
                Expanded(
                  child: Text(
                    label.toUpperCase(),
                    style: const TextStyle(fontSize: 18, letterSpacing: 1.2, color: _ink, fontWeight: FontWeight.w500),
                  ),
                ),
                if (group) Icon(open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: _ink, size: 28),
              ],
            ),
          ),
        ),
      );
    }

    Widget sub(String key, IconData icon, String label, VoidCallback onTap) => InkWell(
      key: Key('menu-$key'),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 15, 22, 15),
        child: Row(
          children: [
            Icon(icon, color: _ink, size: 26),
            const SizedBox(width: 22),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 17, letterSpacing: 0.6, color: Colors.black87)),
            ),
          ],
        ),
      ),
    );

    final cashier = !t.isCaptain;
    return Drawer(
      width: 300,
      backgroundColor: const Color(0xFFF4F2F7),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
                    color: HomeColors.navy,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.storeName,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${user.name} · ${t.deviceCode} · ${t.deviceType}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  top(
                    'cloudSync',
                    Icons.sync,
                    'Cloud Sync',
                    onTap: () => run(() async {
                      await context.read<TerminalCubit>().syncNow();
                      toast('Synced');
                    }),
                  ),
                  if (cashier && (user.can('cash.in_out') || user.can('day.close'))) ...[
                    top('finance', Icons.monetization_on, 'Finance', group: true),
                    if (_open.contains('finance')) ...[
                      if (user.can('cash.in_out'))
                        sub(
                          'cashInOut',
                          Icons.swap_vert,
                          'Cash In / Paid Out',
                          () => run(() async {
                            final m = await askCashMovement(context, t.currencyDecimals);
                            if (m == null) return;
                            await shifts.cashMovement(
                              userId: user.id,
                              direction: m.direction,
                              amountMinor: m.amount,
                              reason: m.reason,
                            );
                            toast('Saved');
                          }),
                        ),
                      if (user.can('day.close'))
                        sub(
                          'closeDay',
                          Icons.event_available,
                          'Close Business Day',
                          () => run(() async {
                            final totals = await shifts.closeDay(userId: user.id);
                            toast('Day closed: ${totals['orders']} orders, ${t.money(totals['total_minor'] as int)}');
                          }),
                        ),
                    ],
                  ],
                  top('orders', Icons.shopping_cart_outlined, 'Orders', group: true),
                  if (_open.contains('orders'))
                    for (final (key, label, ch) in [
                      ('ordersDineIn', 'Dine In', Channel.dineIn),
                      ('ordersTakeaway', 'Take Away', Channel.takeaway),
                      ('ordersDelivery', 'Home Delivery', Channel.homeDelivery),
                      ('ordersPartner', 'Delivery Partner', Channel.partner),
                    ])
                      sub(key, Icons.receipt_long, label, () => push(Routes.ordersFor(ch))),
                  const Divider(height: 1, color: Colors.black38),
                  top('settings', Icons.settings, 'Settings', group: true),
                  if (_open.contains('settings')) ...[
                    sub('printerSettings', Icons.print, 'Printer Settings', () => push(Routes.printers)),
                    sub('activation', Icons.power, 'Activation', () => push(Routes.home)),
                    sub(
                      'contactUs',
                      Icons.phone,
                      'Contact us',
                      () => run(
                        () => showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Contact us'),
                            content: Text(
                              'For help with this terminal contact your store manager or POS administrator.\n\n'
                              'Store: ${t.storeName}\nTerminal: ${t.deviceCode}',
                            ),
                            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const Divider(height: 1, color: Colors.black38),
                  if (cashier && user.can('cash.in_out'))
                    top(
                      'openDrawer',
                      Icons.drag_handle,
                      'Open Drawer',
                      onTap: () => run(() async {
                        final r = await sl<PrintCenter>().openDrawer();
                        toast(r.ok ? 'Drawer opened' : (r.message('Bill') ?? 'Drawer not opened'));
                      }),
                    ),
                  if (cashier && user.can('shift.open_close'))
                    top(
                      'closeShift',
                      Icons.schedule,
                      'Shift Close',
                      onTap: () => run(() async {
                        final counted = await askAmount(
                          context,
                          title: 'Count the cash in the drawer',
                          decimals: t.currencyDecimals,
                        );
                        if (counted == null) return;
                        final s = await shifts.closeShift(userId: user.id, countedCashMinor: counted);
                        widget.onShiftChanged();
                        if (context.mounted) await showShiftClosed(context, t, s, counted);
                      }),
                    ),
                  top(
                    'lock',
                    Icons.logout,
                    'Logout',
                    onTap: () {
                      sl<StaffSession>().value = null;
                      context.go(Routes.lock);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Terminal ${t.deviceCode}',
                style: const TextStyle(fontSize: 13, color: Colors.black54, letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
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
