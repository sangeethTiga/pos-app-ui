import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../cubit/activation_cubit.dart';
import 'activation_text.dart';

/// Small, non-blocking strip while the activation is valid but ends within 7 days.
class ActivationExpiryBanner extends StatelessWidget {
  const ActivationExpiryBanner({super.key, this.cubit});

  /// Defaults to the app-wide cubit.
  final ActivationCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final bloc = cubit ?? (sl.isRegistered<ActivationCubit>() ? sl<ActivationCubit>() : null);
    if (bloc == null) return const SizedBox.shrink();
    return BlocBuilder<ActivationCubit, ActivationState>(
      bloc: bloc,
      buildWhen: (a, b) => a.verdict != b.verdict,
      builder: (context, s) {
        if (!s.verdict.expiresSoon) return const SizedBox.shrink();
        final scheme = Theme.of(context).colorScheme;
        return Material(
          key: const Key('activationExpiryBanner'),
          color: scheme.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Icon(Icons.schedule, size: 18, color: scheme.onTertiaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${expiryWarning(s.verdict.remainingDays!)}. Ask your administrator to renew it.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: scheme.onTertiaryContainer),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
