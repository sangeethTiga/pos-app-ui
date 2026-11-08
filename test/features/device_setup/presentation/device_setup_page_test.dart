import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_app_ui/core/error/failure.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_session.dart';
import 'package:pos_app_ui/features/device_setup/presentation/bloc/device_setup_bloc.dart';
import 'package:pos_app_ui/features/device_setup/presentation/pages/device_setup_page.dart';

class _MockBloc extends MockBloc<DeviceSetupEvent, DeviceSetupState> implements DeviceSetupBloc {}

void main() {
  late _MockBloc bloc;
  setUpAll(() => registerFallbackValue(const DeviceSetupEvent.started()));
  setUp(() => bloc = _MockBloc());

  void stateIs(DeviceSetupState s) => whenListen(bloc, const Stream<DeviceSetupState>.empty(), initialState: s);

  Widget app() => MaterialApp(
    home: BlocProvider<DeviceSetupBloc>.value(value: bloc, child: const DeviceSetupPage()),
  );

  testWidgets('empty codes form is not submitted', (tester) async {
    stateIs(const DeviceSetupState.unpaired());
    await tester.pumpWidget(app());
    await tester.tap(find.byKey(const Key('continueButton')));
    await tester.pump();

    expect(find.text('Required'), findsNWidgets(2));
    verifyNever(() => bloc.add(any()));
  });

  testWidgets('filled codes form sends codesSubmitted', (tester) async {
    stateIs(const DeviceSetupState.unpaired());
    await tester.pumpWidget(app());
    await tester.enterText(find.byKey(const Key('storeCode')), 'ST-0007');
    await tester.enterText(find.byKey(const Key('registrationCode')), '483920');
    await tester.tap(find.byKey(const Key('continueButton')));
    await tester.pump();

    verify(() => bloc.add(const DeviceSetupEvent.codesSubmitted(storeCode: 'ST-0007', registrationCode: '483920')))
        .called(1);
  });

  testWidgets('codes failure message is shown', (tester) async {
    stateIs(
      const DeviceSetupState.failure(
        Failure.server(statusCode: 422, code: 'VALIDATION_FAILED', message: 'Invalid or expired registration code.'),
      ),
    );
    await tester.pumpWidget(app());

    expect(find.text('Invalid or expired registration code.'), findsOneWidget);
  });

  const preview = RegistrationPreview(
    storeId: 's1',
    storeCode: 'ST-0007',
    storeName: 'Khyber Darbar',
    kiosks: [KioskOption(id: 'k1', name: 'U Kiosk')],
    hardwareId: '4C05435D-18E8-5BC2-BA98-6A4C4CFE79BB',
  );

  testWidgets('settings screen: store, device id and all sections; register sends the choices', (tester) async {
    tester.view.physicalSize = const Size(1600, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    stateIs(const DeviceSetupState.ready(preview));
    await tester.pumpWidget(app());

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Khyber Darbar'), findsOneWidget);
    expect(find.text('4C05435D-18E8-5BC2-BA98-6A4C4CFE79BB'), findsOneWidget);
    expect(find.text('KIOSK Settings'), findsOneWidget);
    expect(find.text('Cashier Device'), findsOneWidget);
    expect(find.text('Captain Device'), findsOneWidget);
    expect(find.text('Delivery Manager Settings'), findsOneWidget);

    // device name is required
    await tester.tap(find.byKey(const Key('registerButton')));
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
    verifyNever(() => bloc.add(any()));

    await tester.enterText(find.byKey(const Key('deviceName')), 'Test');
    await tester.tap(find.byKey(const Key('kiosk')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('U Kiosk').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('kioskWise')));
    await tester.tap(find.byKey(const Key('type-captain')));
    await tester.tap(find.byKey(const Key('deliveryManagerPos')));
    await tester.tap(find.byKey(const Key('registerButton')));
    await tester.pump();

    verify(
      () => bloc.add(
        const DeviceSetupEvent.registerSubmitted(
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

  testWidgets('back arrow returns to the codes form', (tester) async {
    stateIs(const DeviceSetupState.ready(preview));
    await tester.pumpWidget(app());
    await tester.tap(find.byKey(const Key('backButton')));
    verify(() => bloc.add(const DeviceSetupEvent.back())).called(1);
  });
}
