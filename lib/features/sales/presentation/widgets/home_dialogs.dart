import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme.dart';
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

bool _narrow(BuildContext c) => MediaQuery.sizeOf(c).width < 700;

/// Width the home screen and its popups are designed at (see SellPage).
const homeDesignWidth = 1780.0;

/// Lays [child] out at [homeDesignWidth] and scales it to the screen, so popups keep the same
/// proportions as the home screen on any tablet or monitor. Phones (< 700) are not scaled.
Widget scaledForHome(BuildContext context, Widget child) {
  final size = MediaQuery.sizeOf(context);
  if (size.width < 700) return child;
  final scale = (size.width / homeDesignWidth).clamp(0.6, 1.6);
  final inner = Size(size.width / scale, size.height / scale);
  return SizedBox.fromSize(
    size: size,
    child: FittedBox(
      fit: BoxFit.fill,
      alignment: Alignment.topLeft,
      child: SizedBox.fromSize(
        size: inner,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(size: inner),
          child: child,
        ),
      ),
    ),
  );
}

ButtonStyle _navyButton() => FilledButton.styleFrom(
  backgroundColor: HomeColors.navy,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
);

/// Cancel | Ok row of the small popups (Select Captain, Delivery Partners).
Widget _cancelOk(BuildContext context, {required VoidCallback? onOk}) => Row(
  children: [
    Expanded(
      child: TextButton(
        key: const Key('dialogCancel'),
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel', style: TextStyle(fontSize: 21, color: PosColors.accent)),
      ),
    ),
    Container(width: 1, height: 36, color: Colors.grey),
    Expanded(
      child: TextButton(
        key: const Key('dialogOk'),
        onPressed: onOk,
        child: const Text('Ok', style: TextStyle(fontSize: 21, color: PosColors.accent)),
      ),
    ),
  ],
);

// ---- Choose Table ----------------------------------------------------------------------------

typedef TableChoice = ({DiningTableInfo table, int guests, OpenOrder? running});

Future<TableChoice?> showChooseTable(
  BuildContext context, {
  required List<DiningTableInfo> tables,
  required List<OpenOrder> openOrders,
  String? selectedTableId,
}) {
  return showDialog<TableChoice>(
    context: context,
    builder: (ctx) => scaledForHome(
      ctx,
      Builder(
        builder: (ctx) {
          final body = _ChooseTable(tables: tables, openOrders: openOrders, selectedTableId: selectedTableId);
          return _narrow(ctx)
              ? Dialog.fullscreen(backgroundColor: HomeColors.dialog, child: body)
              : Dialog(
                  backgroundColor: HomeColors.dialog,
                  insetPadding: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: body,
                );
        },
      ),
    ),
  );
}

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
    final shown = widget.tables.where((t) => _ordersAt(t.id).isNotEmpty == _occupiedView).toList();
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose Table', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              RadioGroup<bool>(
                groupValue: _occupiedView,
                onChanged: (v) => setState(() => _occupiedView = v ?? false),
                child: Wrap(
                  spacing: 40,
                  children: [
                    for (final (v, label) in [(false, 'Un Occupied'), (true, 'Occupied')])
                      InkWell(
                        key: Key(v ? 'occupiedTab' : 'unoccupiedTab'),
                        onTap: () => setState(() => _occupiedView = v),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<bool>(value: v, activeColor: PosColors.accent),
                            Text(label, style: const TextStyle(fontSize: 26)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                key: const Key('clearTables'),
                onPressed: () => setState(() {
                  _selected = null;
                  for (final c in _pax.values) {
                    c.text = '1';
                  }
                }),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.sort, color: Colors.black87),
                label: const Text('Clear all tables', style: TextStyle(color: Colors.black87, fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: shown.isEmpty
                ? Center(child: Text(_occupiedView ? 'No occupied tables' : 'No free tables', style: text.titleMedium))
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 310,
                      mainAxisExtent: 205,
                      crossAxisSpacing: 26,
                      mainAxisSpacing: 22,
                    ),
                    itemCount: shown.length,
                    itemBuilder: (_, i) => _tableCard(shown[i], text),
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                key: const Key('tableCancel'),
                style: _navyButton().copyWith(backgroundColor: const WidgetStatePropertyAll(HomeColors.red)),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 20),
              FilledButton(
                key: const Key('tableOk'),
                style: _navyButton(),
                onPressed: _selected == null ? null : _ok,
                child: const Text('ok', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableCard(DiningTableInfo t, TextTheme text) {
    final orders = _ordersAt(t.id);
    final selected = _selected == t.id;
    return InkWell(
      key: Key('table-${t.id}'),
      onTap: () => setState(() => _selected = t.id),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 18, 16, 14),
        decoration: BoxDecoration(
          color: orders.isEmpty ? HomeColors.tableGreen : HomeColors.tableBusy,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: selected ? HomeColors.navy : Colors.transparent, width: 4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Table ${t.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                if (t.area != null) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(t.area!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ],
              ],
            ),
            const Spacer(),
            Text('Available Seats : ${_available(t)}', style: const TextStyle(fontSize: 19)),
            const SizedBox(height: 6),
            Text(
              orders.isEmpty ? 'Table Capacity : ${t.capacity}' : 'Order ${orders.map((o) => o.orderNo).join(', ')}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 19),
            ),
            const Spacer(),
            Row(
              children: [
                const Text('PAX:', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                const SizedBox(width: 24),
                Expanded(
                  child: TextField(
                    key: Key('pax-${t.id}'),
                    controller: _pax[t.id],
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onTap: () => setState(() => _selected = t.id),
                    style: const TextStyle(fontSize: 21),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
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
  return showDialog<CaptainInfo>(
    context: context,
    builder: (ctx) => scaledForHome(
      ctx,
      StatefulBuilder(
        builder: (ctx, set) => Dialog(
          backgroundColor: HomeColors.dialog,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: HomeColors.navy),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 22, 28, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Select Captain', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 22),
                  if (captains.isEmpty)
                    const Text('No captain accounts in this store.')
                  else
                    Wrap(
                      spacing: 20,
                      runSpacing: 16,
                      children: [
                        for (final c in captains)
                          Material(
                            color: selected == c.id ? HomeColors.navy : const Color(0xFF9E9E9E),
                            child: InkWell(
                              key: Key('captain-${c.id}'),
                              onTap: () => set(() => selected = c.id),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                                child: Text(
                                  c.name,
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: selected == c.id ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 22),
                  _cancelOk(
                    ctx,
                    onOk: selected == null
                        ? null
                        : () => Navigator.pop(ctx, captains.firstWhere((c) => c.id == selected)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
  return showDialog<PartnerChoice>(
    context: context,
    builder: (ctx) => scaledForHome(
      ctx,
      StatefulBuilder(
        builder: (ctx, set) => Dialog(
          backgroundColor: HomeColors.dialog,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: HomeColors.navy),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Delivery Partners', style: TextStyle(fontSize: 26)),
                  const SizedBox(height: 18),
                  if (partners.isEmpty)
                    const Text('No delivery partners. Add them in the admin panel.')
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final p in partners)
                          OutlinedButton(
                            key: Key('partner-${p.id}'),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: selected == p.id ? HomeColors.navy : Colors.white,
                              foregroundColor: selected == p.id ? Colors.white : HomeColors.navy,
                              side: const BorderSide(color: HomeColors.navy),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            ),
                            onPressed: () => set(() => selected = p.id),
                            child: Text(p.name, style: const TextStyle(fontSize: 24)),
                          ),
                      ],
                    ),
                  const SizedBox(height: 18),
                  TextField(
                    key: const Key('partnerOrderNo'),
                    controller: no,
                    decoration: InputDecoration(
                      labelText: 'Order Number',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _cancelOk(
                    ctx,
                    onOk: selected == null
                        ? null
                        : () => Navigator.pop<PartnerChoice>(ctx, (
                            partner: partners.firstWhere((p) => p.id == selected),
                            orderNo: no.text.trim(),
                          )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
}) {
  return showDialog<CustomerChoice>(
    context: context,
    builder: (ctx) => scaledForHome(
      ctx,
      Builder(
        builder: (ctx) {
          final body = _CustomerDetails(repo: repo, userId: userId, selectedId: selectedId);
          return _narrow(ctx)
              ? Dialog.fullscreen(backgroundColor: HomeColors.dialog, child: body)
              : Dialog(
                  backgroundColor: HomeColors.dialog,
                  insetPadding: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: body,
                );
        },
      ),
    ),
  );
}

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

  InputDecoration _dec(String label) => InputDecoration(
    hintText: label,
    hintStyle: TextStyle(fontSize: 19, color: Colors.grey.shade600),
    filled: true,
    fillColor: HomeColors.dialog,
    contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
  );

  String? _required(String? v) => v == null || v.trim().isEmpty ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final list = _list(text);
    final form = _formPanel(text);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Customer Details', style: text.headlineMedium)),
              IconButton(
                key: const Key('customerClose'),
                icon: const Icon(Icons.close, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          RadioGroup<bool>(
            groupValue: _carhop,
            onChanged: (v) => setState(() => _carhop = v ?? false),
            child: Wrap(
              spacing: 200,
              children: [
                for (final (v, label) in [(false, 'Normal'), (true, 'Carhop')])
                  InkWell(
                    key: Key(v ? 'carhop' : 'normal'),
                    onTap: () => setState(() => _carhop = v),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<bool>(value: v, activeColor: PosColors.accent),
                        Text(label, style: text.titleMedium),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) => c.maxWidth < 800
                  ? ListView(
                      children: [
                        SizedBox(height: 320, child: list),
                        const SizedBox(height: 16),
                        form,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: list),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: SingleChildScrollView(child: form)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _list(TextTheme text) => Column(
    children: [
      TextField(
        key: const Key('customerSearch'),
        controller: _search,
        autofocus: !_narrow(context),
        onChanged: _find,
        decoration: _dec('Search Customer Mobile Number or Name').copyWith(
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search, color: HomeColors.navy, size: 30),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                child: Row(
                  children: [
                    Expanded(child: Text('Customer', style: text.headlineSmall)),
                    Expanded(child: Text('Mobile', style: text.headlineSmall)),
                    Expanded(flex: 2, child: Text('Address', style: text.headlineSmall)),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade400),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(child: Text(c.name, style: text.titleMedium)),
                              Expanded(child: Text(c.mobile ?? '', style: text.titleMedium)),
                              Expanded(flex: 2, child: Text(c.address?.oneLine ?? '', style: text.bodyMedium)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _formPanel(TextTheme text) => Form(
    key: _form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(_current == null ? 'Add new Customer:-' : 'Customer:-', style: text.headlineSmall),
        const SizedBox(height: 14),
        TextFormField(
          key: const Key('customerMobile'),
          controller: _mobile,
          keyboardType: TextInputType.phone,
          decoration: _dec('Mobile Number*'),
          validator: _required,
        ),
        const SizedBox(height: 14),
        TextFormField(
          key: const Key('customerName'),
          controller: _name,
          decoration: _dec('Name*'),
          validator: _required,
        ),
        const SizedBox(height: 14),
        TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: _dec('Email')),
        if (_carhop) ...[
          const SizedBox(height: 14),
          TextFormField(
            key: const Key('carNo'),
            controller: _carNo,
            decoration: _dec('Car Number*'),
            validator: _required,
          ),
        ],
        const SizedBox(height: 14),
        TextFormField(controller: _flat, decoration: _dec('Flat')),
        const SizedBox(height: 14),
        TextFormField(controller: _building, decoration: _dec('Building No/Name')),
        const SizedBox(height: 14),
        TextFormField(controller: _street, decoration: _dec('Street')),
        const SizedBox(height: 14),
        TextFormField(controller: _city, decoration: _dec('City')),
        const SizedBox(height: 26),
        DropdownButtonFormField<String>(
          key: ValueKey('area-$_area-${_areas.length}'),
          initialValue: _area,
          hint: const Text('Select an area'),
          isExpanded: true,
          items: [for (final a in _areas) DropdownMenuItem(value: a, child: Text(a))],
          onChanged: (v) => setState(() => _area = v),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        if (_error != null) ...[const SizedBox(height: 10), Text(_error!, style: const TextStyle(color: Colors.red))],
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                key: const Key('customerNew'),
                style: _navyButton(),
                onPressed: _saving ? null : _new,
                child: const Text('New', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: FilledButton(
                key: const Key('customerSave'),
                style: _navyButton(),
                onPressed: _saving ? null : _save,
                child: const Text('Save', style: TextStyle(fontSize: 18)),
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
  return showDialog<String>(
    context: context,
    builder: (ctx) => scaledForHome(
      ctx,
      AlertDialog(
        backgroundColor: HomeColors.dialog,
        title: const Text('Kitchen Note'),
        content: SizedBox(
          width: 460,
          child: TextField(
            key: const Key('kitchenNoteField'),
            controller: c,
            autofocus: true,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'e.g. less spicy, no onion', border: OutlineInputBorder()),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            key: const Key('kitchenNoteSave'),
            style: _navyButton(),
            onPressed: () => Navigator.pop(ctx, c.text),
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

/// Order discount in percent; [maxBp] is the user's limit (BR-09).
Future<int?> showDiscount(BuildContext context, {required int currentBp, required int maxBp}) {
  final c = TextEditingController(
    text: currentBp == 0 ? '' : (currentBp / 100).toStringAsFixed(currentBp % 100 == 0 ? 0 : 2),
  );
  String? error;
  return showDialog<int>(
    context: context,
    builder: (ctx) => scaledForHome(
      ctx,
      StatefulBuilder(
        builder: (ctx, set) {
          void apply(String v) {
            final pct = double.tryParse(v.trim().isEmpty ? '0' : v.trim());
            final bp = pct == null ? null : (pct * 100).round();
            if (bp == null || bp < 0 || bp > 10000) return set(() => error = 'Enter 0 to 100');
            if (bp > maxBp) return set(() => error = 'Your limit is ${(maxBp / 100).toStringAsFixed(0)}%');
            Navigator.pop(ctx, bp);
          }

          return AlertDialog(
            backgroundColor: HomeColors.dialog,
            title: const Text('Discount'),
            content: SizedBox(
              width: 420,
              child: Column(
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
                          child: Text('$p%', style: const TextStyle(fontSize: 18)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, 0), child: const Text('Remove discount')),
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              FilledButton(style: _navyButton(), onPressed: () => apply(c.text), child: const Text('Apply')),
            ],
          );
        },
      ),
    ),
  );
}

typedef OpenFoodItem = ({String name, int priceMinor, int qty});

Future<OpenFoodItem?> showOpenFood(BuildContext context, {required int decimals}) {
  final name = TextEditingController();
  final price = TextEditingController();
  final qty = TextEditingController(text: '1');
  final form = GlobalKey<FormState>();
  return showDialog<OpenFoodItem>(
    context: context,
    builder: (ctx) => scaledForHome(
      ctx,
      AlertDialog(
        backgroundColor: HomeColors.dialog,
        title: const Text('Open Food'),
        content: SizedBox(
          width: 420,
          child: Form(
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
                const SizedBox(height: 12),
                MoneyField(key: const Key('openFoodPrice'), controller: price, label: 'Price*'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: qty,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Qty'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            key: const Key('openFoodAdd'),
            style: _navyButton(),
            onPressed: () {
              final p = parseMoney(price.text, decimals);
              if (!form.currentState!.validate() || p == null || p <= 0) return;
              Navigator.pop<OpenFoodItem>(ctx, (
                name: name.text.trim(),
                priceMinor: p,
                qty: int.tryParse(qty.text) ?? 1,
              ));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ),
  );
}

typedef LineEdit = ({int qtyMilli, String? note});

/// Tap a cart line: quantity, item note, remove (qty 0).
Future<LineEdit?> showLineEdit(BuildContext context, CartLine line) {
  var qty = line.qtyMilli ~/ 1000;
  final note = TextEditingController(text: line.note ?? '');
  return showDialog<LineEdit>(
    context: context,
    builder: (ctx) => scaledForHome(
      ctx,
      StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          backgroundColor: HomeColors.dialog,
          title: Text(line.name),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      onPressed: qty > 1 ? () => set(() => qty--) : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text('$qty', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                    IconButton.filledTonal(onPressed: () => set(() => qty++), icon: const Icon(Icons.add)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('lineNote'),
                  controller: note,
                  decoration: const InputDecoration(labelText: 'Item note (kitchen)', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              key: const Key('lineRemove'),
              onPressed: () => Navigator.pop<LineEdit>(ctx, (qtyMilli: 0, note: null)),
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              style: _navyButton(),
              onPressed: () => Navigator.pop<LineEdit>(ctx, (qtyMilli: qty * 1000, note: note.text)),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    ),
  );
}
