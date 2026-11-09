part of 'device_setup_bloc.dart';

@freezed
sealed class DeviceSetupEvent with _$DeviceSetupEvent {
  /// App start: is this terminal already paired?
  const factory DeviceSetupEvent.started() = DeviceSetupStarted;

  /// The activation code field changed; a complete code is checked (store name and kiosks).
  const factory DeviceSetupEvent.codeChanged(String code) = DeviceSetupCodeChanged;

  /// "Activate": pair and activate with the code and the settings on the page.
  const factory DeviceSetupEvent.activateSubmitted({
    required String code,
    required String deviceName,
    required DeviceProfile profile,
  }) = DeviceSetupActivateSubmitted;
}
