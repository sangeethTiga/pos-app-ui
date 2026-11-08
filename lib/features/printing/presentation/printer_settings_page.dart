import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/di/injection.dart';
import '../../../core/responsive/responsive.dart';
import '../../sales/domain/cart.dart';
import '../data/print_center.dart';
import '../data/printer_service.dart';
import '../domain/printer_device.dart';

/// Printer Settings: which printer prints bills (the kiosk printer) and KOTs (one per kitchen
/// station), print style, print queue and the receipt copies per order type. Right side: find a USB
/// or Bluetooth printer, or enter a LAN printer's IP, then "Set as ...". Every change is saved.
class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  final _printer = sl<PrinterService>();
  final _center = sl<PrintCenter>();
  final _ip = TextEditingController();
  final _port = TextEditingController(text: '9100');

  PrinterSettings _s = const PrinterSettings();
  List<StationInfo> _stations = const [];
  String? _kiosk;
  int _queued = 0;
  bool _loaded = false;

  PrinterKind _kind = PrinterKind.wifi;
  List<PrinterDevice> _found = const [];
  PrinterDevice? _selected;
  StreamSubscription<List<PrinterDevice>>? _scan;

  Responsive get _r => context.r;

  /// Font size token for [designPx] (drawn on the 1920-wide screen), never below [min].
  double _font(double designPx, {double min = 14}) => math.max(_r.f(designPx), min);

  TextStyle get _label => TextStyle(fontSize: _font(22), color: Colors.black87);
  TextStyle get _hint => TextStyle(fontSize: _font(13, min: 12), color: Colors.black87);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await _printer.settings();
    final stations = await _center.stations();
    final kiosk = await _center.kioskName();
    final queued = (await _printer.queued()).length;
    if (!mounted) return;
    final first = !_loaded;
    setState(() {
      _s = s;
      _stations = stations;
      _kiosk = kiosk;
      _queued = queued;
      if (first) {
        _kind = s.bill?.kind ?? s.kot.values.firstOrNull?.kind ?? PrinterKind.wifi;
        _loaded = true;
      }
    });
    if (first) _startScan();
  }

  @override
  void dispose() {
    _scan?.cancel();
    _ip.dispose();
    _port.dispose();
    super.dispose();
  }

  void _startScan() {
    _scan?.cancel();
    setState(() {
      _found = const [];
      _selected = null;
    });
    _scan = _printer.transport.scan(_kind).listen((list) {
      if (mounted) setState(() => _found = list);
    });
  }

  /// The printer the "Set as" buttons assign: the one picked in the list, else the typed IP.
  PrinterDevice? get _candidate {
    if (_selected != null) return _selected;
    final ip = _ip.text.trim();
    if (!RegExp(r'^\d{1,3}(\.\d{1,3}){3}$').hasMatch(ip) && !RegExp(r'^[A-Za-z0-9.-]+\.local$').hasMatch(ip)) {
      return null;
    }
    return PrinterDevice.wifi(ip, port: int.tryParse(_port.text.trim()) ?? 9100);
  }

  Future<void> _save(PrinterSettings s) async {
    setState(() => _s = s);
    await _printer.save(s);
  }

  void _toast(String m) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(m)));

  Future<void> _test() async {
    final d = _candidate;
    if (d == null) return _toast('Pick a printer or enter its IP address first.');
    try {
      await _center.test(d);
      _toast('Test ticket sent to ${d.name}');
    } on Object catch (e) {
      _toast('Could not print: $e');
    }
  }

  Future<void> _flush() async {
    final n = await _printer.flushQueue();
    await _load();
    _toast(n == 0 ? 'Printers still not reachable' : 'Printed $n queued job${n == 1 ? '' : 's'}');
  }

  // ---- left -----------------------------------------------------------------------------------------

  Widget _target(String key, String label, String button, PrinterDevice? current, ValueChanged<PrinterDevice?> set) {
    final c = _candidate;
    final r = _r;
    final text = Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$label : ', style: _label),
          if (current != null)
            TextSpan(
              text: current.name,
              style: TextStyle(fontSize: _font(17), color: PosColors.navy, fontWeight: FontWeight.w600),
            ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    final setAs = FilledButton(
      key: Key('setAs-$key'),
      style: FilledButton.styleFrom(
        backgroundColor: PosColors.navy,
        disabledBackgroundColor: const Color(0xFFD3D2DF),
        disabledForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: Size(0, r.tap(50)),
        padding: EdgeInsets.symmetric(horizontal: r.s(14)),
      ),
      onPressed: c == null ? null : () => set(c),
      child: Text(
        button,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: _font(15)),
      ),
    );
    final buttons = [
      if (current != null)
        IconButton(
          key: Key('clear-$key'),
          tooltip: 'Remove',
          constraints: BoxConstraints.tight(Size.square(r.minTap)),
          onPressed: () => set(null),
          icon: Icon(Icons.close, size: _font(20, min: 20)),
        ),
      // Long station names shrink the button (ellipsis) instead of pushing the row off screen.
      if (r.isCompact)
        Flexible(child: setAs)
      else
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: r.s(340)),
          child: setAs,
        ),
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: r.s(22)),
      // Phones: the printer name gets the full width, the buttons go under it.
      child: r.isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                text,
                const SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: buttons),
              ],
            )
          : Row(
              children: [
                Expanded(child: text),
                ...buttons,
              ],
            ),
    );
  }

  Widget _dropdown<T>(String key, String label, T value, Map<T, String> items, ValueChanged<T> onChanged) => Container(
    constraints: BoxConstraints(maxWidth: _r.s(440)),
    margin: EdgeInsets.only(bottom: _r.s(18)),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade500),
      borderRadius: BorderRadius.circular(6),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        key: Key(key),
        value: value,
        isExpanded: true,
        itemHeight: math.max(kMinInteractiveDimension, _r.tap(56)),
        selectedItemBuilder: (_) => [
          for (final v in items.values)
            Row(
              children: [
                SizedBox(
                  width: _r.s(200),
                  child: Text(label, style: _label, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                Flexible(
                  child: Text(v, style: _label, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
        ],
        items: [for (final e in items.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
        onChanged: (v) => v == null ? null : onChanged(v),
      ),
    ),
  );

  Widget _check(String key, String title, String hint, bool value, ValueChanged<bool>? onChanged) => Padding(
    padding: EdgeInsets.only(bottom: _r.s(14)),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _label),
              Text(hint, style: _hint),
            ],
          ),
        ),
        Checkbox(
          key: Key(key),
          value: value,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          onChanged: onChanged == null ? null : (v) => onChanged(v ?? false),
        ),
        SizedBox(width: _r.s(60)),
      ],
    ),
  );

  Widget _left() {
    final counts = {for (var i = 0; i <= 5; i++) i: ': $i'};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _target(
          'bill',
          '${_kiosk ?? 'Bill'} Printer',
          'Set as KIOSK',
          _s.bill,
          (d) => _save(_s.copyWith(bill: () => d)),
        ),
        if (_stations.isEmpty)
          _target('kot', 'KOT', 'Set as KOT', _s.kot[''], (d) => _save(_s.copyWith(kot: _withKot('', d))))
        else
          for (final st in _stations)
            _target(
              'kot-${st.id}',
              st.name,
              'Set as ${st.name}',
              _s.kot[st.id],
              (d) => _save(_s.copyWith(kot: _withKot(st.id, d))),
            ),
        _dropdown<PrintStyle>('printStyle', 'Print Style :', _s.style, const {
          PrintStyle.text: 'Text',
          PrintStyle.image: 'Image',
        }, (v) => _save(_s.copyWith(style: v))),
        _dropdown<int>('paperSize', 'Paper Size :', _s.width, const {
          48: '80 mm',
          32: '58 mm',
        }, (v) => _save(_s.copyWith(width: v))),
        const SizedBox(height: 10),
        _check(
          'printQueue',
          'Print Queue',
          '(Print jobs are kept in queue while printer is not available to print)',
          _s.queue,
          (v) => _save(_s.copyWith(queue: v, autoQueue: v ? null : false)),
        ),
        _check(
          'autoQueue',
          'Auto Queue Print',
          '( Automatically print jobs from a queue when printer becomes available)',
          _s.autoQueue,
          _s.queue ? (v) => _save(_s.copyWith(autoQueue: v)) : null,
        ),
        if (_queued > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Text('$_queued job${_queued == 1 ? '' : 's'} in the queue', style: _hint),
                const SizedBox(width: 12),
                TextButton(key: const Key('flushQueue'), onPressed: _flush, child: const Text('Print now')),
                TextButton(
                  key: const Key('clearQueue'),
                  onPressed: () async {
                    await _printer.clearQueue();
                    await _load();
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
        _check(
          'drawerKick',
          'Open Cash Drawer',
          '(Open the drawer on the bill printer after a cash payment)',
          _s.drawer,
          (v) => _save(_s.copyWith(drawer: v)),
        ),
        SizedBox(height: _r.s(18)),
        Text(
          'Print Count :-',
          style: TextStyle(fontSize: _font(22), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: _r.s(18)),
        for (final (key, label, channel) in [
          ('countDelivery', 'Home Delivery', Channel.homeDelivery),
          ('countDineIn', 'Dine In', Channel.dineIn),
          ('countTakeaway', 'Take Away', Channel.takeaway),
        ])
          _dropdown<int>(
            key,
            label,
            _s.copiesFor(channel),
            counts,
            (v) => _save(_s.copyWith(copies: {..._s.copies, channel: v})),
          ),
      ],
    );
  }

  Map<String, PrinterDevice> _withKot(String key, PrinterDevice? d) {
    final m = {..._s.kot}..remove(key);
    if (d != null) m[key] = d;
    return m;
  }

  // ---- right ----------------------------------------------------------------------------------------

  Widget _right() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DropdownButtonFormField<PrinterKind>(
        key: const Key('printerType'),
        initialValue: _kind,
        decoration: InputDecoration(
          labelText: 'Type Printer Device',
          labelStyle: const TextStyle(color: PosColors.navy),
          icon: Icon(Icons.print, color: PosColors.navy, size: _font(30, min: 24)),
          border: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: _font(18, min: 16)),
        items: [for (final k in PrinterKind.values) DropdownMenuItem(value: k, child: Text(k.label))],
        onChanged: (k) {
          if (k == null || k == _kind) return;
          _kind = k;
          _startScan();
        },
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Available Printers',
                style: TextStyle(fontSize: _font(22), fontWeight: FontWeight.bold),
              ),
            ),
            if (_kind != PrinterKind.wifi)
              IconButton(
                key: const Key('rescan'),
                tooltip: 'Search again',
                onPressed: _startScan,
                icon: const Icon(Icons.refresh),
              ),
          ],
        ),
      ),
      SizedBox(
        height: math.max(160, _r.s(240)),
        child: _found.isEmpty
            ? Center(
                child: Text(
                  _kind == PrinterKind.wifi
                      ? 'Available Printers Not Found\nEnter the printer\'s IP address below'
                      : 'Available Printers Not Found',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _font(18, min: 15)),
                ),
              )
            : ListView(
                children: [
                  for (final d in _found)
                    ListTile(
                      key: Key('found-${d.address ?? d.name}'),
                      selected: _selected?.sameAs(d) ?? false,
                      selectedTileColor: PosColors.card,
                      leading: Icon(d.kind == PrinterKind.usb ? Icons.usb : Icons.bluetooth),
                      title: Text(d.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(d.address ?? d.queueName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: (_selected?.sameAs(d) ?? false) ? const Icon(Icons.check, color: PosColors.navy) : null,
                      onTap: () => setState(() {
                        _selected = d;
                        _ip.clear();
                      }),
                    ),
                ],
              ),
      ),
      TextField(
        key: const Key('printerIp'),
        controller: _ip,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: _font(18, min: 16)),
        decoration: InputDecoration(
          icon: Icon(Icons.wifi, size: _font(30, min: 24)),
          hintText: 'Ip Address',
          contentPadding: EdgeInsets.symmetric(vertical: math.max(14, _r.s(18))),
        ),
        onChanged: (_) => setState(() => _selected = null),
      ),
      TextField(
        key: const Key('printerPort'),
        controller: _port,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: _font(18, min: 16)),
        decoration: InputDecoration(
          icon: Icon(Icons.tag, size: _font(30, min: 24)),
          labelText: 'Port',
        ),
        onChanged: (_) => setState(() {}),
      ),
      SizedBox(height: _r.s(14)),
      Center(
        child: SizedBox(
          width: math.max(220, _r.s(300)),
          child: OutlinedButton(
            key: const Key('printTest'),
            style: OutlinedButton.styleFrom(
              foregroundColor: PosColors.accent,
              shape: const StadiumBorder(),
              minimumSize: Size(0, _r.tap(50)),
            ),
            onPressed: _test,
            child: Text(
              'Print test ticket',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: _font(16)),
            ),
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Printer Settings')),
    body: LayoutBuilder(
      builder: (context, c) {
        final r = _r;
        final pad = r.gutter * 1.5;
        // Phones and portrait tablets: one scrolling column (printer search first), centred with a
        // readable width. Wider: settings | printer search side by side, capped on big screens.
        if (c.maxWidth < Breakpoints.expanded) {
          final side = math.max(pad, (c.maxWidth - math.max(560, r.s(760))) / 2);
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: side, vertical: pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _right(),
                Divider(height: r.s(40) + 8),
                _left(),
              ],
            ),
          );
        }
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: r.s(1800)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(padding: EdgeInsets.all(pad), child: _left()),
                ),
                Expanded(
                  child: SingleChildScrollView(padding: EdgeInsets.all(pad), child: _right()),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
