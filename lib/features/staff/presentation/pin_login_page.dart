import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../terminal/terminal_cubit.dart';
import '../../terminal/widgets/sync_chip.dart';
import 'pin_login_cubit.dart';

/// Cashier picks their name and enters their PIN. Works offline (PINs are checked on the terminal).
class PinLoginPage extends StatelessWidget {
  const PinLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PinLoginCubit, PinLoginState>(
      listenWhen: (a, b) => !a.loggedIn && b.loggedIn,
      listener: (context, _) => context.go(Routes.sell),
      builder: (context, state) {
        final cubit = context.read<PinLoginCubit>();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Who is selling?'),
            actions: [
              const SyncChip(),
              IconButton(
                tooltip: 'Device status',
                icon: const Icon(Icons.info_outline),
                onPressed: () => context.push(Routes.home),
              ),
            ],
          ),
          body: BlocListener<TerminalCubit, TerminalState>(
            listenWhen: (a, b) => a.lastReport != b.lastReport,
            listener: (context, _) => cubit.load(),
            child: state.users.isEmpty
                ? const _NoUsers()
                : Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: GridView.extent(
                          padding: const EdgeInsets.all(24),
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.2,
                          children: [
                            for (final u in state.users)
                              ChoiceChip(
                                key: Key('user-${u.id}'),
                                label: SizedBox(
                                  width: double.infinity,
                                  child: Text(u.name, textAlign: TextAlign.center),
                                ),
                                selected: state.selected?.id == u.id,
                                onSelected: (_) => cubit.select(u),
                              ),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      SizedBox(
                        width: 340,
                        child: _PinPad(state: state, cubit: cubit),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _NoUsers extends StatelessWidget {
  const _NoUsers();

  @override
  Widget build(BuildContext context) {
    final t = context.watch<TerminalCubit>().state;
    final r = t.lastReport;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('No staff on this terminal yet.', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            t.syncing
                ? 'Downloading users and menu from the server...'
                : r == null
                ? 'Waiting for the first sync.'
                : 'Last sync: ${r.result.name}${r.mode != null ? ' (mode ${r.mode})' : ''}${r.message != null ? ' — ${r.message}' : ''}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: t.syncing ? null : () => context.read<TerminalCubit>().syncNow(),
            icon: const Icon(Icons.sync),
            label: const Text('Sync now'),
          ),
        ],
      ),
    );
  }
}

class _PinPad extends StatelessWidget {
  const _PinPad({required this.state, required this.cubit});

  final PinLoginState state;
  final PinLoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    Widget key(String label, VoidCallback? onTap, {Key? k}) => Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        width: 80,
        height: 64,
        child: OutlinedButton(
          key: k,
          onPressed: onTap,
          child: Text(label, style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
    final enabled = state.selected != null && !state.checking;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.selected?.name ?? 'Select your name', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text('•' * state.pin.length, style: const TextStyle(fontSize: 32, letterSpacing: 8)),
          if (state.error != null)
            Text(
              state.error!,
              key: const Key('pinError'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          if (state.checking) const Padding(padding: EdgeInsets.all(8), child: LinearProgressIndicator()),
          const SizedBox(height: 12),
          for (final row in const [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [for (final d in row) key(d, enabled ? () => cubit.digit(d) : null, k: Key('pin-$d'))],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              key('⌫', enabled ? cubit.backspace : null),
              key('0', enabled ? () => cubit.digit('0') : null, k: const Key('pin-0')),
              key('OK', enabled ? cubit.submit : null, k: const Key('pin-ok')),
            ],
          ),
        ],
      ),
    );
  }
}
