import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/responsive/responsive.dart';
import '../features/device_setup/presentation/bloc/device_setup_bloc.dart';
import '../features/terminal/terminal_cubit.dart';
import 'router.dart';
import 'theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // App-wide blocs: device pairing state is needed by splash and setup screens.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<DeviceSetupBloc>()),
        BlocProvider.value(value: sl<TerminalCubit>()),
      ],
      child: MaterialApp.router(
        title: 'POS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: _router,
        builder: clampTextScale,
      ),
    );
  }
}
