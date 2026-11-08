import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'responsive.dart';

/// Adaptive popup building blocks shared by all POS dialogs: a touch-friendly dialog theme, a
/// sized popup, an AlertDialog replacement that scrolls, and an equal-width tile grid.

/// Font size token for [designPx] (drawn on the 1920-wide screen), never below a readable 14.
double posFont(Responsive r, double designPx) => math.max(r.f(designPx), 14);

/// Theme of the POS popups: buttons, icon buttons, radios and checkboxes are at least
/// [Responsive.minTap] tall, and Material text grows with the density on 4K screens (it never
/// shrinks below Material's sizes on phones).
Widget posDialogTheme(BuildContext context, Widget child) {
  final r = context.r;
  final theme = Theme.of(context);
  final tap = ButtonStyle(minimumSize: WidgetStatePropertyAll(Size(64, r.tap(48))));
  final grow = math.max(1.0, r.density);
  return Theme(
    data: theme.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: grow == 1 ? theme.textTheme : theme.textTheme.apply(fontSizeFactor: grow),
      filledButtonTheme: FilledButtonThemeData(style: tap.merge(theme.filledButtonTheme.style)),
      textButtonTheme: TextButtonThemeData(style: tap.merge(theme.textButtonTheme.style)),
      outlinedButtonTheme: OutlinedButtonThemeData(style: tap.merge(theme.outlinedButtonTheme.style)),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(minimumSize: WidgetStatePropertyAll(Size.square(r.minTap)))
            .merge(theme.iconButtonTheme.style),
      ),
    ),
    child: child,
  );
}

/// Shows a popup as a card capped at [maxWidth] design px ([showPosDialog]: near full width on
/// phones, clear of the keyboard) with [posDialogTheme]. Build it with [posAlert] or a [Dialog]
/// with `insetPadding: EdgeInsets.zero`.
Future<T?> showPosPopup<T>(BuildContext context, {double maxWidth = 560, required WidgetBuilder builder}) =>
    showPosDialog<T>(
      context: context,
      maxWidth: maxWidth,
      builder: (ctx) => posDialogTheme(ctx, Builder(builder: builder)),
    );

/// Alert-style popup for [showPosPopup] (title, content, actions like an AlertDialog): fills the
/// popup's width, title and content scroll on short screens and with the keyboard open, actions
/// stay visible and wrap onto more lines when they do not fit. (No IntrinsicWidth, so the content
/// may use LayoutBuilder, e.g. [TileGrid].)
Widget posAlert(
  BuildContext context, {
  required Widget title,
  required Widget content,
  required List<Widget> actions,
  Color? backgroundColor,
}) {
  final r = context.r;
  final theme = Theme.of(context);
  final pad = r.s(28);
  return Dialog(
    backgroundColor: backgroundColor,
    insetPadding: EdgeInsets.zero,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, pad, pad, r.s(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DefaultTextStyle(
                  style: (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(
                    fontSize: posFont(r, 28),
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  child: Semantics(container: true, child: title),
                ),
                SizedBox(height: r.s(16)),
                DefaultTextStyle(
                  style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  child: content,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(pad, 0, pad, r.s(20)),
          child: OverflowBar(
            alignment: MainAxisAlignment.end,
            overflowAlignment: OverflowBarAlignment.end,
            spacing: 8,
            overflowSpacing: 8,
            children: actions,
          ),
        ),
      ],
    ),
  );
}

/// Equal-width tiles in as many columns as fit tiles at least [minTileWidth] design px wide.
class TileGrid extends StatelessWidget {
  const TileGrid({super.key, required this.minTileWidth, required this.children, this.spacing = 12});

  final double minTileWidth;

  /// Gap between tiles (design px).
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final r = context.r;
      final gap = r.s(spacing);
      final cols = r.columns(c.maxWidth + gap, minTileWidth: minTileWidth + spacing, max: math.max(1, children.length));
      final w = ((c.maxWidth - gap * (cols - 1)) / cols).floorToDouble();
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (final child in children) SizedBox(width: w, child: child)],
      );
    },
  );
}
