part of 'device_setup_bloc.dart';

@freezed
sealed class DeviceSetupState with _$DeviceSetupState {
  const factory DeviceSetupState.initial() = DeviceSetupInitial;

  /// Not paired: show the pairing form.
  const factory DeviceSetupState.unpaired() = DeviceSetupUnpaired;

  const factory DeviceSetupState.submitting() = DeviceSetupSubmitting;

  const factory DeviceSetupState.paired(DeviceSession session) = DeviceSetupPaired;

  /// Pairing failed; the form stays filled in.
  const factory DeviceSetupState.failure(Failure failure) = DeviceSetupFailure;
}
