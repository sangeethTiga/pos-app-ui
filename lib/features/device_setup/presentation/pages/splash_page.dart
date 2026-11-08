import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
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
        DeviceSetupPaired() => context.go(Routes.home),
        DeviceSetupUnpaired() => context.go(Routes.setup),
        _ => null,
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
