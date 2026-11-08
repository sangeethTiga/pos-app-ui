import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../features/device_setup/presentation/pages/device_setup_page.dart';
import '../features/device_setup/presentation/pages/splash_page.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../features/home/presentation/pages/home_page.dart';
import 'routes.dart';

/// Screen-level blocs are created per route; app-wide blocs live in [App].
GoRouter createRouter() => GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
    GoRoute(path: Routes.setup, builder: (_, _) => const DeviceSetupPage()),
    GoRoute(
      path: Routes.home,
      builder: (_, _) => BlocProvider(create: (_) => sl<HomeCubit>()..load(), child: const HomePage()),
    ),
  ],
);
