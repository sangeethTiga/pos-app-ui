import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme.dart';
import '../../../../core/responsive/pos_popup.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/widgets/money_field.dart';
import '../../data/home_repository.dart';
import '../../domain/cart.dart';
import '../../domain/order_service.dart';

/// Colours of the home screen (match the reference POS).
abstract final class HomeColors {
  static const navy = Color(0xFF1E3A5C);
  static const blue = Color(0xFF3A80AF);
  static const green = Color(0xFF5CB85C);
  static const tableGreen = Color(0xFF5CBF6E);
  static const tableBusy = Color(0xFFE57373);
  static const grey = Color(0xFFA2ACBB);
  static const quick = Color(0xFF8A97A8);
  static const place = Color(0xFFF07F4F);
  static const red = Color(0xFFE2533F);
  static const dialog = Color(0xFFEDE9F1);
  static const page = Color(0xFFFCF8FD);
}

/// Font size token for [designPx], never below a readable 14.
double _font(Responsive r, double designPx) => posFont(r, designPx);

/// Shows a big popup (Choose Table, Customer Details): the whole screen on phones (portrait and
/// landscape), elsewhere a card filling the screen up to a cap.
Future<T?> _showLarge<T>(BuildContext context, WidgetBuilder builder) => showDialog<T>(
  context: context,
  builder: (ctx) {
    final r = ctx.r;
    final body = posDialogTheme(ctx, Builder(builder: builder));
    if (r.isPhone) {
      return Dialog.fullscreen(
        backgroundColor: HomeColors.dialog,
        child: SafeArea(child: body),
      );
    }
    return Dialog(
      backgroundColor: HomeColors.dialog,
      insetPadding: EdgeInsets.all(r.gutter * 1.5),
      constraints: BoxConstraints(minWidth: 280, maxWidth: r.s(1800)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: body,
    );
  },
);

/// Text style of popup buttons: the theme's button text at [designPx].
TextStyle? _buttonText(BuildContext context, double designPx) =>
    Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: _font(context.r, designPx));

ButtonStyle _navyButton(BuildContext context) {
  final r = context.r;
  return FilledButton.styleFrom(
    backgroundColor: HomeColors.navy,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    padding: EdgeInsets.symmetric(horizontal: r.s(28)),
    minimumSize: Size(r.s(100), r.tap(58)),
    textStyle: _buttonText(context, 18),
  );
}

/// Cancel | Ok row of the small popups (Select Captain, Delivery Partners).
Widget _cancelOk(BuildContext context, Responsive r, {required VoidCallback? onOk}) {
  final style = TextButton.styleFrom(minimumSize: Size(0, r.tap(56)), textStyle: _buttonText(context, 21));
  return Row(
    children: [
      Expanded(
        child: TextButton(
          key: const Key('dialogCancel'),
          style: style,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: PosColors.accent)),
        ),
      ),
      Container(width: 1, height: r.s(36), color: Colors.grey),
      Expanded(
        child: TextButton(
          key: const Key('dialogOk'),
          style: style,
          onPressed: onOk,
          child: const Text('Ok', style: TextStyle(color: PosColors.accent)),
        ),
      ),
    ],
  );
}

/// Bordered card of the small choice popups: [title], a scrolling [body], Cancel | Ok.
Widget _choicePopup(
  BuildContext context, {
  required Widget title,
  required Widget body,
  required VoidCallback? onOk,
  double top = 22,
}) {
  final r = context.r;
  return Dialog(
    backgroundColor: HomeColors.dialog,
    insetPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: HomeColors.navy),
    ),
    child: Padding(
      padding: EdgeInsets.fromLTRB(r.s(28), r.s(top), r.s(28), r.s(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          SizedBox(height: r.s(20)),
          Flexible(child: SingleChildScrollView(child: body)),
          SizedBox(height: r.s(12)),
          _cancelOk(context, r, onOk: onOk),
        ],
      ),
    ),
  );
}

// ---- Choose Table ----------------------------------------------------------------------------

typedef TableChoice = ({DiningTableInfo table, int guests, OpenOrder? running});

Future<TableChoice?> showChooseTable(
  BuildContext context, {
  required List<DiningTableInfo> tables,
  required List<OpenOrder> openOrders,
  String? selectedTableId,
}) => _showLarge<TableChoice>(
  context,
  (_) => _ChooseTable(tables: tables, openOrders: openOrders, selectedTableId: selectedTableId),
);

class _ChooseTable extends StatefulWidget {
  const _ChooseTable({required this.tables, required this.openOrders, this.selectedTableId});
  final List<DiningTableInfo> tables;
  final List<OpenOrder> openOrders;
  final String? selectedTableId;

  @override
  State<_ChooseTable> createState() => _ChooseTableState();
}

class _ChooseTableState extends State<_ChooseTable> {
  bool _occupiedView = false;
  String? _selected;
  final _pax = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedTableId;
    for (final t in widget.tables) {
      _pax[t.id] = TextEditingController(text: '1');
    }
  }

  @override
  void dispose() {
    for (final c in _pax.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<OpenOrder> _ordersAt(String tableId) => widget.openOrders.where((o) => o.tableId == tableId).toList();

  int _available(DiningTableInfo t) {
    final used = _ordersAt(t.id).fold(0, (s, o) => s + o.guests);
    return (t.capacity - used).clamp(0, t.capacity);
  }

  void _ok() {
    final t = widget.tables.where((t) => t.id == _selected).firstOrNull;
    if (t == null) return;
    final guests = int.tryParse(_pax[t.id]!.text.trim()) ?? 1;
    final running = _ordersAt(t.id).firstOrNull;
    Navigator.pop<TableChoice>(context, (table: t, guests: guests < 1 ? 1 : guests, running: running));
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final shown = widget.tables.where((t) => _ordersAt(t.id).isNotEmpty == _occupiedView).toList();
    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Table',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: _font(r, 28), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: r.s(12)),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: r.s(8),
            children: [
              RadioGroup<bool>(
                groupValue: _occupiedView,
                onChanged: (v) => setState(() => _occupiedView = v ?? false),
                child: Wrap(
                  spacing: r.s(40),
                  children: [
                    for (final (v, label) in [(false, 'Un Occupied'), (true, 'Occupied')])
                      InkWell(
                        key: Key(v ? 'occupiedTab' : 'unoccupiedTab'),
                        onTap: () => setState(() => _occupiedView = v),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<bool>(value: v, activeColor: PosColors.accent),
                            Flexible(
                              child: Text(label, style: TextStyle(fontSize: _font(r, 26))),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              TextButton.icon(
                key: const Key('clearTables'),
                onPressed: () => setState(() {
                  _selected = null;
                  for (final c in _pax.values) {
                    c.text = '1';
                  }
                }),
                iconAlignment: IconAlignment.end,
                icon: Icon(Icons.sort, color: Colors.black87, size: _font(r, 24)),
                label: Text(
                  'Clear all tables',
                  style: TextStyle(color: Colors.black87, fontSize: _font(r, 16)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: r.s(12)),
      ],
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(r.gutter, r.gutter, r.gutter, r.s(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: header),
                if (shown.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        _occupiedView ? 'No occupied tables' : 'No free tables',
                        style: TextStyle(fontSize: _font(r, 20)),
                      ),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: TileGrid(
                      minTileWidth: 300,
                      spacing: 24,
                      children: [for (final t in shown) _tableCard(t, r)],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: r.s(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: FilledButton(
                  key: const Key('tableCancel'),
                  style: _navyButton(context).copyWith(backgroundColor: const WidgetStatePropertyAll(HomeColors.red)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ),
              SizedBox(width: r.s(20)),
              Flexible(
                child: FilledButton(
                  key: const Key('tableOk'),
                  style: _navyButton(context),
                  onPressed: _selected == null ? null : _ok,
                  child: const Text('ok', maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableCard(DiningTableInfo t, Responsive r) {
    final orders = _ordersAt(t.id);
    final selected = _selected == t.id;
    final line = TextStyle(fontSize: _font(r, 19));
    final pax = TextStyle(fontSize: _font(r, 21), fontWeight: FontWeight.bold);
    return InkWell(
      key: Key('table-${t.id}'),
      onTap: () => setState(() => _selected = t.id),
      child: Container(
        constraints: BoxConstraints(minHeight: r.s(205)),
        padding: EdgeInsets.fromLTRB(r.s(22), r.s(18), r.s(16), r.s(14)),
        decoration: BoxDecoration(
          color: orders.isEmpty ? HomeColors.tableGreen : HomeColors.tableBusy,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: selected ? HomeColors.navy : Colors.transparent, width: math.max(3, r.s(4))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    'Table ${t.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: _font(r, 28), fontWeight: FontWeight.bold),
                  ),
                ),
                if (t.area != null) ...[
                  const SizedBox(width: 4),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        t.area!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: _font(r, 15)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: r.s(10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Available Seats : ${_available(t)}', maxLines: 1, overflow: TextOverflow.ellipsis, style: line),
                SizedBox(height: r.s(6)),
                Text(
                  orders.isEmpty
                      ? 'Table Capacity : ${t.capacity}'
                      : 'Order ${orders.map((o) => o.orderNo).join(', ')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: line,
                ),
              ],
            ),
            SizedBox(height: r.s(10)),
            Row(
              children: [
                Text('PAX:', style: pax),
                SizedBox(width: r.s(24)),
                Expanded(
                  child: TextField(
                    key: Key('pax-${t.id}'),
                    controller: _pax[t.id],
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onTap: () => setState(() => _selected = t.id),
                    style: TextStyle(fontSize: _font(r, 21)),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      constraints: BoxConstraints(minHeight: r.minTap),
                      contentPadding: EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(10)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Select Captain ---------------------------------------------------------------------------

Future<CaptainInfo?> showSelectCaptain(BuildContext context, List<CaptainInfo> captains, {String? selectedId}) {
  String? selected = selectedId;
  return showPosPopup<CaptainInfo>(
    context,
    maxWidth: 620,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, set) {
        final r = ctx.r;
        return _choicePopup(
          ctx,
          title: Text(
            'Select Captain',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: _font(r, 22), fontWeight: FontWeight.bold),
          ),
          body: captains.isEmpty
              ? const Text('No captain accounts in this store.', textAlign: TextAlign.center)
              : TileGrid(
                  minTileWidth: 150,
                  spacing: 20,
                  children: [
                    for (final c in captains)
                      Material(
                        color: selected == c.id ? HomeColors.navy : const Color(0xFF9E9E9E),
                        child: InkWell(
                          key: Key('captain-${c.id}'),
                          onTap: () => set(() => selected = c.id),
                          child: Container(
                            constraints: BoxConstraints(minHeight: r.tap(56)),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: r.s(16), vertical: r.s(10)),
                            child: Text(
                              c.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: _font(r, 21),
                                color: selected == c.id ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
          onOk: selected == null ? null : () => Navigator.pop(ctx, captains.firstWhere((c) => c.id == selected)),
        );
      },
    ),
  );
}

// ---- Delivery Partners -------------------------------------------------------------------------

typedef PartnerChoice = ({DeliveryPartnerInfo partner, String orderNo});

Future<PartnerChoice?> showDeliveryPartners(
  BuildContext context,
  List<DeliveryPartnerInfo> partners, {
  String? selectedId,
  String? orderNo,
}) {
  String? selected = selectedId;
  final no = TextEditingController(text: orderNo ?? '');
  return showPosPopup<PartnerChoice>(
    context,
    maxWidth: 760,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, set) {
        final r = ctx.r;
        return _choicePopup(
          ctx,
          top: 24,
          title: Text('Delivery Partners', style: TextStyle(fontSize: _font(r, 26))),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (partners.isEmpty)
                const Text('No delivery partners. Add them in the admin panel.')
              else
                TileGrid(
                  minTileWidth: 150,
                  children: [
                    for (final p in partners)
                      OutlinedButton(
                        key: Key('partner-${p.id}'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: selected == p.id ? HomeColors.navy : Colors.white,
                          foregroundColor: selected == p.id ? Colors.white : HomeColors.navy,
                          side: const BorderSide(color: HomeColors.navy),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          minimumSize: Size(0, r.tap(64)),
                          padding: EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(10)),
                        ),
                        onPressed: () => set(() => selected = p.id),
                        child: Text(
                          p.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: _font(r, 24)),
                        ),
                      ),
                  ],
                ),
              SizedBox(height: r.s(18)),
              TextField(
                key: const Key('partnerOrderNo'),
                controller: no,
                style: TextStyle(fontSize: _font(r, 20)),
                decoration: InputDecoration(
                  labelText: 'Order Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          onOk: selected == null
              ? null
              : () => Navigator.pop<PartnerChoice>(ctx, (
                  partner: partners.firstWhere((p) => p.id == selected),
                  orderNo: no.text.trim(),
                )),
        );
      },
    ),
  );
}

// ---- Customer Details --------------------------------------------------------------------------

typedef CustomerChoice = ({CustomerInfo customer, bool carhop, String? carNo});

Future<CustomerChoice?> showCustomerDetails(
  BuildContext context, {
  required HomeRepository repo,
  required String userId,
  String? selectedId,
}) => _showLarge<CustomerChoice>(context, (_) => _CustomerDetails(repo: repo, userId: userId, selectedId: selectedId));

class _CustomerDetails extends StatefulWidget {
  const _CustomerDetails({required this.repo, required this.userId, this.selectedId});
  final HomeRepository repo;
  final String userId;
  final String? selectedId;

  @override
  State<_CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<_CustomerDetails> {
  final _form = GlobalKey<FormState>();
  final _search = TextEditingController();
  final _mobile = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _flat = TextEditingController();
  final _building = TextEditingController();
  final _street = TextEditingController();
  final _city = TextEditingController();
  final _carNo = TextEditingController();
  bool _carhop = false;
  String? _area;
  List<String> _areas = const [];
  List<CustomerInfo> _results = const [];
  CustomerInfo? _current;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final areas = await widget.repo.deliveryAreas();
    final all = await widget.repo.customers();
    if (!mounted) return;
    setState(() {
      _areas = areas;
      _results = all;
    });
    final sel = all.where((c) => c.id == widget.selectedId).firstOrNull;
    if (sel != null) _fill(sel);
  }

  Future<void> _find(String q) async {
    final r = await widget.repo.customers(query: q);
    if (mounted) setState(() => _results = r);
  }

  void _fill(CustomerInfo c) => setState(() {
    _current = c;
    _mobile.text = c.mobile ?? '';
    _name.text = c.name;
    _email.text = c.email ?? '';
    _flat.text = c.address?.flat ?? '';
    _building.text = c.address?.building ?? '';
    _street.text = c.address?.street ?? '';
    _city.text = c.address?.city ?? '';
    _area = _areas.contains(c.address?.area) ? c.address?.area : null;
    _error = null;
  });

  void _new() => setState(() {
    _current = null;
    for (final c in [_mobile, _name, _email, _flat, _building, _street, _city]) {
      c.clear();
    }
    _area = null;
    _error = null;
  });

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final saved = await widget.repo.saveCustomer(
        id: _current?.id,
        name: _name.text,
        mobile: _mobile.text,
        email: _email.text,
        address: CustomerAddress(
          id: _current?.address?.id,
          flat: _flat.text,
          building: _building.text,
          street: _street.text,
          city: _city.text,
          area: _area,
        ),
        userId: widget.userId,
      );
      if (!mounted) return;
      Navigator.pop<CustomerChoice>(context, (customer: saved, carhop: _carhop, carNo: _carNo.text.trim()));
    } on Object catch (e) {
      setState(() {
        _saving = false;
        _error = 'Could not save: $e';
      });
    }
  }

  @override
  void dispose() {
    for (final c in [_search, _mobile, _name, _email, _flat, _building, _street, _city, _carNo]) {
      c.dispose();
    }
    super.dispose();
  }

  InputDecoration _dec(Responsive r, String label) => InputDecoration(
    hintText: label,
    hintStyle: TextStyle(fontSize: _font(r, 19), color: Colors.grey.shade600),
    filled: true,
    fillColor: HomeColors.dialog,
    contentPadding: EdgeInsets.symmetric(horizontal: r.s(28), vertical: r.s(20)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
  );

  /// One form field with the gap above it.
  Widget _field(
    Responsive r,
    TextEditingController c,
    String label, {
    Key? key,
    TextInputType? keyboard,
    FormFieldValidator<String>? validator,
  }) => Padding(
    padding: EdgeInsets.only(top: r.s(14)),
    child: TextFormField(
      key: key,
      controller: c,
      keyboardType: keyboard,
      style: TextStyle(fontSize: _font(r, 19)),
      decoration: _dec(r, label),
      validator: validator,
    ),
  );

  String? _required(String? v) => v == null || v.trim().isEmpty ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Padding(
      padding: EdgeInsets.fromLTRB(r.gutter, r.s(12), r.gutter, r.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Customer Details',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: _font(r, 32)),
                ),
              ),
              IconButton(
                key: const Key('customerClose'),
                icon: Icon(Icons.close, size: math.max(24, r.f(30))),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          RadioGroup<bool>(
            groupValue: _carhop,
            onChanged: (v) => setState(() => _carhop = v ?? false),
            child: Wrap(
              spacing: r.pick(compact: 16.0, medium: r.s(120), expanded: r.s(200)),
              children: [
                for (final (v, label) in [(false, 'Normal'), (true, 'Carhop')])
                  InkWell(
                    key: Key(v ? 'carhop' : 'normal'),
                    onTap: () => setState(() => _carhop = v),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<bool>(value: v, activeColor: PosColors.accent),
                        Flexible(
                          child: Text(label, style: TextStyle(fontSize: _font(r, 20))),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: r.s(8)),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) => c.maxWidth >= Breakpoints.expanded
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _list(r)),
                        SizedBox(width: r.s(24)),
                        Expanded(flex: 2, child: SingleChildScrollView(child: _formPanel(r))),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: (r.height * 0.5).clamp(240.0, 480.0), child: _list(r)),
                          SizedBox(height: r.s(16)),
                          _formPanel(r),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _list(Responsive r) {
    final head = TextStyle(fontSize: _font(r, 24));
    final cell = TextStyle(fontSize: _font(r, 18));
    final small = TextStyle(fontSize: _font(r, 16), color: Colors.black54);
    return Column(
      children: [
        TextField(
          key: const Key('customerSearch'),
          controller: _search,
          autofocus: !r.isPhone,
          onChanged: _find,
          style: TextStyle(fontSize: _font(r, 19)),
          decoration: _dec(r, 'Search Customer Mobile Number or Name').copyWith(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.search, color: HomeColors.navy, size: math.max(24, r.f(30))),
            ),
          ),
        ),
        SizedBox(height: r.s(16)),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: LayoutBuilder(
              builder: (context, c) {
                // Narrow: one stacked row per customer instead of three squeezed columns.
                final table = c.maxWidth >= Breakpoints.medium;
                return Column(
                  children: [
                    if (table) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(18)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Customer', style: head, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                            Expanded(
                              child: Text('Mobile', style: head, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Address', style: head, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade400),
                    ],
                    Expanded(
                      child: ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (_, i) {
                          final c = _results[i];
                          return Material(
                            color: _current?.id == c.id ? HomeColors.navy.withValues(alpha: 0.12) : Colors.transparent,
                            child: InkWell(
                              key: Key('customer-${c.id}'),
                              onTap: () => _fill(c),
                              child: Container(
                                constraints: BoxConstraints(minHeight: r.minTap),
                                padding: EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(12)),
                                child: table
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              c.name,
                                              style: cell,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              c.mobile ?? '',
                                              style: cell,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              c.address?.oneLine ?? '',
                                              style: small,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(c.name, style: cell, maxLines: 1, overflow: TextOverflow.ellipsis),
                                          Text(
                                            [
                                              c.mobile,
                                              c.address?.oneLine,
                                            ].where((v) => v != null && v.isNotEmpty).join(' · '),
                                            style: small,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _formPanel(Responsive r) => Form(
    key: _form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(_current == null ? 'Add new Customer:-' : 'Customer:-', style: TextStyle(fontSize: _font(r, 24))),
        _field(
          r,
          _mobile,
          'Mobile Number*',
          key: const Key('customerMobile'),
          keyboard: TextInputType.phone,
          validator: _required,
        ),
        _field(r, _name, 'Name*', key: const Key('customerName'), validator: _required),
        _field(r, _email, 'Email', keyboard: TextInputType.emailAddress),
        if (_carhop) _field(r, _carNo, 'Car Number*', key: const Key('carNo'), validator: _required),
        _field(r, _flat, 'Flat'),
        _field(r, _building, 'Building No/Name'),
        _field(r, _street, 'Street'),
        _field(r, _city, 'City'),
        SizedBox(height: r.s(26)),
        DropdownButtonFormField<String>(
          key: ValueKey('area-$_area-${_areas.length}'),
          initialValue: _area,
          hint: const Text('Select an area'),
          isExpanded: true,
          items: [
            for (final a in _areas)
              DropdownMenuItem(
                value: a,
                child: Text(a, overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: (v) => setState(() => _area = v),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: r.s(24), vertical: r.s(20)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        if (_error != null) ...[SizedBox(height: r.s(10)), Text(_error!, style: const TextStyle(color: Colors.red))],
        SizedBox(height: r.s(18)),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                key: const Key('customerNew'),
                style: _navyButton(context),
                onPressed: _saving ? null : _new,
                child: const Text('New'),
              ),
            ),
            SizedBox(width: r.s(24)),
            Expanded(
              child: FilledButton(
                key: const Key('customerSave'),
                style: _navyButton(context),
                onPressed: _saving ? null : _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// ---- small dialogs -------------------------------------------------------------------------------

Future<String?> showKitchenNote(BuildContext context, String? current) {
  final c = TextEditingController(text: current ?? '');
  return showPosPopup<String>(
    context,
    maxWidth: 560,
    builder: (ctx) => posAlert(
      ctx,
      backgroundColor: HomeColors.dialog,
      title: const Text('Kitchen Note'),
      content: TextField(
        key: const Key('kitchenNoteField'),
        controller: c,
        autofocus: true,
        maxLines: 4,
        decoration: const InputDecoration(hintText: 'e.g. less spicy, no onion', border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(
          key: const Key('kitchenNoteSave'),
          style: _navyButton(ctx),
          onPressed: () => Navigator.pop(ctx, c.text),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

/// Order discount in percent; [maxBp] is the user's limit (BR-09).
Future<int?> showDiscount(BuildContext context, {required int currentBp, required int maxBp}) {
  final c = TextEditingController(
    text: currentBp == 0 ? '' : (currentBp / 100).toStringAsFixed(currentBp % 100 == 0 ? 0 : 2),
  );
  String? error;
  return showPosPopup<int>(
    context,
    maxWidth: 560,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, set) {
        final r = ctx.r;
        void apply(String v) {
          final pct = double.tryParse(v.trim().isEmpty ? '0' : v.trim());
          final bp = pct == null ? null : (pct * 100).round();
          if (bp == null || bp < 0 || bp > 10000) return set(() => error = 'Enter 0 to 100');
          if (bp > maxBp) return set(() => error = 'Your limit is ${(maxBp / 100).toStringAsFixed(0)}%');
          Navigator.pop(ctx, bp);
        }

        return posAlert(
          ctx,
          backgroundColor: HomeColors.dialog,
          title: const Text('Discount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final p in [5, 10, 15, 20, 25])
                    OutlinedButton(
                      key: Key('discount-$p'),
                      onPressed: () => apply('$p'),
                      child: Text('$p%', style: TextStyle(fontSize: _font(r, 18))),
                    ),
                ],
              ),
              SizedBox(height: r.s(16)),
              TextField(
                key: const Key('discountField'),
                controller: c,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Discount %',
                  errorText: error,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: apply,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, 0), child: const Text('Remove discount')),
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(style: _navyButton(ctx), onPressed: () => apply(c.text), child: const Text('Apply')),
          ],
        );
      },
    ),
  );
}

typedef OpenFoodItem = ({String name, int priceMinor, int qty});

Future<OpenFoodItem?> showOpenFood(BuildContext context, {required int decimals}) {
  final name = TextEditingController();
  final price = TextEditingController();
  final qty = TextEditingController(text: '1');
  final form = GlobalKey<FormState>();
  return showPosPopup<OpenFoodItem>(
    context,
    maxWidth: 560,
    builder: (ctx) => posAlert(
      ctx,
      backgroundColor: HomeColors.dialog,
      title: const Text('Open Food'),
      content: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const Key('openFoodName'),
              controller: name,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Item name*'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            SizedBox(height: ctx.r.s(12)),
            MoneyField(key: const Key('openFoodPrice'), controller: price, label: 'Price*'),
            SizedBox(height: ctx.r.s(12)),
            TextFormField(
              controller: qty,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Qty'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(
          key: const Key('openFoodAdd'),
          style: _navyButton(ctx),
          onPressed: () {
            final p = parseMoney(price.text, decimals);
            if (!form.currentState!.validate() || p == null || p <= 0) return;
            Navigator.pop<OpenFoodItem>(ctx, (name: name.text.trim(), priceMinor: p, qty: int.tryParse(qty.text) ?? 1));
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}

typedef LineEdit = ({int qtyMilli, String? note});

/// Tap a cart line: quantity, item note, remove (qty 0).
Future<LineEdit?> showLineEdit(BuildContext context, CartLine line) {
  var qty = line.qtyMilli ~/ 1000;
  final note = TextEditingController(text: line.note ?? '');
  return showPosPopup<LineEdit>(
    context,
    maxWidth: 540,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, set) {
        final r = ctx.r;
        final step = IconButton.styleFrom(minimumSize: Size.square(r.tap(56)));
        return posAlert(
          ctx,
          backgroundColor: HomeColors.dialog,
          title: Text(line.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    style: step,
                    iconSize: math.max(24, r.f(28)),
                    onPressed: qty > 1 ? () => set(() => qty--) : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: r.s(24)),
                      child: Text(
                        '$qty',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: _font(r, 28), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    style: step,
                    iconSize: math.max(24, r.f(28)),
                    onPressed: () => set(() => qty++),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: r.s(16)),
              TextField(
                key: const Key('lineNote'),
                controller: note,
                decoration: const InputDecoration(labelText: 'Item note (kitchen)', border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
              key: const Key('lineRemove'),
              onPressed: () => Navigator.pop<LineEdit>(ctx, (qtyMilli: 0, note: null)),
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              style: _navyButton(ctx),
              onPressed: () => Navigator.pop<LineEdit>(ctx, (qtyMilli: qty * 1000, note: note.text)),
              child: const Text('Save'),
            ),
          ],
        );
      },
    ),
  );
}
