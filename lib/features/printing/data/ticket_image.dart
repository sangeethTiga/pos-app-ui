import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

import '../domain/esc_pos.dart';

/// Image print style: draws the ticket's lines (any script, e.g. Arabic) and returns ESC/POS raster
/// bytes, with the ticket's feed, cut and drawer kick.
Future<Uint8List> ticketImage(EscPos ticket, {int widthChars = 48}) async {
  // 80 mm heads are 576 dots wide, 58 mm heads 384.
  final widthPx = widthChars >= 42 ? 576 : 384;
  final fontSize = widthPx / widthChars * 1.65;
  const pad = 4.0;

  final painters = [
    for (final l in ticket.lines)
      TextPainter(
        text: TextSpan(
          text: l.text,
          style: TextStyle(
            color: const Color(0xFF000000),
            fontSize: l.big ? fontSize * 2 : fontSize,
            fontWeight: l.bold || l.big ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'monospace',
            fontFamilyFallback: const ['Menlo', 'Courier New', 'Roboto Mono', 'Noto Sans Arabic'],
            height: 1.15,
          ),
        ),
        textAlign: switch (l.align) {
          'center' => TextAlign.center,
          'right' => TextAlign.right,
          _ => TextAlign.left,
        },
        textDirection: TextDirection.ltr,
      )..layout(minWidth: widthPx.toDouble(), maxWidth: widthPx.toDouble()),
  ];
  final textHeight = painters.fold<double>(0, (h, p) => h + p.height);
  final heightPx = (textHeight + pad * 2).ceil();

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)
    ..drawRect(Rect.fromLTWH(0, 0, widthPx.toDouble(), heightPx.toDouble()), Paint()..color = const Color(0xFFFFFFFF));
  var y = pad;
  for (final p in painters) {
    p.paint(canvas, Offset(0, y));
    y += p.height;
  }
  final image = await recorder.endRecording().toImage(widthPx, heightPx);
  final rgba = (await image.toByteData())!;
  image.dispose();

  final bytesPerRow = widthPx ~/ 8;
  final bits = Uint8List(bytesPerRow * heightPx);
  for (var row = 0; row < heightPx; row++) {
    for (var x = 0; x < widthPx; x++) {
      final i = (row * widthPx + x) * 4;
      final lum = (rgba.getUint8(i) * 299 + rgba.getUint8(i + 1) * 587 + rgba.getUint8(i + 2) * 114) ~/ 1000;
      if (lum < 128) bits[row * bytesPerRow + (x >> 3)] |= 0x80 >> (x & 7);
    }
  }

  final out = BytesBuilder()..add(EscPos.raster(widthPx, heightPx, bits));
  if (ticket.feedLines > 0) out.add([0x1B, 0x64, ticket.feedLines]);
  if (ticket.cuts) out.add(const [0x1D, 0x56, 0x42, 0x03]);
  if (ticket.kicksDrawer) out.add(const [0x1B, 0x70, 0x00, 0x19, 0xFA]);
  return out.toBytes();
}
