// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceStatusModel {

 String get deviceId; String get deviceCode; String get status; String get storeStatus; bool get canSell; bool get isGateway; String? get businessDate; DateTime? get serverTime;
/// Create a copy of DeviceStatusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceStatusModelCopyWith<DeviceStatusModel> get copyWith => _$DeviceStatusModelCopyWithImpl<DeviceStatusModel>(this as DeviceStatusModel, _$identity);

  /// Serializes this DeviceStatusModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceStatusModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceStatusModel&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.deviceCode, _this.deviceCode) || other.deviceCode == _this.deviceCode)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.storeStatus, _this.storeStatus) || other.storeStatus == _this.storeStatus)&&(identical(other.canSell, _this.canSell) || other.canSell == _this.canSell)&&(identical(other.isGateway, _this.isGateway) || other.isGateway == _this.isGateway)&&(identical(other.businessDate, _this.businessDate) || other.businessDate == _this.businessDate)&&(identical(other.serverTime, _this.serverTime) || other.serverTime == _this.serverTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceStatusModel;
  return Object.hash(runtimeType,_this.deviceId,_this.deviceCode,_this.status,_this.storeStatus,_this.canSell,_this.isGateway,_this.businessDate,_this.serverTime);
}

@override
String toString() {
  final _this = this as DeviceStatusModel;
  return 'DeviceStatusModel(deviceId: ${_this.deviceId}, deviceCode: ${_this.deviceCode}, status: ${_this.status}, storeStatus: ${_this.storeStatus}, canSell: ${_this.canSell}, isGateway: ${_this.isGateway}, businessDate: ${_this.businessDate}, serverTime: ${_this.serverTime})';
}


}

/// @nodoc
abstract mixin class $DeviceStatusModelCopyWith<$Res>  {
  factory $DeviceStatusModelCopyWith(DeviceStatusModel value, $Res Function(DeviceStatusModel) _then) = _$DeviceStatusModelCopyWithImpl;
@useResult
$Res call({
 String deviceId, String deviceCode, String status, String storeStatus, bool canSell, bool isGateway, String? businessDate, DateTime? serverTime
});




}
/// @nodoc
class _$DeviceStatusModelCopyWithImpl<$Res>
    implements $DeviceStatusModelCopyWith<$Res> {
  _$DeviceStatusModelCopyWithImpl(this._self, this._then);

  final DeviceStatusModel _self;
  final $Res Function(DeviceStatusModel) _then;

/// Create a copy of DeviceStatusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? deviceCode = null,Object? status = null,Object? storeStatus = null,Object? canSell = null,Object? isGateway = null,Object? businessDate = freezed,Object? serverTime = freezed,}) {
  return _then(DeviceStatusModel(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceCode: null == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,storeStatus: null == storeStatus ? _self.storeStatus : storeStatus // ignore: cast_nullable_to_non_nullable
as String,canSell: null == canSell ? _self.canSell : canSell // ignore: cast_nullable_to_non_nullable
as bool,isGateway: null == isGateway ? _self.isGateway : isGateway // ignore: cast_nullable_to_non_nullable
as bool,businessDate: freezed == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String?,serverTime: freezed == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceStatusModel].
extension DeviceStatusModelPatterns on DeviceStatusModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceStatusModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceStatusModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceStatusModel value)  $default,){
final _that = this;
switch (_that) {
case _DeviceStatusModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceStatusModel value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceStatusModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String deviceCode,  String status,  String storeStatus,  bool canSell,  bool isGateway,  String? businessDate,  DateTime? serverTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceStatusModel() when $default != null:
return $default(_that.deviceId,_that.deviceCode,_that.status,_that.storeStatus,_that.canSell,_that.isGateway,_that.businessDate,_that.serverTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String deviceCode,  String status,  String storeStatus,  bool canSell,  bool isGateway,  String? businessDate,  DateTime? serverTime)  $default,) {final _that = this;
switch (_that) {
case _DeviceStatusModel():
return $default(_that.deviceId,_that.deviceCode,_that.status,_that.storeStatus,_that.canSell,_that.isGateway,_that.businessDate,_that.serverTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String deviceCode,  String status,  String storeStatus,  bool canSell,  bool isGateway,  String? businessDate,  DateTime? serverTime)?  $default,) {final _that = this;
switch (_that) {
case _DeviceStatusModel() when $default != null:
return $default(_that.deviceId,_that.deviceCode,_that.status,_that.storeStatus,_that.canSell,_that.isGateway,_that.businessDate,_that.serverTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceStatusModel extends DeviceStatusModel {
  const _DeviceStatusModel({required this.deviceId, required this.deviceCode, required this.status, required this.storeStatus, required this.canSell, required this.isGateway, this.businessDate, this.serverTime}): super._();
  factory _DeviceStatusModel.fromJson(Map<String, dynamic> json) => _$DeviceStatusModelFromJson(json);

@override final  String deviceId;
@override final  String deviceCode;
@override final  String status;
@override final  String storeStatus;
@override final  bool canSell;
@override final  bool isGateway;
@override final  String? businessDate;
@override final  DateTime? serverTime;

/// Create a copy of DeviceStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceStatusModelCopyWith<_DeviceStatusModel> get copyWith => __$DeviceStatusModelCopyWithImpl<_DeviceStatusModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceStatusModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceStatusModel&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceCode, deviceCode) || other.deviceCode == deviceCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.storeStatus, storeStatus) || other.storeStatus == storeStatus)&&(identical(other.canSell, canSell) || other.canSell == canSell)&&(identical(other.isGateway, isGateway) || other.isGateway == isGateway)&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,deviceCode,status,storeStatus,canSell,isGateway,businessDate,serverTime);
}

@override
String toString() {
    return 'DeviceStatusModel(deviceId: $deviceId, deviceCode: $deviceCode, status: $status, storeStatus: $storeStatus, canSell: $canSell, isGateway: $isGateway, businessDate: $businessDate, serverTime: $serverTime)';
}


}

/// @nodoc
abstract mixin class _$DeviceStatusModelCopyWith<$Res> implements $DeviceStatusModelCopyWith<$Res> {
  factory _$DeviceStatusModelCopyWith(_DeviceStatusModel value, $Res Function(_DeviceStatusModel) _then) = __$DeviceStatusModelCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String deviceCode, String status, String storeStatus, bool canSell, bool isGateway, String? businessDate, DateTime? serverTime
});




}
/// @nodoc
class __$DeviceStatusModelCopyWithImpl<$Res>
    implements _$DeviceStatusModelCopyWith<$Res> {
  __$DeviceStatusModelCopyWithImpl(this._self, this._then);

  final _DeviceStatusModel _self;
  final $Res Function(_DeviceStatusModel) _then;

/// Create a copy of DeviceStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? deviceCode = null,Object? status = null,Object? storeStatus = null,Object? canSell = null,Object? isGateway = null,Object? businessDate = freezed,Object? serverTime = freezed,}) {
  return _then(_DeviceStatusModel(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceCode: null == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,storeStatus: null == storeStatus ? _self.storeStatus : storeStatus // ignore: cast_nullable_to_non_nullable
as String,canSell: null == canSell ? _self.canSell : canSell // ignore: cast_nullable_to_non_nullable
as bool,isGateway: null == isGateway ? _self.isGateway : isGateway // ignore: cast_nullable_to_non_nullable
as bool,businessDate: freezed == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String?,serverTime: freezed == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
