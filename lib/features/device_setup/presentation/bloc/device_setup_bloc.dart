import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/activation_policy.dart';
import '../../domain/entities/device_session.dart';
import '../../domain/usecases/get_current_session.dart';
import '../../domain/usecases/get_hardware_id.dart';
import '../../domain/usecases/preview_setup.dart';
import '../../domain/usecases/setup_device.dart';

part 'device_setup_bloc.freezed.dart';
part 'device_setup_event.dart';
part 'device_setup_state.dart';

/// One-page setup: an activation code (checked as soon as it is complete: store name, kiosks) plus the
/// settings (name, kiosk, role, delivery flags); "Activate" pairs and activates in one call.
class DeviceSetupBloc extends Bloc<DeviceSetupEvent, DeviceSetupState> {
  DeviceSetupBloc(this._setupDevice, this._getCurrentSession, this._preview, this._hardwareId)
    : super(const DeviceSetupState.initial()) {
    on<DeviceSetupStarted>(_onStarted);
    on<DeviceSetupCodeChanged>(_onCodeChanged);
    on<DeviceSetupActivateSubmitted>(_onActivate);
  }

  final SetupDevice _setupDevice;
  final GetCurrentSession _getCurrentSession;
  final PreviewSetup _preview;
  final GetHardwareId _hardwareId;

  DeviceSetupUnpaired get _form => switch (state) {
    final DeviceSetupUnpaired s => s,
    _ => const DeviceSetupUnpaired(),
  };

  Future<void> _onStarted(DeviceSetupStarted event, Emitter<DeviceSetupState> emit) async {
    final session = await _getCurrentSession();
    if (session != null) return emit(DeviceSetupState.paired(session));
    String? hardwareId;
    try {
      hardwareId = await _hardwareId();
    } on Object {
      // Storage refused: the page works without the copy row; setup creates the id again.
    }
    emit(DeviceSetupState.unpaired(hardwareId: hardwareId));
  }

  Future<void> _onCodeChanged(DeviceSetupCodeChanged event, Emitter<DeviceSetupState> emit) async {
    final current = _form;
    if (current.submitting) return;
    final code = ActivationCode.format(event.code);
    if (!ActivationCode.isComplete(code)) {
      // Incomplete: forget the store of the previous code.
      if (current.code != null || current.failure != null) {
        emit(current.copyWith(code: null, checking: false, preview: null, previewFailure: null, failure: null));
      }
      return;
    }
    if (code == current.code && current.previewFailure == null) return; // already checked / checking
    emit(current.copyWith(code: code, checking: true, preview: null, previewFailure: null, failure: null));
    final result = await _preview(code);
    final now = _form;
    if (now.code != code) return; // the code changed meanwhile
    emit(
      result.when(
        success: (preview) => now.copyWith(checking: false, preview: preview),
        failure: (f) => now.copyWith(checking: false, previewFailure: f),
      ),
    );
  }

  Future<void> _onActivate(DeviceSetupActivateSubmitted event, Emitter<DeviceSetupState> emit) async {
    final current = _form;
    if (current.submitting) return; // double tap
    emit(current.copyWith(submitting: true, failure: null));
    final result = await _setupDevice(
      code: event.code,
      deviceName: event.deviceName,
      profile: event.profile.copyWith(hardwareId: event.profile.hardwareId ?? current.hardwareId),
    );
    emit(
      result.when(
        success: DeviceSetupState.paired,
        failure: (f) => _form.copyWith(submitting: false, failure: f),
      ),
    );
  }
}
