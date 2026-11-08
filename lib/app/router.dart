import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../features/device_setup/presentation/pages/device_setup_page.dart';
import '../features/device_setup/presentation/pages/splash_page.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/printing/presentation/printer_settings_page.dart';
import '../features/sales/presentation/cubit/sell_cubit.dart';
import '../features/sales/presentation/pages/sell_page.dart';
import '../features/staff/data/staff_repository.dart';
import '../features/staff/presentation/pin_login_cubit.dart';
import '../features/staff/presentation/pin_login_page.dart';
import 'routes.dart';

/// Screen-level blocs are created per route; app-wide blocs live in [App].
GoRouter createRouter({String initialLocation = Routes.splash}) => GoRouter(
  initialLocation: initialLocation,
  redirect: (context, state) {
    // Selling needs a logged-in cashier.
    if (state.matchedLocation == Routes.sell && sl<StaffSession>().value == null) return Routes.lock;
    return null;
  },
  routes: [
    GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
    GoRoute(path: Routes.setup, builder: (_, _) => const DeviceSetupPage()),
    GoRoute(
      path: Routes.home,
      builder: (_, _) => BlocProvider(create: (_) => sl<HomeCubit>()..load(), child: const HomePage()),
    ),
    GoRoute(
      path: Routes.lock,
      builder: (_, _) => BlocProvider(create: (_) => sl<PinLoginCubit>()..load(), child: const PinLoginPage()),
    ),
    GoRoute(
      path: Routes.sell,
      builder: (_, _) => BlocProvider(create: (_) => sl<SellCubit>()..load(), child: const SellPage()),
    ),
    GoRoute(path: Routes.printers, builder: (_, _) => const PrinterSettingsPage()),
  ],
);
