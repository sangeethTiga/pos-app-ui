import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Parses "12.50" into minor units for [decimals]; null when invalid.
int? parseMoney(String text, int decimals) {
  final t = text.trim();
  if (!RegExp(r'^\d+([.,]\d*)?$').hasMatch(t)) return null;
  final parts = t.replaceAll(',', '.').split('.');
  final frac = parts.length > 1 ? parts[1] : '';
  if (frac.length > decimals) return null;
  var mult = 1;
  for (var i = 0; i < decimals; i++) {
    mult *= 10;
  }
  return int.parse(parts[0]) * mult + (frac.isEmpty ? 0 : int.parse(frac.padRight(decimals, '0')));
}

class MoneyField extends StatelessWidget {
  const MoneyField({
    super.key,
    required this.controller,
    required this.label,
    this.autofocus = false,
    this.onSubmitted,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    autofocus: autofocus,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
    decoration: InputDecoration(labelText: label),
    onSubmitted: onSubmitted,
    onChanged: onChanged,
  );
}
