part of 'device_setup_bloc.dart';

@freezed
sealed class DeviceSetupState with _$DeviceSetupState {
  const factory DeviceSetupState.initial() = DeviceSetupInitial;

  /// Not paired: the setup page (activation code + settings).
  const factory DeviceSetupState.unpaired({
    /// This terminal's own id (copy row).
    String? hardwareId,

    /// Complete code (XXXX-XXXX-XXXX) that [checking] / [preview] / [previewFailure] belong to.
    String? code,

    /// Checking [code].
    @Default(false) bool checking,

    /// Store and kiosks behind [code].
    SetupPreview? preview,

    /// Why [code] was refused (or could not be checked).
    Failure? previewFailure,

    /// Pairing and activating.
    @Default(false) bool submitting,

    /// Why the last "Activate" failed; the page stays filled in.
    Failure? failure,
  }) = DeviceSetupUnpaired;

  const factory DeviceSetupState.paired(DeviceSession session) = DeviceSetupPaired;
}
