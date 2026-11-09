import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/terminal/terminal_context.dart';
import '../features/device_setup/presentation/cubit/activation_cubit.dart';
import '../features/device_setup/presentation/pages/activation_gate_page.dart';
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
  // Re-run the redirect when the activation starts or stops allowing sales (expiry, event, code).
  refreshListenable: sl.isRegistered<ActivationCubit>() ? _SellGateListenable(sl<ActivationCubit>()) : null,
  redirect: (context, state) {
    final loggedIn = sl<StaffSession>().value != null;
    final loc = state.matchedLocation;
    // Selling needs a logged-in cashier.
    if (loc == Routes.sell && !loggedIn) return Routes.lock;
    // ... and an activated terminal: otherwise the activation gate instead of the sell screen.
    final activation = sl.isRegistered<ActivationCubit>() ? sl<ActivationCubit>().state : null;
    if (activation == null) return null;
    if (loc == Routes.sell && !activation.canSell) return Routes.activation;
    if (loc == Routes.activation && activation.canSell && state.uri.queryParameters['renew'] == null) {
      return loggedIn ? Routes.sell : Routes.lock;
    }
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
    GoRoute(
      path: Routes.activation,
      builder: (context, state) {
        final holder = sl<TerminalContextHolder>();
        final ctx = holder.ready ? holder.ctx : null;
        final loggedIn = sl<StaffSession>().value != null;
        return BlocProvider.value(
          value: sl<ActivationCubit>(),
          child: ActivationGatePage(
            storeName: ctx?.storeName ?? '',
            deviceCode: ctx?.deviceCode ?? '',
            toLocal: ctx?.localNow,
            loggedIn: loggedIn,
            renew: state.uri.queryParameters['renew'] != null,
            onOrders: () => context.push(Routes.orders),
            onPrinters: () => context.push(Routes.printers),
            onLogin: () => context.go(Routes.lock),
            onLogout: () {
              sl<StaffSession>().value = null;
              context.go(Routes.lock);
            },
          ),
        );
      },
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

/// Notifies the router when [ActivationCubit] flips between "may sell" and "blocked".
class _SellGateListenable extends ChangeNotifier {
  _SellGateListenable(ActivationCubit cubit) : _canSell = cubit.state.canSell {
    _sub = cubit.stream.listen((s) {
      if (s.canSell == _canSell) return;
      _canSell = s.canSell;
      notifyListeners();
    });
  }

  bool _canSell;
  late final StreamSubscription<ActivationState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
