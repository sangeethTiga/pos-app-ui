import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/terminal/terminal_context.dart';
import '../features/device_setup/presentation/pages/device_setup_page.dart';
import '../features/device_setup/presentation/pages/splash_page.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/orders/presentation/order_detail_cubit.dart';
import '../features/orders/presentation/order_detail_page.dart';
import '../features/orders/presentation/orders_cubit.dart';
import '../features/orders/presentation/orders_page.dart';
import '../features/printing/presentation/printer_settings_page.dart';
import '../features/sales/presentation/cubit/sell_cubit.dart';
import '../features/sales/presentation/pages/sell_page.dart';
import '../features/staff/data/staff_repository.dart';
import '../features/staff/presentation/login_cubit.dart';
import '../features/staff/presentation/login_page.dart';
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
      builder: (_, _) => BlocProvider(
        create: (_) => sl<LoginCubit>()..load(),
        child: LoginPage(storeName: sl<TerminalContextHolder>().ready ? sl<TerminalContextHolder>().ctx.storeName : ''),
      ),
    ),
    GoRoute(
      path: Routes.sell,
      builder: (_, _) => BlocProvider(create: (_) => sl<SellCubit>()..load(), child: const SellPage()),
    ),
    GoRoute(path: Routes.printers, builder: (_, _) => const PrinterSettingsPage()),
    GoRoute(
      path: Routes.orders,
      builder: (_, state) => BlocProvider(
        create: (_) => sl<OrdersCubit>()
          ..open(state.uri.queryParameters['channel'])
          ..load(),
        child: const OrdersPage(),
      ),
      routes: [
        GoRoute(
          path: ':id',
          builder: (_, state) => BlocProvider(
            create: (_) => sl<OrderDetailCubit>(param1: state.pathParameters['id']!)..load(),
            child: const OrderDetailPage(),
          ),
        ),
      ],
    ),
  ],
);
