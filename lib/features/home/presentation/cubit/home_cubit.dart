import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../device_setup/domain/entities/device_session.dart';
import '../../../device_setup/domain/repositories/device_repository.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._devices) : super(const HomeState.loading());

  final DeviceRepository _devices;

  Future<void> load() async {
    final session = await _devices.currentSession();
    if (session == null) return emit(const HomeState.unpaired());
    emit(HomeState.ready(session: session));
    await checkServer();
  }

  /// Signed `GET /devices/me`.
  Future<void> checkServer() async {
    final current = state;
    if (current is! HomeReady) return;
    emit(current.copyWith(checking: true, failure: null));
    final result = await _devices.status();
    emit(
      result.when(
        success: (s) => current.copyWith(status: s, failure: null, checking: false),
        failure: (f) => current.copyWith(status: null, failure: f, checking: false),
      ),
    );
  }

  Future<void> unpair() async {
    await _devices.unpair();
    emit(const HomeState.unpaired());
  }
}
