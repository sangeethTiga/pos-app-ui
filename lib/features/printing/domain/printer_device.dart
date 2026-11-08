/// How a printer is reached.
enum PrinterKind {
  usb('usb'),
  wifi('Wifi'),
  bluetooth('Bluetooth');

  const PrinterKind(this.label);

  /// Shown in the "Type Printer Device" dropdown.
  final String label;

  static PrinterKind fromName(String? name) =>
      PrinterKind.values.firstWhere((k) => k.name == name, orElse: () => PrinterKind.wifi);
}

/// A printer this terminal can print to: a LAN printer (IP + port), a USB printer or a Bluetooth
/// printer found by a scan.
class PrinterDevice {
  const PrinterDevice({
    required this.kind,
    required this.name,
    this.address,
    this.port = 9100,
    this.vendorId,
    this.productId,
    this.deviceUri,
    this.queueName,
  });

  /// A LAN printer at [ip]:[port] (raw TCP, ESC/POS).
  factory PrinterDevice.wifi(String ip, {int port = 9100}) =>
      PrinterDevice(kind: PrinterKind.wifi, name: '$ip:$port', address: ip, port: port);

  final PrinterKind kind;
  final String name;

  /// IP for Wifi, device address / id for USB and Bluetooth.
  final String? address;
  final int port;
  final String? vendorId, productId;

  /// macOS system print queue of a USB printer (from the scan).
  final String? deviceUri, queueName;

  /// Same physical printer (used to match scan results with a saved printer).
  bool sameAs(PrinterDevice o) =>
      kind == o.kind &&
      (kind == PrinterKind.wifi
          ? address == o.address && port == o.port
          : (address ?? name) == (o.address ?? o.name) && queueName == o.queueName);

  Map<String, dynamic> toMap() => {
    'kind': kind.name,
    'name': name,
    'address': ?address,
    'port': port,
    'vendor_id': ?vendorId,
    'product_id': ?productId,
    'device_uri': ?deviceUri,
    'queue_name': ?queueName,
  };

  static PrinterDevice? fromMap(Object? m) {
    if (m is! Map) return null;
    return PrinterDevice(
      kind: PrinterKind.fromName(m['kind'] as String?),
      name: m['name'] as String? ?? '',
      address: m['address'] as String?,
      port: (m['port'] as num?)?.toInt() ?? 9100,
      vendorId: m['vendor_id'] as String?,
      productId: m['product_id'] as String?,
      deviceUri: m['device_uri'] as String?,
      queueName: m['queue_name'] as String?,
    );
  }
}
