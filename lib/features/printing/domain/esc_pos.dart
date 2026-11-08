import 'dart:convert';
import 'dart:typed_data';

/// Minimal ESC/POS command builder (Epson-compatible thermal printers, 58/80 mm).
/// Text is sent as Latin-1; characters outside it are replaced with '?'.
class EscPos {
  EscPos({this.width = 48});

  /// Characters per line: 48 for 80 mm (font A), 32 for 58 mm.
  final int width;
  final BytesBuilder _b = BytesBuilder()..add(const [0x1B, 0x40]); // ESC @ init

  Uint8List get bytes => _b.toBytes();

  void _raw(List<int> b) => _b.add(b);

  EscPos align(String a) {
    _raw([0x1B, 0x61, a == 'center' ? 1 : (a == 'right' ? 2 : 0)]);
    return this;
  }

  EscPos bold(bool on) {
    _raw([0x1B, 0x45, on ? 1 : 0]);
    return this;
  }

  /// Double width and height.
  EscPos big(bool on) {
    _raw([0x1D, 0x21, on ? 0x11 : 0x00]);
    return this;
  }

  EscPos text(String s) {
    _raw(latin1.encode(s.runes.map((r) => r < 256 ? String.fromCharCode(r) : '?').join()));
    _raw([0x0A]);
    return this;
  }

  /// Left text and right text on one line.
  EscPos row(String left, String right) {
    final space = width - right.length;
    final l = left.length > space - 1 ? left.substring(0, space - 1) : left;
    return text(l.padRight(space) + right);
  }

  EscPos line([String ch = '-']) => text(ch * width);

  EscPos feed(int lines) {
    _raw([0x1B, 0x64, lines]);
    return this;
  }

  /// Partial cut after feeding.
  EscPos cut() {
    _raw([0x1D, 0x56, 0x42, 0x03]);
    return this;
  }

  /// Cash drawer kick on pin 2 (ESC p 0 25 250).
  EscPos openDrawer() {
    _raw([0x1B, 0x70, 0x00, 0x19, 0xFA]);
    return this;
  }
}
