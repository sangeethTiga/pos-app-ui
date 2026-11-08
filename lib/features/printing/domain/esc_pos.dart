import 'dart:convert';
import 'dart:typed_data';

/// One printed text line, kept for image-style printing.
class PrintLine {
  const PrintLine(this.text, {this.align = 'left', this.bold = false, this.big = false});
  final String text, align;
  final bool bold, big;
}

/// Minimal ESC/POS command builder (Epson-compatible thermal printers, 58/80 mm).
/// Text is sent as Latin-1; characters outside it are replaced with '?' (use the Image print style
/// for Arabic and other scripts).
class EscPos {
  EscPos({this.width = 48});

  /// Characters per line: 48 for 80 mm (font A), 32 for 58 mm.
  final int width;
  final BytesBuilder _b = BytesBuilder()..add(const [0x1B, 0x40]); // ESC @ init

  Uint8List get bytes => _b.toBytes();

  final _preview = StringBuffer();
  String _align = 'left';
  bool _bold = false, _big = false;
  final _lines = <PrintLine>[];
  int _feed = 0;
  bool _cut = false, _drawer = false;

  /// The text lines with their style, for printing the ticket as an image.
  List<PrintLine> get lines => List.unmodifiable(_lines);

  /// Blank lines fed at the end, and whether the ticket ends with a cut / drawer kick.
  int get feedLines => _feed;
  bool get cuts => _cut;
  bool get kicksDrawer => _drawer;

  /// Plain-text copy of the ticket (on-screen preview when no printer is set up).
  String get preview => _preview.toString();

  void _raw(List<int> b) => _b.add(b);

  EscPos align(String a) {
    _align = a;
    _raw([0x1B, 0x61, a == 'center' ? 1 : (a == 'right' ? 2 : 0)]);
    return this;
  }

  EscPos bold(bool on) {
    _bold = on;
    _raw([0x1B, 0x45, on ? 1 : 0]);
    return this;
  }

  /// Double width and height.
  EscPos big(bool on) {
    _big = on;
    _raw([0x1D, 0x21, on ? 0x11 : 0x00]);
    return this;
  }

  EscPos text(String s) {
    _raw(latin1.encode(s.runes.map((r) => r < 256 ? String.fromCharCode(r) : '?').join()));
    _raw([0x0A]);
    final pad = s.length >= width
        ? 0
        : (_align == 'center' ? (width - s.length) ~/ 2 : (_align == 'right' ? width - s.length : 0));
    _preview.writeln(' ' * pad + s);
    _lines.add(PrintLine(s, align: _align, bold: _bold, big: _big));
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
    _feed += lines;
    _raw([0x1B, 0x64, lines]);
    return this;
  }

  /// Partial cut after feeding.
  EscPos cut() {
    _cut = true;
    _raw([0x1D, 0x56, 0x42, 0x03]);
    return this;
  }

  /// Cash drawer kick on pin 2 (ESC p 0 25 250).
  EscPos openDrawer() {
    _drawer = true;
    _raw([0x1B, 0x70, 0x00, 0x19, 0xFA]);
    return this;
  }

  /// Raster image commands (GS v 0) for a 1-bit image, [widthPx] a multiple of 8; [bits] is one
  /// byte per 8 horizontal pixels, rows top to bottom, set bit = black.
  static Uint8List raster(int widthPx, int heightPx, Uint8List bits) {
    final bytesPerRow = widthPx ~/ 8;
    final out = BytesBuilder()..add(const [0x1B, 0x40]);
    // Bands of at most 256 rows; some printers drop larger blocks.
    for (var y = 0; y < heightPx; y += 256) {
      final rows = heightPx - y < 256 ? heightPx - y : 256;
      out
        ..add([0x1D, 0x76, 0x30, 0x00, bytesPerRow & 0xFF, bytesPerRow >> 8, rows & 0xFF, rows >> 8])
        ..add(bits.sublist(y * bytesPerRow, (y + rows) * bytesPerRow));
    }
    return out.toBytes();
  }
}
