import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/config/app_config.dart';
import '../../core/sync/local_store.dart';
import '../../core/terminal/terminal_context.dart';
import '../device_setup/domain/entities/device_session.dart';
import '../sync/domain/sync_engine.dart';
import '../sync/domain/sync_scheduler.dart';

part 'terminal_cubit.freezed.dart';

@freezed
abstract class TerminalState with _$TerminalState {
  const factory TerminalState({
    @Default(false) bool started,
    @Default(false) bool syncing,
    SyncReport? lastReport,
    @Default(0) int pending,
    DateTime? lastSyncAt,
  }) = _TerminalState;
}

/// Starts the terminal session after pairing (local DB, context, sync) and exposes sync status.
class TerminalCubit extends Cubit<TerminalState> {
  TerminalCubit(this._store, this._ctx, this._scheduler, this._config) : super(const TerminalState());

  final LocalStore _store;
  final TerminalContextHolder _ctx;
  final SyncScheduler _scheduler;
  final AppConfig _config;
  StreamSubscription<SyncReport>? _sub;

  Future<void> start(DeviceSession s) async {
    if (state.started) return;
    _ctx.ctx = TerminalContext(
      deviceId: s.deviceId,
      deviceCode: s.deviceCode,
      tokenLetter: s.tokenLetter,
      storeId: s.store.id,
      storeName: s.store.name,
      currency: s.store.currency,
      currencyDecimals: s.store.currencyDecimals,
      timezone: s.store.timezone,
      businessDayCutoff: s.store.businessDayCutoff,
      pricesIncludeTax: s.store.pricesIncludeTax,
    );
    await _store.open(s.deviceCode);
    emit(state.copyWith(started: true, syncing: true, pending: await _store.pendingCount()));
    _sub = _scheduler.reports.listen(_onReport);
    final origin = Uri.parse(_config.apiBaseUrl);
    unawaited(_scheduler.start(websocketOrigin: '${origin.scheme}://${origin.authority}'));
  }

  Future<void> _onReport(SyncReport r) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        syncing: false,
        lastReport: r,
        pending: await _store.pendingCount(),
        lastSyncAt: r.result == SyncResult.synced ? DateTime.now() : state.lastSyncAt,
      ),
    );
  }

  Future<void> refreshPending() async => emit(state.copyWith(pending: await _store.pendingCount()));

  Future<void> syncNow() async {
    emit(state.copyWith(syncing: true));
    await _scheduler.syncNow();
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _scheduler.stop();
    return super.close();
  }
}
