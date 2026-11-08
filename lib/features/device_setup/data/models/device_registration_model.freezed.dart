// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_registration_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreModel {

 String get id; String get code; String get name; String get currency; int get currencyDecimals; String get timezone; String get businessDayCutoff; bool get pricesIncludeTax;
/// Create a copy of StoreModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreModelCopyWith<StoreModel> get copyWith => _$StoreModelCopyWithImpl<StoreModel>(this as StoreModel, _$identity);

  /// Serializes this StoreModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StoreModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.currencyDecimals, _this.currencyDecimals) || other.currencyDecimals == _this.currencyDecimals)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.businessDayCutoff, _this.businessDayCutoff) || other.businessDayCutoff == _this.businessDayCutoff)&&(identical(other.pricesIncludeTax, _this.pricesIncludeTax) || other.pricesIncludeTax == _this.pricesIncludeTax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StoreModel;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.currency,_this.currencyDecimals,_this.timezone,_this.businessDayCutoff,_this.pricesIncludeTax);
}

@override
String toString() {
  final _this = this as StoreModel;
  return 'StoreModel(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, currency: ${_this.currency}, currencyDecimals: ${_this.currencyDecimals}, timezone: ${_this.timezone}, businessDayCutoff: ${_this.businessDayCutoff}, pricesIncludeTax: ${_this.pricesIncludeTax})';
}


}

/// @nodoc
abstract mixin class $StoreModelCopyWith<$Res>  {
  factory $StoreModelCopyWith(StoreModel value, $Res Function(StoreModel) _then) = _$StoreModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, String currency, int currencyDecimals, String timezone, String businessDayCutoff, bool pricesIncludeTax
});




}
/// @nodoc
class _$StoreModelCopyWithImpl<$Res>
    implements $StoreModelCopyWith<$Res> {
  _$StoreModelCopyWithImpl(this._self, this._then);

  final StoreModel _self;
  final $Res Function(StoreModel) _then;

/// Create a copy of StoreModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? currency = null,Object? currencyDecimals = null,Object? timezone = null,Object? businessDayCutoff = null,Object? pricesIncludeTax = null,}) {
  return _then(StoreModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,currencyDecimals: null == currencyDecimals ? _self.currencyDecimals : currencyDecimals // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,businessDayCutoff: null == businessDayCutoff ? _self.businessDayCutoff : businessDayCutoff // ignore: cast_nullable_to_non_nullable
as String,pricesIncludeTax: null == pricesIncludeTax ? _self.pricesIncludeTax : pricesIncludeTax // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreModel].
extension StoreModelPatterns on StoreModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreModel value)  $default,){
final _that = this;
switch (_that) {
case _StoreModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreModel value)?  $default,){
final _that = this;
switch (_that) {
case _StoreModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String currency,  int currencyDecimals,  String timezone,  String businessDayCutoff,  bool pricesIncludeTax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.currency,_that.currencyDecimals,_that.timezone,_that.businessDayCutoff,_that.pricesIncludeTax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String currency,  int currencyDecimals,  String timezone,  String businessDayCutoff,  bool pricesIncludeTax)  $default,) {final _that = this;
switch (_that) {
case _StoreModel():
return $default(_that.id,_that.code,_that.name,_that.currency,_that.currencyDecimals,_that.timezone,_that.businessDayCutoff,_that.pricesIncludeTax);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  String currency,  int currencyDecimals,  String timezone,  String businessDayCutoff,  bool pricesIncludeTax)?  $default,) {final _that = this;
switch (_that) {
case _StoreModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.currency,_that.currencyDecimals,_that.timezone,_that.businessDayCutoff,_that.pricesIncludeTax);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreModel extends StoreModel {
  const _StoreModel({required this.id, required this.code, required this.name, required this.currency, required this.currencyDecimals, required this.timezone, required this.businessDayCutoff, required this.pricesIncludeTax}): super._();
  factory _StoreModel.fromJson(Map<String, dynamic> json) => _$StoreModelFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;
@override final  String currency;
@override final  int currencyDecimals;
@override final  String timezone;
@override final  String businessDayCutoff;
@override final  bool pricesIncludeTax;

/// Create a copy of StoreModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreModelCopyWith<_StoreModel> get copyWith => __$StoreModelCopyWithImpl<_StoreModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currencyDecimals, currencyDecimals) || other.currencyDecimals == currencyDecimals)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.businessDayCutoff, businessDayCutoff) || other.businessDayCutoff == businessDayCutoff)&&(identical(other.pricesIncludeTax, pricesIncludeTax) || other.pricesIncludeTax == pricesIncludeTax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,currency,currencyDecimals,timezone,businessDayCutoff,pricesIncludeTax);
}

@override
String toString() {
    return 'StoreModel(id: $id, code: $code, name: $name, currency: $currency, currencyDecimals: $currencyDecimals, timezone: $timezone, businessDayCutoff: $businessDayCutoff, pricesIncludeTax: $pricesIncludeTax)';
}


}

/// @nodoc
abstract mixin class _$StoreModelCopyWith<$Res> implements $StoreModelCopyWith<$Res> {
  factory _$StoreModelCopyWith(_StoreModel value, $Res Function(_StoreModel) _then) = __$StoreModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, String currency, int currencyDecimals, String timezone, String businessDayCutoff, bool pricesIncludeTax
});




}
/// @nodoc
class __$StoreModelCopyWithImpl<$Res>
    implements _$StoreModelCopyWith<$Res> {
  __$StoreModelCopyWithImpl(this._self, this._then);

  final _StoreModel _self;
  final $Res Function(_StoreModel) _then;

/// Create a copy of StoreModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? currency = null,Object? currencyDecimals = null,Object? timezone = null,Object? businessDayCutoff = null,Object? pricesIncludeTax = null,}) {
  return _then(_StoreModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,currencyDecimals: null == currencyDecimals ? _self.currencyDecimals : currencyDecimals // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,businessDayCutoff: null == businessDayCutoff ? _self.businessDayCutoff : businessDayCutoff // ignore: cast_nullable_to_non_nullable
as String,pricesIncludeTax: null == pricesIncludeTax ? _self.pricesIncludeTax : pricesIncludeTax // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DeviceRegistrationModel {

 String get deviceId; String get deviceCode; String get tokenLetter; int get gatewayPriority; StoreModel get store; String get signingSecret; String get accessToken; DateTime get accessTokenExpiresAt; String get refreshToken; DateTime get refreshTokenExpiresAt; DateTime? get serverTime;
/// Create a copy of DeviceRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceRegistrationModelCopyWith<DeviceRegistrationModel> get copyWith => _$DeviceRegistrationModelCopyWithImpl<DeviceRegistrationModel>(this as DeviceRegistrationModel, _$identity);

  /// Serializes this DeviceRegistrationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceRegistrationModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceRegistrationModel&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.deviceCode, _this.deviceCode) || other.deviceCode == _this.deviceCode)&&(identical(other.tokenLetter, _this.tokenLetter) || other.tokenLetter == _this.tokenLetter)&&(identical(other.gatewayPriority, _this.gatewayPriority) || other.gatewayPriority == _this.gatewayPriority)&&(identical(other.store, _this.store) || other.store == _this.store)&&(identical(other.signingSecret, _this.signingSecret) || other.signingSecret == _this.signingSecret)&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.accessTokenExpiresAt, _this.accessTokenExpiresAt) || other.accessTokenExpiresAt == _this.accessTokenExpiresAt)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.refreshTokenExpiresAt, _this.refreshTokenExpiresAt) || other.refreshTokenExpiresAt == _this.refreshTokenExpiresAt)&&(identical(other.serverTime, _this.serverTime) || other.serverTime == _this.serverTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceRegistrationModel;
  return Object.hash(runtimeType,_this.deviceId,_this.deviceCode,_this.tokenLetter,_this.gatewayPriority,_this.store,_this.signingSecret,_this.accessToken,_this.accessTokenExpiresAt,_this.refreshToken,_this.refreshTokenExpiresAt,_this.serverTime);
}

@override
String toString() {
  final _this = this as DeviceRegistrationModel;
  return 'DeviceRegistrationModel(deviceId: ${_this.deviceId}, deviceCode: ${_this.deviceCode}, tokenLetter: ${_this.tokenLetter}, gatewayPriority: ${_this.gatewayPriority}, store: ${_this.store}, signingSecret: ${_this.signingSecret}, accessToken: ${_this.accessToken}, accessTokenExpiresAt: ${_this.accessTokenExpiresAt}, refreshToken: ${_this.refreshToken}, refreshTokenExpiresAt: ${_this.refreshTokenExpiresAt}, serverTime: ${_this.serverTime})';
}


}

/// @nodoc
abstract mixin class $DeviceRegistrationModelCopyWith<$Res>  {
  factory $DeviceRegistrationModelCopyWith(DeviceRegistrationModel value, $Res Function(DeviceRegistrationModel) _then) = _$DeviceRegistrationModelCopyWithImpl;
@useResult
$Res call({
 String deviceId, String deviceCode, String tokenLetter, int gatewayPriority, StoreModel store, String signingSecret, String accessToken, DateTime accessTokenExpiresAt, String refreshToken, DateTime refreshTokenExpiresAt, DateTime? serverTime
});


$StoreModelCopyWith<$Res> get store;

}
/// @nodoc
class _$DeviceRegistrationModelCopyWithImpl<$Res>
    implements $DeviceRegistrationModelCopyWith<$Res> {
  _$DeviceRegistrationModelCopyWithImpl(this._self, this._then);

  final DeviceRegistrationModel _self;
  final $Res Function(DeviceRegistrationModel) _then;

/// Create a copy of DeviceRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? deviceCode = null,Object? tokenLetter = null,Object? gatewayPriority = null,Object? store = null,Object? signingSecret = null,Object? accessToken = null,Object? accessTokenExpiresAt = null,Object? refreshToken = null,Object? refreshTokenExpiresAt = null,Object? serverTime = freezed,}) {
  return _then(DeviceRegistrationModel(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceCode: null == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as String,tokenLetter: null == tokenLetter ? _self.tokenLetter : tokenLetter // ignore: cast_nullable_to_non_nullable
as String,gatewayPriority: null == gatewayPriority ? _self.gatewayPriority : gatewayPriority // ignore: cast_nullable_to_non_nullable
as int,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as StoreModel,signingSecret: null == signingSecret ? _self.signingSecret : signingSecret // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,accessTokenExpiresAt: null == accessTokenExpiresAt ? _self.accessTokenExpiresAt : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,refreshTokenExpiresAt: null == refreshTokenExpiresAt ? _self.refreshTokenExpiresAt : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,serverTime: freezed == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of DeviceRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreModelCopyWith<$Res> get store {
  
  return $StoreModelCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeviceRegistrationModel].
extension DeviceRegistrationModelPatterns on DeviceRegistrationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceRegistrationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceRegistrationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceRegistrationModel value)  $default,){
final _that = this;
switch (_that) {
case _DeviceRegistrationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceRegistrationModel value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceRegistrationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String deviceCode,  String tokenLetter,  int gatewayPriority,  StoreModel store,  String signingSecret,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt,  DateTime? serverTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceRegistrationModel() when $default != null:
return $default(_that.deviceId,_that.deviceCode,_that.tokenLetter,_that.gatewayPriority,_that.store,_that.signingSecret,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt,_that.serverTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String deviceCode,  String tokenLetter,  int gatewayPriority,  StoreModel store,  String signingSecret,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt,  DateTime? serverTime)  $default,) {final _that = this;
switch (_that) {
case _DeviceRegistrationModel():
return $default(_that.deviceId,_that.deviceCode,_that.tokenLetter,_that.gatewayPriority,_that.store,_that.signingSecret,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt,_that.serverTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String deviceCode,  String tokenLetter,  int gatewayPriority,  StoreModel store,  String signingSecret,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt,  DateTime? serverTime)?  $default,) {final _that = this;
switch (_that) {
case _DeviceRegistrationModel() when $default != null:
return $default(_that.deviceId,_that.deviceCode,_that.tokenLetter,_that.gatewayPriority,_that.store,_that.signingSecret,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt,_that.serverTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceRegistrationModel extends DeviceRegistrationModel {
  const _DeviceRegistrationModel({required this.deviceId, required this.deviceCode, required this.tokenLetter, required this.gatewayPriority, required this.store, required this.signingSecret, required this.accessToken, required this.accessTokenExpiresAt, required this.refreshToken, required this.refreshTokenExpiresAt, this.serverTime}): super._();
  factory _DeviceRegistrationModel.fromJson(Map<String, dynamic> json) => _$DeviceRegistrationModelFromJson(json);

@override final  String deviceId;
@override final  String deviceCode;
@override final  String tokenLetter;
@override final  int gatewayPriority;
@override final  StoreModel store;
@override final  String signingSecret;
@override final  String accessToken;
@override final  DateTime accessTokenExpiresAt;
@override final  String refreshToken;
@override final  DateTime refreshTokenExpiresAt;
@override final  DateTime? serverTime;

/// Create a copy of DeviceRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceRegistrationModelCopyWith<_DeviceRegistrationModel> get copyWith => __$DeviceRegistrationModelCopyWithImpl<_DeviceRegistrationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceRegistrationModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceRegistrationModel&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceCode, deviceCode) || other.deviceCode == deviceCode)&&(identical(other.tokenLetter, tokenLetter) || other.tokenLetter == tokenLetter)&&(identical(other.gatewayPriority, gatewayPriority) || other.gatewayPriority == gatewayPriority)&&(identical(other.store, store) || other.store == store)&&(identical(other.signingSecret, signingSecret) || other.signingSecret == signingSecret)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.accessTokenExpiresAt, accessTokenExpiresAt) || other.accessTokenExpiresAt == accessTokenExpiresAt)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.refreshTokenExpiresAt, refreshTokenExpiresAt) || other.refreshTokenExpiresAt == refreshTokenExpiresAt)&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,deviceCode,tokenLetter,gatewayPriority,store,signingSecret,accessToken,accessTokenExpiresAt,refreshToken,refreshTokenExpiresAt,serverTime);
}

@override
String toString() {
    return 'DeviceRegistrationModel(deviceId: $deviceId, deviceCode: $deviceCode, tokenLetter: $tokenLetter, gatewayPriority: $gatewayPriority, store: $store, signingSecret: $signingSecret, accessToken: $accessToken, accessTokenExpiresAt: $accessTokenExpiresAt, refreshToken: $refreshToken, refreshTokenExpiresAt: $refreshTokenExpiresAt, serverTime: $serverTime)';
}


}

/// @nodoc
abstract mixin class _$DeviceRegistrationModelCopyWith<$Res> implements $DeviceRegistrationModelCopyWith<$Res> {
  factory _$DeviceRegistrationModelCopyWith(_DeviceRegistrationModel value, $Res Function(_DeviceRegistrationModel) _then) = __$DeviceRegistrationModelCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String deviceCode, String tokenLetter, int gatewayPriority, StoreModel store, String signingSecret, String accessToken, DateTime accessTokenExpiresAt, String refreshToken, DateTime refreshTokenExpiresAt, DateTime? serverTime
});


@override $StoreModelCopyWith<$Res> get store;

}
/// @nodoc
class __$DeviceRegistrationModelCopyWithImpl<$Res>
    implements _$DeviceRegistrationModelCopyWith<$Res> {
  __$DeviceRegistrationModelCopyWithImpl(this._self, this._then);

  final _DeviceRegistrationModel _self;
  final $Res Function(_DeviceRegistrationModel) _then;

/// Create a copy of DeviceRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? deviceCode = null,Object? tokenLetter = null,Object? gatewayPriority = null,Object? store = null,Object? signingSecret = null,Object? accessToken = null,Object? accessTokenExpiresAt = null,Object? refreshToken = null,Object? refreshTokenExpiresAt = null,Object? serverTime = freezed,}) {
  return _then(_DeviceRegistrationModel(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceCode: null == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as String,tokenLetter: null == tokenLetter ? _self.tokenLetter : tokenLetter // ignore: cast_nullable_to_non_nullable
as String,gatewayPriority: null == gatewayPriority ? _self.gatewayPriority : gatewayPriority // ignore: cast_nullable_to_non_nullable
as int,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as StoreModel,signingSecret: null == signingSecret ? _self.signingSecret : signingSecret // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,accessTokenExpiresAt: null == accessTokenExpiresAt ? _self.accessTokenExpiresAt : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,refreshTokenExpiresAt: null == refreshTokenExpiresAt ? _self.refreshTokenExpiresAt : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,serverTime: freezed == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of DeviceRegistrationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreModelCopyWith<$Res> get store {
  
  return $StoreModelCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

// dart format on
