// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_activation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceActivationModel {

 String? get deviceId; String? get storeId; String get status; bool get valid; DateTime? get startsAt; DateTime? get expiresAt; int? get remainingDays; String? get activationId;
/// Create a copy of DeviceActivationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceActivationModelCopyWith<DeviceActivationModel> get copyWith => _$DeviceActivationModelCopyWithImpl<DeviceActivationModel>(this as DeviceActivationModel, _$identity);

  /// Serializes this DeviceActivationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceActivationModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceActivationModel&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.storeId, _this.storeId) || other.storeId == _this.storeId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.valid, _this.valid) || other.valid == _this.valid)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.remainingDays, _this.remainingDays) || other.remainingDays == _this.remainingDays)&&(identical(other.activationId, _this.activationId) || other.activationId == _this.activationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceActivationModel;
  return Object.hash(runtimeType,_this.deviceId,_this.storeId,_this.status,_this.valid,_this.startsAt,_this.expiresAt,_this.remainingDays,_this.activationId);
}

@override
String toString() {
  final _this = this as DeviceActivationModel;
  return 'DeviceActivationModel(deviceId: ${_this.deviceId}, storeId: ${_this.storeId}, status: ${_this.status}, valid: ${_this.valid}, startsAt: ${_this.startsAt}, expiresAt: ${_this.expiresAt}, remainingDays: ${_this.remainingDays}, activationId: ${_this.activationId})';
}


}

/// @nodoc
abstract mixin class $DeviceActivationModelCopyWith<$Res>  {
  factory $DeviceActivationModelCopyWith(DeviceActivationModel value, $Res Function(DeviceActivationModel) _then) = _$DeviceActivationModelCopyWithImpl;
@useResult
$Res call({
 String? deviceId, String? storeId, String status, bool valid, DateTime? startsAt, DateTime? expiresAt, int? remainingDays, String? activationId
});




}
/// @nodoc
class _$DeviceActivationModelCopyWithImpl<$Res>
    implements $DeviceActivationModelCopyWith<$Res> {
  _$DeviceActivationModelCopyWithImpl(this._self, this._then);

  final DeviceActivationModel _self;
  final $Res Function(DeviceActivationModel) _then;

/// Create a copy of DeviceActivationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = freezed,Object? storeId = freezed,Object? status = null,Object? valid = null,Object? startsAt = freezed,Object? expiresAt = freezed,Object? remainingDays = freezed,Object? activationId = freezed,}) {
  return _then(DeviceActivationModel(
deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remainingDays: freezed == remainingDays ? _self.remainingDays : remainingDays // ignore: cast_nullable_to_non_nullable
as int?,activationId: freezed == activationId ? _self.activationId : activationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceActivationModel].
extension DeviceActivationModelPatterns on DeviceActivationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceActivationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceActivationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceActivationModel value)  $default,){
final _that = this;
switch (_that) {
case _DeviceActivationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceActivationModel value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceActivationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? deviceId,  String? storeId,  String status,  bool valid,  DateTime? startsAt,  DateTime? expiresAt,  int? remainingDays,  String? activationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceActivationModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? deviceId,  String? storeId,  String status,  bool valid,  DateTime? startsAt,  DateTime? expiresAt,  int? remainingDays,  String? activationId)  $default,) {final _that = this;
switch (_that) {
case _DeviceActivationModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? deviceId,  String? storeId,  String status,  bool valid,  DateTime? startsAt,  DateTime? expiresAt,  int? remainingDays,  String? activationId)?  $default,) {final _that = this;
switch (_that) {
case _DeviceActivationModel() when $default != null:
return $default(_that.deviceId,_that.storeId,_that.status,_that.valid,_that.startsAt,_that.expiresAt,_that.remainingDays,_that.activationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceActivationModel extends DeviceActivationModel {
  const _DeviceActivationModel({this.deviceId, this.storeId, this.status = 'INACTIVE', this.valid = false, this.startsAt, this.expiresAt, this.remainingDays, this.activationId}): super._();
  factory _DeviceActivationModel.fromJson(Map<String, dynamic> json) => _$DeviceActivationModelFromJson(json);

@override final  String? deviceId;
@override final  String? storeId;
@override@JsonKey() final  String status;
@override@JsonKey() final  bool valid;
@override final  DateTime? startsAt;
@override final  DateTime? expiresAt;
@override final  int? remainingDays;
@override final  String? activationId;

/// Create a copy of DeviceActivationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceActivationModelCopyWith<_DeviceActivationModel> get copyWith => __$DeviceActivationModelCopyWithImpl<_DeviceActivationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceActivationModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceActivationModel&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.valid, valid) || other.valid == valid)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.remainingDays, remainingDays) || other.remainingDays == remainingDays)&&(identical(other.activationId, activationId) || other.activationId == activationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,storeId,status,valid,startsAt,expiresAt,remainingDays,activationId);
}

@override
String toString() {
    return 'DeviceActivationModel(deviceId: $deviceId, storeId: $storeId, status: $status, valid: $valid, startsAt: $startsAt, expiresAt: $expiresAt, remainingDays: $remainingDays, activationId: $activationId)';
}


}

/// @nodoc
abstract mixin class _$DeviceActivationModelCopyWith<$Res> implements $DeviceActivationModelCopyWith<$Res> {
  factory _$DeviceActivationModelCopyWith(_DeviceActivationModel value, $Res Function(_DeviceActivationModel) _then) = __$DeviceActivationModelCopyWithImpl;
@override @useResult
$Res call({
 String? deviceId, String? storeId, String status, bool valid, DateTime? startsAt, DateTime? expiresAt, int? remainingDays, String? activationId
});




}
/// @nodoc
class __$DeviceActivationModelCopyWithImpl<$Res>
    implements _$DeviceActivationModelCopyWith<$Res> {
  __$DeviceActivationModelCopyWithImpl(this._self, this._then);

  final _DeviceActivationModel _self;
  final $Res Function(_DeviceActivationModel) _then;

/// Create a copy of DeviceActivationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = freezed,Object? storeId = freezed,Object? status = null,Object? valid = null,Object? startsAt = freezed,Object? expiresAt = freezed,Object? remainingDays = freezed,Object? activationId = freezed,}) {
  return _then(_DeviceActivationModel(
deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,valid: null == valid ? _self.valid : valid // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remainingDays: freezed == remainingDays ? _self.remainingDays : remainingDays // ignore: cast_nullable_to_non_nullable
as int?,activationId: freezed == activationId ? _self.activationId : activationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ActivateDeviceResponseModel {

 String? get deviceId; DeviceActivationModel get activation;
/// Create a copy of ActivateDeviceResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivateDeviceResponseModelCopyWith<ActivateDeviceResponseModel> get copyWith => _$ActivateDeviceResponseModelCopyWithImpl<ActivateDeviceResponseModel>(this as ActivateDeviceResponseModel, _$identity);

  /// Serializes this ActivateDeviceResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ActivateDeviceResponseModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivateDeviceResponseModel&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.activation, _this.activation) || other.activation == _this.activation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ActivateDeviceResponseModel;
  return Object.hash(runtimeType,_this.deviceId,_this.activation);
}

@override
String toString() {
  final _this = this as ActivateDeviceResponseModel;
  return 'ActivateDeviceResponseModel(deviceId: ${_this.deviceId}, activation: ${_this.activation})';
}


}

/// @nodoc
abstract mixin class $ActivateDeviceResponseModelCopyWith<$Res>  {
  factory $ActivateDeviceResponseModelCopyWith(ActivateDeviceResponseModel value, $Res Function(ActivateDeviceResponseModel) _then) = _$ActivateDeviceResponseModelCopyWithImpl;
@useResult
$Res call({
 String? deviceId, DeviceActivationModel activation
});


$DeviceActivationModelCopyWith<$Res> get activation;

}
/// @nodoc
class _$ActivateDeviceResponseModelCopyWithImpl<$Res>
    implements $ActivateDeviceResponseModelCopyWith<$Res> {
  _$ActivateDeviceResponseModelCopyWithImpl(this._self, this._then);

  final ActivateDeviceResponseModel _self;
  final $Res Function(ActivateDeviceResponseModel) _then;

/// Create a copy of ActivateDeviceResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = freezed,Object? activation = null,}) {
  return _then(ActivateDeviceResponseModel(
deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,activation: null == activation ? _self.activation : activation // ignore: cast_nullable_to_non_nullable
as DeviceActivationModel,
  ));
}
/// Create a copy of ActivateDeviceResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceActivationModelCopyWith<$Res> get activation {
  
  return $DeviceActivationModelCopyWith<$Res>(_self.activation, (value) {
    return _then(_self.copyWith(activation: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivateDeviceResponseModel].
extension ActivateDeviceResponseModelPatterns on ActivateDeviceResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivateDeviceResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivateDeviceResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivateDeviceResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivateDeviceResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivateDeviceResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivateDeviceResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? deviceId,  DeviceActivationModel activation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivateDeviceResponseModel() when $default != null:
return $default(_that.deviceId,_that.activation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? deviceId,  DeviceActivationModel activation)  $default,) {final _that = this;
switch (_that) {
case _ActivateDeviceResponseModel():
return $default(_that.deviceId,_that.activation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? deviceId,  DeviceActivationModel activation)?  $default,) {final _that = this;
switch (_that) {
case _ActivateDeviceResponseModel() when $default != null:
return $default(_that.deviceId,_that.activation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivateDeviceResponseModel implements ActivateDeviceResponseModel {
  const _ActivateDeviceResponseModel({this.deviceId, required this.activation});
  factory _ActivateDeviceResponseModel.fromJson(Map<String, dynamic> json) => _$ActivateDeviceResponseModelFromJson(json);

@override final  String? deviceId;
@override final  DeviceActivationModel activation;

/// Create a copy of ActivateDeviceResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivateDeviceResponseModelCopyWith<_ActivateDeviceResponseModel> get copyWith => __$ActivateDeviceResponseModelCopyWithImpl<_ActivateDeviceResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivateDeviceResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivateDeviceResponseModel&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.activation, activation) || other.activation == activation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,activation);
}

@override
String toString() {
    return 'ActivateDeviceResponseModel(deviceId: $deviceId, activation: $activation)';
}


}

/// @nodoc
abstract mixin class _$ActivateDeviceResponseModelCopyWith<$Res> implements $ActivateDeviceResponseModelCopyWith<$Res> {
  factory _$ActivateDeviceResponseModelCopyWith(_ActivateDeviceResponseModel value, $Res Function(_ActivateDeviceResponseModel) _then) = __$ActivateDeviceResponseModelCopyWithImpl;
@override @useResult
$Res call({
 String? deviceId, DeviceActivationModel activation
});


@override $DeviceActivationModelCopyWith<$Res> get activation;

}
/// @nodoc
class __$ActivateDeviceResponseModelCopyWithImpl<$Res>
    implements _$ActivateDeviceResponseModelCopyWith<$Res> {
  __$ActivateDeviceResponseModelCopyWithImpl(this._self, this._then);

  final _ActivateDeviceResponseModel _self;
  final $Res Function(_ActivateDeviceResponseModel) _then;

/// Create a copy of ActivateDeviceResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = freezed,Object? activation = null,}) {
  return _then(_ActivateDeviceResponseModel(
deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,activation: null == activation ? _self.activation : activation // ignore: cast_nullable_to_non_nullable
as DeviceActivationModel,
  ));
}

/// Create a copy of ActivateDeviceResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceActivationModelCopyWith<$Res> get activation {
  
  return $DeviceActivationModelCopyWith<$Res>(_self.activation, (value) {
    return _then(_self.copyWith(activation: value));
  });
}
}


/// @nodoc
mixin _$ActivationSnapshotModel {

 DeviceActivationModel get activation; int get clockOffsetMs; DateTime? get lastServerTime; DateTime get receivedAt;
/// Create a copy of ActivationSnapshotModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationSnapshotModelCopyWith<ActivationSnapshotModel> get copyWith => _$ActivationSnapshotModelCopyWithImpl<ActivationSnapshotModel>(this as ActivationSnapshotModel, _$identity);

  /// Serializes this ActivationSnapshotModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ActivationSnapshotModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationSnapshotModel&&(identical(other.activation, _this.activation) || other.activation == _this.activation)&&(identical(other.clockOffsetMs, _this.clockOffsetMs) || other.clockOffsetMs == _this.clockOffsetMs)&&(identical(other.lastServerTime, _this.lastServerTime) || other.lastServerTime == _this.lastServerTime)&&(identical(other.receivedAt, _this.receivedAt) || other.receivedAt == _this.receivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ActivationSnapshotModel;
  return Object.hash(runtimeType,_this.activation,_this.clockOffsetMs,_this.lastServerTime,_this.receivedAt);
}

@override
String toString() {
  final _this = this as ActivationSnapshotModel;
  return 'ActivationSnapshotModel(activation: ${_this.activation}, clockOffsetMs: ${_this.clockOffsetMs}, lastServerTime: ${_this.lastServerTime}, receivedAt: ${_this.receivedAt})';
}


}

/// @nodoc
abstract mixin class $ActivationSnapshotModelCopyWith<$Res>  {
  factory $ActivationSnapshotModelCopyWith(ActivationSnapshotModel value, $Res Function(ActivationSnapshotModel) _then) = _$ActivationSnapshotModelCopyWithImpl;
@useResult
$Res call({
 DeviceActivationModel activation, int clockOffsetMs, DateTime? lastServerTime, DateTime receivedAt
});


$DeviceActivationModelCopyWith<$Res> get activation;

}
/// @nodoc
class _$ActivationSnapshotModelCopyWithImpl<$Res>
    implements $ActivationSnapshotModelCopyWith<$Res> {
  _$ActivationSnapshotModelCopyWithImpl(this._self, this._then);

  final ActivationSnapshotModel _self;
  final $Res Function(ActivationSnapshotModel) _then;

/// Create a copy of ActivationSnapshotModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activation = null,Object? clockOffsetMs = null,Object? lastServerTime = freezed,Object? receivedAt = null,}) {
  return _then(ActivationSnapshotModel(
activation: null == activation ? _self.activation : activation // ignore: cast_nullable_to_non_nullable
as DeviceActivationModel,clockOffsetMs: null == clockOffsetMs ? _self.clockOffsetMs : clockOffsetMs // ignore: cast_nullable_to_non_nullable
as int,lastServerTime: freezed == lastServerTime ? _self.lastServerTime : lastServerTime // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ActivationSnapshotModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceActivationModelCopyWith<$Res> get activation {
  
  return $DeviceActivationModelCopyWith<$Res>(_self.activation, (value) {
    return _then(_self.copyWith(activation: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivationSnapshotModel].
extension ActivationSnapshotModelPatterns on ActivationSnapshotModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationSnapshotModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationSnapshotModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationSnapshotModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivationSnapshotModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationSnapshotModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationSnapshotModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceActivationModel activation,  int clockOffsetMs,  DateTime? lastServerTime,  DateTime receivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationSnapshotModel() when $default != null:
return $default(_that.activation,_that.clockOffsetMs,_that.lastServerTime,_that.receivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceActivationModel activation,  int clockOffsetMs,  DateTime? lastServerTime,  DateTime receivedAt)  $default,) {final _that = this;
switch (_that) {
case _ActivationSnapshotModel():
return $default(_that.activation,_that.clockOffsetMs,_that.lastServerTime,_that.receivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceActivationModel activation,  int clockOffsetMs,  DateTime? lastServerTime,  DateTime receivedAt)?  $default,) {final _that = this;
switch (_that) {
case _ActivationSnapshotModel() when $default != null:
return $default(_that.activation,_that.clockOffsetMs,_that.lastServerTime,_that.receivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivationSnapshotModel extends ActivationSnapshotModel {
  const _ActivationSnapshotModel({required this.activation, this.clockOffsetMs = 0, this.lastServerTime, required this.receivedAt}): super._();
  factory _ActivationSnapshotModel.fromJson(Map<String, dynamic> json) => _$ActivationSnapshotModelFromJson(json);

@override final  DeviceActivationModel activation;
@override@JsonKey() final  int clockOffsetMs;
@override final  DateTime? lastServerTime;
@override final  DateTime receivedAt;

/// Create a copy of ActivationSnapshotModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationSnapshotModelCopyWith<_ActivationSnapshotModel> get copyWith => __$ActivationSnapshotModelCopyWithImpl<_ActivationSnapshotModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivationSnapshotModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationSnapshotModel&&(identical(other.activation, activation) || other.activation == activation)&&(identical(other.clockOffsetMs, clockOffsetMs) || other.clockOffsetMs == clockOffsetMs)&&(identical(other.lastServerTime, lastServerTime) || other.lastServerTime == lastServerTime)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,activation,clockOffsetMs,lastServerTime,receivedAt);
}

@override
String toString() {
    return 'ActivationSnapshotModel(activation: $activation, clockOffsetMs: $clockOffsetMs, lastServerTime: $lastServerTime, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class _$ActivationSnapshotModelCopyWith<$Res> implements $ActivationSnapshotModelCopyWith<$Res> {
  factory _$ActivationSnapshotModelCopyWith(_ActivationSnapshotModel value, $Res Function(_ActivationSnapshotModel) _then) = __$ActivationSnapshotModelCopyWithImpl;
@override @useResult
$Res call({
 DeviceActivationModel activation, int clockOffsetMs, DateTime? lastServerTime, DateTime receivedAt
});


@override $DeviceActivationModelCopyWith<$Res> get activation;

}
/// @nodoc
class __$ActivationSnapshotModelCopyWithImpl<$Res>
    implements _$ActivationSnapshotModelCopyWith<$Res> {
  __$ActivationSnapshotModelCopyWithImpl(this._self, this._then);

  final _ActivationSnapshotModel _self;
  final $Res Function(_ActivationSnapshotModel) _then;

/// Create a copy of ActivationSnapshotModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activation = null,Object? clockOffsetMs = null,Object? lastServerTime = freezed,Object? receivedAt = null,}) {
  return _then(_ActivationSnapshotModel(
activation: null == activation ? _self.activation : activation // ignore: cast_nullable_to_non_nullable
as DeviceActivationModel,clockOffsetMs: null == clockOffsetMs ? _self.clockOffsetMs : clockOffsetMs // ignore: cast_nullable_to_non_nullable
as int,lastServerTime: freezed == lastServerTime ? _self.lastServerTime : lastServerTime // ignore: cast_nullable_to_non_nullable
as DateTime?,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ActivationSnapshotModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceActivationModelCopyWith<$Res> get activation {
  
  return $DeviceActivationModelCopyWith<$Res>(_self.activation, (value) {
    return _then(_self.copyWith(activation: value));
  });
}
}

// dart format on
