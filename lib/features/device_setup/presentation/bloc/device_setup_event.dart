part of 'device_setup_bloc.dart';

@freezed
sealed class DeviceSetupEvent with _$DeviceSetupEvent {
  /// App start: is this terminal already paired?
  const factory DeviceSetupEvent.started() = DeviceSetupStarted;

  const factory DeviceSetupEvent.submitted({
    required String storeCode,
    required String registrationCode,
    required String deviceName,
  }) = DeviceSetupSubmitted;
}
