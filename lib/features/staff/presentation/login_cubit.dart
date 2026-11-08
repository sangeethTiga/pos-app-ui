import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/sync/local_store.dart';
import '../../../core/terminal/terminal_context.dart';
import '../../../core/widgets/money_field.dart';
import '../../shift/domain/shift_service.dart';
import '../data/staff_repository.dart';

part 'login_cubit.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(<StaffUser>[]) List<StaffUser> users,
    StaffUser? selected,
    @Default(<String>[]) List<String> shiftNames,
    String? shiftName,

    /// CASHIER or CAPTAIN: captains have no cash drawer, so no shift or drawer balance.
    @Default('CASHIER') String deviceType,

    /// A shift is already open on this terminal: no shift / drawer fields.
    String? openShiftName,
    @Default(false) bool shiftAlreadyOpen,
    @Default(false) bool loaded,
    @Default(false) bool checking,
    @Default(false) bool loggedIn,
    String? error,
  }) = _LoginState;

  const LoginState._();

  /// Shift + Open Drawer Balance fields are shown.
  bool get needsShift => deviceType != 'CAPTAIN' && !shiftAlreadyOpen;
}

/// Login screen: user name + password (checked on the terminal, works offline). A cashier terminal
/// without an open shift also picks the shift and enters the opening drawer balance.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._staff, this._session, this._shifts, this._store, this._ctx) : super(const LoginState());

  static const defaultShiftNames = ['Morning Shift', 'Evening Shift', 'Night Shift'];

  final StaffRepository _staff;
  final StaffSession _session;
  final ShiftService _shifts;
  final LocalStore _store;
  final TerminalContextHolder _ctx;

  Future<void> load() async {
    final users = await _staff.users();
    final names = await _shiftNames();
    final open = _ctx.ready ? await _shifts.openShift() : null;
    final selected = users.where((u) => u.id == state.selected?.id).firstOrNull;
    emit(
      state.copyWith(
        users: users,
        selected: selected,
        shiftNames: names,
        shiftName: names.contains(state.shiftName) ? state.shiftName : names.firstOrNull,
        deviceType: _ctx.ready ? _ctx.ctx.deviceType : 'CASHIER',
        shiftAlreadyOpen: open != null,
        openShiftName: open?.data['name'] as String?,
        loaded: true,
      ),
    );
  }

  /// Store setting `shift_names` (admin panel), else the defaults.
  Future<List<String>> _shiftNames() async {
    for (final r in await _store.all('store_setting')) {
      if (r.data['key'] != 'shift_names') continue;
      var v = r.data['value'];
      if (v is Map && v.containsKey('v')) v = v['v'];
      final names = v is List
          ? [
              for (final n in v)
                if (n is String && n.trim().isNotEmpty) n,
            ]
          : const <String>[];
      if (names.isNotEmpty) return names;
    }
    return defaultShiftNames;
  }

  void selectUser(StaffUser? u) => emit(state.copyWith(selected: u, error: null));

  void selectShift(String? name) => emit(state.copyWith(shiftName: name, error: null));

  Future<void> login({required String password, required String openingBalance}) async {
    if (state.checking) return;
    final u = state.selected;
    if (u == null) return emit(state.copyWith(error: 'Select your user name'));
    if (password.isEmpty) return emit(state.copyWith(error: 'Enter your password'));
    if (u.passwordHash == null) {
      return emit(state.copyWith(error: 'No password on this terminal yet for ${u.name}. Sync and try again.'));
    }
    if (_staff.isLocked(u.id)) return emit(state.copyWith(error: 'Too many wrong passwords. Try again in 5 minutes.'));

    int? float;
    if (state.needsShift) {
      if (state.shiftName == null) return emit(state.copyWith(error: 'Select a shift'));
      final decimals = _ctx.ready ? _ctx.ctx.currencyDecimals : 2;
      float = openingBalance.trim().isEmpty ? 0 : parseMoney(openingBalance, decimals);
      if (float == null || float < 0) return emit(state.copyWith(error: 'Invalid open drawer balance'));
    }

    emit(state.copyWith(checking: true, error: null));
    if (!await _staff.verifyPassword(u, password)) {
      return emit(state.copyWith(checking: false, error: 'Wrong password'));
    }
    if (state.needsShift) {
      if (!u.can('shift.open_close')) {
        return emit(state.copyWith(checking: false, error: '${u.name} may not open a shift. Ask a manager.'));
      }
      try {
        await _shifts.startShift(userId: u.id, openingFloatMinor: float!, name: state.shiftName);
      } on StateError {
        // Another login opened the shift a moment ago: keep that one.
      }
    }
    _session.value = u;
    emit(state.copyWith(checking: false, loggedIn: true));
  }
}
