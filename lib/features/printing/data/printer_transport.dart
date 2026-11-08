import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/network/network_print_result.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import '../domain/printer_device.dart';

class PrinterException implements Exception {
  const PrinterException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Finds printers and sends ESC/POS bytes to them.
abstract interface class PrinterTransport {
  Future<void> send(PrinterDevice device, Uint8List bytes);

  /// Printers of [kind] found nearby (USB and Bluetooth); the list updates while scanning.
  /// Wifi printers are entered by IP, so their scan is empty.
  Stream<List<PrinterDevice>> scan(PrinterKind kind);

  Future<void> stopScan();
}

/// flutter_thermal_printer: USB (Android, Windows, macOS), Bluetooth LE (all) and LAN (raw TCP).
class ThermalPrinterTransport implements PrinterTransport {
  FlutterThermalPrinter get _plugin => FlutterThermalPrinter.instance;

  static ConnectionType _type(PrinterKind k) => k == PrinterKind.usb ? ConnectionType.USB : ConnectionType.BLE;

  static Printer _toPrinter(PrinterDevice d) => Printer(
    address: d.address,
    name: d.name,
    connectionType: _type(d.kind),
    vendorId: d.vendorId,
    productId: d.productId,
    deviceUri: d.deviceUri,
    queueName: d.queueName,
  );

  static PrinterDevice _fromPrinter(Printer p, PrinterKind kind) => PrinterDevice(
    kind: kind,
    name: (p.name?.trim().isNotEmpty ?? false) ? p.name!.trim() : (p.address ?? 'Printer'),
    address: p.address,
    vendorId: p.vendorId,
    productId: p.productId,
    deviceUri: p.deviceUri,
    queueName: p.queueName,
  );

  @override
  Future<void> send(PrinterDevice device, Uint8List bytes) async {
    if (device.kind == PrinterKind.wifi) {
      final host = device.address;
      if (host == null || host.isEmpty) throw const PrinterException('No IP address for this printer.');
      final result = await FlutterThermalPrinterNetwork(
        host,
        port: device.port,
        timeout: const Duration(seconds: 4),
      ).printTicket(bytes);
      if (result != NetworkPrintResult.success) throw PrinterException('${device.name}: ${result.msg}');
      return;
    }
    final printer = _toPrinter(device);
    try {
      if (!await _plugin.connect(printer)) throw PrinterException('${device.name} is not connected.');
      await _plugin.printData(printer, bytes, longData: true);
    } on MissingPluginException {
      throw const PrinterException('USB and Bluetooth printers are not supported on this device.');
    } on PlatformException catch (e) {
      throw PrinterException('${device.name}: ${e.message ?? e.code}');
    }
  }

  @override
  Stream<List<PrinterDevice>> scan(PrinterKind kind) {
    if (kind == PrinterKind.wifi) return Stream.value(const []);
    final type = _type(kind);
    late final StreamController<List<PrinterDevice>> out;
    StreamSubscription<List<Printer>>? sub;
    out = StreamController<List<PrinterDevice>>(
      onListen: () async {
        sub = _plugin.devicesStream.listen(
          (list) => out.add([
            for (final p in list)
              if (p.connectionType == type || (kind == PrinterKind.usb && p.isSystemPrinter)) _fromPrinter(p, kind),
          ]),
          onError: (Object _) {},
        );
        try {
          await _plugin.getPrinters(connectionTypes: [type]);
        } on Object {
          // No plugin on this platform or permission denied: the list stays empty.
          out.add(const []);
        }
      },
      onCancel: () async {
        await sub?.cancel();
        await stopScan();
      },
    );
    return out.stream;
  }

  @override
  Future<void> stopScan() async {
    try {
      await _plugin.stopScan();
    } on Object {
      // nothing to stop
    }
  }
}
