import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Width classes of the POS screens. Breakpoints follow Material 3 window size classes, with two
/// extra classes for large POS monitors and TVs.
enum ScreenClass {
  /// < 600: phones in portrait.
  compact,

  /// 600–904: phones in landscape, small tablets, tablets in portrait.
  medium,

  /// 905–1239: tablets in landscape, 10–12" POS terminals (1024 x 768).
  expanded,

  /// 1240–1919: laptops, desktops, 15" POS terminals (1280–1600 wide).
  large,

  /// >= 1920: full-HD monitors, large POS screens, TVs and 4K.
  xlarge,
}

/// Central breakpoints (logical pixels). Use these, never raw screen widths.
abstract final class Breakpoints {
  static const double medium = 600;
  static const double expanded = 905;
  static const double large = 1240;
  static const double xlarge = 1920;

  /// 4K and up (3840 physical at 1.0 or 2560+ logical).
  static const double ultra = 2560;

  /// Below this a side-by-side "products | cart" layout no longer fits; the cart becomes a sheet.
  static const double splitPane = 900;

  static ScreenClass classOf(double width) {
    if (width < medium) return ScreenClass.compact;
    if (width < expanded) return ScreenClass.medium;
    if (width < large) return ScreenClass.expanded;
    if (width < xlarge) return ScreenClass.large;
    return ScreenClass.xlarge;
  }
}

/// Responsive facts and size tokens for one layout box.
///
/// Layouts adapt structurally per [ScreenClass] (columns, panes, sheets, navigation). Sizes come
/// from tokens: the screens were drawn on a 1920-wide POS monitor, so [f]/[s] map a value from that
/// drawing to the density of the current class (a step per class, not a continuous zoom), and
/// [tap] never goes below a finger-sized touch target.
@immutable
class Responsive {
  const Responsive._(this.width, this.height, this.cls, this.orientation, this.touch);

  /// From the whole screen (MediaQuery).
  factory Responsive.of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Responsive._fromSize(context, size.width, size.height);
  }

  /// From a layout box (LayoutBuilder constraints); falls back to the screen when unbounded.
  factory Responsive.constraints(BuildContext context, BoxConstraints c) {
    final screen = MediaQuery.sizeOf(context);
    return Responsive._fromSize(
      context,
      c.hasBoundedWidth ? c.maxWidth : screen.width,
      c.hasBoundedHeight ? c.maxHeight : screen.height,
    );
  }

  factory Responsive._fromSize(BuildContext context, double w, double h) {
    final platform = Theme.of(context).platform;
    final touch = platform == TargetPlatform.android || platform == TargetPlatform.iOS;
    return Responsive._(w, h, Breakpoints.classOf(w), w >= h ? Orientation.landscape : Orientation.portrait, touch);
  }

  final double width, height;
  final ScreenClass cls;
  final Orientation orientation;

  /// Phone / tablet OS. Desktop POS terminals often have touch screens too, so touch targets are
  /// kept at least [minTap] everywhere; this only adds a little extra room on mobile.
  final bool touch;

  bool get isCompact => cls == ScreenClass.compact;
  bool get isMedium => cls == ScreenClass.medium;
  bool get isPhone => cls == ScreenClass.compact || (cls == ScreenClass.medium && height < 500);
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isUltra => width >= Breakpoints.ultra;

  /// Products and cart side by side (otherwise the cart is a bottom sheet).
  bool get splitPane => width >= Breakpoints.splitPane;

  /// Density of this class relative to the 1920-wide drawing.
  double get density {
    if (width >= Breakpoints.ultra) return math.min(1.6, width / Breakpoints.xlarge);
    return switch (cls) {
      ScreenClass.compact => 0.78,
      ScreenClass.medium => 0.8,
      ScreenClass.expanded => 0.72,
      ScreenClass.large => width < 1500 ? 0.76 : 0.86,
      ScreenClass.xlarge => 1.0,
    };
  }

  /// Font size / icon size token.
  double f(double designPx) => (designPx * density).roundToDouble();

  /// Spacing / padding token.
  double s(double designPx) => (designPx * density).roundToDouble();

  /// Minimum touch target (Material: 48).
  double get minTap => touch ? 48 : 44;

  /// Height of a tappable control: the token, but never smaller than a finger.
  double tap(double designPx) => math.max(f(designPx), minTap);

  /// Page padding.
  double get gutter => switch (cls) {
    ScreenClass.compact => 12,
    ScreenClass.medium => 16,
    ScreenClass.expanded => 16,
    ScreenClass.large => 20,
    ScreenClass.xlarge => isUltra ? 32 : 24,
  };

  /// Value for this class; missing ones fall back to the nearest smaller class.
  T pick<T>({required T compact, T? medium, T? expanded, T? large, T? xlarge}) {
    final m = medium ?? compact;
    final e = expanded ?? m;
    final l = large ?? e;
    final x = xlarge ?? l;
    return switch (cls) {
      ScreenClass.compact => compact,
      ScreenClass.medium => m,
      ScreenClass.expanded => e,
      ScreenClass.large => l,
      ScreenClass.xlarge => x,
    };
  }

  /// Grid columns for tiles at least [minTileWidth] (design px) wide in [available] width.
  int columns(double available, {required double minTileWidth, int min = 1, int max = 12}) =>
      (available / s(minTileWidth)).floor().clamp(min, max);
}

extension ResponsiveContext on BuildContext {
  /// Responsive facts of the whole screen. Inside a [ResponsiveBuilder] prefer its argument.
  Responsive get r => Responsive.of(this);
}

/// LayoutBuilder that hands its child the [Responsive] facts of the space it actually has.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder});
  final Widget Function(BuildContext context, Responsive r) builder;

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, c) => builder(context, Responsive.constraints(context, c)));
}

/// Shows [child] as a dialog sized for the screen: full screen on phones, a centred card capped
/// at [maxWidth] (design px) and 90 % of the height elsewhere. Keeps clear of the keyboard.
Future<T?> showPosDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double maxWidth = 720,
  bool barrierDismissible = true,
}) => showDialog<T>(
  context: context,
  barrierDismissible: barrierDismissible,
  builder: (ctx) => PosDialogFrame(
    maxWidth: maxWidth,
    child: Builder(builder: builder),
  ),
);

/// Constrains a dialog to the screen class (used by [showPosDialog]; also wraps existing
/// AlertDialogs so they never overflow the screen or hide under the keyboard).
class PosDialogFrame extends StatelessWidget {
  const PosDialogFrame({super.key, required this.child, this.maxWidth = 720});
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final mq = MediaQuery.of(context);
    final avail = Size(mq.size.width, mq.size.height - mq.viewInsets.bottom);
    final cap = math.min(r.s(maxWidth).clamp(280.0, 1100.0), avail.width - (r.isCompact ? 16 : 48));
    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: cap, maxHeight: math.max(240, avail.height * 0.92)),
          child: MediaQuery.removeViewInsets(context: context, removeBottom: true, child: child),
        ),
      ),
    );
  }
}

/// App-wide text scaling limits: honour the user's accessibility setting but cap it so dense POS
/// screens stay usable.
Widget clampTextScale(BuildContext context, Widget? child) =>
    MediaQuery.withClampedTextScaling(minScaleFactor: 0.85, maxScaleFactor: 1.3, child: child ?? const SizedBox());
