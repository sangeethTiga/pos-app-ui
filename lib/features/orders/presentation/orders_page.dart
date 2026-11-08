import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/terminal/terminal_context.dart';
import '../../sales/domain/cart.dart';
import '../../sales/domain/order_manager.dart';
import '../../sales/presentation/widgets/home_dialogs.dart';
import '../../staff/data/staff_repository.dart';
import '../../sync/domain/sync_engine.dart';
import '../../terminal/terminal_cubit.dart';
import 'orders_cubit.dart';

/// Orders Dashboard: running and closed orders by channel, with live timers and auto refresh.
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
    final target = await showDialog<OrderSummary>(
      context: context,
      builder: (ctx) => scaledForHome(
        ctx,
        SimpleDialog(
          backgroundColor: HomeColors.dialog,
          title: Text('Merge ${source.orderNo} into'),
          children: [
            for (final t in targets)
              SimpleDialogOption(
                key: Key('mergeInto-${t.id}'),
                onPressed: () => Navigator.pop(ctx, t),
                child: Text('${t.orderNo} · ${t.where}', style: const TextStyle(fontSize: 20)),
              ),
          ],
        ),
      ),
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
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) => c.maxWidth < 700
                ? _body(context, s, phone: true)
                : scaledForHome(context, Material(color: HomeColors.page, child: _body(context, s, phone: false))),
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, OrdersState s, {required bool phone}) {
    final cubit = context.read<OrdersCubit>();
    final visible = s.visible;
    return Column(
      children: [
        _Header(count: s.ongoingCount, phone: phone, onBack: () => context.pop()),
        _Tabs(channel: s.channel, phone: phone, onTap: cubit.channel),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('orderSearch'),
                  onChanged: cubit.search,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Search order by no.',
                    suffixIcon: const Icon(Icons.search, size: 30),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
              ),
              if (!phone) ...[
                const SizedBox(width: 60),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: _refresh,
                  child: Text(
                    'Refresh in 00:${_countdown.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              IconButton(
                key: const Key('ordersRefresh'),
                icon: const Icon(Icons.refresh, size: 32),
                onPressed: _refresh,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          child: Row(
            children: [
              SizedBox(
                width: phone ? 200 : 380,
                child: DropdownButtonFormField<OrderFilter>(
                  key: const Key('orderFilter'),
                  initialValue: s.filter,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                      ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  onChanged: (f) => cubit.filter(f ?? OrderFilter.ongoing),
                ),
              ),
              const SizedBox(width: 24),
              if (!phone) const Spacer(),
              if (!phone) const _Legend(),
            ],
          ),
        ),
        Expanded(
          child: s.loading
              ? const Center(child: CircularProgressIndicator())
              : visible.isEmpty
              ? const Center(
                  child: Text('No orders', style: TextStyle(fontSize: 20, color: Colors.black54)),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: phone ? 520 : 460,
                    mainAxisExtent: 262,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: visible.length,
                  itemBuilder: (_, i) => _OrderCard(
                    order: visible[i],
                    onTap: () => _open(visible[i]),
                    onMerge: () => _merge(visible[i], s.orders),
                  ),
                ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count, required this.phone, required this.onBack});
  final int count;
  final bool phone;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final term = context.watch<TerminalCubit>().state;
    final failed = term.lastReport?.result == SyncResult.failed;
    final synced = term.pending == 0 && !failed;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(18, 10, 18, phone ? 10 : 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF223A5C), Color(0xFF3B5578)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              key: const Key('ordersBack'),
              onTap: onBack,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orders Dashboard',
                  style: TextStyle(color: Colors.white, fontSize: phone ? 22 : 32, fontWeight: FontWeight.bold),
                ),
                if (!phone)
                  const Text('Manage and track all orders', style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
          if (!phone) ...[
            _Pill(
              color: synced ? const Color(0xFF66BB6A) : Colors.orange,
              icon: synced ? Icons.cloud_done : Icons.sync_problem,
              label: synced ? 'Synced' : '${term.pending} pending',
            ),
            const SizedBox(width: 30),
            InkWell(
              key: const Key('cloudSync'),
              onTap: term.syncing ? null : () => context.read<TerminalCubit>().syncNow(),
              child: _Pill(
                color: const Color(0xFFA43BC2),
                icon: Icons.cloud_download,
                label: term.syncing ? 'Syncing…' : 'Cloud Sync',
              ),
            ),
            const SizedBox(width: 30),
          ],
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F0FB),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF9EC5F0), width: 3),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long, color: Color(0xFF2F80ED), size: 30),
                const SizedBox(width: 12),
                const Text(
                  'Orders:',
                  style: TextStyle(color: Color(0xFF1F4E9E), fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF3B8EEA), borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '$count',
                    key: const Key('ordersCount'),
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.color, required this.icon, required this.label});
  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10)],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.channel, required this.phone, required this.onTap});
  final String channel;
  final bool phone;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: HomeColors.navy, borderRadius: BorderRadius.circular(26)),
    child: Row(
      children: [
        for (final (key, label, value) in [
          ('tabDineIn', 'Dine in', Channel.dineIn),
          ('tabTakeaway', 'Take Away', Channel.takeaway),
          ('tabDelivery', 'Home Delivery', Channel.homeDelivery),
          ('tabPartner', phone ? 'Partner' : 'Delivery Partner Order', Channel.partner),
        ])
          Expanded(
            child: InkWell(
              key: Key(key),
              onTap: () => onTap(value),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                height: phone ? 46 : 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: channel == value ? HomeColors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(color: Colors.white, fontSize: phone ? 15 : 22),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class _Legend extends StatelessWidget {
  const _Legend();

  Widget _dot(Color? fill, {Color border = Colors.black54}) => Container(
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      color: fill,
      shape: BoxShape.circle,
      border: Border.all(color: border),
    ),
  );

  Widget _item(Widget mark, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      mark,
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    ],
  );

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 40,
    runSpacing: 8,
    children: [
      _item(const Icon(Icons.cloud_done, color: Color(0xFF4CAF50), size: 26), 'synced'),
      _item(const Icon(Icons.sync_problem, color: Colors.orange, size: 26), 'pending'),
      _item(_dot(Colors.white), 'ongoing'),
      _item(_dot(const Color(0xFF4CAF50)), 'paid'),
      _item(_dot(const Color(0xFFE53935)), 'cancelled'),
      _item(_dot(const Color(0xFFF0A030)), 'void'),
    ],
  );
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap, required this.onMerge});
  final OrderSummary order;
  final VoidCallback onTap, onMerge;

  @override
  Widget build(BuildContext context) {
    final t = sl<TerminalContextHolder>().ctx;
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
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.grey.shade300, width: 3),
      ),
      child: InkWell(
        key: Key('order-${o.id}'),
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    o.synced ? Icons.cloud_done : Icons.sync_problem,
                    color: o.synced ? const Color(0xFF4CAF50) : Colors.orange,
                    size: 26,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(o.orderNo, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  ),
                  if (stateColor != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: stateColor, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        o.state.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  if (o.captainName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFF5CB85C), borderRadius: BorderRadius.circular(4)),
                      child: Text(o.captainName!, style: const TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      o.where,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFFF07F3C), fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Text(at == null ? '' : _dateTime(at), style: const TextStyle(fontSize: 24))),
                  _Timer(elapsed),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  if (o.ongoing) ...[
                    FilledButton(
                      key: Key('merge-${o.id}'),
                      style: FilledButton.styleFrom(
                        backgroundColor: HomeColors.navy,
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: onMerge,
                      child: const Text('Merge', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade400, width: 2),
                      ),
                      child: Text(
                        'Total: ${t.currency} ${t.money(o.totalMinor)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
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
  const _Timer(this.elapsed);
  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final parts = [elapsed.inHours, elapsed.inMinutes % 60, elapsed.inSeconds % 60];
    return Row(
      children: [
        for (final (i, label) in ['HH', 'MM', 'SS'].indexed)
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Color(0xFFE5483B), shape: BoxShape.circle),
                  child: Text(
                    parts[i].clamp(0, 99).toString().padLeft(2, '0'),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(label, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
      ],
    );
  }
}
