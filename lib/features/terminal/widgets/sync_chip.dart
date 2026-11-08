import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../sync/domain/sync_engine.dart';
import '../terminal_cubit.dart';

/// "Synced · 0 pending" / "Offline · 12 pending". Tap to sync now.
class SyncChip extends StatelessWidget {
  const SyncChip({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<TerminalCubit>().state;
    final r = s.lastReport?.result;
    final (icon, text) = switch (r) {
      _ when s.syncing => (Icons.sync, 'Syncing'),
      SyncResult.synced => (Icons.cloud_done_outlined, 'Synced'),
      SyncResult.waitingForSchedule => (Icons.schedule, 'Scheduled'),
      SyncResult.notGateway => (Icons.lan_outlined, 'Not gateway'),
      SyncResult.failed => (Icons.cloud_off_outlined, 'Offline'),
      null => (Icons.cloud_queue, 'Not synced'),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ActionChip(
        key: const Key('syncChip'),
        avatar: Icon(icon, size: 18),
        label: Text('$text · ${s.pending} pending'),
        tooltip: s.lastReport?.message ?? 'Sync now',
        onPressed: s.syncing ? null : () => context.read<TerminalCubit>().syncNow(),
      ),
    );
  }
}
