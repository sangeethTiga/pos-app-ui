import 'package:flutter/material.dart';

import '../../../core/responsive/pos_popup.dart';
import '../../../core/terminal/terminal_context.dart';
import '../../../core/widgets/money_field.dart';
import '../domain/shift_service.dart';

Future<int?> askAmount(BuildContext context, {required String title, required int decimals, String label = 'Amount'}) {
  final c = TextEditingController();
  return showPosPopup<int>(
    context,
    maxWidth: 520,
    builder: (ctx) => posAlert(
      ctx,
      title: Text(title),
      content: MoneyField(
        controller: c,
        label: label,
        autofocus: true,
        onSubmitted: (_) => Navigator.pop(ctx, parseMoney(c.text, decimals)),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, parseMoney(c.text, decimals)), child: const Text('OK')),
      ],
    ),
  );
}

Future<({String direction, int amount, String reason})?> askCashMovement(BuildContext context, int decimals) {
  final amount = TextEditingController();
  final reason = TextEditingController();
  var direction = 'OUT';
  return showPosPopup(
    context,
    maxWidth: 560,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, set) => posAlert(
        ctx,
        title: const Text('Cash in / paid out'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<String>(
              expandedInsets: EdgeInsets.zero,
              segments: const [
                ButtonSegment(value: 'IN', label: Text('Cash in')),
                ButtonSegment(value: 'OUT', label: Text('Paid out')),
              ],
              selected: {direction},
              onSelectionChanged: (v) => set(() => direction = v.first),
            ),
            const SizedBox(height: 12),
            MoneyField(controller: amount, label: 'Amount', autofocus: true),
            const SizedBox(height: 12),
            TextField(
              controller: reason,
              decoration: const InputDecoration(labelText: 'Reason'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final a = parseMoney(amount.text, decimals);
              if (a == null || a <= 0 || reason.text.trim().isEmpty) return;
              Navigator.pop(ctx, (direction: direction, amount: a, reason: reason.text.trim()));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

Future<void> showShiftClosed(BuildContext context, TerminalContext t, ShiftSummary s, int counted) => showPosPopup(
  context,
  maxWidth: 560,
  builder: (ctx) => posAlert(
    ctx,
    title: const Text('Shift closed'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Orders: ${s.orders}'),
        Text('Opening float: ${t.money(s.openingFloatMinor)}'),
        Text('Cash sales: ${t.money(s.cashSalesMinor)}'),
        Text('Cash in / out: ${t.money(s.cashInMinor)} / ${t.money(s.cashOutMinor)}'),
        Text('Expected cash: ${t.money(s.expectedCashMinor)}'),
        Text('Counted cash: ${t.money(counted)}'),
        Text(
          'Difference: ${t.money(counted - s.expectedCashMinor)}',
          style: TextStyle(fontWeight: FontWeight.bold, color: counted == s.expectedCashMinor ? null : Colors.red),
        ),
      ],
    ),
    actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
  ),
);
