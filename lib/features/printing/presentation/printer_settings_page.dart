import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/di/injection.dart';
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

  static const _label = TextStyle(fontSize: 22, color: Colors.black87);
  static const _hint = TextStyle(fontSize: 13, color: Colors.black87);

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$label : ', style: _label),
                  if (current != null)
                    TextSpan(
                      text: current.name,
                      style: const TextStyle(fontSize: 17, color: PosColors.navy, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (current != null)
            IconButton(
              key: Key('clear-$key'),
              tooltip: 'Remove',
              onPressed: () => set(null),
              icon: const Icon(Icons.close, size: 20),
            ),
          FilledButton(
            key: Key('setAs-$key'),
            style: FilledButton.styleFrom(
              backgroundColor: PosColors.navy,
              disabledBackgroundColor: const Color(0xFFD3D2DF),
              disabledForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            onPressed: c == null ? null : () => set(c),
            child: Text(button, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _dropdown<T>(String key, String label, T value, Map<T, String> items, ValueChanged<T> onChanged) => Container(
    width: 330,
    margin: const EdgeInsets.only(bottom: 18),
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
        itemHeight: 56,
        selectedItemBuilder: (_) => [
          for (final v in items.values)
            Row(
              children: [
                SizedBox(width: 165, child: Text(label, style: _label)),
                Text(v, style: _label),
              ],
            ),
        ],
        items: [for (final e in items.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
        onChanged: (v) => v == null ? null : onChanged(v),
      ),
    ),
  );

  Widget _check(String key, String title, String hint, bool value, ValueChanged<bool>? onChanged) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
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
        Checkbox(key: Key(key), value: value, onChanged: onChanged == null ? null : (v) => onChanged(v ?? false)),
        const SizedBox(width: 60),
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
        const SizedBox(height: 18),
        const Text('Print Count :-', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
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
        decoration: const InputDecoration(
          labelText: 'Type Printer Device',
          labelStyle: TextStyle(color: PosColors.navy),
          icon: Icon(Icons.print, color: PosColors.navy, size: 30),
          border: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
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
            const Expanded(
              child: Text('Available Printers', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
        height: 200,
        child: _found.isEmpty
            ? Center(
                child: Text(
                  _kind == PrinterKind.wifi
                      ? 'Available Printers Not Found\nEnter the printer\'s IP address below'
                      : 'Available Printers Not Found',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
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
                      title: Text(d.name),
                      subtitle: Text(d.address ?? d.queueName ?? ''),
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
        style: const TextStyle(fontSize: 18),
        decoration: const InputDecoration(
          icon: Icon(Icons.wifi, size: 30),
          hintText: 'Ip Address',
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
        onChanged: (_) => setState(() => _selected = null),
      ),
      TextField(
        key: const Key('printerPort'),
        controller: _port,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 18),
        decoration: const InputDecoration(icon: Icon(Icons.tag, size: 30), labelText: 'Port'),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 14),
      Center(
        child: SizedBox(
          width: 250,
          child: OutlinedButton(
            key: const Key('printTest'),
            style: OutlinedButton.styleFrom(
              foregroundColor: PosColors.accent,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: _test,
            child: const Text('Print test ticket', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Printer Settings')),
    body: LayoutBuilder(
      builder: (_, c) {
        if (c.maxWidth < 900) {
          return ListView(padding: const EdgeInsets.all(20), children: [_right(), const Divider(height: 40), _left()]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: _left()),
            ),
            Expanded(
              child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: _right()),
            ),
          ],
        );
      },
    ),
  );
}
