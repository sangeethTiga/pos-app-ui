import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/device_session.dart';
import '../../domain/usecases/get_current_session.dart';
import '../../domain/usecases/preview_registration.dart';
import '../../domain/usecases/register_device.dart';

part 'device_setup_bloc.freezed.dart';
part 'device_setup_event.dart';
part 'device_setup_state.dart';

/// Two-step registration: codes, then the settings screen (store, name, kiosk, role, delivery flags).
class DeviceSetupBloc extends Bloc<DeviceSetupEvent, DeviceSetupState> {
  DeviceSetupBloc(this._registerDevice, this._getCurrentSession, this._preview)
    : super(const DeviceSetupState.initial()) {
    on<DeviceSetupStarted>(_onStarted);
    on<DeviceSetupCodesSubmitted>(_onCodes);
    on<DeviceSetupRegisterSubmitted>(_onRegister);
    on<DeviceSetupBack>((_, emit) => emit(const DeviceSetupState.unpaired()));
  }

  final RegisterDevice _registerDevice;
  final GetCurrentSession _getCurrentSession;
  final PreviewRegistration _preview;

  String _storeCode = '';
  String _registrationCode = '';

  Future<void> _onStarted(DeviceSetupStarted event, Emitter<DeviceSetupState> emit) async {
    final session = await _getCurrentSession();
    emit(session == null ? const DeviceSetupState.unpaired() : DeviceSetupState.paired(session));
  }

  Future<void> _onCodes(DeviceSetupCodesSubmitted event, Emitter<DeviceSetupState> emit) async {
    if (state is DeviceSetupVerifying) return; // double tap
    emit(const DeviceSetupState.verifying());
    final result = await _preview(storeCode: event.storeCode, registrationCode: event.registrationCode);
    emit(
      result.when(
        success: (preview) {
          _storeCode = event.storeCode;
          _registrationCode = event.registrationCode;
          return DeviceSetupState.ready(preview);
        },
        failure: DeviceSetupState.failure,
      ),
    );
  }

  Future<void> _onRegister(DeviceSetupRegisterSubmitted event, Emitter<DeviceSetupState> emit) async {
    final current = state;
    if (current is! DeviceSetupReady || current.submitting) return;
    emit(current.copyWith(submitting: true, failure: null));
    final result = await _registerDevice(
      storeCode: _storeCode,
      registrationCode: _registrationCode,
      deviceName: event.deviceName,
      profile: event.profile.copyWith(hardwareId: current.preview.hardwareId),
    );
    emit(
      result.when(
        success: DeviceSetupState.paired,
        failure: (f) => current.copyWith(submitting: false, failure: f),
      ),
    );
  }
}
