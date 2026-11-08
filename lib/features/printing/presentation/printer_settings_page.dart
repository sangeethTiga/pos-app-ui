import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/terminal/terminal_context.dart';
import '../data/printer_service.dart';
import '../domain/esc_pos.dart';

class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  final _receipt = TextEditingController();
  final _kitchen = TextEditingController();
  int _width = 48;
  bool _drawer = true;
  final _printer = sl<PrinterService>();

  @override
  void initState() {
    super.initState();
    _printer.settings().then((s) {
      if (!mounted) return;
      setState(() {
        _receipt.text = s.receiptHost ?? '';
        _kitchen.text = s.kitchenHost ?? '';
        _width = s.width;
        _drawer = s.drawer;
      });
    });
  }

  PrinterSettings get _current => PrinterSettings(
    receiptHost: _receipt.text.trim(),
    kitchenHost: _kitchen.text.trim(),
    width: _width,
    drawer: _drawer,
  );

  Future<void> _test(String host) async {
    final t = sl<TerminalContextHolder>().ctx;
    final bytes =
        (EscPos(width: _width)
              ..align('center')
              ..text(t.storeName)
              ..text('Printer test ${t.deviceCode}')
              ..feed(3)
              ..cut())
            .bytes;
    try {
      await _printer.send(host, 9100, Uint8List.fromList(bytes));
      _toast('Sent to $host');
    } on Object catch (e) {
      _toast('Failed: $e');
    }
  }

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Printers')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Network (LAN) thermal printers, ESC/POS on port 9100.'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _receipt,
                decoration: const InputDecoration(labelText: 'Receipt printer IP'),
              ),
            ),
            TextButton(onPressed: () => _test(_receipt.text.trim()), child: const Text('Test')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _kitchen,
                decoration: const InputDecoration(labelText: 'Kitchen (KOT) printer IP'),
              ),
            ),
            TextButton(onPressed: () => _test(_kitchen.text.trim()), child: const Text('Test')),
          ],
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _width,
          decoration: const InputDecoration(labelText: 'Paper'),
          items: const [
            DropdownMenuItem(value: 48, child: Text('80 mm (48 characters)')),
            DropdownMenuItem(value: 32, child: Text('58 mm (32 characters)')),
          ],
          onChanged: (v) => setState(() => _width = v ?? 48),
        ),
        SwitchListTile(
          title: const Text('Open cash drawer on cash sales'),
          value: _drawer,
          onChanged: (v) => setState(() => _drawer = v),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () async {
            await _printer.save(_current);
            _toast('Saved');
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
