part of 'device_setup_bloc.dart';

@freezed
sealed class DeviceSetupState with _$DeviceSetupState {
  const factory DeviceSetupState.initial() = DeviceSetupInitial;

  /// Not paired: show the codes form.
  const factory DeviceSetupState.unpaired() = DeviceSetupUnpaired;

  /// Checking the codes.
  const factory DeviceSetupState.verifying() = DeviceSetupVerifying;

  /// Codes are valid: show the settings screen for [preview].
  const factory DeviceSetupState.ready(
    RegistrationPreview preview, {
    @Default(false) bool submitting,
    Failure? failure,
  }) = DeviceSetupReady;

  const factory DeviceSetupState.paired(DeviceSession session) = DeviceSetupPaired;

  /// Codes were refused; the codes form stays filled in.
  const factory DeviceSetupState.failure(Failure failure) = DeviceSetupFailure;
}
