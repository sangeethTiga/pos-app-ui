// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoreInfo {

 String get id; String get code; String get name; String get currency; int get currencyDecimals; String get timezone; String get businessDayCutoff; bool get pricesIncludeTax;
/// Create a copy of StoreInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreInfoCopyWith<StoreInfo> get copyWith => _$StoreInfoCopyWithImpl<StoreInfo>(this as StoreInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StoreInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.currencyDecimals, _this.currencyDecimals) || other.currencyDecimals == _this.currencyDecimals)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.businessDayCutoff, _this.businessDayCutoff) || other.businessDayCutoff == _this.businessDayCutoff)&&(identical(other.pricesIncludeTax, _this.pricesIncludeTax) || other.pricesIncludeTax == _this.pricesIncludeTax));
}


@override
int get hashCode {
  final _this = this as StoreInfo;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.currency,_this.currencyDecimals,_this.timezone,_this.businessDayCutoff,_this.pricesIncludeTax);
}

@override
String toString() {
  final _this = this as StoreInfo;
  return 'StoreInfo(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, currency: ${_this.currency}, currencyDecimals: ${_this.currencyDecimals}, timezone: ${_this.timezone}, businessDayCutoff: ${_this.businessDayCutoff}, pricesIncludeTax: ${_this.pricesIncludeTax})';
}


}

/// @nodoc
abstract mixin class $StoreInfoCopyWith<$Res>  {
  factory $StoreInfoCopyWith(StoreInfo value, $Res Function(StoreInfo) _then) = _$StoreInfoCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, String currency, int currencyDecimals, String timezone, String businessDayCutoff, bool pricesIncludeTax
});




}
/// @nodoc
class _$StoreInfoCopyWithImpl<$Res>
    implements $StoreInfoCopyWith<$Res> {
  _$StoreInfoCopyWithImpl(this._self, this._then);

  final StoreInfo _self;
  final $Res Function(StoreInfo) _then;

/// Create a copy of StoreInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? currency = null,Object? currencyDecimals = null,Object? timezone = null,Object? businessDayCutoff = null,Object? pricesIncludeTax = null,}) {
  return _then(StoreInfo(
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


/// Adds pattern-matching-related methods to [StoreInfo].
extension StoreInfoPatterns on StoreInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreInfo value)  $default,){
final _that = this;
switch (_that) {
case _StoreInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreInfo value)?  $default,){
final _that = this;
switch (_that) {
case _StoreInfo() when $default != null:
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
case _StoreInfo() when $default != null:
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
case _StoreInfo():
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
case _StoreInfo() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.currency,_that.currencyDecimals,_that.timezone,_that.businessDayCutoff,_that.pricesIncludeTax);case _:
  return null;

}
}

}

/// @nodoc


class _StoreInfo implements StoreInfo {
  const _StoreInfo({required this.id, required this.code, required this.name, required this.currency, required this.currencyDecimals, required this.timezone, required this.businessDayCutoff, required this.pricesIncludeTax});
  

@override final  String id;
@override final  String code;
@override final  String name;
@override final  String currency;
@override final  int currencyDecimals;
@override final  String timezone;
@override final  String businessDayCutoff;
@override final  bool pricesIncludeTax;

/// Create a copy of StoreInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreInfoCopyWith<_StoreInfo> get copyWith => __$StoreInfoCopyWithImpl<_StoreInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.currencyDecimals, currencyDecimals) || other.currencyDecimals == currencyDecimals)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.businessDayCutoff, businessDayCutoff) || other.businessDayCutoff == businessDayCutoff)&&(identical(other.pricesIncludeTax, pricesIncludeTax) || other.pricesIncludeTax == pricesIncludeTax));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,currency,currencyDecimals,timezone,businessDayCutoff,pricesIncludeTax);
}

@override
String toString() {
    return 'StoreInfo(id: $id, code: $code, name: $name, currency: $currency, currencyDecimals: $currencyDecimals, timezone: $timezone, businessDayCutoff: $businessDayCutoff, pricesIncludeTax: $pricesIncludeTax)';
}


}

/// @nodoc
abstract mixin class _$StoreInfoCopyWith<$Res> implements $StoreInfoCopyWith<$Res> {
  factory _$StoreInfoCopyWith(_StoreInfo value, $Res Function(_StoreInfo) _then) = __$StoreInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, String currency, int currencyDecimals, String timezone, String businessDayCutoff, bool pricesIncludeTax
});




}
/// @nodoc
class __$StoreInfoCopyWithImpl<$Res>
    implements _$StoreInfoCopyWith<$Res> {
  __$StoreInfoCopyWithImpl(this._self, this._then);

  final _StoreInfo _self;
  final $Res Function(_StoreInfo) _then;

/// Create a copy of StoreInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? currency = null,Object? currencyDecimals = null,Object? timezone = null,Object? businessDayCutoff = null,Object? pricesIncludeTax = null,}) {
  return _then(_StoreInfo(
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
mixin _$DeviceSession {

 String get deviceId;/// Origin of every change this terminal writes (P1, P2 ...) and its bill-number prefix.
 String get deviceCode; String get tokenLetter; int get gatewayPriority; StoreInfo get store; String get accessToken; DateTime get accessTokenExpiresAt; String get refreshToken; DateTime get refreshTokenExpiresAt; String get signingSecret;
/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSessionCopyWith<DeviceSession> get copyWith => _$DeviceSessionCopyWithImpl<DeviceSession>(this as DeviceSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSession&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.deviceCode, _this.deviceCode) || other.deviceCode == _this.deviceCode)&&(identical(other.tokenLetter, _this.tokenLetter) || other.tokenLetter == _this.tokenLetter)&&(identical(other.gatewayPriority, _this.gatewayPriority) || other.gatewayPriority == _this.gatewayPriority)&&(identical(other.store, _this.store) || other.store == _this.store)&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.accessTokenExpiresAt, _this.accessTokenExpiresAt) || other.accessTokenExpiresAt == _this.accessTokenExpiresAt)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.refreshTokenExpiresAt, _this.refreshTokenExpiresAt) || other.refreshTokenExpiresAt == _this.refreshTokenExpiresAt)&&(identical(other.signingSecret, _this.signingSecret) || other.signingSecret == _this.signingSecret));
}


@override
int get hashCode {
  final _this = this as DeviceSession;
  return Object.hash(runtimeType,_this.deviceId,_this.deviceCode,_this.tokenLetter,_this.gatewayPriority,_this.store,_this.accessToken,_this.accessTokenExpiresAt,_this.refreshToken,_this.refreshTokenExpiresAt,_this.signingSecret);
}

@override
String toString() {
  final _this = this as DeviceSession;
  return 'DeviceSession(deviceId: ${_this.deviceId}, deviceCode: ${_this.deviceCode}, tokenLetter: ${_this.tokenLetter}, gatewayPriority: ${_this.gatewayPriority}, store: ${_this.store}, accessToken: ${_this.accessToken}, accessTokenExpiresAt: ${_this.accessTokenExpiresAt}, refreshToken: ${_this.refreshToken}, refreshTokenExpiresAt: ${_this.refreshTokenExpiresAt}, signingSecret: ${_this.signingSecret})';
}


}

/// @nodoc
abstract mixin class $DeviceSessionCopyWith<$Res>  {
  factory $DeviceSessionCopyWith(DeviceSession value, $Res Function(DeviceSession) _then) = _$DeviceSessionCopyWithImpl;
@useResult
$Res call({
 String deviceId, String deviceCode, String tokenLetter, int gatewayPriority, StoreInfo store, String accessToken, DateTime accessTokenExpiresAt, String refreshToken, DateTime refreshTokenExpiresAt, String signingSecret
});


$StoreInfoCopyWith<$Res> get store;

}
/// @nodoc
class _$DeviceSessionCopyWithImpl<$Res>
    implements $DeviceSessionCopyWith<$Res> {
  _$DeviceSessionCopyWithImpl(this._self, this._then);

  final DeviceSession _self;
  final $Res Function(DeviceSession) _then;

/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? deviceCode = null,Object? tokenLetter = null,Object? gatewayPriority = null,Object? store = null,Object? accessToken = null,Object? accessTokenExpiresAt = null,Object? refreshToken = null,Object? refreshTokenExpiresAt = null,Object? signingSecret = null,}) {
  return _then(DeviceSession(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceCode: null == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as String,tokenLetter: null == tokenLetter ? _self.tokenLetter : tokenLetter // ignore: cast_nullable_to_non_nullable
as String,gatewayPriority: null == gatewayPriority ? _self.gatewayPriority : gatewayPriority // ignore: cast_nullable_to_non_nullable
as int,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as StoreInfo,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,accessTokenExpiresAt: null == accessTokenExpiresAt ? _self.accessTokenExpiresAt : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,refreshTokenExpiresAt: null == refreshTokenExpiresAt ? _self.refreshTokenExpiresAt : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,signingSecret: null == signingSecret ? _self.signingSecret : signingSecret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreInfoCopyWith<$Res> get store {
  
  return $StoreInfoCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeviceSession].
extension DeviceSessionPatterns on DeviceSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceSession value)  $default,){
final _that = this;
switch (_that) {
case _DeviceSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceSession value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String deviceCode,  String tokenLetter,  int gatewayPriority,  StoreInfo store,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt,  String signingSecret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceSession() when $default != null:
return $default(_that.deviceId,_that.deviceCode,_that.tokenLetter,_that.gatewayPriority,_that.store,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt,_that.signingSecret);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String deviceCode,  String tokenLetter,  int gatewayPriority,  StoreInfo store,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt,  String signingSecret)  $default,) {final _that = this;
switch (_that) {
case _DeviceSession():
return $default(_that.deviceId,_that.deviceCode,_that.tokenLetter,_that.gatewayPriority,_that.store,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt,_that.signingSecret);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String deviceCode,  String tokenLetter,  int gatewayPriority,  StoreInfo store,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt,  String signingSecret)?  $default,) {final _that = this;
switch (_that) {
case _DeviceSession() when $default != null:
return $default(_that.deviceId,_that.deviceCode,_that.tokenLetter,_that.gatewayPriority,_that.store,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt,_that.signingSecret);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceSession extends DeviceSession {
  const _DeviceSession({required this.deviceId, required this.deviceCode, required this.tokenLetter, required this.gatewayPriority, required this.store, required this.accessToken, required this.accessTokenExpiresAt, required this.refreshToken, required this.refreshTokenExpiresAt, required this.signingSecret}): super._();
  

@override final  String deviceId;
/// Origin of every change this terminal writes (P1, P2 ...) and its bill-number prefix.
@override final  String deviceCode;
@override final  String tokenLetter;
@override final  int gatewayPriority;
@override final  StoreInfo store;
@override final  String accessToken;
@override final  DateTime accessTokenExpiresAt;
@override final  String refreshToken;
@override final  DateTime refreshTokenExpiresAt;
@override final  String signingSecret;

/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceSessionCopyWith<_DeviceSession> get copyWith => __$DeviceSessionCopyWithImpl<_DeviceSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceSession&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceCode, deviceCode) || other.deviceCode == deviceCode)&&(identical(other.tokenLetter, tokenLetter) || other.tokenLetter == tokenLetter)&&(identical(other.gatewayPriority, gatewayPriority) || other.gatewayPriority == gatewayPriority)&&(identical(other.store, store) || other.store == store)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.accessTokenExpiresAt, accessTokenExpiresAt) || other.accessTokenExpiresAt == accessTokenExpiresAt)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.refreshTokenExpiresAt, refreshTokenExpiresAt) || other.refreshTokenExpiresAt == refreshTokenExpiresAt)&&(identical(other.signingSecret, signingSecret) || other.signingSecret == signingSecret));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,deviceCode,tokenLetter,gatewayPriority,store,accessToken,accessTokenExpiresAt,refreshToken,refreshTokenExpiresAt,signingSecret);
}

@override
String toString() {
    return 'DeviceSession(deviceId: $deviceId, deviceCode: $deviceCode, tokenLetter: $tokenLetter, gatewayPriority: $gatewayPriority, store: $store, accessToken: $accessToken, accessTokenExpiresAt: $accessTokenExpiresAt, refreshToken: $refreshToken, refreshTokenExpiresAt: $refreshTokenExpiresAt, signingSecret: $signingSecret)';
}


}

/// @nodoc
abstract mixin class _$DeviceSessionCopyWith<$Res> implements $DeviceSessionCopyWith<$Res> {
  factory _$DeviceSessionCopyWith(_DeviceSession value, $Res Function(_DeviceSession) _then) = __$DeviceSessionCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String deviceCode, String tokenLetter, int gatewayPriority, StoreInfo store, String accessToken, DateTime accessTokenExpiresAt, String refreshToken, DateTime refreshTokenExpiresAt, String signingSecret
});


@override $StoreInfoCopyWith<$Res> get store;

}
/// @nodoc
class __$DeviceSessionCopyWithImpl<$Res>
    implements _$DeviceSessionCopyWith<$Res> {
  __$DeviceSessionCopyWithImpl(this._self, this._then);

  final _DeviceSession _self;
  final $Res Function(_DeviceSession) _then;

/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? deviceCode = null,Object? tokenLetter = null,Object? gatewayPriority = null,Object? store = null,Object? accessToken = null,Object? accessTokenExpiresAt = null,Object? refreshToken = null,Object? refreshTokenExpiresAt = null,Object? signingSecret = null,}) {
  return _then(_DeviceSession(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceCode: null == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as String,tokenLetter: null == tokenLetter ? _self.tokenLetter : tokenLetter // ignore: cast_nullable_to_non_nullable
as String,gatewayPriority: null == gatewayPriority ? _self.gatewayPriority : gatewayPriority // ignore: cast_nullable_to_non_nullable
as int,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as StoreInfo,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,accessTokenExpiresAt: null == accessTokenExpiresAt ? _self.accessTokenExpiresAt : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,refreshTokenExpiresAt: null == refreshTokenExpiresAt ? _self.refreshTokenExpiresAt : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,signingSecret: null == signingSecret ? _self.signingSecret : signingSecret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreInfoCopyWith<$Res> get store {
  
  return $StoreInfoCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

/// @nodoc
mixin _$DeviceStatus {

 String get deviceCode; String get status; String get storeStatus; bool get canSell; bool get isGateway; String? get businessDate; DateTime? get serverTime;
/// Create a copy of DeviceStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceStatusCopyWith<DeviceStatus> get copyWith => _$DeviceStatusCopyWithImpl<DeviceStatus>(this as DeviceStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceStatus&&(identical(other.deviceCode, _this.deviceCode) || other.deviceCode == _this.deviceCode)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.storeStatus, _this.storeStatus) || other.storeStatus == _this.storeStatus)&&(identical(other.canSell, _this.canSell) || other.canSell == _this.canSell)&&(identical(other.isGateway, _this.isGateway) || other.isGateway == _this.isGateway)&&(identical(other.businessDate, _this.businessDate) || other.businessDate == _this.businessDate)&&(identical(other.serverTime, _this.serverTime) || other.serverTime == _this.serverTime));
}


@override
int get hashCode {
  final _this = this as DeviceStatus;
  return Object.hash(runtimeType,_this.deviceCode,_this.status,_this.storeStatus,_this.canSell,_this.isGateway,_this.businessDate,_this.serverTime);
}

@override
String toString() {
  final _this = this as DeviceStatus;
  return 'DeviceStatus(deviceCode: ${_this.deviceCode}, status: ${_this.status}, storeStatus: ${_this.storeStatus}, canSell: ${_this.canSell}, isGateway: ${_this.isGateway}, businessDate: ${_this.businessDate}, serverTime: ${_this.serverTime})';
}


}

/// @nodoc
abstract mixin class $DeviceStatusCopyWith<$Res>  {
  factory $DeviceStatusCopyWith(DeviceStatus value, $Res Function(DeviceStatus) _then) = _$DeviceStatusCopyWithImpl;
@useResult
$Res call({
 String deviceCode, String status, String storeStatus, bool canSell, bool isGateway, String? businessDate, DateTime? serverTime
});




}
/// @nodoc
class _$DeviceStatusCopyWithImpl<$Res>
    implements $DeviceStatusCopyWith<$Res> {
  _$DeviceStatusCopyWithImpl(this._self, this._then);

  final DeviceStatus _self;
  final $Res Function(DeviceStatus) _then;

/// Create a copy of DeviceStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceCode = null,Object? status = null,Object? storeStatus = null,Object? canSell = null,Object? isGateway = null,Object? businessDate = freezed,Object? serverTime = freezed,}) {
  return _then(DeviceStatus(
deviceCode: null == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [DeviceStatus].
extension DeviceStatusPatterns on DeviceStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceStatus value)  $default,){
final _that = this;
switch (_that) {
case _DeviceStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceStatus value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceCode,  String status,  String storeStatus,  bool canSell,  bool isGateway,  String? businessDate,  DateTime? serverTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceStatus() when $default != null:
return $default(_that.deviceCode,_that.status,_that.storeStatus,_that.canSell,_that.isGateway,_that.businessDate,_that.serverTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceCode,  String status,  String storeStatus,  bool canSell,  bool isGateway,  String? businessDate,  DateTime? serverTime)  $default,) {final _that = this;
switch (_that) {
case _DeviceStatus():
return $default(_that.deviceCode,_that.status,_that.storeStatus,_that.canSell,_that.isGateway,_that.businessDate,_that.serverTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceCode,  String status,  String storeStatus,  bool canSell,  bool isGateway,  String? businessDate,  DateTime? serverTime)?  $default,) {final _that = this;
switch (_that) {
case _DeviceStatus() when $default != null:
return $default(_that.deviceCode,_that.status,_that.storeStatus,_that.canSell,_that.isGateway,_that.businessDate,_that.serverTime);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceStatus implements DeviceStatus {
  const _DeviceStatus({required this.deviceCode, required this.status, required this.storeStatus, required this.canSell, required this.isGateway, this.businessDate, this.serverTime});
  

@override final  String deviceCode;
@override final  String status;
@override final  String storeStatus;
@override final  bool canSell;
@override final  bool isGateway;
@override final  String? businessDate;
@override final  DateTime? serverTime;

/// Create a copy of DeviceStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceStatusCopyWith<_DeviceStatus> get copyWith => __$DeviceStatusCopyWithImpl<_DeviceStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceStatus&&(identical(other.deviceCode, deviceCode) || other.deviceCode == deviceCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.storeStatus, storeStatus) || other.storeStatus == storeStatus)&&(identical(other.canSell, canSell) || other.canSell == canSell)&&(identical(other.isGateway, isGateway) || other.isGateway == isGateway)&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceCode,status,storeStatus,canSell,isGateway,businessDate,serverTime);
}

@override
String toString() {
    return 'DeviceStatus(deviceCode: $deviceCode, status: $status, storeStatus: $storeStatus, canSell: $canSell, isGateway: $isGateway, businessDate: $businessDate, serverTime: $serverTime)';
}


}

/// @nodoc
abstract mixin class _$DeviceStatusCopyWith<$Res> implements $DeviceStatusCopyWith<$Res> {
  factory _$DeviceStatusCopyWith(_DeviceStatus value, $Res Function(_DeviceStatus) _then) = __$DeviceStatusCopyWithImpl;
@override @useResult
$Res call({
 String deviceCode, String status, String storeStatus, bool canSell, bool isGateway, String? businessDate, DateTime? serverTime
});




}
/// @nodoc
class __$DeviceStatusCopyWithImpl<$Res>
    implements _$DeviceStatusCopyWith<$Res> {
  __$DeviceStatusCopyWithImpl(this._self, this._then);

  final _DeviceStatus _self;
  final $Res Function(_DeviceStatus) _then;

/// Create a copy of DeviceStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceCode = null,Object? status = null,Object? storeStatus = null,Object? canSell = null,Object? isGateway = null,Object? businessDate = freezed,Object? serverTime = freezed,}) {
  return _then(_DeviceStatus(
deviceCode: null == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
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
