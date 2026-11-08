/// Hybrid logical clock value: `<13-digit epoch ms>-<4+ digit counter>-<node>` (backend `Hlc`).
class Hlc implements Comparable<Hlc> {
  const Hlc(this.ms, this.counter, this.node);

  factory Hlc.parse(String s) {
    final first = s.indexOf('-');
    final second = s.indexOf('-', first + 1);
    if (first < 0 || second < 0) throw FormatException('Invalid HLC: $s');
    return Hlc(int.parse(s.substring(0, first)), int.parse(s.substring(first + 1, second)), s.substring(second + 1));
  }

  final int ms;
  final int counter;
  final String node;

  @override
  int compareTo(Hlc other) {
    if (ms != other.ms) return ms.compareTo(other.ms);
    if (counter != other.counter) return counter.compareTo(other.counter);
    return node.compareTo(other.node); // byte order, as on the server
  }

  bool operator >(Hlc o) => compareTo(o) > 0;

  @override
  String toString() => '${ms.toString().padLeft(13, '0')}-${counter.toString().padLeft(4, '0')}-$node';

  @override
  bool operator ==(Object other) => other is Hlc && compareTo(other) == 0;

  @override
  int get hashCode => Object.hash(ms, counter, node);

  /// Compare two HLC strings; null sorts first.
  static int compareStrings(String? a, String? b) {
    if (a == null) return b == null ? 0 : -1;
    if (b == null) return 1;
    return Hlc.parse(a).compareTo(Hlc.parse(b));
  }
}

/// Monotonic clock for this terminal. Never goes backwards; persisted by the local store.
class HlcClock {
  HlcClock(this.node, {Hlc? last, int Function()? wallMs})
    : _last = last ?? Hlc(0, 0, node),
      _wall = wallMs ?? (() => DateTime.now().millisecondsSinceEpoch);

  final String node;
  final int Function() _wall;
  Hlc _last;

  Hlc get last => _last;

  /// Local event.
  Hlc now() {
    final pt = _wall() > _last.ms ? _wall() : _last.ms;
    final c = pt == _last.ms ? _last.counter + 1 : 0;
    return _last = Hlc(pt, c, node);
  }

  /// Change received from another node (server or peer).
  Hlc receive(Hlc remote) {
    final wall = _wall();
    final pt = [wall, _last.ms, remote.ms].reduce((a, b) => a > b ? a : b);
    final int c;
    if (pt == _last.ms && pt == remote.ms) {
      c = (_last.counter > remote.counter ? _last.counter : remote.counter) + 1;
    } else if (pt == _last.ms) {
      c = _last.counter + 1;
    } else if (pt == remote.ms) {
      c = remote.counter + 1;
    } else {
      c = 0;
    }
    return _last = Hlc(pt, c, node);
  }
}
