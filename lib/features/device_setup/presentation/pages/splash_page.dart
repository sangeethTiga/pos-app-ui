import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../terminal/terminal_cubit.dart';
import '../../domain/entities/device_session.dart';
import '../bloc/device_setup_bloc.dart';
import '../cubit/activation_cubit.dart';

/// Decides between pairing and the home screen.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<DeviceSetupBloc>().add(const DeviceSetupEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceSetupBloc, DeviceSetupState>(
      listener: (context, state) => switch (state) {
        DeviceSetupPaired(:final session) => _start(context, session),
        DeviceSetupUnpaired() => context.go(Routes.setup),
        _ => null,
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  Future<void> _start(BuildContext context, DeviceSession session) async {
    context.read<TerminalCubit>().start(session);
    final activation = context.read<ActivationCubit>();
    await activation.start(session.deviceId); // stored state first: works offline
    if (!context.mounted) return;
    // Not activated: the activation gate first (staff login stays one tap away).
    context.go(activation.state.canSell ? Routes.lock : Routes.activation);
  }
}
