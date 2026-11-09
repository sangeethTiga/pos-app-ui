import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../sync/data/realtime_client.dart';
import '../../../sync/domain/sync_engine.dart';
import '../../domain/activation_policy.dart';
import '../../domain/entities/device_activation.dart';
import '../../domain/repositories/activation_repository.dart';

part 'activation_cubit.freezed.dart';

@freezed
abstract class ActivationState with _$ActivationState {
  const ActivationState._();

  const factory ActivationState({
    /// The stored activation has been read (until then the terminal counts as not activated).
    @Default(false) bool loaded,
    ActivationSnapshot? snapshot,
    @Default(ActivationVerdict.unknown) ActivationVerdict verdict,
    @Default(false) bool refreshing,
    @Default(false) bool activating,

    /// Why the last code was refused (shown under the code field).
    String? activationError,

    /// Why the last status refresh failed (offline ...); the stored state still applies.
    String? refreshError,
  }) = _ActivationState;

  /// New orders allowed now (judged locally, so it also holds offline).
  bool get canSell => verdict.canSell;
}

/// App-wide platform activation of this terminal: keeps the last known state, re-judges it against the
/// (server-corrected) clock every [tick], refreshes it from heartbeats, `GET /devices/activation`, the
/// `device.activation` WebSocket event and DEVICE_NOT_ACTIVATED sync rejections.
class ActivationCubit extends Cubit<ActivationState> {
  ActivationCubit(
    this._repo, {
    this._realtime,
    this._syncReports,
    DateTime Function()? clock,
    this.tick = const Duration(seconds: 30),
    this.heartbeatEvery = const Duration(minutes: 1),
  }) : _clock = clock ?? DateTime.now,
       super(const ActivationState()) {
    _changes = _repo.changes.listen(_apply);
  }

  final ActivationRepository _repo;
  final Stream<RealtimeMessage>? _realtime;
  final Stream<SyncReport>? _syncReports;
  final DateTime Function() _clock;
  final Duration tick;
  final Duration heartbeatEvery;

  late final StreamSubscription<ActivationSnapshot> _changes;
  StreamSubscription<RealtimeMessage>? _eventsSub;
  StreamSubscription<SyncReport>? _reportsSub;
  Timer? _tick, _heartbeat;
  String? _deviceId;
  final _seenEvents = <String>[];

  /// Starts watching the activation of [deviceId] (after pairing / on app start). Reads the stored state
  /// first so the gate decision is ready at once, then asks the server.
  Future<void> start(String deviceId) async {
    await load(); // also after an unpair + re-pair: the stored state was cleared
    if (_deviceId == deviceId && _tick != null) return unawaited(refresh());
    _deviceId = deviceId;
    _tick?.cancel();
    _heartbeat?.cancel();
    _tick = Timer.periodic(tick, (_) => reevaluate());
    _heartbeat = Timer.periodic(heartbeatEvery, (_) => heartbeat());
    await _eventsSub?.cancel();
    _eventsSub = _realtime?.listen(_onRealtime);
    await _reportsSub?.cancel();
    _reportsSub = _syncReports?.listen((r) {
      if (r.deviceNotActivated) refresh();
    });
    unawaited(refresh());
  }

  /// Reads the stored activation (offline enforcement).
  Future<void> load() async {
    final cached = await _repo.cached();
    if (isClosed) return;
    emit(state.copyWith(loaded: true, snapshot: cached, verdict: ActivationPolicy.evaluate(cached, _clock())));
  }

  void _apply(ActivationSnapshot s) {
    if (isClosed) return;
    emit(state.copyWith(loaded: true, snapshot: s, verdict: ActivationPolicy.evaluate(s, _clock())));
  }

  /// Judges the stored state again (expiry / start passing while offline).
  void reevaluate() {
    if (isClosed) return;
    final v = ActivationPolicy.evaluate(state.snapshot, _clock());
    if (v != state.verdict) emit(state.copyWith(verdict: v));
  }

  /// Signed `GET /devices/activation`. A call while one runs fetches once more after it.
  Future<void> refresh() async {
    if (isClosed) return;
    if (_refreshing != null) {
      _refreshAgain = true;
      return _refreshing;
    }
    final run = _refreshing = _refreshLoop();
    await run;
  }

  Future<void>? _refreshing;
  bool _refreshAgain = false;

  Future<void> _refreshLoop() async {
    try {
      do {
        _refreshAgain = false;
        emit(state.copyWith(refreshing: true, refreshError: null));
        final result = await _repo.fetch();
        if (isClosed) return;
        emit(
          state.copyWith(
            refreshing: false,
            refreshError: result.when(success: (_) => null, failure: (f) => f.userMessage),
          ),
        );
      } while (_refreshAgain && !isClosed);
    } finally {
      _refreshing = null;
    }
  }

  /// Device heartbeat; the activation it reports is stored by the repository.
  Future<void> heartbeat() async {
    await _repo.heartbeat();
    reevaluate();
  }

  Future<void> activate(String code) async {
    if (state.activating) return;
    if (!ActivationCode.isComplete(code)) {
      return emit(state.copyWith(activationError: 'Enter the 12-character code (XXXX-XXXX-XXXX).'));
    }
    emit(state.copyWith(activating: true, activationError: null));
    final result = await _repo.activate(code);
    if (isClosed) return;
    switch (result) {
      case Success(:final value):
        emit(
          state.copyWith(
            activating: false,
            loaded: true,
            snapshot: value,
            verdict: ActivationPolicy.evaluate(value, _clock()),
            refreshError: null,
          ),
        );
      case Err(:final failure):
        emit(state.copyWith(activating: false, activationError: _activationMessage(failure)));
    }
  }

  void clearError() {
    if (state.activationError != null) emit(state.copyWith(activationError: null));
  }

  static String _activationMessage(Failure f) => switch (f) {
    ServerFailure(code: 'INVALID_ACTIVATION_CODE') =>
      'This code is not valid for this terminal, or it has expired or was already used.',
    ServerFailure(statusCode: 429) => 'Too many attempts. Wait a minute and try again.',
    _ => f.userMessage,
  };

  Future<void> _onRealtime(RealtimeMessage m) async {
    final deviceId = _deviceId;
    if (m.event != 'device.activation' || deviceId == null) return;
    // The server sends it on both the devices and sync channels.
    final eventId = m.data['event_id'];
    if (eventId is String) {
      if (_seenEvents.contains(eventId)) return;
      _seenEvents.add(eventId);
      if (_seenEvents.length > 50) _seenEvents.removeAt(0);
    }
    final applied = await _repo.recordPushed(m.data, deviceId: deviceId);
    if (applied != null) await refresh(); // confirm with the server
  }

  @override
  Future<void> close() async {
    _tick?.cancel();
    _heartbeat?.cancel();
    await _changes.cancel();
    await _eventsSub?.cancel();
    await _reportsSub?.cancel();
    return super.close();
  }
}
