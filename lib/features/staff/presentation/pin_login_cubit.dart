import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/staff_repository.dart';

part 'pin_login_cubit.freezed.dart';

@freezed
abstract class PinLoginState with _$PinLoginState {
  const factory PinLoginState({
    @Default(<StaffUser>[]) List<StaffUser> users,
    StaffUser? selected,
    @Default('') String pin,
    @Default(false) bool checking,
    @Default(false) bool loggedIn,
    String? error,
  }) = _PinLoginState;
}

class PinLoginCubit extends Cubit<PinLoginState> {
  PinLoginCubit(this._staff, this._session) : super(const PinLoginState());

  final StaffRepository _staff;
  final StaffSession _session;

  Future<void> load() async => emit(state.copyWith(users: await _staff.users()));

  void select(StaffUser u) => emit(state.copyWith(selected: u, pin: '', error: null));

  void digit(String d) {
    if (state.pin.length >= 8 || state.checking) return;
    emit(state.copyWith(pin: state.pin + d, error: null));
  }

  void backspace() => emit(state.copyWith(pin: state.pin.isEmpty ? '' : state.pin.substring(0, state.pin.length - 1)));

  Future<void> submit() async {
    final u = state.selected;
    if (u == null || state.pin.length < 4) return;
    if (_staff.isLocked(u.id)) {
      return emit(state.copyWith(pin: '', error: 'Too many wrong PINs. Try again in 5 minutes.'));
    }
    emit(state.copyWith(checking: true));
    final ok = await _staff.verifyPin(u, state.pin);
    if (ok) {
      _session.value = u;
      emit(state.copyWith(checking: false, loggedIn: true, pin: ''));
    } else {
      emit(state.copyWith(checking: false, pin: '', error: 'Wrong PIN'));
    }
  }
}
