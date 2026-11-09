import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_app_ui/app/routes.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/error/failure.dart';
import 'package:pos_app_ui/core/network/api_client.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_local_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_remote_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/repositories/activation_repository_impl.dart';
import 'package:pos_app_ui/features/device_setup/data/repositories/device_repository_impl.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_session.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/get_current_session.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/get_hardware_id.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/preview_setup.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/setup_device.dart';
import 'package:pos_app_ui/features/device_setup/presentation/bloc/device_setup_bloc.dart';
import 'package:pos_app_ui/features/device_setup/presentation/cubit/activation_cubit.dart';
import 'package:pos_app_ui/features/device_setup/presentation/pages/device_setup_page.dart';
import 'package:pos_app_ui/features/terminal/terminal_cubit.dart';

class _MockBloc extends MockBloc<DeviceSetupEvent, DeviceSetupState> implements DeviceSetupBloc {}

class _MockTerminal extends MockCubit<TerminalState> implements TerminalCubit {}

class _FakeSession extends Fake implements DeviceSession {}

/// Answers by path; records every request.
class _Backend implements HttpClientAdapter {
  _Backend(this.routes);
  final Map<String, (int, String)> routes;
  final requests = <(String, Object?)>[];

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final sent = requestStream == null ? null : utf8.decode((await requestStream.toList()).expand((c) => c).toList());
    requests.add((o.path, sent == null ? null : jsonDecode(sent)));
    final (status, body) = routes[o.path] ?? (500, '{}');
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _MockBloc bloc;
  setUpAll(() {
    registerFallbackValue(const DeviceSetupEvent.started());
    registerFallbackValue(_FakeSession());
  });
  setUp(() => bloc = _MockBloc());

  void stateIs(DeviceSetupState s) => whenListen(bloc, const Stream<DeviceSetupState>.empty(), initialState: s);

  void tallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1600, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Widget app() => MaterialApp(
    home: BlocProvider<DeviceSetupBloc>.value(value: bloc, child: const DeviceSetupPage()),
  );

  const code = 'ABCD-EFGH-JKMN';
  const preview = SetupPreview(
    storeId: 's1',
    storeCode: 'ST-0007',
    storeName: 'Khyber Darbar',
    kiosks: [KioskOption(id: 'k1', name: 'U Kiosk')],
  );

  testWidgets('one page: code, device id and every section; nothing is sent while incomplete', (tester) async {
    tallScreen(tester);
    stateIs(const DeviceSetupState.unpaired(hardwareId: '4C05435D-18E8-5BC2-BA98-6A4C4CFE79BB'));
    await tester.pumpWidget(app());

    expect(find.text('Set up terminal'), findsOneWidget);
    expect(find.byKey(const Key('activationCodeField')), findsOneWidget);
    expect(find.text('4C05435D-18E8-5BC2-BA98-6A4C4CFE79BB'), findsOneWidget);
    expect(find.text('KIOSK Settings'), findsOneWidget);
    expect(find.text('Cashier Device'), findsOneWidget);
    expect(find.text('Captain Device'), findsOneWidget);
    expect(find.text('Delivery Manager Settings'), findsOneWidget);
    expect(find.byKey(const Key('storeCard')), findsNothing);
    expect(find.byKey(const Key('kiosk')), findsNothing); // kiosks come with the code
    expect(find.byKey(const Key('backButton')), findsNothing);

    await tester.tap(find.byKey(const Key('activateButton')));
    await tester.pump();
    expect(find.text('Enter the 12-character code (XXXX-XXXX-XXXX).'), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);
    verifyNever(() => bloc.add(any()));
  });

  testWidgets('typing the code formats it and reports every change', (tester) async {
    stateIs(const DeviceSetupState.unpaired());
    await tester.pumpWidget(app());
    await tester.enterText(find.byKey(const Key('activationCodeField')), 'abcdefghjkmn');

    expect(find.text(code), findsOneWidget);
    verify(() => bloc.add(const DeviceSetupEvent.codeChanged(code))).called(1);
  });

  testWidgets('checking, then the store behind the code, then a refused code', (tester) async {
    whenListen(
      bloc,
      Stream<DeviceSetupState>.fromIterable([const DeviceSetupState.unpaired(code: code, preview: preview)]),
      initialState: const DeviceSetupState.unpaired(code: code, checking: true),
    );
    await tester.pumpWidget(app());
    expect(find.byKey(const Key('previewChecking')), findsOneWidget);
    await tester.pump();
    expect(find.byKey(const Key('previewChecking')), findsNothing);
    expect(find.text('Khyber Darbar'), findsOneWidget);
    expect(find.text('Store code ST-0007'), findsOneWidget);

    stateIs(
      const DeviceSetupState.unpaired(
        code: code,
        previewFailure: Failure.server(statusCode: 422, code: 'INVALID_ACTIVATION_CODE', message: 'Invalid.'),
      ),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(app());
    expect(find.text('This activation code is not valid, or it has expired or was already used.'), findsOneWidget);
  });

  testWidgets('re-pair code: shows the terminal, fills its name and limits the roles', (tester) async {
    tallScreen(tester);
    whenListen(
      bloc,
      Stream<DeviceSetupState>.fromIterable([
        const DeviceSetupState.unpaired(
          code: code,
          preview: SetupPreview(
            storeId: 's1',
            storeCode: 'ST-0007',
            storeName: 'Khyber Darbar',
            deviceTypes: [DeviceType.captain],
            rePair: true,
            deviceCode: 'P3',
            deviceName: 'Front till',
          ),
        ),
      ]),
      initialState: const DeviceSetupState.unpaired(code: code, checking: true),
    );
    await tester.pumpWidget(app());
    await tester.pump();

    expect(find.text('Store code ST-0007  ·  re-pairing terminal P3'), findsOneWidget);
    expect(find.text('Front till'), findsOneWidget);
    expect(find.text('Cashier Device'), findsNothing);
    expect(find.text('Captain Device'), findsOneWidget);
  });

  testWidgets('activate sends the code and every choice', (tester) async {
    tallScreen(tester);
    stateIs(const DeviceSetupState.unpaired(code: code, preview: preview));
    await tester.pumpWidget(app());

    await tester.enterText(find.byKey(const Key('activationCodeField')), code);
    await tester.enterText(find.byKey(const Key('deviceName')), 'Test');
    await tester.tap(find.byKey(const Key('kiosk')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('U Kiosk').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('kioskWise')));
    await tester.tap(find.byKey(const Key('type-captain')));
    await tester.tap(find.byKey(const Key('deliveryManagerPos')));
    await tester.tap(find.byKey(const Key('activateButton')));
    await tester.pump();

    verify(
      () => bloc.add(
        const DeviceSetupEvent.activateSubmitted(
          code: code,
          deviceName: 'Test',
          profile: DeviceProfile(
            deviceType: DeviceType.captain,
            kioskId: 'k1',
            kioskWiseOrderListing: true,
            deliveryManagerPos: true,
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('setup failure is explained', (tester) async {
    tallScreen(tester);
    stateIs(
      const DeviceSetupState.unpaired(
        code: code,
        preview: preview,
        failure: Failure.server(statusCode: 402, code: 'DEVICE_LIMIT_REACHED', message: 'Limit.'),
      ),
    );
    await tester.pumpWidget(app());
    expect(find.textContaining('reached its terminal limit'), findsOneWidget);
  });

  testWidgets('opened after an unpair: reads the stored state again', (tester) async {
    stateIs(const DeviceSetupState.initial());
    await tester.pumpWidget(app());
    verify(() => bloc.add(const DeviceSetupEvent.started())).called(1);
  });

  testWidgets('real flow: preview, one setup call, activation seeded, straight to the lock screen', (tester) async {
    tallScreen(tester);
    // Activated from yesterday for 30 days, server clock = device clock: may sell now.
    final now = DateTime.now().toUtc();
    final setupBody = jsonDecode(File('test/fixtures/setup_response.json').readAsStringSync()) as Map<String, dynamic>;
    setupBody['server_time'] = now.toIso8601String();
    (setupBody['activation'] as Map<String, dynamic>)
      ..['starts_at'] = now.subtract(const Duration(days: 1)).toIso8601String()
      ..['expires_at'] = now.add(const Duration(days: 30)).toIso8601String();
    final backend = _Backend({
      '/devices/setup/preview': (
        200,
        '{"store":{"id":"s1","code":"ST-0007","name":"Khyber Darbar"},"kiosks":[],'
            '"device_types":["CASHIER","CAPTAIN"],"re_pair":false,"device":null}',
      ),
      '/devices/setup': (201, jsonEncode(setupBody)),
    });
    const config = AppConfig(apiBaseUrl: 'http://pos.test/api/v1', appVersion: '1.2.3');
    final dio = createDio(config)..httpClientAdapter = backend;
    final remote = DeviceRemoteDataSource(dio);
    final local = DeviceLocalDataSource(MemorySecureStore());
    final activations = ActivationRepositoryImpl(remote, local, config);
    final devices = DeviceRepositoryImpl(remote, local, config, platform: 'android', activations: activations);
    final setupBloc = DeviceSetupBloc(
      SetupDevice(devices),
      GetCurrentSession(devices),
      PreviewSetup(devices),
      GetHardwareId(devices),
    );
    final activationCubit = ActivationCubit(activations);
    final terminal = _MockTerminal();
    when(() => terminal.start(any())).thenAnswer((_) async {});
    final router = GoRouter(
      initialLocation: Routes.setup,
      routes: [
        GoRoute(path: Routes.setup, builder: (_, _) => const DeviceSetupPage()),
        GoRoute(path: Routes.lock, builder: (_, _) => const Text('LOCK')),
        GoRoute(path: Routes.activation, builder: (_, _) => const Text('GATE')),
      ],
    );
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: setupBloc),
          BlocProvider<TerminalCubit>.value(value: terminal),
          BlocProvider.value(value: activationCubit),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('activationCodeField')), 'abcdefghjkmn');
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
    expect(find.text('Khyber Darbar'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('deviceName')), 'POS-1');
    await tester.tap(find.byKey(const Key('activateButton')));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();

    expect(find.text('LOCK'), findsOneWidget);
    expect(activationCubit.state.canSell, isTrue);
    final paths = backend.requests.map((r) => r.$1).toList();
    expect(paths.take(2), ['/devices/setup/preview', '/devices/setup']);
    expect(backend.requests[1].$2, containsPair('code', code));
    verify(() => terminal.start(any())).called(1);

    await tester.runAsync(() async {
      await activationCubit.close();
      await setupBloc.close();
    });
  });
}
