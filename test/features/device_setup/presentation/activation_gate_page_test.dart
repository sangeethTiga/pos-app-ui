import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app_ui/app/router.dart';
import 'package:pos_app_ui/app/routes.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/di/injection.dart';
import 'package:pos_app_ui/core/error/failure.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_activation.dart';
import 'package:pos_app_ui/features/device_setup/domain/repositories/activation_repository.dart';
import 'package:pos_app_ui/features/device_setup/presentation/cubit/activation_cubit.dart';
import 'package:pos_app_ui/features/device_setup/presentation/pages/activation_gate_page.dart';
import 'package:pos_app_ui/features/device_setup/presentation/widgets/activation_expiry_banner.dart';
import 'package:pos_app_ui/features/staff/data/staff_repository.dart';
import 'package:pos_app_ui/features/sync/domain/sync_scheduler.dart';
import 'package:pos_app_ui/features/terminal/terminal_cubit.dart';

import 'activation_cubit_test.dart' show FakeActivationRepository;

void main() {
  final now = DateTime.utc(2026, 11, 9, 12);

  Widget gate(ActivationCubit cubit, {bool loggedIn = false}) => MaterialApp(
    home: BlocProvider.value(
      value: cubit,
      child: ActivationGatePage(
        storeName: 'Al Noor Restaurant',
        deviceCode: 'P3',
        toLocal: (u) => u,
        loggedIn: loggedIn,
        onLogout: () {},
        onLogin: () {},
        showSyncChip: false,
      ),
    ),
  );

  testWidgets('not activated: store, terminal, status; code is formatted and sent; errors shown', (tester) async {
    final repo = FakeActivationRepository(
      serverState: DeviceActivation(
        deviceId: 'd1',
        status: ActivationStatus.active,
        valid: true,
        startsAt: DateTime.utc(2026, 11, 1),
        expiresAt: DateTime.utc(2027, 11, 1),
      ),
    )..activateFailure = const Failure.server(statusCode: 422, code: 'INVALID_ACTIVATION_CODE', message: 'x');
    final cubit = ActivationCubit(repo, clock: () => now);
    addTearDown(cubit.close);
    await cubit.load();

    await tester.pumpWidget(gate(cubit));

    expect(find.text('Al Noor Restaurant'), findsOneWidget);
    expect(find.text('Terminal P3'), findsOneWidget);
    expect(find.text('Not activated'), findsOneWidget);
    expect(find.text('Ask your administrator for an activation code for this terminal.'), findsOneWidget);
    expect(find.byKey(const Key('activationStaffLogin')), findsOneWidget);
    expect(find.byKey(const Key('activationLogout')), findsNothing);

    await tester.enterText(find.byKey(const Key('activationCodeField')), 'abcdefghjklm');
    await tester.pump();
    expect(find.text('ABCD-EFGH-JKLM'), findsOneWidget);

    await tester.tap(find.byKey(const Key('activateButton')));
    await tester.pumpAndSettle();
    expect(repo.activatedCodes, ['ABCD-EFGH-JKLM']);
    expect(find.textContaining('not valid for this terminal'), findsOneWidget);

    repo.activateFailure = null;
    await tester.tap(find.byKey(const Key('activateButton')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Active until'), findsOneWidget);
    expect(cubit.state.canSell, isTrue);
  });

  testWidgets('expired, suspended, starts later; refresh and logout', (tester) async {
    final repo = FakeActivationRepository(serverState: const DeviceActivation(status: ActivationStatus.suspended));
    final cubit = ActivationCubit(repo, clock: () => now);
    addTearDown(cubit.close);
    await repo.record(
      DeviceActivation(
        status: ActivationStatus.active,
        valid: true,
        startsAt: DateTime.utc(2026, 10, 1),
        expiresAt: DateTime.utc(2026, 11, 1, 10),
      ),
    );

    await tester.pumpWidget(gate(cubit, loggedIn: true));
    await tester.pump();
    expect(find.text('Expired on 1 Nov 2026'), findsOneWidget);
    expect(find.byKey(const Key('activationLogout')), findsOneWidget);

    await tester.tap(find.byKey(const Key('refreshActivationButton')));
    await tester.pumpAndSettle();
    expect(find.text('Suspended'), findsOneWidget);

    await repo.record(DeviceActivation(status: ActivationStatus.scheduled, startsAt: DateTime.utc(2026, 12, 9, 10)));
    await tester.pumpAndSettle();
    expect(find.text('Starts on 9 Dec 2026'), findsOneWidget);
  });

  testWidgets('expiry banner only while valid with 7 days or less left', (tester) async {
    final repo = FakeActivationRepository();
    final cubit = ActivationCubit(repo, clock: () => now);
    addTearDown(cubit.close);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ActivationExpiryBanner(cubit: cubit)),
      ),
    );

    await repo.record(
      DeviceActivation(status: ActivationStatus.active, valid: true, expiresAt: now.add(const Duration(days: 30))),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('activationExpiryBanner')), findsNothing);

    await repo.record(
      DeviceActivation(status: ActivationStatus.active, valid: true, expiresAt: now.add(const Duration(days: 3))),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Activation expires in 3 days'), findsOneWidget);
  });

  testWidgets('router: the sell screen redirects to the gate while not activated, back once activated', (tester) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await sl.reset();
    await configureDependencies(
      config: const AppConfig(apiBaseUrl: 'http://pos.test/api/v1', appVersion: '1.0.0'),
      secureStore: MemorySecureStore(),
      database: openTestDatabase(NativeDatabase.memory()),
    );
    sl<TerminalContextHolder>().ctx = TerminalContext(
      deviceId: 'd1',
      deviceCode: 'P1',
      tokenLetter: 'A',
      storeId: 's1',
      storeName: 'Demo store',
      currency: 'AED',
      currencyDecimals: 2,
      timezone: 'Asia/Dubai',
      businessDayCutoff: '04:00',
      pricesIncludeTax: true,
    );
    await tester.runAsync(() => sl<LocalStore>().open('P1'));
    await tester.runAsync(() => sl<ActivationCubit>().load());
    sl<StaffSession>().value = const StaffUser(
      id: 'u1',
      name: 'Asha',
      pinHash: '',
      permissions: {'order.create'},
      maxDiscountBp: 0,
    );
    // New orders are refused below the UI too.
    expect(sl<TerminalContextHolder>().newOrdersAllowed(), isFalse);

    final router = createRouter(initialLocation: Routes.sell);
    await tester.pumpWidget(
      BlocProvider.value(
        value: sl<TerminalCubit>(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    expect(router.state.matchedLocation, Routes.activation);
    expect(find.byType(ActivationGatePage), findsOneWidget);
    expect(find.text('Demo store'), findsOneWidget);
    expect(find.byKey(const Key('activationLogout')), findsOneWidget);

    // Activated (e.g. by the device.activation event): straight back to selling.
    await tester.runAsync(
      () => sl<ActivationRepository>().record(
        DeviceActivation(
          deviceId: 'd1',
          status: ActivationStatus.active,
          valid: true,
          expiresAt: DateTime.now().toUtc().add(const Duration(days: 90)),
        ),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pumpAndSettle();
    expect(router.state.matchedLocation, Routes.sell);
    expect(GoRouter.of(tester.element(find.byType(Scaffold).first)).state.matchedLocation, Routes.sell);
    expect(sl<TerminalContextHolder>().newOrdersAllowed(), isTrue);

    sl<StaffSession>().value = null;
    await tester.pumpWidget(const SizedBox());
    await sl<SyncScheduler>().stop();
    await tester.runAsync(() => sl<LocalStore>().db.close());
  });
}
