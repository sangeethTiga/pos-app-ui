// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_activation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceActivation {

 String? get deviceId; String? get storeId; ActivationStatus get status; bool get valid; DateTime? get startsAt; DateTime? get expiresAt; int? get remainingDays; String? get activationId;
/// Create a copy of DeviceActivation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceActivationCopyWith<DeviceActivation> get copyWith => _$DeviceActivationCopyWithImpl<DeviceActivation>(this as DeviceActivation, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceActivation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceActivation&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.storeId, _this.storeId) || other.storeId == _this.storeId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.valid, _this.valid) || other.valid == _this.valid)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.remainingDays, _this.remainingDays) || other.remainingDays == _this.remainingDays)&&(identical(other.activationId, _this.activationId) || other.activationId == _this.activationId));
}


@override
int get hashCode {
  final _this = this as DeviceActivation;
  return Object.hash(runtimeType,_this.deviceId,_this.storeId,_this.status,_this.valid,_this.startsAt,_this.expiresAt,_this.remainingDays,_this.activationId);
}

@override
String toString() {
  final _this = this as DeviceActivation;
  return 'DeviceActivation(deviceId: ${_this.deviceId}, storeId: ${_this.storeId}, status: ${_this.status}, valid: ${_this.valid}, startsAt: ${_this.startsAt}, expiresAt: ${_this.expiresAt}, remainingDays: ${_this.remainingDays}, activationId: ${_this.activationId})';
}


}

/// @nodoc
abstract mixin class $DeviceActivationCopyWith<$Res>  {
  factory $DeviceActivationCopyWith(DeviceActivation value, $Res Function(DeviceActivation) _then) = _$DeviceActivationCopyWithImpl;
@useResult
$Res call({
 String? deviceId, String? storeId, ActivationStatus status, bool valid, DateTime? startsAt, DateTime? expiresAt, int? remainingDays, String? activationId
});




}
/// @nodoc
class _$DeviceActivationCopyWithImpl<$Res>
    implements $DeviceActivationCopyWith<$Res> {
  _$DeviceActivationCopyWithImpl(this._self, this._then);

  final DeviceActivation _self;
  final $Res Function(DeviceActivation) _then;

/// Create a copy of DeviceActivation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = freezed,Object? storeId = freezed,Object? status = null,Object? valid = null,Object? startsAt = freezed,Object? expiresAt = freezed,Object? remainingDays = freezed,Object? activationId = freezed,}) {
  return _then(DeviceActivation(
deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ActivationStatus,valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remainingDays: freezed == remainingDays ? _self.remainingDays : remainingDays // ignore: cast_nullable_to_non_nullable
as int?,activationId: freezed == activationId ? _self.activationId : activationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceActivation].
extension DeviceActivationPatterns on DeviceActivation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceActivation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceActivation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceActivation value)  $default,){
final _that = this;
switch (_that) {
case _DeviceActivation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceActivation value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceActivation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? deviceId,  String? storeId,  ActivationStatus status,  bool valid,  DateTime? startsAt,  DateTime? expiresAt,  int? remainingDays,  String? activationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceActivation() when $default != null:
return $default(_that.deviceId,_that.storeId,_that.status,_that.valid,_that.startsAt,_that.expiresAt,_that.remainingDays,_that.activationId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? deviceId,  String? storeId,  ActivationStatus status,  bool valid,  DateTime? startsAt,  DateTime? expiresAt,  int? remainingDays,  String? activationId)  $default,) {final _that = this;
switch (_that) {
case _DeviceActivation():
return $default(_that.deviceId,_that.storeId,_that.status,_that.valid,_that.startsAt,_that.expiresAt,_that.remainingDays,_that.activationId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? deviceId,  String? storeId,  ActivationStatus status,  bool valid,  DateTime? startsAt,  DateTime? expiresAt,  int? remainingDays,  String? activationId)?  $default,) {final _that = this;
switch (_that) {
case _DeviceActivation() when $default != null:
return $default(_that.deviceId,_that.storeId,_that.status,_that.valid,_that.startsAt,_that.expiresAt,_that.remainingDays,_that.activationId);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceActivation implements DeviceActivation {
  const _DeviceActivation({this.deviceId, this.storeId, this.status = ActivationStatus.inactive, this.valid = false, this.startsAt, this.expiresAt, this.remainingDays, this.activationId});
  

@override final  String? deviceId;
@override final  String? storeId;
@override@JsonKey() final  ActivationStatus status;
@override@JsonKey() final  bool valid;
@override final  DateTime? startsAt;
@override final  DateTime? expiresAt;
@override final  int? remainingDays;
@override final  String? activationId;

/// Create a copy of DeviceActivation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceActivationCopyWith<_DeviceActivation> get copyWith => __$DeviceActivationCopyWithImpl<_DeviceActivation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceActivation&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.remainingDays, remainingDays) || other.remainingDays == remainingDays)&&(identical(other.activationId, activationId) || other.activationId == activationId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,storeId,status,valid,startsAt,expiresAt,remainingDays,activationId);
}

@override
String toString() {
    return 'DeviceActivation(deviceId: $deviceId, storeId: $storeId, status: $status, valid: $valid, startsAt: $startsAt, expiresAt: $expiresAt, remainingDays: $remainingDays, activationId: $activationId)';
}


}

/// @nodoc
abstract mixin class _$DeviceActivationCopyWith<$Res> implements $DeviceActivationCopyWith<$Res> {
  factory _$DeviceActivationCopyWith(_DeviceActivation value, $Res Function(_DeviceActivation) _then) = __$DeviceActivationCopyWithImpl;
@override @useResult
$Res call({
 String? deviceId, String? storeId, ActivationStatus status, bool valid, DateTime? startsAt, DateTime? expiresAt, int? remainingDays, String? activationId
});




}
/// @nodoc
class __$DeviceActivationCopyWithImpl<$Res>
    implements _$DeviceActivationCopyWith<$Res> {
  __$DeviceActivationCopyWithImpl(this._self, this._then);

  final _DeviceActivation _self;
  final $Res Function(_DeviceActivation) _then;

/// Create a copy of DeviceActivation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = freezed,Object? storeId = freezed,Object? status = null,Object? valid = null,Object? startsAt = freezed,Object? expiresAt = freezed,Object? remainingDays = freezed,Object? activationId = freezed,}) {
  return _then(_DeviceActivation(
deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ActivationStatus,valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remainingDays: freezed == remainingDays ? _self.remainingDays : remainingDays // ignore: cast_nullable_to_non_nullable
as int?,activationId: freezed == activationId ? _self.activationId : activationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ActivationSnapshot {

 DeviceActivation get activation;/// server clock - device clock, from the last response that carried the server time.
 Duration get clockOffset;/// Latest server time seen: "now" never goes back before it (device clock turned back).
 DateTime? get lastServerTime;/// Device time when [activation] was received.
 DateTime get receivedAt;
/// Create a copy of ActivationSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationSnapshotCopyWith<ActivationSnapshot> get copyWith => _$ActivationSnapshotCopyWithImpl<ActivationSnapshot>(this as ActivationSnapshot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ActivationSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationSnapshot&&(identical(other.activation, _this.activation) || other.activation == _this.activation)&&(identical(other.clockOffset, _this.clockOffset) || other.clockOffset == _this.clockOffset)&&(identical(other.lastServerTime, _this.lastServerTime) || other.lastServerTime == _this.lastServerTime)&&(identical(other.receivedAt, _this.receivedAt) || other.receivedAt == _this.receivedAt));
}


@override
int get hashCode {
  final _this = this as ActivationSnapshot;
  return Object.hash(runtimeType,_this.activation,_this.clockOffset,_this.lastServerTime,_this.receivedAt);
}

@override
String toString() {
  final _this = this as ActivationSnapshot;
  return 'ActivationSnapshot(activation: ${_this.activation}, clockOffset: ${_this.clockOffset}, lastServerTime: ${_this.lastServerTime}, receivedAt: ${_this.receivedAt})';
}


}

/// @nodoc
abstract mixin class $ActivationSnapshotCopyWith<$Res>  {
  factory $ActivationSnapshotCopyWith(ActivationSnapshot value, $Res Function(ActivationSnapshot) _then) = _$ActivationSnapshotCopyWithImpl;
@useResult
$Res call({
 DeviceActivation activation, Duration clockOffset, DateTime? lastServerTime, DateTime receivedAt
});


$DeviceActivationCopyWith<$Res> get activation;

}
/// @nodoc
class _$ActivationSnapshotCopyWithImpl<$Res>
    implements $ActivationSnapshotCopyWith<$Res> {
  _$ActivationSnapshotCopyWithImpl(this._self, this._then);

  final ActivationSnapshot _self;
  final $Res Function(ActivationSnapshot) _then;

/// Create a copy of ActivationSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activation = null,Object? clockOffset = null,Object? lastServerTime = freezed,Object? receivedAt = null,}) {
  return _then(ActivationSnapshot(
activation: null == activation ? _self.activation : activation // ignore: cast_nullable_to_non_nullable
as DeviceActivation,clockOffset: null == clockOffset ? _self.clockOffset : clockOffset // ignore: cast_nullable_to_non_nullable
as Duration,lastServerTime: freezed == lastServerTime ? _self.lastServerTime : lastServerTime // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ActivationSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceActivationCopyWith<$Res> get activation {
  
  return $DeviceActivationCopyWith<$Res>(_self.activation, (value) {
    return _then(_self.copyWith(activation: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivationSnapshot].
extension ActivationSnapshotPatterns on ActivationSnapshot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationSnapshot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ActivationSnapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationSnapshot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceActivation activation,  Duration clockOffset,  DateTime? lastServerTime,  DateTime receivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationSnapshot() when $default != null:
return $default(_that.activation,_that.clockOffset,_that.lastServerTime,_that.receivedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceActivation activation,  Duration clockOffset,  DateTime? lastServerTime,  DateTime receivedAt)  $default,) {final _that = this;
switch (_that) {
case _ActivationSnapshot():
return $default(_that.activation,_that.clockOffset,_that.lastServerTime,_that.receivedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceActivation activation,  Duration clockOffset,  DateTime? lastServerTime,  DateTime receivedAt)?  $default,) {final _that = this;
switch (_that) {
case _ActivationSnapshot() when $default != null:
return $default(_that.activation,_that.clockOffset,_that.lastServerTime,_that.receivedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ActivationSnapshot implements ActivationSnapshot {
  const _ActivationSnapshot({required this.activation, this.clockOffset = Duration.zero, this.lastServerTime, required this.receivedAt});
  

@override final  DeviceActivation activation;
/// server clock - device clock, from the last response that carried the server time.
@override@JsonKey() final  Duration clockOffset;
/// Latest server time seen: "now" never goes back before it (device clock turned back).
@override final  DateTime? lastServerTime;
/// Device time when [activation] was received.
@override final  DateTime receivedAt;

/// Create a copy of ActivationSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationSnapshotCopyWith<_ActivationSnapshot> get copyWith => __$ActivationSnapshotCopyWithImpl<_ActivationSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationSnapshot&&(identical(other.activation, activation) || other.activation == activation)&&(identical(other.clockOffset, clockOffset) || other.clockOffset == clockOffset)&&(identical(other.lastServerTime, lastServerTime) || other.lastServerTime == lastServerTime)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,activation,clockOffset,lastServerTime,receivedAt);
}

@override
String toString() {
    return 'ActivationSnapshot(activation: $activation, clockOffset: $clockOffset, lastServerTime: $lastServerTime, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class _$ActivationSnapshotCopyWith<$Res> implements $ActivationSnapshotCopyWith<$Res> {
  factory _$ActivationSnapshotCopyWith(_ActivationSnapshot value, $Res Function(_ActivationSnapshot) _then) = __$ActivationSnapshotCopyWithImpl;
@override @useResult
$Res call({
 DeviceActivation activation, Duration clockOffset, DateTime? lastServerTime, DateTime receivedAt
});


@override $DeviceActivationCopyWith<$Res> get activation;

}
/// @nodoc
class __$ActivationSnapshotCopyWithImpl<$Res>
    implements _$ActivationSnapshotCopyWith<$Res> {
  __$ActivationSnapshotCopyWithImpl(this._self, this._then);

  final _ActivationSnapshot _self;
  final $Res Function(_ActivationSnapshot) _then;

/// Create a copy of ActivationSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activation = null,Object? clockOffset = null,Object? lastServerTime = freezed,Object? receivedAt = null,}) {
  return _then(_ActivationSnapshot(
activation: null == activation ? _self.activation : activation // ignore: cast_nullable_to_non_nullable
as DeviceActivation,clockOffset: null == clockOffset ? _self.clockOffset : clockOffset // ignore: cast_nullable_to_non_nullable
as Duration,lastServerTime: freezed == lastServerTime ? _self.lastServerTime : lastServerTime // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ActivationSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceActivationCopyWith<$Res> get activation {
  
  return $DeviceActivationCopyWith<$Res>(_self.activation, (value) {
    return _then(_self.copyWith(activation: value));
  });
}
}

/// @nodoc
mixin _$ActivationVerdict {

/// null: the terminal may take new orders.
 ActivationBlock? get block;/// Whole days left (rounded up, as the server counts them); null without an expiry.
 int? get remainingDays; DateTime? get startsAt; DateTime? get expiresAt;
/// Create a copy of ActivationVerdict
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationVerdictCopyWith<ActivationVerdict> get copyWith => _$ActivationVerdictCopyWithImpl<ActivationVerdict>(this as ActivationVerdict, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ActivationVerdict;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationVerdict&&(identical(other.block, _this.block) || other.block == _this.block)&&(identical(other.remainingDays, _this.remainingDays) || other.remainingDays == _this.remainingDays)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}


@override
int get hashCode {
  final _this = this as ActivationVerdict;
  return Object.hash(runtimeType,_this.block,_this.remainingDays,_this.startsAt,_this.expiresAt);
}

@override
String toString() {
  final _this = this as ActivationVerdict;
  return 'ActivationVerdict(block: ${_this.block}, remainingDays: ${_this.remainingDays}, startsAt: ${_this.startsAt}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $ActivationVerdictCopyWith<$Res>  {
  factory $ActivationVerdictCopyWith(ActivationVerdict value, $Res Function(ActivationVerdict) _then) = _$ActivationVerdictCopyWithImpl;
@useResult
$Res call({
 ActivationBlock? block, int? remainingDays, DateTime? startsAt, DateTime? expiresAt
});




}
/// @nodoc
class _$ActivationVerdictCopyWithImpl<$Res>
    implements $ActivationVerdictCopyWith<$Res> {
  _$ActivationVerdictCopyWithImpl(this._self, this._then);

  final ActivationVerdict _self;
  final $Res Function(ActivationVerdict) _then;

/// Create a copy of ActivationVerdict
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? block = freezed,Object? remainingDays = freezed,Object? startsAt = freezed,Object? expiresAt = freezed,}) {
  return _then(ActivationVerdict(
block: freezed == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as ActivationBlock?,remainingDays: freezed == remainingDays ? _self.remainingDays : remainingDays // ignore: cast_nullable_to_non_nullable
as int?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivationVerdict].
extension ActivationVerdictPatterns on ActivationVerdict {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationVerdict value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationVerdict() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationVerdict value)  $default,){
final _that = this;
switch (_that) {
case _ActivationVerdict():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationVerdict value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationVerdict() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ActivationBlock? block,  int? remainingDays,  DateTime? startsAt,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationVerdict() when $default != null:
return $default(_that.block,_that.remainingDays,_that.startsAt,_that.expiresAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ActivationBlock? block,  int? remainingDays,  DateTime? startsAt,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _ActivationVerdict():
return $default(_that.block,_that.remainingDays,_that.startsAt,_that.expiresAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ActivationBlock? block,  int? remainingDays,  DateTime? startsAt,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _ActivationVerdict() when $default != null:
return $default(_that.block,_that.remainingDays,_that.startsAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _ActivationVerdict extends ActivationVerdict {
  const _ActivationVerdict({this.block, this.remainingDays, this.startsAt, this.expiresAt}): super._();
  

/// null: the terminal may take new orders.
@override final  ActivationBlock? block;
/// Whole days left (rounded up, as the server counts them); null without an expiry.
@override final  int? remainingDays;
@override final  DateTime? startsAt;
@override final  DateTime? expiresAt;

/// Create a copy of ActivationVerdict
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationVerdictCopyWith<_ActivationVerdict> get copyWith => __$ActivationVerdictCopyWithImpl<_ActivationVerdict>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationVerdict&&(identical(other.block, block) || other.block == block)&&(identical(other.remainingDays, remainingDays) || other.remainingDays == remainingDays)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,block,remainingDays,startsAt,expiresAt);
}

@override
String toString() {
    return 'ActivationVerdict(block: $block, remainingDays: $remainingDays, startsAt: $startsAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ActivationVerdictCopyWith<$Res> implements $ActivationVerdictCopyWith<$Res> {
  factory _$ActivationVerdictCopyWith(_ActivationVerdict value, $Res Function(_ActivationVerdict) _then) = __$ActivationVerdictCopyWithImpl;
@override @useResult
$Res call({
 ActivationBlock? block, int? remainingDays, DateTime? startsAt, DateTime? expiresAt
});




}
/// @nodoc
class __$ActivationVerdictCopyWithImpl<$Res>
    implements _$ActivationVerdictCopyWith<$Res> {
  __$ActivationVerdictCopyWithImpl(this._self, this._then);

  final _ActivationVerdict _self;
  final $Res Function(_ActivationVerdict) _then;

/// Create a copy of ActivationVerdict
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? block = freezed,Object? remainingDays = freezed,Object? startsAt = freezed,Object? expiresAt = freezed,}) {
  return _then(_ActivationVerdict(
block: freezed == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as ActivationBlock?,remainingDays: freezed == remainingDays ? _self.remainingDays : remainingDays // ignore: cast_nullable_to_non_nullable
as int?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
