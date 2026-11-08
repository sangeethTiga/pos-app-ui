import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/terminal/terminal_context.dart';
import '../../sales/domain/cart.dart';
import '../../sales/domain/order_manager.dart';
import '../../sales/presentation/widgets/home_dialogs.dart' show HomeColors;
import '../../staff/data/staff_repository.dart';
import '../../sync/domain/sync_engine.dart';
import '../../terminal/terminal_cubit.dart';
import 'orders_cubit.dart';

/// Orders Dashboard: running and closed orders by channel, with live timers and auto refresh.
///
/// Phones and short screens scroll the whole page (header, tabs, filters and cards together);
/// taller screens keep the header fixed and scroll only the card grid, whose column count comes
/// from the available width.
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  static const refreshEvery = 30;
  Timer? _tick;
  int _countdown = refreshEvery;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _countdown--);
      if (_countdown <= 0) _refresh();
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _refresh() {
    _countdown = refreshEvery;
    context.read<OrdersCubit>().load();
  }

  Future<void> _open(OrderSummary o) async {
    await context.push(Routes.orderDetail(o.id));
    if (mounted) _refresh();
  }

  Future<void> _merge(OrderSummary source, List<OrderSummary> all) async {
    final user = sl<StaffSession>().user;
    if (!user.can('order.void')) {
      return _toast('${user.name} may not merge bills (needs the order.void permission).');
    }
    final targets = all.where((o) => o.ongoing && o.id != source.id && o.channel == source.channel).toList();
    if (targets.isEmpty) return _toast('No other running order to merge into.');
    final target = await showPosDialog<OrderSummary>(
      context: context,
      maxWidth: 560,
      builder: (ctx) {
        final r = ctx.r;
        return SimpleDialog(
          backgroundColor: HomeColors.dialog,
          insetPadding: EdgeInsets.zero,
          title: Text('Merge ${source.orderNo} into', style: TextStyle(fontSize: r.f(26))),
          children: [
            for (final t in targets)
              SimpleDialogOption(
                key: Key('mergeInto-${t.id}'),
                onPressed: () => Navigator.pop(ctx, t),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: r.minTap),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('${t.orderNo} · ${t.where}', style: TextStyle(fontSize: r.f(20))),
                  ),
                ),
              ),
          ],
        );
      },
    );
    if (target != null && mounted) await context.read<OrdersCubit>().merge(source, target, user.id);
  }

  void _toast(String m) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listenWhen: (a, b) => (b.error != null && a.error != b.error) || (b.info != null && a.info != b.info),
      listener: (_, s) => _toast(s.error ?? s.info!),
      builder: (context, s) => Scaffold(
        backgroundColor: HomeColors.page,
        body: SafeArea(child: ResponsiveBuilder(builder: (context, r) => _body(context, s, r))),
      ),
    );
  }

  Widget _body(BuildContext context, OrdersState s, Responsive r) {
    final cubit = context.read<OrdersCubit>();
    final top = [
      _Header(count: s.ongoingCount, r: r, onBack: () => context.pop()),
      _Tabs(channel: s.channel, r: r, onTap: cubit.channel),
      _toolbar(context, s, r),
    ];
    final grid = _grid(context, s, r);
    // Decided on the whole screen (not the box, which shrinks while the keyboard is open) so the
    // layout does not switch (and the search field keeps its focus) when the keyboard shows.
    final screen = context.r;
    if (screen.isPhone || screen.height < 560) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Column(children: top)),
          grid,
        ],
      );
    }
    return Column(
      children: [
        ...top,
        Expanded(child: CustomScrollView(slivers: [grid])),
      ],
    );
  }

  /// Search, refresh countdown, status filter and legend. On compact screens the filter and the
  /// legend go below the search field; elsewhere the legend shares the filter's row and wraps.
  Widget _toolbar(BuildContext context, OrdersState s, Responsive r) {
    final cubit = context.read<OrdersCubit>();
    final g = r.gutter;
    final search = TextField(
      key: const Key('orderSearch'),
      onChanged: cubit.search,
      style: TextStyle(fontSize: r.f(18)),
      scrollPadding: EdgeInsets.all(r.s(80)),
      decoration: InputDecoration(
        hintText: 'Search order by no.',
        suffixIcon: Icon(Icons.search, size: r.f(30)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: r.s(18), vertical: r.s(18)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.s(18)),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.s(18)),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
    final filter = DropdownButtonFormField<OrderFilter>(
      key: const Key('orderFilter'),
      initialValue: s.filter,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(12)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      ),
      items: const [
        DropdownMenuItem(value: OrderFilter.ongoing, child: Text('Ongoing')),
        DropdownMenuItem(value: OrderFilter.paid, child: Text('Paid')),
        DropdownMenuItem(value: OrderFilter.cancelled, child: Text('Cancelled')),
        DropdownMenuItem(value: OrderFilter.voided, child: Text('Void')),
        DropdownMenuItem(value: OrderFilter.all, child: Text('All')),
      ],
      style: Theme.of(context).textTheme.titleLarge
          ?.copyWith(fontSize: r.f(20), fontWeight: FontWeight.bold, color: Colors.black87),
      onChanged: (f) => cubit.filter(f ?? OrderFilter.ongoing),
    );
    final refresh = IconButton(
      key: const Key('ordersRefresh'),
      iconSize: r.f(32),
      constraints: BoxConstraints(minWidth: r.minTap, minHeight: r.minTap),
      icon: const Icon(Icons.refresh),
      onPressed: _refresh,
    );
    final filterWidth = math.min(r.s(380), r.width - 2 * g);
    return Padding(
      padding: EdgeInsets.fromLTRB(g, r.s(6), g, r.s(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: search),
              if (!r.isCompact) ...[
                SizedBox(width: r.s(60)),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, r.minTap),
                    padding: EdgeInsets.symmetric(horizontal: r.s(20), vertical: r.s(18)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: _refresh,
                  child: Text(
                    'Refresh in 00:${_countdown.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: r.f(18), color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              refresh,
            ],
          ),
          SizedBox(height: r.s(14)),
          if (r.isCompact) ...[
            SizedBox(width: filterWidth, child: filter),
            SizedBox(height: r.s(12)),
            _Legend(r: r),
          ] else
            Row(
              children: [
                SizedBox(width: filterWidth, child: filter),
                SizedBox(width: r.s(24)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _Legend(r: r),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _grid(BuildContext context, OrdersState s, Responsive r) {
    final visible = s.visible;
    if (s.loading || visible.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: EdgeInsets.all(r.s(24)),
          child: Center(
            child: s.loading
                ? const CircularProgressIndicator()
                : Text(
                    'No orders',
                    style: TextStyle(fontSize: r.f(20), color: Colors.black54),
                  ),
          ),
        ),
      );
    }
    final g = r.gutter;
    final gap = r.s(14);
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(g, r.s(4), g, r.s(16)),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: r.columns(r.width - 2 * g + gap, minTileWidth: 414, max: 8),
          mainAxisExtent: _OrderCard.extent(r, MediaQuery.textScalerOf(context)),
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
        ),
        itemCount: visible.length,
        itemBuilder: (_, i) => _OrderCard(
          order: visible[i],
          r: r,
          onTap: () => _open(visible[i]),
          onMerge: () => _merge(visible[i], s.orders),
        ),
      ),
    );
  }
}

/// Gradient header. Expanded and up: one row with the full pills. Medium: one row, the sync pills
/// shrink to icons. Compact: title row, then the pills wrap on a row of their own.
class _Header extends StatelessWidget {
  const _Header({required this.count, required this.r, required this.onBack});
  final int count;
  final Responsive r;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final term = context.watch<TerminalCubit>().state;
    final failed = term.lastReport?.result == SyncResult.failed;
    final synced = term.pending == 0 && !failed;
    final wide = r.cls.index >= ScreenClass.expanded.index;
    final iconOnly = r.isMedium;
    final status = _Pill(
      r: r,
      iconOnly: iconOnly,
      color: synced ? const Color(0xFF66BB6A) : Colors.orange,
      icon: synced ? Icons.cloud_done : Icons.sync_problem,
      label: synced ? 'Synced' : '${term.pending} pending',
    );
    final cloud = InkWell(
      key: const Key('cloudSync'),
      borderRadius: BorderRadius.circular(r.s(22)),
      onTap: term.syncing ? null : () => context.read<TerminalCubit>().syncNow(),
      child: _Pill(
        r: r,
        iconOnly: iconOnly,
        color: const Color(0xFFA43BC2),
        icon: Icons.cloud_download,
        label: term.syncing ? 'Syncing…' : 'Cloud Sync',
      ),
    );
    final counter = Container(
      constraints: BoxConstraints(minHeight: r.minTap),
      padding: EdgeInsets.fromLTRB(r.s(20), r.s(8), r.s(10), r.s(8)),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0FB),
        borderRadius: BorderRadius.circular(r.s(18)),
        border: Border.all(color: const Color(0xFF9EC5F0), width: 3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long, color: const Color(0xFF2F80ED), size: r.f(30)),
          SizedBox(width: r.s(12)),
          Flexible(
            child: Text(
              'Orders:',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: const Color(0xFF1F4E9E), fontSize: r.f(20), fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: r.s(8)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(4)),
            decoration: BoxDecoration(color: const Color(0xFF3B8EEA), borderRadius: BorderRadius.circular(10)),
            child: Text(
              '$count',
              key: const Key('ordersCount'),
              style: TextStyle(color: Colors.white, fontSize: r.f(22), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orders Dashboard',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: r.f(r.isCompact ? 28 : 32), fontWeight: FontWeight.bold),
        ),
        if (wide)
          Text(
            'Manage and track all orders',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: r.f(18)),
          ),
      ],
    );
    final back = Material(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        key: const Key('ordersBack'),
        onTap: onBack,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox.square(
          dimension: r.tap(58),
          child: Icon(Icons.arrow_back, color: Colors.white, size: r.f(30)),
        ),
      ),
    );
    final pillGap = SizedBox(width: r.s(wide ? 30 : 12));
    final titleRow = Row(
      children: [
        back,
        SizedBox(width: r.s(22)),
        Expanded(child: title),
        if (!r.isCompact) ...[pillGap, status, pillGap, cloud, pillGap, counter],
      ],
    );
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(r.s(18), r.s(10), r.s(18), r.s(14)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF223A5C), Color(0xFF3B5578)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(r.s(28))),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: r.isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleRow,
                SizedBox(height: r.s(12)),
                Wrap(
                  spacing: r.s(12),
                  runSpacing: r.s(10),
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [status, cloud, counter],
                ),
              ],
            )
          : titleRow,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.r, required this.color, required this.icon, required this.label, this.iconOnly = false});
  final Responsive r;
  final Color color;
  final IconData icon;
  final String label;
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      constraints: BoxConstraints(minHeight: r.minTap, minWidth: r.minTap),
      padding: EdgeInsets.symmetric(horizontal: iconOnly ? r.s(8) : r.s(18), vertical: r.s(8)),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(r.s(22)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: r.f(26)),
          if (!iconOnly) ...[
            SizedBox(width: r.s(8)),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: r.f(18), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
    return iconOnly ? Tooltip(message: label, child: pill) : pill;
  }
}

/// Channel tabs: equal width when the labels fit, otherwise they scroll horizontally. Below the
/// expanded class the partner tab uses its short label.
class _Tabs extends StatelessWidget {
  const _Tabs({required this.channel, required this.r, required this.onTap});
  final String channel;
  final Responsive r;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final short = r.cls.index < ScreenClass.expanded.index;
    final pad = r.s(12);
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(color: HomeColors.navy, borderRadius: BorderRadius.circular(r.s(26))),
      child: LayoutBuilder(
        builder: (context, c) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final (key, label, value) in [
                ('tabDineIn', 'Dine in', Channel.dineIn),
                ('tabTakeaway', 'Take Away', Channel.takeaway),
                ('tabDelivery', 'Home Delivery', Channel.homeDelivery),
                ('tabPartner', short ? 'Partner' : 'Delivery Partner Order', Channel.partner),
              ])
                InkWell(
                  key: Key(key),
                  onTap: () => onTap(value),
                  borderRadius: BorderRadius.circular(r.s(22)),
                  child: Container(
                    constraints: BoxConstraints(minWidth: c.maxWidth / 4, minHeight: r.tap(64)),
                    padding: EdgeInsets.symmetric(horizontal: r.s(20), vertical: r.s(6)),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: channel == value ? HomeColors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(r.s(22)),
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: r.f(22)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.r});
  final Responsive r;

  Widget _dot(Color? fill) => Container(
    width: r.f(22),
    height: r.f(22),
    decoration: BoxDecoration(
      color: fill,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.black54),
    ),
  );

  Widget _item(Widget mark, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      mark,
      SizedBox(width: r.s(8)),
      Text(
        label,
        style: TextStyle(fontSize: r.f(20), fontWeight: FontWeight.w600),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: r.s(r.isCompact ? 24 : 40),
    runSpacing: r.s(8),
    alignment: r.isCompact ? WrapAlignment.start : WrapAlignment.end,
    children: [
      _item(Icon(Icons.cloud_done, color: const Color(0xFF4CAF50), size: r.f(26)), 'synced'),
      _item(Icon(Icons.sync_problem, color: Colors.orange, size: r.f(26)), 'pending'),
      _item(_dot(Colors.white), 'ongoing'),
      _item(_dot(const Color(0xFF4CAF50)), 'paid'),
      _item(_dot(const Color(0xFFE53935)), 'cancelled'),
      _item(_dot(const Color(0xFFF0A030)), 'void'),
    ],
  );
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.r, required this.onTap, required this.onMerge});
  final OrderSummary order;
  final Responsive r;
  final VoidCallback onTap, onMerge;

  /// Height of a text line of [size] design px.
  static double _line(Responsive r, TextScaler ts, double size) => ts.scale(r.f(size)) * 1.25;

  /// Height of the bottom row (Merge button, total).
  static double _actionsHeight(Responsive r, TextScaler ts) => math.max(r.tap(56), _line(r, ts, 26) + r.s(16));

  /// Grid row height that fits the card's content at this density and text scale.
  static double extent(Responsive r, TextScaler ts) {
    final top = math.max(r.f(26), _line(r, ts, 26));
    final where = math.max(_line(r, ts, 30), _line(r, ts, 20) + r.s(12));
    final when = math.max(_Timer.height(r, ts), 2 * _line(r, ts, 24));
    return r.s(32) + 6 + top + r.s(10) + where + r.s(8) + when + r.s(10) + _actionsHeight(r, ts);
  }

  @override
  Widget build(BuildContext context) {
    final t = sl<TerminalContextHolder>().ctx;
    final ts = MediaQuery.textScalerOf(context);
    final o = order;
    final at = o.openedAt;
    final end = o.ongoing ? DateTime.now() : (o.closedAt ?? DateTime.now());
    final elapsed = at == null ? Duration.zero : end.difference(at);
    final stateColor = switch (o.state) {
      'paid' => const Color(0xFF4CAF50),
      'cancelled' => const Color(0xFFE53935),
      'void' => const Color(0xFFF0A030),
      _ => null,
    };
    final radius = BorderRadius.circular(r.s(24));
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: Colors.grey.shade300, width: 3),
      ),
      child: InkWell(
        key: Key('order-${o.id}'),
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(r.s(22), r.s(16), r.s(22), r.s(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    o.synced ? Icons.cloud_done : Icons.sync_problem,
                    color: o.synced ? const Color(0xFF4CAF50) : Colors.orange,
                    size: r.f(26),
                  ),
                  SizedBox(width: r.s(18)),
                  Expanded(
                    child: Text(
                      o.orderNo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: r.f(26), fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (stateColor != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(3)),
                      decoration: BoxDecoration(color: stateColor, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        o.state.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: r.f(16)),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  if (o.captainName != null) ...[
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(6)),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CB85C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          o.captainName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: r.f(20)),
                        ),
                      ),
                    ),
                    SizedBox(width: r.s(10)),
                  ],
                  Expanded(
                    child: Text(
                      o.where,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: const Color(0xFFF07F3C), fontSize: r.f(30), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: r.s(8)),
              Row(
                children: [
                  // Date and time break onto two lines on narrow cards.
                  Expanded(
                    child: Text(
                      at == null ? '' : _dateTime(at),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: r.f(24)),
                    ),
                  ),
                  _Timer(elapsed, r: r),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: _actionsHeight(r, ts),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (o.ongoing) ...[
                      FilledButton(
                        key: Key('merge-${o.id}'),
                        style: FilledButton.styleFrom(
                          backgroundColor: HomeColors.navy,
                          padding: EdgeInsets.symmetric(horizontal: r.s(26)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: onMerge,
                        child: Text('Merge', style: TextStyle(fontSize: r.f(20))),
                      ),
                      SizedBox(width: r.s(12)),
                    ],
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: r.s(22), vertical: r.s(4)),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade400, width: 2),
                        ),
                        // The amount must stay whole: it shrinks rather than being cut off.
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Total: ${t.currency} ${t.money(o.totalMinor)}',
                            maxLines: 1,
                            style: TextStyle(fontSize: r.f(26), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _dateTime(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}  '
        '$h:${d.minute.toString().padLeft(2, '0')} ${d.hour < 12 ? 'AM' : 'PM'}';
  }
}

/// HH MM SS bubbles of the time since the order was placed.
class _Timer extends StatelessWidget {
  const _Timer(this.elapsed, {required this.r});
  final Duration elapsed;
  final Responsive r;

  /// Bubble diameter: the design size, grown with the text scale so two digits always fit.
  static double _bubble(Responsive r, TextScaler ts) => math.max(r.f(36), ts.scale(r.f(16)) * 1.25 + r.s(8));

  static double height(Responsive r, TextScaler ts) => _bubble(r, ts) + ts.scale(r.f(12)) * 1.25;

  @override
  Widget build(BuildContext context) {
    final d = _bubble(r, MediaQuery.textScalerOf(context));
    final parts = [elapsed.inHours, elapsed.inMinutes % 60, elapsed.inSeconds % 60];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (i, label) in ['HH', 'MM', 'SS'].indexed)
          Padding(
            padding: EdgeInsets.only(left: r.s(6)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: d,
                  height: d,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Color(0xFFE5483B), shape: BoxShape.circle),
                  child: Text(
                    parts[i].clamp(0, 99).toString().padLeft(2, '0'),
                    maxLines: 1,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: r.f(16)),
                  ),
                ),
                Text(label, style: TextStyle(fontSize: r.f(12))),
              ],
            ),
          ),
      ],
    );
  }
}
