import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_app_ui/core/error/failure.dart';
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

  testWidgets('empty form is not submitted', (tester) async {
    stateIs(const DeviceSetupState.unpaired());
    await tester.pumpWidget(app());
    await tester.tap(find.byKey(const Key('pairButton')));
    await tester.pump();

    expect(find.text('Required'), findsNWidgets(2)); // store code + registration code; name has a default
    verifyNever(() => bloc.add(any()));
  });

  testWidgets('filled form sends DeviceSetupEvent.submitted', (tester) async {
    stateIs(const DeviceSetupState.unpaired());
    await tester.pumpWidget(app());
    await tester.enterText(find.byKey(const Key('storeCode')), 'ST-0007');
    await tester.enterText(find.byKey(const Key('registrationCode')), '483920');
    await tester.tap(find.byKey(const Key('pairButton')));
    await tester.pump();

    verify(
      () => bloc.add(
        const DeviceSetupEvent.submitted(storeCode: 'ST-0007', registrationCode: '483920', deviceName: 'POS'),
      ),
    ).called(1);
  });

  testWidgets('failure message is shown', (tester) async {
    stateIs(
      const DeviceSetupState.failure(
        Failure.server(statusCode: 422, code: 'VALIDATION_FAILED', message: 'Invalid or expired registration code.'),
      ),
    );
    await tester.pumpWidget(app());

    expect(find.text('Invalid or expired registration code.'), findsOneWidget);
  });
}
