// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_device_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterDeviceRequest {

 String get storeCode; String get registrationCode; String get deviceName;/// `windows` or `android`.
 String get platform; String get appVersion; int? get gatewayPriority;/// `CASHIER` or `CAPTAIN`.
 String? get deviceType; String? get hardwareId; String? get kioskId;/// kiosk_wise_order_listing, delivery_manager_pos, settle_assigned_orders_only.
 Map<String, bool>? get settings;
/// Create a copy of RegisterDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterDeviceRequestCopyWith<RegisterDeviceRequest> get copyWith => _$RegisterDeviceRequestCopyWithImpl<RegisterDeviceRequest>(this as RegisterDeviceRequest, _$identity);

  /// Serializes this RegisterDeviceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RegisterDeviceRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterDeviceRequest&&(identical(other.storeCode, _this.storeCode) || other.storeCode == _this.storeCode)&&(identical(other.registrationCode, _this.registrationCode) || other.registrationCode == _this.registrationCode)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName)&&(identical(other.platform, _this.platform) || other.platform == _this.platform)&&(identical(other.appVersion, _this.appVersion) || other.appVersion == _this.appVersion)&&(identical(other.gatewayPriority, _this.gatewayPriority) || other.gatewayPriority == _this.gatewayPriority)&&(identical(other.deviceType, _this.deviceType) || other.deviceType == _this.deviceType)&&(identical(other.hardwareId, _this.hardwareId) || other.hardwareId == _this.hardwareId)&&(identical(other.kioskId, _this.kioskId) || other.kioskId == _this.kioskId)&&const DeepCollectionEquality().equals(other.settings, _this.settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RegisterDeviceRequest;
  return Object.hash(runtimeType,_this.storeCode,_this.registrationCode,_this.deviceName,_this.platform,_this.appVersion,_this.gatewayPriority,_this.deviceType,_this.hardwareId,_this.kioskId,const DeepCollectionEquality().hash(_this.settings));
}

@override
String toString() {
  final _this = this as RegisterDeviceRequest;
  return 'RegisterDeviceRequest(storeCode: ${_this.storeCode}, registrationCode: ${_this.registrationCode}, deviceName: ${_this.deviceName}, platform: ${_this.platform}, appVersion: ${_this.appVersion}, gatewayPriority: ${_this.gatewayPriority}, deviceType: ${_this.deviceType}, hardwareId: ${_this.hardwareId}, kioskId: ${_this.kioskId}, settings: ${_this.settings})';
}


}

/// @nodoc
abstract mixin class $RegisterDeviceRequestCopyWith<$Res>  {
  factory $RegisterDeviceRequestCopyWith(RegisterDeviceRequest value, $Res Function(RegisterDeviceRequest) _then) = _$RegisterDeviceRequestCopyWithImpl;
@useResult
$Res call({
 String storeCode, String registrationCode, String deviceName, String platform, String appVersion, int? gatewayPriority, String? deviceType, String? hardwareId, String? kioskId, Map<String, bool>? settings
});




}
/// @nodoc
class _$RegisterDeviceRequestCopyWithImpl<$Res>
    implements $RegisterDeviceRequestCopyWith<$Res> {
  _$RegisterDeviceRequestCopyWithImpl(this._self, this._then);

  final RegisterDeviceRequest _self;
  final $Res Function(RegisterDeviceRequest) _then;

/// Create a copy of RegisterDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeCode = null,Object? registrationCode = null,Object? deviceName = null,Object? platform = null,Object? appVersion = null,Object? gatewayPriority = freezed,Object? deviceType = freezed,Object? hardwareId = freezed,Object? kioskId = freezed,Object? settings = freezed,}) {
  return _then(RegisterDeviceRequest(
storeCode: null == storeCode ? _self.storeCode : storeCode // ignore: cast_nullable_to_non_nullable
as String,registrationCode: null == registrationCode ? _self.registrationCode : registrationCode // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,gatewayPriority: freezed == gatewayPriority ? _self.gatewayPriority : gatewayPriority // ignore: cast_nullable_to_non_nullable
as int?,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String?,hardwareId: freezed == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String?,kioskId: freezed == kioskId ? _self.kioskId : kioskId // ignore: cast_nullable_to_non_nullable
as String?,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterDeviceRequest].
extension RegisterDeviceRequestPatterns on RegisterDeviceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterDeviceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterDeviceRequest value)  $default,){
final _that = this;
switch (_that) {
case _RegisterDeviceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterDeviceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storeCode,  String registrationCode,  String deviceName,  String platform,  String appVersion,  int? gatewayPriority,  String? deviceType,  String? hardwareId,  String? kioskId,  Map<String, bool>? settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterDeviceRequest() when $default != null:
return $default(_that.storeCode,_that.registrationCode,_that.deviceName,_that.platform,_that.appVersion,_that.gatewayPriority,_that.deviceType,_that.hardwareId,_that.kioskId,_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storeCode,  String registrationCode,  String deviceName,  String platform,  String appVersion,  int? gatewayPriority,  String? deviceType,  String? hardwareId,  String? kioskId,  Map<String, bool>? settings)  $default,) {final _that = this;
switch (_that) {
case _RegisterDeviceRequest():
return $default(_that.storeCode,_that.registrationCode,_that.deviceName,_that.platform,_that.appVersion,_that.gatewayPriority,_that.deviceType,_that.hardwareId,_that.kioskId,_that.settings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storeCode,  String registrationCode,  String deviceName,  String platform,  String appVersion,  int? gatewayPriority,  String? deviceType,  String? hardwareId,  String? kioskId,  Map<String, bool>? settings)?  $default,) {final _that = this;
switch (_that) {
case _RegisterDeviceRequest() when $default != null:
return $default(_that.storeCode,_that.registrationCode,_that.deviceName,_that.platform,_that.appVersion,_that.gatewayPriority,_that.deviceType,_that.hardwareId,_that.kioskId,_that.settings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterDeviceRequest implements RegisterDeviceRequest {
  const _RegisterDeviceRequest({required this.storeCode, required this.registrationCode, required this.deviceName, required this.platform, required this.appVersion, this.gatewayPriority, this.deviceType, this.hardwareId, this.kioskId,  Map<String, bool>? settings}): _settings = settings;
  factory _RegisterDeviceRequest.fromJson(Map<String, dynamic> json) => _$RegisterDeviceRequestFromJson(json);

@override final  String storeCode;
@override final  String registrationCode;
@override final  String deviceName;
/// `windows` or `android`.
@override final  String platform;
@override final  String appVersion;
@override final  int? gatewayPriority;
/// `CASHIER` or `CAPTAIN`.
@override final  String? deviceType;
@override final  String? hardwareId;
@override final  String? kioskId;
/// kiosk_wise_order_listing, delivery_manager_pos, settle_assigned_orders_only.
 final  Map<String, bool>? _settings;
/// kiosk_wise_order_listing, delivery_manager_pos, settle_assigned_orders_only.
@override Map<String, bool>? get settings {
  final value = _settings;
  if (value == null) return null;
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of RegisterDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterDeviceRequestCopyWith<_RegisterDeviceRequest> get copyWith => __$RegisterDeviceRequestCopyWithImpl<_RegisterDeviceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterDeviceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterDeviceRequest&&(identical(other.storeCode, storeCode) || other.storeCode == storeCode)&&(identical(other.registrationCode, registrationCode) || other.registrationCode == registrationCode)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.gatewayPriority, gatewayPriority) || other.gatewayPriority == gatewayPriority)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.hardwareId, hardwareId) || other.hardwareId == hardwareId)&&(identical(other.kioskId, kioskId) || other.kioskId == kioskId)&&const DeepCollectionEquality().equals(other.settings, _settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,storeCode,registrationCode,deviceName,platform,appVersion,gatewayPriority,deviceType,hardwareId,kioskId,const DeepCollectionEquality().hash(_settings));
}

@override
String toString() {
    return 'RegisterDeviceRequest(storeCode: $storeCode, registrationCode: $registrationCode, deviceName: $deviceName, platform: $platform, appVersion: $appVersion, gatewayPriority: $gatewayPriority, deviceType: $deviceType, hardwareId: $hardwareId, kioskId: $kioskId, settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$RegisterDeviceRequestCopyWith<$Res> implements $RegisterDeviceRequestCopyWith<$Res> {
  factory _$RegisterDeviceRequestCopyWith(_RegisterDeviceRequest value, $Res Function(_RegisterDeviceRequest) _then) = __$RegisterDeviceRequestCopyWithImpl;
@override @useResult
$Res call({
 String storeCode, String registrationCode, String deviceName, String platform, String appVersion, int? gatewayPriority, String? deviceType, String? hardwareId, String? kioskId, Map<String, bool>? settings
});




}
/// @nodoc
class __$RegisterDeviceRequestCopyWithImpl<$Res>
    implements _$RegisterDeviceRequestCopyWith<$Res> {
  __$RegisterDeviceRequestCopyWithImpl(this._self, this._then);

  final _RegisterDeviceRequest _self;
  final $Res Function(_RegisterDeviceRequest) _then;

/// Create a copy of RegisterDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeCode = null,Object? registrationCode = null,Object? deviceName = null,Object? platform = null,Object? appVersion = null,Object? gatewayPriority = freezed,Object? deviceType = freezed,Object? hardwareId = freezed,Object? kioskId = freezed,Object? settings = freezed,}) {
  return _then(_RegisterDeviceRequest(
storeCode: null == storeCode ? _self.storeCode : storeCode // ignore: cast_nullable_to_non_nullable
as String,registrationCode: null == registrationCode ? _self.registrationCode : registrationCode // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,gatewayPriority: freezed == gatewayPriority ? _self.gatewayPriority : gatewayPriority // ignore: cast_nullable_to_non_nullable
as int?,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String?,hardwareId: freezed == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String?,kioskId: freezed == kioskId ? _self.kioskId : kioskId // ignore: cast_nullable_to_non_nullable
as String?,settings: freezed == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,
  ));
}


}

// dart format on
