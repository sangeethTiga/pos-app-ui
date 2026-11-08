import 'package:flutter/material.dart';

import '../../../../core/terminal/terminal_context.dart';
import '../../../../core/widgets/money_field.dart';
import '../../../catalogue/data/catalogue_repository.dart';
import '../../domain/pricing_engine.dart';

typedef PaymentResult = ({List<({PaymentMethod method, int? amountMinor})> tenders, int? cashTendered});

/// Single or split payment. A cash tender takes "the rest" and is rounded by the store's increment.
Future<PaymentResult?> showPaymentDialog(
  BuildContext context, {
  required TerminalContext t,
  required PricedOrder priced,
  required List<PaymentMethod> methods,
  required int roundingIncrement,
}) {
  final nonCash = <PaymentMethod, TextEditingController>{};
  final cashGiven = TextEditingController();
  PaymentMethod? cash;
  for (final m in methods) {
    if (m.cashLike && cash == null) {
      cash = m;
    } else if (!m.cashLike && m.kind != 'CREDIT') {
      nonCash[m] = TextEditingController();
    }
  }
  return showDialog<PaymentResult>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, set) {
        final paidNonCash = nonCash.entries.fold(0, (s, e) => s + (parseMoney(e.value.text, t.currencyDecimals) ?? 0));
        final rest = priced.totalMinor - paidNonCash;
        final cashDue = cash == null ? 0 : IntMath.roundToIncrement(rest < 0 ? 0 : rest, roundingIncrement);
        final given = parseMoney(cashGiven.text, t.currencyDecimals);
        final valid = rest >= 0 && (cash != null || rest == 0) && (given == null || given >= cashDue);

        void payAll(PaymentMethod m) => Navigator.pop(ctx, (
          tenders: [(method: m, amountMinor: m.cashLike ? null : priced.totalMinor)],
          cashTendered: m.cashLike ? given : null,
        ));

        return AlertDialog(
          title: Text('Pay ${t.currency} ${t.money(priced.totalMinor)}'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final m in [?cash, ...nonCash.keys])
                      FilledButton.tonal(
                        key: Key('payAll-${m.kind}'),
                        onPressed: () => payAll(m),
                        child: Text('All ${m.name}'),
                      ),
                  ],
                ),
                const Divider(height: 24),
                Text('Split payment', style: Theme.of(ctx).textTheme.titleSmall),
                for (final e in nonCash.entries)
                  MoneyField(controller: e.value, label: e.key.name, onChanged: (_) => set(() {})),
                if (cash != null) ...[
                  const SizedBox(height: 8),
                  Text('${cash.name} due: ${t.money(cashDue)}'),
                  MoneyField(controller: cashGiven, label: 'Cash given (for change)', onChanged: (_) => set(() {})),
                  if (given != null && given >= cashDue) Text('Change: ${t.money(given - cashDue)}'),
                ],
                if (rest < 0)
                  Text(
                    'Card/wallet amounts exceed the bill.',
                    style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              key: const Key('confirmPayment'),
              onPressed: valid
                  ? () => Navigator.pop(ctx, (
                      tenders: [
                        for (final e in nonCash.entries)
                          if ((parseMoney(e.value.text, t.currencyDecimals) ?? 0) > 0)
                            (method: e.key, amountMinor: parseMoney(e.value.text, t.currencyDecimals)),
                        if (cash != null && rest > 0) (method: cash, amountMinor: null),
                      ],
                      cashTendered: given,
                    ))
                  : null,
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    ),
  );
}
