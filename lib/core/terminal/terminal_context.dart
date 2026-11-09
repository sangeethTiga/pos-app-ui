import 'package:timezone/data/latest_10y.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Facts about this paired terminal that every POS feature needs. Set once after pairing.
class TerminalContext {
  TerminalContext({
    required this.deviceId,
    required this.deviceCode,
    required this.tokenLetter,
    required this.storeId,
    required this.storeName,
    required this.currency,
    required this.currencyDecimals,
    required this.timezone,
    required this.businessDayCutoff,
    required this.pricesIncludeTax,
    this.deviceType = 'CASHIER',
    this.kioskId,
  });

  final String deviceId;

  /// Origin of this terminal's changes and bill prefix (P1, P2 ...).
  final String deviceCode;
  final String tokenLetter;
  final String storeId;
  final String storeName;
  final String currency;
  final int currencyDecimals;
  final String timezone;

  /// "04:00": sales before this local time belong to the previous business date.
  final String businessDayCutoff;
  final bool pricesIncludeTax;

  /// CASHIER or CAPTAIN (registration screen).
  final String deviceType;

  /// Kiosk this terminal takes orders for; stamped on its orders.
  final String? kioskId;

  bool get isCaptain => deviceType == 'CAPTAIN';

  static bool _tzReady = false;

  DateTime localNow([DateTime? utc]) {
    if (!_tzReady) {
      tzdata.initializeTimeZones();
      _tzReady = true;
    }
    final now = utc ?? DateTime.now().toUtc();
    try {
      return tz.TZDateTime.from(now, tz.getLocation(timezone));
    } on Object {
      return now.toLocal();
    }
  }

  /// Business date (YYYY-MM-DD) for [utc], honouring the cut-off.
  String businessDate([DateTime? utc]) {
    final local = localNow(utc);
    final parts = businessDayCutoff.split(':');
    final cutoff = Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1]));
    final shifted = local.subtract(cutoff);
    return '${shifted.year.toString().padLeft(4, '0')}-${shifted.month.toString().padLeft(2, '0')}-'
        '${shifted.day.toString().padLeft(2, '0')}';
  }

  String money(int minor) {
    final neg = minor < 0;
    final a = minor.abs();
    if (currencyDecimals == 0) return '${neg ? '-' : ''}$a';
    var div = 1;
    for (var i = 0; i < currencyDecimals; i++) {
      div *= 10;
    }
    return '${neg ? '-' : ''}${a ~/ div}.${(a % div).toString().padLeft(currencyDecimals, '0')}';
  }
}

/// Mutable holder registered in get_it; filled in when the terminal session starts.
class TerminalContextHolder {
  TerminalContext? _ctx;
  TerminalContext get ctx => _ctx ?? (throw StateError('Terminal session not started'));
  bool get ready => _ctx != null;
  set ctx(TerminalContext value) => _ctx = value;

  /// May this terminal start a new order now? Wired by DI to the platform activation (orders made while
  /// not activated are rejected by the server). Editing, paying and syncing existing orders is not gated.
  bool Function() newOrdersAllowed = _always;

  static bool _always() => true;

  static const notActivatedMessage = 'This terminal is not activated. New orders are blocked until it is activated.';
}
