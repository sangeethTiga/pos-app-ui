import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    visualDensity: VisualDensity.standard,
  );
}
