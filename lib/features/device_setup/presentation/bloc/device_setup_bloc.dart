import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/device_session.dart';
import '../../domain/usecases/get_current_session.dart';
import '../../domain/usecases/register_device.dart';

part 'device_setup_bloc.freezed.dart';
part 'device_setup_event.dart';
part 'device_setup_state.dart';

class DeviceSetupBloc extends Bloc<DeviceSetupEvent, DeviceSetupState> {
  DeviceSetupBloc(this._registerDevice, this._getCurrentSession) : super(const DeviceSetupState.initial()) {
    on<DeviceSetupStarted>(_onStarted);
    on<DeviceSetupSubmitted>(_onSubmitted);
  }

  final RegisterDevice _registerDevice;
  final GetCurrentSession _getCurrentSession;

  Future<void> _onStarted(DeviceSetupStarted event, Emitter<DeviceSetupState> emit) async {
    final session = await _getCurrentSession();
    emit(session == null ? const DeviceSetupState.unpaired() : DeviceSetupState.paired(session));
  }

  Future<void> _onSubmitted(DeviceSetupSubmitted event, Emitter<DeviceSetupState> emit) async {
    if (state is DeviceSetupSubmitting) return; // double tap
    emit(const DeviceSetupState.submitting());
    final result = await _registerDevice(
      storeCode: event.storeCode,
      registrationCode: event.registrationCode,
      deviceName: event.deviceName,
    );
    emit(result.when(success: DeviceSetupState.paired, failure: DeviceSetupState.failure));
  }
}
