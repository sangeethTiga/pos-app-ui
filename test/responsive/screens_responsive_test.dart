import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/app/routes.dart';
import 'package:pos_app_ui/core/di/injection.dart';
import 'package:pos_app_ui/core/responsive/responsive.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/sync/sync_change.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_session.dart';
import 'package:pos_app_ui/features/device_setup/presentation/bloc/device_setup_bloc.dart';
import 'package:pos_app_ui/features/device_setup/presentation/pages/device_setup_page.dart';
import 'package:pos_app_ui/features/home/presentation/cubit/home_cubit.dart';
import 'package:pos_app_ui/features/home/presentation/pages/home_page.dart';

import 'harness.dart';

class _SetupBloc extends MockBloc<DeviceSetupEvent, DeviceSetupState> implements DeviceSetupBloc {}

class _HomeCubit extends MockCubit<HomeState> implements HomeCubit {}

/// Login, printer settings, device registration and device status at every screen size, at text
/// scale 1.3 and with the on-screen keyboard open on phones: no overflow, content centred and
/// reachable (scrolls), main buttons visible and finger sized.
void main() {
  for (final e in posSizes.entries) {
    testWidgets('screens adapt: ${e.key}', (tester) async {
      setScreen(tester, e.value);
      addTearDown(tester.view.reset);
      await _checkAll(tester, e.value);
    });
  }

  for (final name in ['phone-320', 'phone-landscape', 'pos-1024x768', 'tv-4k-3840x2160']) {
    testWidgets('screens adapt at text scale 1.3: $name', (tester) async {
      setScreen(tester, posSizes[name]!);
      addTearDown(tester.view.reset);
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await _checkAll(tester, posSizes[name]!);
    });
  }

  for (final name in ['phone-320', 'phone-portrait', 'phone-landscape', 'tablet-portrait']) {
    testWidgets('screens stay usable with the keyboard open: $name', (tester) async {
      final size = posSizes[name]!;
      setScreen(tester, size);
      tester.view.viewInsets = FakeViewPadding(bottom: (size.height * 0.42).roundToDouble());
      addTearDown(tester.view.reset);
      await _checkAll(tester, size);
    });
  }
}

Future<void> _checkAll(WidgetTester tester, Size screen) async {
  await setUpPos(tester);
  // The demo staff have no password; add a cashier who can log in on this terminal.
  await tester.runAsync(
    () => sl<LocalStore>().applyIncoming([
      const SyncChange(
        changeId: 'c-login',
        origin: 'SERVER',
        seq: 5000,
        txId: 't-login',
        hlc: '1762585120000-5000-SERVER',
        entity: 'user',
        entityId: 'u-login',
        op: 'INSERT',
        fields: {
          'name': 'Sreelakshmi Unnikrishnan Nair',
          'email': 'sreelakshmi.unnikrishnan.nair@example.com',
          'active': true,
          'password_hash': r'$2y$10$Ucs/UZbky3AT4mFew8TLo.kfbvDor4e9kkf3daMNSO9kMLL68DR5W',
          'permissions': ['order.create', 'payment.take', 'shift.open_close'],
          'roles': ['Cashier'],
        },
        createdAt: '2026-11-08T07:00:00.000Z',
      ),
    ]),
  );

  // Login (dark): user, password, login button.
  await tester.pumpWidget(posApp(Routes.lock));
  await settle(tester);
  await _reachable(tester, find.byKey(const Key('userField')), 'login user');
  await _reachable(tester, find.byKey(const Key('passwordField')), 'login password');
  await _reachable(tester, find.byKey(const Key('loginButton')), 'login button');
  expect(find.byKey(const Key('deviceTypeBadge')).hitTestable(), findsOneWidget);
  expect(find.byKey(const Key('syncChip')).hitTestable(), findsOneWidget);
  _onScreen(tester, find.byKey(const Key('deviceTypeBadge')), screen);

  // Printer settings: printer search and every setting reachable.
  await tester.pumpWidget(posApp(Routes.printers));
  await settle(tester);
  for (final k in ['printerType', 'printerIp', 'printTest', 'setAs-bill', 'printQueue', 'autoQueue', 'countDelivery']) {
    await _reachable(tester, find.byKey(Key(k)), 'printer $k');
  }
  await tearDownPos(tester);

  // Terminal setup: one page (activation code + settings), before and after the code is checked.
  final setup = _SetupBloc();
  whenListen(
    setup,
    const Stream<DeviceSetupState>.empty(),
    initialState: const DeviceSetupState.unpaired(hardwareId: '4C05435D-18E8-5BC2-BA98-6A4C4CFE79BB'),
  );
  Widget setupApp() => MaterialApp(
    builder: clampTextScale,
    home: BlocProvider<DeviceSetupBloc>.value(value: setup, child: const DeviceSetupPage()),
  );
  await tester.pumpWidget(setupApp());
  await tester.pumpAndSettle();
  await _reachable(tester, find.byKey(const Key('activationCodeField')), 'setup activation code');
  await _reachable(tester, find.byKey(const Key('activateButton')), 'setup activate');
  _centred(tester, find.byKey(const Key('activationCodeField')), screen);

  whenListen(
    setup,
    const Stream<DeviceSetupState>.empty(),
    initialState: const DeviceSetupState.unpaired(
      hardwareId: '4C05435D-18E8-5BC2-BA98-6A4C4CFE79BB',
      code: 'ABCD-EFGH-JKMN',
      preview: SetupPreview(
        storeId: 's1',
        storeCode: 'ST-0007',
        storeName: 'Al Noor Restaurant and Cafeteria Deira Branch',
        kiosks: [
          KioskOption(id: 'k1', name: 'U Kiosk'),
          KioskOption(id: 'k2', name: 'Drive-through kiosk'),
        ],
      ),
    ),
  );
  await tester.pumpWidget(const SizedBox());
  await tester.pumpWidget(setupApp());
  await tester.pumpAndSettle();
  for (final k in ['deviceName', 'copyHardwareId', 'kiosk', 'kioskWise', 'type-captain', 'settleAssignedOnly']) {
    await _reachable(tester, find.byKey(Key(k)), 'setup $k');
  }
  await _reachable(tester, find.byKey(const Key('activateButton')), 'setup activate');
  _centred(tester, find.byKey(const Key('storeCard')), screen);

  // Device status.
  final home = _HomeCubit();
  whenListen(
    home,
    const Stream<HomeState>.empty(),
    initialState: HomeState.ready(
      session: DeviceSession(
        deviceId: 'd1',
        deviceCode: 'P1',
        tokenLetter: 'A',
        gatewayPriority: 1,
        store: const StoreInfo(
          id: 's1',
          code: 'ST-0007',
          name: 'Al Noor Restaurant and Cafeteria Deira Branch',
          currency: 'AED',
          currencyDecimals: 2,
          timezone: 'Asia/Dubai',
          businessDayCutoff: '04:00',
          pricesIncludeTax: true,
        ),
        accessToken: 'a',
        accessTokenExpiresAt: DateTime.utc(2030),
        refreshToken: 'r',
        refreshTokenExpiresAt: DateTime.utc(2030),
        signingSecret: 's',
      ),
      status: const DeviceStatus(
        deviceCode: 'P1',
        status: 'ACTIVE',
        storeStatus: 'OPEN',
        canSell: true,
        isGateway: true,
        businessDate: '2026-11-08',
      ),
    ),
  );
  await tester.pumpWidget(
    MaterialApp(
      builder: clampTextScale,
      home: BlocProvider<HomeCubit>.value(value: home, child: const HomePage()),
    ),
  );
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(find.text('Business date'), 120, scrollable: find.byType(Scrollable).first);
  await _reachable(tester, find.text('Business date'), 'status business date');
  _centred(tester, find.text('Store'), screen);
  await tester.pumpWidget(const SizedBox());
}

/// Scrolls [f] into view; it must then be on screen, hit-testable and (for controls) finger sized.
Future<void> _reachable(WidgetTester tester, Finder f, String what) async {
  expect(f, findsOneWidget, reason: what);
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  expect(f.hitTestable(), findsOneWidget, reason: '$what visible');
  if (tester.widget(f) is! Text) {
    expect(tester.getSize(f).height, greaterThanOrEqualTo(40), reason: '$what touch target');
  }
}

void _onScreen(WidgetTester tester, Finder f, Size screen) {
  final rect = tester.getRect(f);
  expect((Offset.zero & screen).inflate(0.5).contains(rect.bottomRight), isTrue, reason: '$rect on $screen');
}

/// On big screens content sits in a centred column, not stuck to the left edge.
void _centred(WidgetTester tester, Finder f, Size screen) {
  if (screen.width < Breakpoints.large) return;
  expect(tester.getRect(f).left, greaterThan(screen.width * 0.15), reason: 'centred on $screen');
}
