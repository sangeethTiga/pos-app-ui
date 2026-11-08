import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../terminal/terminal_cubit.dart';
import '../../domain/entities/device_session.dart';
import '../bloc/device_setup_bloc.dart';

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

  void _start(BuildContext context, DeviceSession session) {
    context.read<TerminalCubit>().start(session);
    context.go(Routes.lock);
  }
}
