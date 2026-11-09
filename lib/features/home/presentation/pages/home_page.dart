import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../device_setup/domain/activation_policy.dart';
import '../../../device_setup/domain/entities/device_activation.dart';
import '../../../device_setup/presentation/widgets/activation_text.dart';
import '../cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeUnpaired) context.go(Routes.setup);
      },
      builder: (context, state) {
        if (state is! HomeReady) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final s = state.session;
        final r = context.r;
        final theme = Theme.of(context);
        // Material text grows on 4K screens (never shrinks on phones).
        final grow = math.max(1.0, r.density);
        return Theme(
          data: grow == 1 ? theme : theme.copyWith(textTheme: theme.textTheme.apply(fontSizeFactor: grow)),
          child: Scaffold(
            appBar: AppBar(
              title: Text('${s.store.name} · ${s.deviceCode}', maxLines: 1, overflow: TextOverflow.ellipsis),
              actions: [
                IconButton(
                  tooltip: 'Check server',
                  onPressed: state.checking ? null : () => context.read<HomeCubit>().checkServer(),
                  icon: const Icon(Icons.sync),
                ),
                IconButton(
                  tooltip: 'Unpair',
                  onPressed: () => context.read<HomeCubit>().unpair(),
                  icon: const Icon(Icons.link_off),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, c) {
                // Centred column with a readable width; the list still scrolls edge to edge.
                final side = math.max(r.gutter * 1.5, (c.maxWidth - math.max(640, r.s(900))) / 2);
                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: side, vertical: r.gutter * 1.5),
                  children: [
                    _Row('Store', '${s.store.name} (${s.store.code})'),
                    _Row('Terminal', '${s.deviceCode}  token letter ${s.tokenLetter}'),
                    _Row('Currency', '${s.store.currency} (${s.store.currencyDecimals} decimals)'),
                    _Row('Timezone', s.store.timezone),
                    const Divider(height: 32),
                    if (state.checking) const LinearProgressIndicator(),
                    if (state.status case final st?) ...[
                      _Row('Server', 'connected (signed request OK)'),
                      _Row('Device status', st.status),
                      _Row('Can sell', st.canSell ? 'yes' : 'no (store ${st.storeStatus})'),
                      if (st.activation case final a?)
                        _Row(
                          'Activation',
                          activationHeadline(
                            ActivationPolicy.evaluate(
                              ActivationSnapshot(activation: a, receivedAt: DateTime.now().toUtc()),
                              DateTime.now(),
                            ),
                          ),
                        ),
                      _Row('Gateway', st.isGateway ? 'this terminal' : 'no'),
                      if (st.businessDate != null) _Row('Business date', st.businessDate!),
                    ],
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        key: const Key('enterActivationCode'),
                        onPressed: () => context.push(Routes.activationRenew),
                        icon: const Icon(Icons.vpn_key_outlined),
                        label: const Text('Enter activation code'),
                      ),
                    ),
                    if (state.failure case final f?)
                      Text(
                        f.userMessage,
                        key: const Key('homeError'),
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: r.pick(compact: 110.0, medium: 140.0, xlarge: math.max(140, r.s(200))),
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
