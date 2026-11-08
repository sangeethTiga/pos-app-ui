import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/responsive/responsive.dart';
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
///
/// Laid out for the space it has (no scaling of the whole screen):
/// * [Responsive.splitPane] and wider: products | cart side by side. The category column has two
///   columns of tiles when there is room, one column when tighter, and becomes a strip on top of
///   the products when the left pane is narrow. Products page with Prev / Next; a page is exactly
///   the grid that fits.
/// * Narrower (phones, tablets in portrait, phone landscape): category strip, scrolling product
///   grid and a cart bar that opens the cart as a bottom sheet.
/// Sizes come from the [Responsive] tokens, so text and touch targets suit every screen class.
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

  /// Snackbar; with the cart beside the products it floats bottom-left so it never covers the
  /// cart buttons.
  void _toast(String m) {
    final r = context.r;
    final width = math.max(360.0, r.s(520));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(m),
          duration: const Duration(seconds: 3),
          behavior: r.splitPane ? SnackBarBehavior.floating : null,
          margin: r.splitPane
              ? EdgeInsets.only(left: r.gutter, bottom: r.gutter, right: math.max(r.gutter, r.width - r.gutter - width))
              : null,
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
                      _topBar(s, cubit, kotPrinterMissing: false),
                      Expanded(child: _OpenShift(onOpened: cubit.refreshShift)),
                    ],
                  )
                : ResponsiveBuilder(builder: (context, r) => _layout(context, r, s, cubit)),
          ),
        );
      },
    );
  }

  Widget _topBar(SellState s, SellCubit cubit, {required bool kotPrinterMissing}) => _TopBar(
    state: s,
    cubit: cubit,
    kotPrinterMissing: kotPrinterMissing,
    onMenu: () => _scaffold.currentState?.openDrawer(),
    onRecall: (h) => cubit.recall(h),
  );

  Widget _cart(SellState s, SellCubit cubit) => _CartPanel(
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

  _ActionButtons _actions(SellState s, SellCubit cubit, _ActionsLayout layout) => _ActionButtons(
    layout: layout,
    onKitchenNote: () => _kitchenNote(s, cubit),
    onDiscount: () => _discount(s, cubit),
    onOpenFood: () => _openFood(cubit),
    onNewOrder: () => _newOrder(s, cubit),
    onOrders: () async {
      await context.push(Routes.orders);
      if (mounted) cubit.load();
    },
  );

  /// [r] describes the body (screen minus safe areas and keyboard).
  Widget _layout(BuildContext context, Responsive r, SellState s, SellCubit cubit) {
    final top = _topBar(s, cubit, kotPrinterMissing: _kotPrinterMissing ?? false);
    final searchRow = _SearchRow(
      search: _search,
      barcode: _barcode,
      onSearch: cubit.searchFor,
      onBarcode: (code) async {
        if (await cubit.addBarcode(code)) _barcode.clear();
      },
    );
    if (!r.splitPane) return _narrowLayout(context, r, s, cubit, top, searchRow);

    // Products | cart. The cart keeps about a third of the width, within finger-friendly limits.
    final cartWidth = (r.width * 0.32).clamp(340.0, math.max<double>(340.0, r.s(600)));
    final left = r.width - cartWidth;
    final categoryCols = left >= r.s(1150) ? 2 : (left >= r.s(760) ? 1 : 0);
    final categoryWidth = categoryCols == 2
        ? (left * 0.27).clamp(r.s(260), r.s(400))
        : (left * 0.22).clamp(r.s(170), r.s(240));
    // Two rows of big action buttons only when the screen is tall for its density.
    final actions = _actions(s, cubit, r.height >= r.s(1070) ? _ActionsLayout.twoRows : _ActionsLayout.oneRow);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              top,
              searchRow,
              if (categoryCols == 0) _CategoryStrip(state: s, cubit: cubit),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (categoryCols > 0)
                      SizedBox(
                        width: categoryWidth,
                        child: _CategoryGrid(state: s, cubit: cubit, columns: categoryCols),
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _PagedProductGrid(state: s, cubit: cubit),
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
        SizedBox(width: cartWidth, child: _cart(s, cubit)),
      ],
    );
  }

  /// Phones, tablets in portrait, phone landscape: one column with a cart bar opening the cart.
  Widget _narrowLayout(BuildContext context, Responsive r, SellState s, SellCubit cubit, Widget top, Widget searchRow) {
    // The page's own context: the Scaffold hides the keyboard inset from its body.
    final keyboard = MediaQuery.viewInsetsOf(this.context).bottom;
    // Header stays put on tall screens; on short ones (phone landscape, small phones) it scrolls
    // away with the products. Decided without the keyboard so opening it never moves the fields.
    final pinHeader = r.height + keyboard >= r.s(900);
    final strip = _CategoryStrip(state: s, cubit: cubit);
    return Column(
      children: [
        if (pinHeader) ...[top, searchRow, strip],
        Expanded(
          child: CustomScrollView(
            slivers: [
              if (!pinHeader) ...[
                SliverToBoxAdapter(child: top),
                SliverToBoxAdapter(child: searchRow),
                SliverToBoxAdapter(child: strip),
              ],
              _ProductSliverGrid(state: s, cubit: cubit),
            ],
          ),
        ),
        if (keyboard == 0) _actions(s, cubit, _ActionsLayout.strip),
        _CartBar(state: s, t: t, onOpen: () => _openCartSheet(cubit)),
      ],
    );
  }

  Future<void> _openCartSheet(SellCubit cubit) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // Full width (Material 3 caps sheets at 640): landscape phones put lines and totals side by side.
    constraints: const BoxConstraints(),
    backgroundColor: HomeColors.page,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: FractionallySizedBox(
        heightFactor: 0.92,
        child: BlocBuilder<SellCubit, SellState>(builder: (ctx, s) => _cart(s, cubit)),
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

// ---- shared bits -------------------------------------------------------------------------------------

/// Short text (a number, a one-word label) that shrinks rather than wrap or overflow its box.
Widget _fit(Widget child, {AlignmentGeometry alignment = Alignment.center}) =>
    FittedBox(fit: BoxFit.scaleDown, alignment: alignment, child: child);

/// Room a line of [fontSize] text takes at the current text scale (with a little leading).
double _lineHeight(BuildContext context, double fontSize) => MediaQuery.textScalerOf(context).scale(fontSize) * 1.25;

// ---- top bar ---------------------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.state,
    required this.cubit,
    required this.kotPrinterMissing,
    required this.onMenu,
    required this.onRecall,
  });
  final SellState state;
  final SellCubit cubit;
  final bool kotPrinterMissing;
  final VoidCallback onMenu;
  final ValueChanged<HeldCart> onRecall;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final term = context.watch<TerminalCubit>().state;
    final online = term.lastReport?.result != SyncResult.failed;
    final t = sl<TerminalContextHolder>().ctx;
    final fs = r.f(22);
    final h = r.tap(58);
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(6));
    return Padding(
      padding: EdgeInsets.fromLTRB(r.s(8), r.s(10), r.s(8), r.s(6)),
      child: LayoutBuilder(
        builder: (context, c) {
          // Less important items collapse as the bar gets narrower.
          final full = c.maxWidth >= r.s(1150); // KOT warning in words, "Fix it"
          final roomy = c.maxWidth >= r.s(700); // "Held Orders", "Refresh" labels
          final tiny = c.maxWidth < r.s(520); // online chip as an icon
          final onlineLabel = term.syncing ? 'Syncing' : (online ? 'Online' : 'Offline');
          final onlineStyle = FilledButton.styleFrom(
            backgroundColor: online ? HomeColors.green : Colors.red.shade400,
            shape: shape,
            minimumSize: Size(r.minTap, h),
            padding: EdgeInsets.symmetric(horizontal: tiny ? r.s(10) : r.s(18)),
          );
          final onSync = term.syncing ? null : () => context.read<TerminalCubit>().syncNow();
          final onlineIcon = Icon(online ? Icons.wifi : Icons.wifi_off, size: r.f(28));
          return Row(
            children: [
              IconButton(
                key: const Key('homeMenu'),
                onPressed: onMenu,
                icon: Icon(Icons.menu, size: r.f(30)),
              ),
              SizedBox(width: tiny ? 0 : r.s(8)),
              if (tiny)
                Tooltip(
                  message: onlineLabel,
                  child: FilledButton(
                    key: const Key('onlineChip'),
                    style: onlineStyle,
                    onPressed: onSync,
                    child: onlineIcon,
                  ),
                )
              else
                FilledButton.icon(
                  key: const Key('onlineChip'),
                  style: onlineStyle,
                  onPressed: onSync,
                  icon: onlineIcon,
                  label: Text(onlineLabel, style: TextStyle(fontSize: fs)),
                ),
              if (kotPrinterMissing && full) ...[
                SizedBox(width: r.s(6)),
                Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: r.f(28)),
                Flexible(
                  child: Text(
                    'KOT printer not configured',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: Colors.redAccent, fontSize: r.f(21)),
                  ),
                ),
                SizedBox(width: r.s(10)),
                OutlinedButton(
                  key: const Key('fixPrinter'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(r.minTap, h),
                    padding: EdgeInsets.symmetric(horizontal: r.s(16)),
                    shape: shape,
                  ),
                  onPressed: () => context.push(Routes.printers),
                  child: Text(
                    'Fix it',
                    style: TextStyle(fontSize: fs, color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                ),
              ] else if (kotPrinterMissing)
                IconButton(
                  key: const Key('fixPrinter'),
                  tooltip: 'KOT printer not configured',
                  onPressed: () => context.push(Routes.printers),
                  icon: Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: r.f(30)),
                ),
              SizedBox(width: r.s(8)),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _heldMenu(context, r, t, fs, h, roomy: roomy),
                ),
              ),
              SizedBox(width: tiny ? r.s(4) : r.s(12)),
              OutlinedButton(
                key: const Key('refresh'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(r.minTap, h),
                  padding: EdgeInsets.symmetric(horizontal: roomy ? r.s(22) : r.s(8)),
                  shape: shape,
                ),
                onPressed: () {
                  context.read<TerminalCubit>().syncNow();
                  cubit.refresh();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (roomy)
                      Text(
                        'Refresh ',
                        style: TextStyle(fontSize: fs, color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    Icon(Icons.refresh, color: Colors.black87, size: r.f(28)),
                  ],
                ),
              ),
              IconButton(
                key: const Key('togglePrices'),
                tooltip: state.showPrices ? 'Hide prices' : 'Show prices',
                onPressed: cubit.togglePrices,
                icon: Icon(state.showPrices ? Icons.visibility : Icons.visibility_off, size: r.f(28)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _heldMenu(BuildContext context, Responsive r, TerminalContext t, double fs, double h, {required bool roomy}) =>
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
          constraints: BoxConstraints(minHeight: h),
          padding: EdgeInsets.symmetric(horizontal: roomy ? r.s(14) : r.s(8)),
          decoration: BoxDecoration(color: HomeColors.navy, borderRadius: BorderRadius.circular(6)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: roomy
                    ? Text(
                        'Held Orders(${state.held.length})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: fs),
                      )
                    // Short label: shrinks rather than lose the count on the narrowest phones.
                    : _fit(
                        Text(
                          'Held(${state.held.length})',
                          style: TextStyle(color: Colors.white, fontSize: fs),
                        ),
                      ),
              ),
              if (roomy) Icon(Icons.arrow_drop_down, color: Colors.white, size: r.f(30)),
            ],
          ),
        ),
      );
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({required this.search, required this.barcode, required this.onSearch, required this.onBarcode});
  final TextEditingController search, barcode;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onBarcode;

  InputDecoration _dec(Responsive r, String hint, VoidCallback onClear) => InputDecoration(
    hintText: hint,
    prefixIcon: Icon(Icons.search, size: r.f(28)),
    suffixIcon: IconButton(
      icon: Icon(Icons.close, size: r.f(26)),
      onPressed: onClear,
    ),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(vertical: r.s(16), horizontal: r.s(12)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final style = TextStyle(fontSize: r.f(20));
    final searchField = TextField(
      key: const Key('search'),
      controller: search,
      onChanged: onSearch,
      style: style,
      scrollPadding: EdgeInsets.all(r.s(20)),
      decoration: _dec(r, 'Search products', () {
        search.clear();
        onSearch('');
      }),
    );
    final barcodeField = TextField(
      key: const Key('barcode'),
      controller: barcode,
      onSubmitted: onBarcode,
      style: style,
      scrollPadding: EdgeInsets.all(r.s(20)),
      decoration: _dec(r, 'Search by Barcode', barcode.clear),
    );
    final enter = FilledButton(
      key: const Key('barcodeEnter'),
      style: FilledButton.styleFrom(
        backgroundColor: HomeColors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        minimumSize: Size(r.minTap, r.tap(56)),
        padding: EdgeInsets.symmetric(horizontal: r.s(26)),
      ),
      onPressed: () => onBarcode(barcode.text),
      child: Text('Enter', style: TextStyle(fontSize: r.f(20))),
    );
    final gap = r.s(18);
    return Padding(
      padding: EdgeInsets.fromLTRB(r.s(12), r.s(4), r.s(12), r.s(8)),
      child: LayoutBuilder(
        builder: (context, c) => c.maxWidth < r.s(900)
            ? Column(
                children: [
                  searchField,
                  SizedBox(height: r.s(10)),
                  Row(
                    children: [
                      Expanded(child: barcodeField),
                      SizedBox(width: r.s(10)),
                      enter,
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: searchField),
                  SizedBox(width: gap),
                  Expanded(child: barcodeField),
                  SizedBox(width: gap),
                  enter,
                ],
              ),
      ),
    );
  }
}

// ---- categories ---------------------------------------------------------------------------------------

List<(String?, String)> _categoryTiles(SellState s) => [
  (fastMovingId, 'Fast Moving'),
  for (final c in s.categories) (c.id, c.name),
];

/// Category column beside the products (1 or 2 columns of tiles).
class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.state, required this.cubit, required this.columns});
  final SellState state;
  final SellCubit cubit;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final tiles = _categoryTiles(state);
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(r.s(12), r.s(6), r.s(8), r.s(12)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: r.tap(82),
        crossAxisSpacing: r.s(14),
        mainAxisSpacing: r.s(7),
      ),
      itemCount: tiles.length,
      itemBuilder: (_, i) => _CategoryTile(
        id: tiles[i].$1,
        name: tiles[i].$2,
        selected: state.search.isEmpty && state.categoryId == tiles[i].$1,
        onTap: () => cubit.category(tiles[i].$1),
        fontSize: r.f(22),
      ),
    );
  }
}

/// Horizontal category strip (narrow screens, or a narrow product pane).
class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({required this.state, required this.cubit});
  final SellState state;
  final SellCubit cubit;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final tiles = _categoryTiles(state);
    final pad = r.s(6);
    return SizedBox(
      height: r.tap(64) + 2 * pad,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: r.s(12), vertical: pad),
        scrollDirection: Axis.horizontal,
        itemCount: tiles.length,
        separatorBuilder: (_, _) => SizedBox(width: r.s(10)),
        itemBuilder: (_, i) => SizedBox(
          width: r.s(190),
          child: _CategoryTile(
            id: tiles[i].$1,
            name: tiles[i].$2,
            selected: state.search.isEmpty && state.categoryId == tiles[i].$1,
            onTap: () => cubit.category(tiles[i].$1),
            fontSize: r.f(20),
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
    required this.fontSize,
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
          padding: EdgeInsets.symmetric(horizontal: context.r.s(8)),
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

/// Product grid with Prev / Next (beside the cart). A page is exactly the columns x rows that fit.
class _PagedProductGrid extends StatelessWidget {
  const _PagedProductGrid({required this.state, required this.cubit});
  final SellState state;
  final SellCubit cubit;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final products = state.visibleProducts;
    final tileHeight = r.s(196);
    final gap = r.s(12);
    final pagerHeight = r.tap(55) + r.s(14);
    final pad = EdgeInsets.fromLTRB(r.s(4), 0, r.s(12), r.s(8));
    return LayoutBuilder(
      builder: (context, c) {
        final cols = r.columns(c.maxWidth - pad.horizontal, minTileWidth: 200, min: 2, max: 10);
        final gridHeight = math.max(0.0, c.maxHeight - pagerHeight - pad.vertical);
        final rows = ((gridHeight + gap) / (tileHeight + gap)).floor().clamp(1, 50);
        // Tiles grow a little to fill the height instead of leaving a gap under the last row.
        final fit = (gridHeight - gap * (rows - 1)) / rows;
        final extent = fit >= tileHeight ? math.min(fit, tileHeight * 1.25) : tileHeight;
        final perPage = rows * cols;
        final pages = (products.length / perPage).ceil().clamp(1, 1 << 20);
        final page = state.page.clamp(0, pages - 1);
        final shown = products.skip(page * perPage).take(perPage).toList();
        return Column(
          children: [
            SizedBox(
              height: pagerHeight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, r.s(6), r.s(12), r.s(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: _PagerButton(
                        key: const Key('prevPage'),
                        label: 'Prev',
                        onTap: page > 0 ? () => cubit.setPage(page - 1) : null,
                      ),
                    ),
                    SizedBox(width: r.s(24)),
                    Flexible(
                      child: _PagerButton(
                        key: const Key('nextPage'),
                        label: 'Next',
                        onTap: page < pages - 1 ? () => cubit.setPage(page + 1) : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Text('No products', style: TextStyle(fontSize: r.f(20))),
                    )
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: pad,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisExtent: extent,
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

/// Scrolling product grid (sliver) for narrow screens; columns follow the width.
class _ProductSliverGrid extends StatelessWidget {
  const _ProductSliverGrid({required this.state, required this.cubit});
  final SellState state;
  final SellCubit cubit;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final products = state.visibleProducts;
    if (products.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('No products', style: TextStyle(fontSize: r.f(20))),
        ),
      );
    }
    final gap = r.s(12);
    return SliverPadding(
      padding: EdgeInsets.all(r.s(12)),
      sliver: SliverLayoutBuilder(
        builder: (context, c) => SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: r.columns(c.crossAxisExtent, minTileWidth: 200, min: 2, max: 10),
            mainAxisExtent: r.s(165),
            crossAxisSpacing: gap,
            mainAxisSpacing: gap,
          ),
          itemCount: products.length,
          itemBuilder: (_, i) =>
              _ProductTile(product: products[i], state: state, big: false, onTap: () => cubit.add(products[i])),
        ),
      ),
    );
  }
}

class _PagerButton extends StatelessWidget {
  const _PagerButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return SizedBox(
      width: r.s(176),
      height: r.tap(55),
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: HomeColors.navy,
          disabledBackgroundColor: HomeColors.grey,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(horizontal: r.s(8)),
        ),
        onPressed: onTap,
        child: _fit(Text(label, style: TextStyle(fontSize: r.f(20)))),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.state, required this.big, required this.onTap});
  final Product product;
  final SellState state;

  /// Paged grid beside the cart (bigger tiles); otherwise the narrow-screen grid.
  final bool big;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
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
          padding: EdgeInsets.fromLTRB(r.s(big ? 16 : 14), r.s(big ? 12 : 10), r.s(10), r.s(big ? 12 : 10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: r.f(big ? 23 : 21), fontWeight: FontWeight.w500, height: 1.4),
                ),
              ),
              if (product.outOfStock)
                Container(
                  margin: EdgeInsets.only(bottom: r.s(4)),
                  padding: EdgeInsets.symmetric(horizontal: r.s(5), vertical: 1),
                  color: Colors.orange,
                  child: Text(
                    'OUT OF STOCK',
                    maxLines: 1,
                    style: TextStyle(color: Colors.white, fontSize: r.f(13), fontWeight: FontWeight.bold),
                  ),
                ),
              if (state.showPrices)
                Text(
                  '${t.currency}  ${t.money(product.priceMinor)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: r.f(big ? 22 : 20), fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ActionsLayout {
  /// Narrow screens: one row of buttons, scrolling sideways when they do not fit.
  strip,

  /// Beside the cart on short screens: one row of five.
  oneRow,

  /// Beside the cart on tall screens: three big buttons over two.
  twoRows,
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.layout,
    required this.onKitchenNote,
    required this.onDiscount,
    required this.onOpenFood,
    required this.onNewOrder,
    required this.onOrders,
  });
  final _ActionsLayout layout;
  final VoidCallback onKitchenNote, onDiscount, onOpenFood, onNewOrder, onOrders;

  Widget _btn(Responsive r, (String, String, VoidCallback) b, double height, double fontSize) => Padding(
    padding: const EdgeInsets.all(2),
    child: SizedBox(
      height: height,
      child: FilledButton(
        key: Key(b.$1),
        style: FilledButton.styleFrom(
          backgroundColor: HomeColors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          padding: EdgeInsets.symmetric(horizontal: r.s(8)),
        ),
        onPressed: b.$3,
        child: Text(
          b.$2,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final buttons = [
      ('kitchenNote', 'Kitchen Note', onKitchenNote),
      ('discount', 'Discount', onDiscount),
      ('openFood', 'Open Food', onOpenFood),
      ('newOrder', 'New Order', onNewOrder),
      ('orders', 'Orders', onOrders),
    ];
    Widget row(Iterable<(String, String, VoidCallback)> bs, double height, double fontSize) =>
        Row(children: [for (final b in bs) Expanded(child: _btn(r, b, height, fontSize))]);
    switch (layout) {
      case _ActionsLayout.strip:
        final height = r.tap(64);
        final width = r.s(170);
        final fontSize = r.f(20);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: r.s(8), vertical: 2),
          child: LayoutBuilder(
            builder: (context, c) => c.maxWidth >= width * buttons.length
                ? row(buttons, height, fontSize)
                : SizedBox(
                    height: height + 4,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [for (final b in buttons) SizedBox(width: width, child: _btn(r, b, height, fontSize))],
                    ),
                  ),
          ),
        );
      case _ActionsLayout.oneRow:
        return Padding(
          padding: EdgeInsets.fromLTRB(0, r.s(8), r.s(8), r.s(4)),
          child: row(buttons, r.tap(80), r.f(22)),
        );
      case _ActionsLayout.twoRows:
        final height = r.tap(100);
        final fontSize = r.f(23);
        return Padding(
          padding: EdgeInsets.fromLTRB(0, r.s(8), r.s(8), r.s(4)),
          child: Column(children: [row(buttons.take(3), height, fontSize), row(buttons.skip(3), height, fontSize)]),
        );
    }
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

  static const _channels = [
    ('chDineIn', 'Dine In', Channel.dineIn),
    ('chTakeaway', 'Take away', Channel.takeaway),
    ('chDelivery', 'Home Delivery', Channel.homeDelivery),
    ('chPartner', 'Delivery Partner', Channel.partner),
  ];

  /// Order-type buttons fit in one row when each gets this much width; otherwise 2 x 2.
  static bool _channelsInOneRow(Responsive r, double width) => width / _channels.length >= r.s(140);

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      color: HomeColors.page,
      padding: EdgeInsets.fromLTRB(r.s(8), r.s(10), r.s(8), r.s(8)),
      child: LayoutBuilder(builder: (context, c) => _body(context, r, c)),
    );
  }

  Widget _body(BuildContext context, Responsive r, BoxConstraints c) {
    final cart = state.cart;
    final priced = state.priced;
    final editing = cart.existingOrderId != null;
    final details = editing ? null : _details(cart);
    final service = (priced?.charges ?? const <PricedCharge>[])
        .where((c) => c.code == 'SERVICE')
        .fold(0, (sum, c) => sum + c.net + c.tax);

    List<Widget> head(double width) => [
      if (editing) _editHeader(r, cart) else _channelButtons(r, cart.channel, _channelsInOneRow(r, width)),
      if (details != null) _detailsRow(r, details, cart.channel),
      SizedBox(height: r.s(10)),
      _itemsHeader(r, cart),
    ];
    Widget line(int i) => _LineRow(
      line: cart.lines[i],
      total: priced?.lines[i].lineTotal,
      t: t,
      selected: cart.lines[i].key == state.selectedKey,
      onTap: () => onEditLine(cart.lines[i]),
      onQty: (d) => onQty(cart.lines[i].key, d),
    );
    final totals = _totals(r, cart, priced, service);
    final buttons = _buttons(r, editing, cart.isEmpty);

    // Room the fixed parts need; the line list gets what is left (at least a few lines).
    final textLine = _lineHeight(context, r.f(26)) + r.s(4);
    final headHeight =
        (editing
            ? _lineHeight(context, r.f(21)) * 2
            : (_channelsInOneRow(r, c.maxWidth) ? 1 : 2) * (r.tap(56) + r.s(4))) +
        (details != null ? math.max(r.minTap, _lineHeight(context, r.f(18)) + r.s(6)) : 0) +
        r.s(10) +
        _lineHeight(context, r.f(19)) +
        r.s(22);
    // Sum rows, the delivery row (finger-sized Edit), two dividers, the dashed line, padding, buttons.
    final totalsHeight =
        (totals.length - 4) * textLine + math.max(r.minTap, textLine) + 38 + r.s(24) + r.tap(68) + r.s(6);
    final tall = c.maxHeight >= headHeight + totalsHeight + r.s(240);
    Widget box(List<Widget> children) => _totalsBox(r, children);

    if (tall) {
      // Order type and totals stay put; only the lines scroll.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...head(c.maxWidth),
          Expanded(
            child: ListView.builder(itemCount: cart.lines.length, itemBuilder: (_, i) => line(i)),
          ),
          // Capped (scrolling inside) so the lines always keep some room, whatever the text size.
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: math.max(r.tap(68) + r.s(60), c.maxHeight - headHeight - r.s(120))),
            child: box([
              Flexible(
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: totals),
                ),
              ),
              SizedBox(height: r.s(6)),
              buttons,
            ]),
          ),
        ],
      );
    }
    if (c.maxWidth >= r.s(760) && c.maxWidth > c.maxHeight * 1.3) {
      // Short and wide (phone landscape): lines on the left, totals and buttons on the right.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 11,
            child: LayoutBuilder(
              builder: (context, lc) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...head(lc.maxWidth),
                  Expanded(
                    child: ListView.builder(itemCount: cart.lines.length, itemBuilder: (_, i) => line(i)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: r.s(12)),
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: SingleChildScrollView(child: box(totals))),
                SizedBox(height: r.s(6)),
                buttons,
              ],
            ),
          ),
        ],
      );
    }
    // Short: lines and totals scroll together (the order type too when even that is too tall);
    // the Hold / Quick / Place buttons stay on screen.
    final pinHead = c.maxHeight >= headHeight + r.tap(68) + r.s(200);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (pinHead) ...head(c.maxWidth),
        Expanded(
          child: CustomScrollView(
            slivers: [
              if (!pinHead) SliverList.list(children: head(c.maxWidth)),
              SliverList.builder(itemCount: cart.lines.length, itemBuilder: (_, i) => line(i)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: r.s(8)),
                  child: box(totals),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: r.s(6)),
        buttons,
      ],
    );
  }

  Widget _editHeader(Responsive r, Cart cart) => Padding(
    key: const Key('editHeader'),
    padding: EdgeInsets.fromLTRB(r.s(4), r.s(4), r.s(4), r.s(2)),
    child: Text(
      'Bill No :  #${cart.existingOrderNo ?? ''}    Bill Type : ${_typeLabel(cart.channel)}',
      style: TextStyle(fontSize: r.f(21), color: Colors.black87),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );

  Widget _channelButtons(Responsive r, String ch, bool oneRow) {
    Widget button((String, String, String) c) => Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.s(2)),
        child: SizedBox(
          height: r.tap(56),
          child: FilledButton(
            key: Key(c.$1),
            style: FilledButton.styleFrom(
              backgroundColor: ch == c.$3 ? HomeColors.navy : HomeColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: HomeColors.navy),
              ),
              padding: EdgeInsets.symmetric(horizontal: r.s(4)),
            ),
            onPressed: () => onChannel(c.$3),
            child: _fit(Text(c.$2, style: TextStyle(fontSize: r.f(22)))),
          ),
        ),
      ),
    );
    if (oneRow) return Row(children: [for (final c in _channels) button(c)]);
    return Column(
      children: [
        Row(children: [for (final c in _channels.take(2)) button(c)]),
        SizedBox(height: r.s(4)),
        Row(children: [for (final c in _channels.skip(2)) button(c)]),
      ],
    );
  }

  Widget _detailsRow(Responsive r, String details, String ch) => InkWell(
    key: const Key('orderDetails'),
    onTap: () => onChannel(ch),
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: r.minTap),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.s(6), r.s(6), r.s(6), 0),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: r.f(22), color: HomeColors.navy),
            SizedBox(width: r.s(6)),
            Expanded(
              child: Text(
                details,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: HomeColors.navy, fontWeight: FontWeight.w600, fontSize: r.f(18)),
              ),
            ),
            Icon(Icons.edit, size: r.f(22), color: HomeColors.navy),
          ],
        ),
      ),
    ),
  );

  Widget _itemsHeader(Responsive r, Cart cart) {
    final style = TextStyle(color: Colors.white, fontSize: r.f(19));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.s(18), vertical: r.s(11)),
      decoration: BoxDecoration(color: HomeColors.navy, borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text('items(${cart.itemCount})', maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
          ),
          Expanded(
            flex: 2,
            child: Text('Qty', textAlign: TextAlign.center, maxLines: 1, style: style),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Price (${t.currency})',
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ],
      ),
    );
  }

  /// Subtotal, delivery charge, discount, service, VAT, Net Total (first and last are dividers).
  List<Widget> _totals(Responsive r, Cart cart, PricedOrder? priced, int service) {
    final vatRate = cart.lines.isEmpty ? 0 : cart.lines.first.taxRateBp;
    final inclusive = cart.lines.isEmpty || cart.lines.first.priceIncludesTax;
    return [
      _sum(r, 'Subtotal', t.money(priced?.subtotalMinor ?? 0)),
      _delivery(r, cart.deliveryChargeMinor),
      Divider(color: Colors.grey.shade400, height: 20),
      if ((priced?.discountMinor ?? 0) > 0)
        _sum(
          r,
          'Discount (${(cart.discountBp / 100).toStringAsFixed(cart.discountBp % 100 == 0 ? 0 : 2)}%)',
          '-${t.money(priced!.discountMinor)}',
        ),
      if (service > 0) _sum(r, 'Service charge', t.money(service)),
      _sum(r, 'Subtotal before VAT', t.money((priced?.totalMinor ?? 0) - (priced?.taxMinor ?? 0))),
      _sum(
        r,
        'VAT ${inclusive ? 'inclusive' : 'exclusive'} (${(vatRate / 100).toStringAsFixed(vatRate % 100 == 0 ? 0 : 2)}%)',
        t.money(priced?.taxMinor ?? 0),
      ),
      const _Dashed(),
      _sum(r, 'Net Total', '${t.currency} ${t.money(priced?.totalMinor ?? 0)}', bold: true),
      Divider(color: Colors.grey.shade400, height: 16),
    ];
  }

  Widget _totalsBox(Responsive r, List<Widget> children) => Container(
    padding: EdgeInsets.fromLTRB(r.s(18), r.s(14), r.s(18), r.s(10)),
    decoration: BoxDecoration(
      color: HomeColors.page,
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
  );

  Widget _buttons(Responsive r, bool editing, bool empty) {
    final gap = SizedBox(width: r.s(16));
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _bottomButton(r, 'hold', 'Hold', HomeColors.green, empty || state.busy ? null : onHold),
        ),
        if (!captainDevice) ...[
          gap,
          Expanded(
            flex: 4,
            child: _bottomButton(
              r,
              'pay',
              editing ? 'Quick Update Order' : 'Quick Order(No KOT)',
              editing ? HomeColors.navy : HomeColors.quick,
              empty || state.busy ? null : onQuick,
            ),
          ),
        ],
        gap,
        Expanded(
          flex: 4,
          child: _bottomButton(
            r,
            'placeOrder',
            editing ? 'Update Order' : 'Place Order',
            HomeColors.place,
            empty || state.busy ? null : onPlace,
          ),
        ),
      ],
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
  Widget _delivery(Responsive r, int minor) {
    final red = TextStyle(fontSize: r.f(26), color: const Color(0xFFE5574B));
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: _fit(Text('Delivery charge', style: red), alignment: Alignment.centerLeft),
              ),
              SizedBox(width: r.s(22)),
              InkWell(
                key: const Key('deliveryChargeEdit'),
                onTap: onDeliveryCharge,
                borderRadius: BorderRadius.circular(5),
                // The chip stays small; the tap target is finger-sized.
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: r.minTap, minWidth: r.minTap),
                  child: Center(
                    widthFactor: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: r.s(6), vertical: r.s(2)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Edit',
                            style: TextStyle(fontSize: r.f(19), color: const Color(0xFF4CAF50)),
                          ),
                          Icon(Icons.edit, size: r.f(20), color: Colors.black87),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(t.money(minor), style: red),
      ],
    );
  }

  Widget _sum(Responsive r, String a, String b, {bool bold = false}) {
    final style = TextStyle(fontSize: r.f(bold ? 28 : 26), fontWeight: bold ? FontWeight.bold : FontWeight.w400);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: r.s(2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(a, style: style)),
          SizedBox(width: r.s(8)),
          Text(b, style: style),
        ],
      ),
    );
  }

  Widget _bottomButton(Responsive r, String key, String label, Color color, VoidCallback? onTap) => SizedBox(
    height: r.tap(68),
    child: FilledButton(
      key: Key(key),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: color.withValues(alpha: 0.45),
        disabledForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: EdgeInsets.symmetric(horizontal: r.s(6)),
      ),
      onPressed: onTap,
      // Long labels ("Quick Order(No KOT)") wrap to two lines in a narrow cart before shrinking.
      child: LayoutBuilder(
        builder: (_, c) => FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: c.hasBoundedWidth ? c.maxWidth : null,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(fontSize: r.f(20), height: 1.1, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
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
    this.selected = false,
  });
  final CartLine line;
  final int? total;
  final TerminalContext t;
  final VoidCallback onTap;
  final ValueChanged<int> onQty;

  final bool selected;

  String get _qty => line.qtyMilli % 1000 == 0 ? '${line.qtyMilli ~/ 1000}' : (line.qtyMilli / 1000).toStringAsFixed(3);

  /// White card: name and unit price, qty, line total, stacked + / - on the right; blue when
  /// selected. In a narrow cart the name gets the full width and unit price, qty and total sit
  /// under it.
  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final fg = selected ? Colors.white : Colors.black87;
    final name = Text(
      line.name,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: r.f(21), color: fg),
    );
    final unit = Text(
      t.money(line.unitPriceMinor),
      maxLines: 1,
      style: TextStyle(fontSize: r.f(19), color: fg),
    );
    final note = line.note == null
        ? null
        : Text(
            '* ${line.note}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: r.f(16), color: selected ? Colors.white : Colors.deepOrange),
          );
    final qty = _fit(
      Text(
        _qty,
        maxLines: 1,
        style: TextStyle(fontSize: r.f(23), color: fg),
      ),
    );
    final amount = _fit(
      Text(
        t.money(total ?? line.unitPriceMinor * line.qtyMilli ~/ 1000),
        maxLines: 1,
        style: TextStyle(fontSize: r.f(23), color: fg),
      ),
      alignment: Alignment.centerRight,
    );
    final stack = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stackButton(r, Icons.add, () => onQty(1), 'plus-${line.key}'),
        SizedBox(height: r.s(8)),
        _stackButton(r, Icons.remove, () => onQty(-1), 'minus-${line.key}'),
      ],
    );
    return InkWell(
      key: Key('line-${line.key}'),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: r.s(8)),
        padding: EdgeInsets.fromLTRB(r.s(18), r.s(8), r.s(14), r.s(8)),
        decoration: BoxDecoration(
          color: selected ? HomeColors.blue : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder: (context, c) => c.maxWidth >= r.s(480)
              ? Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [name, unit, ?note]),
                    ),
                    Expanded(flex: 2, child: qty),
                    Expanded(flex: 2, child: amount),
                    SizedBox(width: r.s(6)),
                    stack,
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          name,
                          ?note,
                          SizedBox(height: r.s(4)),
                          Row(
                            children: [
                              Expanded(flex: 3, child: _fit(unit, alignment: Alignment.centerLeft)),
                              Expanded(flex: 2, child: qty),
                              Expanded(flex: 3, child: amount),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: r.s(10)),
                    stack,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _stackButton(Responsive r, IconData icon, VoidCallback onTap, String key) => Material(
    color: selected ? Colors.white : const Color(0xFFE8E6EC),
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      key: Key(key),
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: math.max(r.s(84), r.minTap),
        height: r.tap(50),
        child: Icon(icon, size: r.f(28), color: Colors.black),
      ),
    ),
  );
}

class _CartBar extends StatelessWidget {
  const _CartBar({required this.state, required this.t, required this.onOpen});
  final SellState state;
  final TerminalContext t;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Material(
      color: HomeColors.navy,
      child: InkWell(
        key: const Key('openCart'),
        onTap: onOpen,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: r.tap(64)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: r.s(18), vertical: r.s(8)),
            child: Row(
              children: [
                Icon(Icons.shopping_cart_outlined, color: Colors.white, size: r.f(28)),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Text(
                    '${state.cart.itemCount} items · ${state.cart.channel.replaceAll('_', ' ')}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: r.f(20)),
                  ),
                ),
                SizedBox(width: r.s(8)),
                Text(
                  '${t.currency} ${t.money(state.priced?.totalMinor ?? 0)}',
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: r.f(23), fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_up, color: Colors.white, size: r.f(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
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

  /// One menu row: finger-sized, icon and label.
  Widget _item(
    Responsive r,
    String key,
    IconData icon,
    Widget label,
    VoidCallback? onTap, {
    Color? color,
    Widget? trailing,
    double vertical = 17,
  }) => Material(
    color: color ?? Colors.transparent,
    child: InkWell(
      key: Key('menu-$key'),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: r.minTap),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.s(26), vertical: r.s(vertical)),
          child: Row(
            children: [
              Icon(icon, color: _ink, size: r.f(32)),
              SizedBox(width: r.s(26)),
              Expanded(child: label),
              ?trailing,
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final r = context.r;
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
      return _item(
        r,
        key,
        icon,
        Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: r.f(22), letterSpacing: 1.2, color: _ink, fontWeight: FontWeight.w500),
        ),
        group ? () => setState(() => open ? _open.remove(key) : _open.add(key)) : onTap,
        color: group && open ? const Color(0xFFE9E7EE) : null,
        trailing: group
            ? Icon(open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: _ink, size: r.f(32))
            : null,
      );
    }

    Widget sub(String key, IconData icon, String label, VoidCallback onTap) => _item(
      r,
      key,
      icon,
      Text(
        label,
        style: TextStyle(fontSize: r.f(21), letterSpacing: 0.6, color: Colors.black87),
      ),
      onTap,
      vertical: 15,
    );

    final cashier = !t.isCaptain;
    return Drawer(
      width: math.min(r.width * 0.86, math.max(304.0, r.s(400))),
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
                    padding: EdgeInsets.fromLTRB(r.s(26), r.s(22), r.s(26), r.s(18)),
                    color: HomeColors.navy,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.storeName,
                          style: TextStyle(color: Colors.white, fontSize: r.f(25), fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${user.name} · ${t.deviceCode} · ${t.deviceType}',
                          style: TextStyle(color: Colors.white70, fontSize: r.f(18)),
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
              padding: EdgeInsets.symmetric(vertical: r.s(18)),
              child: Text(
                'Terminal ${t.deviceCode}',
                style: TextStyle(fontSize: r.f(16), color: Colors.black54, letterSpacing: 1),
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
    final r = context.r;
    final t = sl<TerminalContextHolder>().ctx;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(r.gutter),
        child: FilledButton.icon(
          key: const Key('openShift'),
          style: FilledButton.styleFrom(
            minimumSize: Size(r.s(240), r.tap(64)),
            padding: EdgeInsets.symmetric(horizontal: r.s(28)),
          ),
          icon: Icon(Icons.play_arrow, size: r.f(30)),
          label: Text('Open shift', style: TextStyle(fontSize: r.f(24))),
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
      ),
    );
  }
}
