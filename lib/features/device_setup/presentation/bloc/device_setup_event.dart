part of 'device_setup_bloc.dart';

@freezed
sealed class DeviceSetupEvent with _$DeviceSetupEvent {
  /// App start: is this terminal already paired?
  const factory DeviceSetupEvent.started() = DeviceSetupStarted;

  /// Step 1: store code + registration code from the admin panel.
  const factory DeviceSetupEvent.codesSubmitted({required String storeCode, required String registrationCode}) =
      DeviceSetupCodesSubmitted;

  /// Step 2: settings screen "Register Device".
  const factory DeviceSetupEvent.registerSubmitted({required String deviceName, required DeviceProfile profile}) =
      DeviceSetupRegisterSubmitted;

  /// Back arrow on the settings screen: enter other codes.
  const factory DeviceSetupEvent.back() = DeviceSetupBack;
}
