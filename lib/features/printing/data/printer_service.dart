import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '../../../core/sync/local_store.dart';
import '../../sales/domain/cart.dart';
import '../domain/esc_pos.dart';
import '../domain/printer_device.dart';
import 'printer_transport.dart';
import 'ticket_image.dart';

/// Text = ESC/POS text commands (fast, Latin only). Image = the ticket drawn as a picture (any
/// script, e.g. Arabic; slower).
enum PrintStyle { text, image }

class PrinterSettings {
  const PrinterSettings({
    this.bill,
    this.kot = const {},
    this.style = PrintStyle.text,
    this.queue = false,
    this.autoQueue = false,
    this.copies = const {},
    this.width = 48,
    this.drawer = true,
  });

  /// Bill / receipt printer of this terminal (the kiosk printer).
  final PrinterDevice? bill;

  /// Kitchen printers by kitchen station id; key '' is the KOT printer for items without a station
  /// (or when the store has no stations).
  final Map<String, PrinterDevice> kot;
  final PrintStyle style;

  /// Keep jobs that could not print and print them later.
  final bool queue;

  /// Retry queued jobs automatically every 30 seconds.
  final bool autoQueue;

  /// Receipt copies printed on payment, by order type (DINE_IN, TAKEAWAY, DELIVERY; partner orders
  /// use DELIVERY). Missing = 1, 0 = none.
  final Map<String, int> copies;

  /// Characters per line: 48 for 80 mm, 32 for 58 mm.
  final int width;

  /// Kick the cash drawer (on the bill printer) on cash payments.
  final bool drawer;

  int copiesFor(String channel) => copies[channel == Channel.partner ? Channel.homeDelivery : channel] ?? 1;

  /// Printer for a KOT of [stationId]: that station's printer, else the default KOT printer, else
  /// any kitchen printer.
  PrinterDevice? kotFor(String? stationId) => kot[stationId ?? ''] ?? kot[''] ?? kot.values.firstOrNull;

  bool get hasKot => kot.isNotEmpty;

  PrinterSettings copyWith({
    PrinterDevice? Function()? bill,
    Map<String, PrinterDevice>? kot,
    PrintStyle? style,
    bool? queue,
    bool? autoQueue,
    Map<String, int>? copies,
    int? width,
    bool? drawer,
  }) => PrinterSettings(
    bill: bill != null ? bill() : this.bill,
    kot: kot ?? this.kot,
    style: style ?? this.style,
    queue: queue ?? this.queue,
    autoQueue: autoQueue ?? this.autoQueue,
    copies: copies ?? this.copies,
    width: width ?? this.width,
    drawer: drawer ?? this.drawer,
  );

  Map<String, dynamic> toJson() => {
    'bill': bill?.toMap(),
    'kot': {for (final e in kot.entries) e.key: e.value.toMap()},
    'style': style.name,
    'queue': queue,
    'auto_queue': autoQueue,
    'copies': copies,
    'width': width,
    'drawer': drawer,
  };

  factory PrinterSettings.fromJson(Map<String, dynamic> j) {
    String? host(String k) => (j[k] as String?)?.trim().isEmpty ?? true ? null : (j[k] as String).trim();
    final port = (j['port'] as num?)?.toInt() ?? 9100;
    // Settings saved before USB/Bluetooth support: receipt_host / kitchen_host IPs.
    final oldBill = host('receipt_host');
    final oldKot = host('kitchen_host');
    final kot = <String, PrinterDevice>{
      if (j['kot'] is Map)
        for (final e in (j['kot'] as Map).entries) e.key as String: ?PrinterDevice.fromMap(e.value),
    };
    if (kot.isEmpty && oldKot != null) kot[''] = PrinterDevice.wifi(oldKot, port: port);
    return PrinterSettings(
      bill: PrinterDevice.fromMap(j['bill']) ?? (oldBill == null ? null : PrinterDevice.wifi(oldBill, port: port)),
      kot: kot,
      style: j['style'] == 'image' ? PrintStyle.image : PrintStyle.text,
      queue: j['queue'] as bool? ?? false,
      autoQueue: j['auto_queue'] as bool? ?? false,
      copies: {
        if (j['copies'] is Map)
          for (final e in (j['copies'] as Map).entries) e.key as String: (e.value as num).toInt(),
      },
      width: (j['width'] as num?)?.toInt() ?? 48,
      drawer: j['drawer'] as bool? ?? true,
    );
  }
}

/// A print job waiting in the queue.
class QueuedJob {
  const QueuedJob({required this.device, required this.bytes, required this.label, required this.at});
  final PrinterDevice device;
  final Uint8List bytes;
  final String label;
  final DateTime at;

  Map<String, dynamic> toMap() => {
    'device': device.toMap(),
    'bytes': base64Encode(bytes),
    'label': label,
    'at': at.toUtc().toIso8601String(),
  };

  static QueuedJob? fromMap(Object? m) {
    if (m is! Map) return null;
    final d = PrinterDevice.fromMap(m['device']);
    if (d == null) return null;
    return QueuedJob(
      device: d,
      bytes: base64Decode(m['bytes'] as String? ?? ''),
      label: m['label'] as String? ?? '',
      at: DateTime.tryParse(m['at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

/// Printed now, or kept in the print queue because the printer was not reachable.
enum SendResult { printed, queued }

/// Sends tickets to USB, Bluetooth and LAN thermal printers (flutter_thermal_printer), as text or as
/// an image, with an optional queue for jobs that could not print.
class PrinterService {
  PrinterService(this._store, {PrinterTransport? transport}) : transport = transport ?? ThermalPrinterTransport();

  final LocalStore _store;
  final PrinterTransport transport;
  Timer? _auto;
  bool _flushing = false;

  static const _queueKey = 'print_queue';

  Future<PrinterSettings> settings() async => PrinterSettings.fromJson(await _store.getJson('printer_settings'));

  Future<void> save(PrinterSettings s) async {
    await _store.setJson('printer_settings', s.toJson());
    startAutoQueue();
  }

  /// Ticket bytes in the chosen print style.
  Future<Uint8List> render(EscPos ticket, PrinterSettings s) async =>
      s.style == PrintStyle.image ? await ticketImage(ticket, widthChars: s.width) : ticket.bytes;

  /// Prints [ticket] [copies] times on [device]. When the printer cannot be reached the job goes to
  /// the queue if the queue is on; otherwise [PrinterException] is thrown.
  Future<SendResult> print(PrinterDevice device, EscPos ticket, {required String label, int copies = 1}) async {
    final s = await settings();
    final bytes = await render(ticket, s);
    var printed = 0;
    try {
      for (; printed < copies; printed++) {
        await transport.send(device, bytes);
      }
      return SendResult.printed;
    } on Object catch (e) {
      if (!s.queue) throw e is PrinterException ? e : PrinterException('$e');
      for (var i = printed; i < copies; i++) {
        await _enqueue(QueuedJob(device: device, bytes: bytes, label: label, at: DateTime.now()));
      }
      return SendResult.queued;
    }
  }

  /// Raw bytes (test tickets, drawer kick); no queue.
  Future<void> sendRaw(PrinterDevice device, Uint8List bytes) => transport.send(device, bytes);

  // ---- queue -----------------------------------------------------------------------------------------

  Future<List<QueuedJob>> queued() async {
    final raw = (await _store.getJson(_queueKey))['jobs'];
    return [
      if (raw is List)
        for (final m in raw) ?QueuedJob.fromMap(m),
    ];
  }

  Future<void> _saveQueue(List<QueuedJob> jobs) => _store.setJson(_queueKey, {
    'jobs': [for (final j in jobs) j.toMap()],
  });

  Future<void> _enqueue(QueuedJob job) async => _saveQueue([...await queued(), job]);

  /// Prints queued jobs in order; jobs whose printer is still unreachable stay queued. Returns the
  /// number printed.
  Future<int> flushQueue() async {
    if (_flushing) return 0;
    _flushing = true;
    try {
      final jobs = await queued();
      final left = <QueuedJob>[];
      final down = <PrinterDevice>[];
      var printed = 0;
      for (final j in jobs) {
        if (down.any(j.device.sameAs)) {
          left.add(j);
          continue;
        }
        try {
          await transport.send(j.device, j.bytes);
          printed++;
        } on Object {
          down.add(j.device);
          left.add(j);
        }
      }
      if (printed > 0) await _saveQueue(left);
      return printed;
    } finally {
      _flushing = false;
    }
  }

  Future<void> clearQueue() => _saveQueue(const []);

  /// Auto Queue Print: retries the queue every 30 seconds while the setting is on.
  void startAutoQueue() {
    stopAutoQueue();
    settings().then((s) {
      if (s.autoQueue && s.queue) {
        _auto = Timer.periodic(const Duration(seconds: 30), (_) => flushQueue());
      }
    });
  }

  void stopAutoQueue() {
    _auto?.cancel();
    _auto = null;
  }
}
