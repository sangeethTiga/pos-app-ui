import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    visualDensity: VisualDensity.standard,
  );
}

/// Colours of the registration and login screens (match the reference POS screens).
abstract final class PosColors {
  /// "Register Device" / "Login" buttons.
  static const navy = Color(0xFF1D3557);

  /// Settings section cards.
  static const card = Color(0xFFF4F1F8);

  /// Checkboxes and radios.
  static const accent = Color(0xFF6750A4);

  /// CASHIER badge on the login screen.
  static const online = Color(0xFF5CB85C);
}
