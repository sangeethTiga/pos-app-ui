import 'dart:io';
import 'dart:typed_data';

import '../../../core/sync/local_store.dart';

class PrinterSettings {
  const PrinterSettings({this.receiptHost, this.kitchenHost, this.port = 9100, this.width = 48, this.drawer = true});

  /// IP of the receipt printer (LAN, raw TCP 9100). null = not configured.
  final String? receiptHost;

  /// IP of the kitchen printer for KOTs. null = not configured.
  final String? kitchenHost;
  final int port;
  final int width;

  /// Kick the cash drawer (connected to the receipt printer) on cash sales.
  final bool drawer;

  Map<String, dynamic> toJson() => {
    'receipt_host': receiptHost,
    'kitchen_host': kitchenHost,
    'port': port,
    'width': width,
    'drawer': drawer,
  };

  factory PrinterSettings.fromJson(Map<String, dynamic> j) => PrinterSettings(
    receiptHost: (j['receipt_host'] as String?)?.trim().isEmpty ?? true ? null : j['receipt_host'] as String,
    kitchenHost: (j['kitchen_host'] as String?)?.trim().isEmpty ?? true ? null : j['kitchen_host'] as String,
    port: (j['port'] as num?)?.toInt() ?? 9100,
    width: (j['width'] as num?)?.toInt() ?? 48,
    drawer: j['drawer'] as bool? ?? true,
  );
}

/// Sends ESC/POS bytes to network printers (raw TCP, port 9100). USB/Bluetooth printers are not
/// supported yet.
class PrinterService {
  PrinterService(this._store, {Future<Socket> Function(String host, int port)? connect})
    : _connect = connect ?? ((h, p) => Socket.connect(h, p, timeout: const Duration(seconds: 3)));

  final LocalStore _store;
  final Future<Socket> Function(String host, int port) _connect;

  Future<PrinterSettings> settings() async => PrinterSettings.fromJson(await _store.getJson('printer_settings'));

  Future<void> save(PrinterSettings s) => _store.setJson('printer_settings', s.toJson());

  /// Throws [SocketException] when the printer cannot be reached.
  Future<void> send(String host, int port, Uint8List bytes) async {
    final socket = await _connect(host, port);
    socket.add(bytes);
    await socket.flush();
    await socket.close();
  }
}
