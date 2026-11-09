import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/request_signer.dart';
import '../../../../core/utils/result.dart';
import '../../domain/activation_policy.dart';
import '../../domain/entities/device_activation.dart';
import '../../domain/entities/device_session.dart';
import '../../domain/repositories/activation_repository.dart';
import '../datasources/device_local_data_source.dart';
import '../datasources/device_remote_data_source.dart';
import '../models/device_activation_model.dart';

class ActivationRepositoryImpl implements ActivationRepository {
  ActivationRepositoryImpl(this._remote, this._local, this._config, {this._signer, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DeviceRemoteDataSource _remote;
  final DeviceLocalDataSource _local;
  final AppConfig _config;
  final RequestSigner? _signer;
  final DateTime Function() _clock;
  final _changes = StreamController<ActivationSnapshot>.broadcast();

  @override
  Stream<ActivationSnapshot> get changes => _changes.stream;

  @override
  Future<ActivationSnapshot?> cached() async => (await _local.readActivation())?.toEntity();

  @override
  Future<Result<ActivationSnapshot>> fetch() async {
    try {
      final res = await _remote.activation();
      return Success(await record(res.activation.toEntity(), serverTime: res.serverTime));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    }
  }

  @override
  Future<Result<ActivationSnapshot>> activate(String code) async {
    try {
      final res = await _remote.activate(ActivationCode.format(code));
      final a = res.result.activation.toEntity();
      return Success(await record(a.copyWith(deviceId: a.deviceId ?? res.result.deviceId), serverTime: res.serverTime));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    }
  }

  @override
  Future<Result<DeviceStatus>> heartbeat() async {
    try {
      final status = (await _remote.heartbeat(appVersion: _config.appVersion)).toEntity();
      if (status.activation case final a?) await record(a, serverTime: status.serverTime);
      return Success(status);
    } on DioException catch (e) {
      return Err(mapDioError(e));
    }
  }

  @override
  Future<ActivationSnapshot?> recordPushed(Map<String, dynamic> payload, {required String deviceId}) async {
    final block = payload['activation'];
    if (payload['device_id'] != deviceId || block is! Map) return null;
    final DeviceActivation a;
    try {
      a = DeviceActivationModel.fromJson(Map<String, dynamic>.from(block)).toEntity();
    } on Object {
      return null; // malformed event: the re-fetch that follows still brings the state
    }
    return record(a.copyWith(deviceId: deviceId));
  }

  @override
  Future<ActivationSnapshot> record(DeviceActivation activation, {DateTime? serverTime}) async {
    final previous = await cached();
    final deviceNow = _clock().toUtc();
    final server = serverTime?.toUtc();
    final offset = server != null ? server.difference(deviceNow) : (previous?.clockOffset ?? Duration.zero);
    final lastSeen = previous?.lastServerTime;
    final snapshot = ActivationSnapshot(
      activation: activation,
      clockOffset: offset,
      lastServerTime: server == null ? lastSeen : (lastSeen != null && lastSeen.isAfter(server) ? lastSeen : server),
      receivedAt: deviceNow,
    );
    if (server != null) _signer?.clockOffset = offset; // signatures use the same server clock
    try {
      await _local.saveActivation(ActivationSnapshotModel.fromEntity(snapshot));
    } on Object {
      // Storage refused: still enforced for this run from memory.
    }
    if (!_changes.isClosed) _changes.add(snapshot);
    return snapshot;
  }
}
