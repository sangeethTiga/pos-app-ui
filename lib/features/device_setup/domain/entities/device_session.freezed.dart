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
mixin _$DeviceProfile {

 DeviceType get deviceType;/// This terminal's own id (shown with a copy button on the setup screen).
 String? get hardwareId; String? get kioskId; String? get kioskName; bool get kioskWiseOrderListing; bool get deliveryManagerPos; bool get settleAssignedOrdersOnly;
/// Create a copy of DeviceProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceProfileCopyWith<DeviceProfile> get copyWith => _$DeviceProfileCopyWithImpl<DeviceProfile>(this as DeviceProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceProfile&&(identical(other.deviceType, _this.deviceType) || other.deviceType == _this.deviceType)&&(identical(other.hardwareId, _this.hardwareId) || other.hardwareId == _this.hardwareId)&&(identical(other.kioskId, _this.kioskId) || other.kioskId == _this.kioskId)&&(identical(other.kioskName, _this.kioskName) || other.kioskName == _this.kioskName)&&(identical(other.kioskWiseOrderListing, _this.kioskWiseOrderListing) || other.kioskWiseOrderListing == _this.kioskWiseOrderListing)&&(identical(other.deliveryManagerPos, _this.deliveryManagerPos) || other.deliveryManagerPos == _this.deliveryManagerPos)&&(identical(other.settleAssignedOrdersOnly, _this.settleAssignedOrdersOnly) || other.settleAssignedOrdersOnly == _this.settleAssignedOrdersOnly));
}


@override
int get hashCode {
  final _this = this as DeviceProfile;
  return Object.hash(runtimeType,_this.deviceType,_this.hardwareId,_this.kioskId,_this.kioskName,_this.kioskWiseOrderListing,_this.deliveryManagerPos,_this.settleAssignedOrdersOnly);
}

@override
String toString() {
  final _this = this as DeviceProfile;
  return 'DeviceProfile(deviceType: ${_this.deviceType}, hardwareId: ${_this.hardwareId}, kioskId: ${_this.kioskId}, kioskName: ${_this.kioskName}, kioskWiseOrderListing: ${_this.kioskWiseOrderListing}, deliveryManagerPos: ${_this.deliveryManagerPos}, settleAssignedOrdersOnly: ${_this.settleAssignedOrdersOnly})';
}


}

/// @nodoc
abstract mixin class $DeviceProfileCopyWith<$Res>  {
  factory $DeviceProfileCopyWith(DeviceProfile value, $Res Function(DeviceProfile) _then) = _$DeviceProfileCopyWithImpl;
@useResult
$Res call({
 DeviceType deviceType, String? hardwareId, String? kioskId, String? kioskName, bool kioskWiseOrderListing, bool deliveryManagerPos, bool settleAssignedOrdersOnly
});




}
/// @nodoc
class _$DeviceProfileCopyWithImpl<$Res>
    implements $DeviceProfileCopyWith<$Res> {
  _$DeviceProfileCopyWithImpl(this._self, this._then);

  final DeviceProfile _self;
  final $Res Function(DeviceProfile) _then;

/// Create a copy of DeviceProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceType = null,Object? hardwareId = freezed,Object? kioskId = freezed,Object? kioskName = freezed,Object? kioskWiseOrderListing = null,Object? deliveryManagerPos = null,Object? settleAssignedOrdersOnly = null,}) {
  return _then(DeviceProfile(
deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as DeviceType,hardwareId: freezed == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String?,kioskId: freezed == kioskId ? _self.kioskId : kioskId // ignore: cast_nullable_to_non_nullable
as String?,kioskName: freezed == kioskName ? _self.kioskName : kioskName // ignore: cast_nullable_to_non_nullable
as String?,kioskWiseOrderListing: null == kioskWiseOrderListing ? _self.kioskWiseOrderListing : kioskWiseOrderListing // ignore: cast_nullable_to_non_nullable
as bool,deliveryManagerPos: null == deliveryManagerPos ? _self.deliveryManagerPos : deliveryManagerPos // ignore: cast_nullable_to_non_nullable
as bool,settleAssignedOrdersOnly: null == settleAssignedOrdersOnly ? _self.settleAssignedOrdersOnly : settleAssignedOrdersOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceProfile].
extension DeviceProfilePatterns on DeviceProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceProfile value)  $default,){
final _that = this;
switch (_that) {
case _DeviceProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceProfile value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceType deviceType,  String? hardwareId,  String? kioskId,  String? kioskName,  bool kioskWiseOrderListing,  bool deliveryManagerPos,  bool settleAssignedOrdersOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceProfile() when $default != null:
return $default(_that.deviceType,_that.hardwareId,_that.kioskId,_that.kioskName,_that.kioskWiseOrderListing,_that.deliveryManagerPos,_that.settleAssignedOrdersOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceType deviceType,  String? hardwareId,  String? kioskId,  String? kioskName,  bool kioskWiseOrderListing,  bool deliveryManagerPos,  bool settleAssignedOrdersOnly)  $default,) {final _that = this;
switch (_that) {
case _DeviceProfile():
return $default(_that.deviceType,_that.hardwareId,_that.kioskId,_that.kioskName,_that.kioskWiseOrderListing,_that.deliveryManagerPos,_that.settleAssignedOrdersOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceType deviceType,  String? hardwareId,  String? kioskId,  String? kioskName,  bool kioskWiseOrderListing,  bool deliveryManagerPos,  bool settleAssignedOrdersOnly)?  $default,) {final _that = this;
switch (_that) {
case _DeviceProfile() when $default != null:
return $default(_that.deviceType,_that.hardwareId,_that.kioskId,_that.kioskName,_that.kioskWiseOrderListing,_that.deliveryManagerPos,_that.settleAssignedOrdersOnly);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceProfile implements DeviceProfile {
  const _DeviceProfile({this.deviceType = DeviceType.cashier, this.hardwareId, this.kioskId, this.kioskName, this.kioskWiseOrderListing = false, this.deliveryManagerPos = false, this.settleAssignedOrdersOnly = false});
  

@override@JsonKey() final  DeviceType deviceType;
/// This terminal's own id (shown with a copy button on the setup screen).
@override final  String? hardwareId;
@override final  String? kioskId;
@override final  String? kioskName;
@override@JsonKey() final  bool kioskWiseOrderListing;
@override@JsonKey() final  bool deliveryManagerPos;
@override@JsonKey() final  bool settleAssignedOrdersOnly;

/// Create a copy of DeviceProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceProfileCopyWith<_DeviceProfile> get copyWith => __$DeviceProfileCopyWithImpl<_DeviceProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceProfile&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.hardwareId, hardwareId) || other.hardwareId == hardwareId)&&(identical(other.kioskId, kioskId) || other.kioskId == kioskId)&&(identical(other.kioskName, kioskName) || other.kioskName == kioskName)&&(identical(other.kioskWiseOrderListing, kioskWiseOrderListing) || other.kioskWiseOrderListing == kioskWiseOrderListing)&&(identical(other.deliveryManagerPos, deliveryManagerPos) || other.deliveryManagerPos == deliveryManagerPos)&&(identical(other.settleAssignedOrdersOnly, settleAssignedOrdersOnly) || other.settleAssignedOrdersOnly == settleAssignedOrdersOnly));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceType,hardwareId,kioskId,kioskName,kioskWiseOrderListing,deliveryManagerPos,settleAssignedOrdersOnly);
}

@override
String toString() {
    return 'DeviceProfile(deviceType: $deviceType, hardwareId: $hardwareId, kioskId: $kioskId, kioskName: $kioskName, kioskWiseOrderListing: $kioskWiseOrderListing, deliveryManagerPos: $deliveryManagerPos, settleAssignedOrdersOnly: $settleAssignedOrdersOnly)';
}


}

/// @nodoc
abstract mixin class _$DeviceProfileCopyWith<$Res> implements $DeviceProfileCopyWith<$Res> {
  factory _$DeviceProfileCopyWith(_DeviceProfile value, $Res Function(_DeviceProfile) _then) = __$DeviceProfileCopyWithImpl;
@override @useResult
$Res call({
 DeviceType deviceType, String? hardwareId, String? kioskId, String? kioskName, bool kioskWiseOrderListing, bool deliveryManagerPos, bool settleAssignedOrdersOnly
});




}
/// @nodoc
class __$DeviceProfileCopyWithImpl<$Res>
    implements _$DeviceProfileCopyWith<$Res> {
  __$DeviceProfileCopyWithImpl(this._self, this._then);

  final _DeviceProfile _self;
  final $Res Function(_DeviceProfile) _then;

/// Create a copy of DeviceProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceType = null,Object? hardwareId = freezed,Object? kioskId = freezed,Object? kioskName = freezed,Object? kioskWiseOrderListing = null,Object? deliveryManagerPos = null,Object? settleAssignedOrdersOnly = null,}) {
  return _then(_DeviceProfile(
deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as DeviceType,hardwareId: freezed == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String?,kioskId: freezed == kioskId ? _self.kioskId : kioskId // ignore: cast_nullable_to_non_nullable
as String?,kioskName: freezed == kioskName ? _self.kioskName : kioskName // ignore: cast_nullable_to_non_nullable
as String?,kioskWiseOrderListing: null == kioskWiseOrderListing ? _self.kioskWiseOrderListing : kioskWiseOrderListing // ignore: cast_nullable_to_non_nullable
as bool,deliveryManagerPos: null == deliveryManagerPos ? _self.deliveryManagerPos : deliveryManagerPos // ignore: cast_nullable_to_non_nullable
as bool,settleAssignedOrdersOnly: null == settleAssignedOrdersOnly ? _self.settleAssignedOrdersOnly : settleAssignedOrdersOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$KioskOption {

 String get id; String get name;
/// Create a copy of KioskOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KioskOptionCopyWith<KioskOption> get copyWith => _$KioskOptionCopyWithImpl<KioskOption>(this as KioskOption, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KioskOption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KioskOption&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}


@override
int get hashCode {
  final _this = this as KioskOption;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as KioskOption;
  return 'KioskOption(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $KioskOptionCopyWith<$Res>  {
  factory $KioskOptionCopyWith(KioskOption value, $Res Function(KioskOption) _then) = _$KioskOptionCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$KioskOptionCopyWithImpl<$Res>
    implements $KioskOptionCopyWith<$Res> {
  _$KioskOptionCopyWithImpl(this._self, this._then);

  final KioskOption _self;
  final $Res Function(KioskOption) _then;

/// Create a copy of KioskOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(KioskOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KioskOption].
extension KioskOptionPatterns on KioskOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KioskOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KioskOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KioskOption value)  $default,){
final _that = this;
switch (_that) {
case _KioskOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KioskOption value)?  $default,){
final _that = this;
switch (_that) {
case _KioskOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KioskOption() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _KioskOption():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _KioskOption() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _KioskOption implements KioskOption {
  const _KioskOption({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of KioskOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KioskOptionCopyWith<_KioskOption> get copyWith => __$KioskOptionCopyWithImpl<_KioskOption>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KioskOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'KioskOption(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$KioskOptionCopyWith<$Res> implements $KioskOptionCopyWith<$Res> {
  factory _$KioskOptionCopyWith(_KioskOption value, $Res Function(_KioskOption) _then) = __$KioskOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$KioskOptionCopyWithImpl<$Res>
    implements _$KioskOptionCopyWith<$Res> {
  __$KioskOptionCopyWithImpl(this._self, this._then);

  final _KioskOption _self;
  final $Res Function(_KioskOption) _then;

/// Create a copy of KioskOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_KioskOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SetupPreview {

 String get storeId; String get storeCode; String get storeName; List<KioskOption> get kiosks;/// Roles the store allows (empty: all).
 List<DeviceType> get deviceTypes;/// The code re-pairs an existing terminal (same P-code): [deviceCode] / [deviceName].
 bool get rePair; String? get deviceCode; String? get deviceName;
/// Create a copy of SetupPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupPreviewCopyWith<SetupPreview> get copyWith => _$SetupPreviewCopyWithImpl<SetupPreview>(this as SetupPreview, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SetupPreview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupPreview&&(identical(other.storeId, _this.storeId) || other.storeId == _this.storeId)&&(identical(other.storeCode, _this.storeCode) || other.storeCode == _this.storeCode)&&(identical(other.storeName, _this.storeName) || other.storeName == _this.storeName)&&const DeepCollectionEquality().equals(other.kiosks, _this.kiosks)&&const DeepCollectionEquality().equals(other.deviceTypes, _this.deviceTypes)&&(identical(other.rePair, _this.rePair) || other.rePair == _this.rePair)&&(identical(other.deviceCode, _this.deviceCode) || other.deviceCode == _this.deviceCode)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName));
}


@override
int get hashCode {
  final _this = this as SetupPreview;
  return Object.hash(runtimeType,_this.storeId,_this.storeCode,_this.storeName,const DeepCollectionEquality().hash(_this.kiosks),const DeepCollectionEquality().hash(_this.deviceTypes),_this.rePair,_this.deviceCode,_this.deviceName);
}

@override
String toString() {
  final _this = this as SetupPreview;
  return 'SetupPreview(storeId: ${_this.storeId}, storeCode: ${_this.storeCode}, storeName: ${_this.storeName}, kiosks: ${_this.kiosks}, deviceTypes: ${_this.deviceTypes}, rePair: ${_this.rePair}, deviceCode: ${_this.deviceCode}, deviceName: ${_this.deviceName})';
}


}

/// @nodoc
abstract mixin class $SetupPreviewCopyWith<$Res>  {
  factory $SetupPreviewCopyWith(SetupPreview value, $Res Function(SetupPreview) _then) = _$SetupPreviewCopyWithImpl;
@useResult
$Res call({
 String storeId, String storeCode, String storeName, List<KioskOption> kiosks, List<DeviceType> deviceTypes, bool rePair, String? deviceCode, String? deviceName
});




}
/// @nodoc
class _$SetupPreviewCopyWithImpl<$Res>
    implements $SetupPreviewCopyWith<$Res> {
  _$SetupPreviewCopyWithImpl(this._self, this._then);

  final SetupPreview _self;
  final $Res Function(SetupPreview) _then;

/// Create a copy of SetupPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeId = null,Object? storeCode = null,Object? storeName = null,Object? kiosks = null,Object? deviceTypes = null,Object? rePair = null,Object? deviceCode = freezed,Object? deviceName = freezed,}) {
  return _then(SetupPreview(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,storeCode: null == storeCode ? _self.storeCode : storeCode // ignore: cast_nullable_to_non_nullable
as String,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,kiosks: null == kiosks ? _self.kiosks : kiosks // ignore: cast_nullable_to_non_nullable
as List<KioskOption>,deviceTypes: null == deviceTypes ? _self.deviceTypes : deviceTypes // ignore: cast_nullable_to_non_nullable
as List<DeviceType>,rePair: null == rePair ? _self.rePair : rePair // ignore: cast_nullable_to_non_nullable
as bool,deviceCode: freezed == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as String?,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetupPreview].
extension SetupPreviewPatterns on SetupPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetupPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetupPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetupPreview value)  $default,){
final _that = this;
switch (_that) {
case _SetupPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetupPreview value)?  $default,){
final _that = this;
switch (_that) {
case _SetupPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storeId,  String storeCode,  String storeName,  List<KioskOption> kiosks,  List<DeviceType> deviceTypes,  bool rePair,  String? deviceCode,  String? deviceName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetupPreview() when $default != null:
return $default(_that.storeId,_that.storeCode,_that.storeName,_that.kiosks,_that.deviceTypes,_that.rePair,_that.deviceCode,_that.deviceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storeId,  String storeCode,  String storeName,  List<KioskOption> kiosks,  List<DeviceType> deviceTypes,  bool rePair,  String? deviceCode,  String? deviceName)  $default,) {final _that = this;
switch (_that) {
case _SetupPreview():
return $default(_that.storeId,_that.storeCode,_that.storeName,_that.kiosks,_that.deviceTypes,_that.rePair,_that.deviceCode,_that.deviceName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storeId,  String storeCode,  String storeName,  List<KioskOption> kiosks,  List<DeviceType> deviceTypes,  bool rePair,  String? deviceCode,  String? deviceName)?  $default,) {final _that = this;
switch (_that) {
case _SetupPreview() when $default != null:
return $default(_that.storeId,_that.storeCode,_that.storeName,_that.kiosks,_that.deviceTypes,_that.rePair,_that.deviceCode,_that.deviceName);case _:
  return null;

}
}

}

/// @nodoc


class _SetupPreview implements SetupPreview {
  const _SetupPreview({required this.storeId, required this.storeCode, required this.storeName,  List<KioskOption> kiosks = const <KioskOption>[],  List<DeviceType> deviceTypes = const <DeviceType>[], this.rePair = false, this.deviceCode, this.deviceName}): _kiosks = kiosks,_deviceTypes = deviceTypes;
  

@override final  String storeId;
@override final  String storeCode;
@override final  String storeName;
 final  List<KioskOption> _kiosks;
@override@JsonKey() List<KioskOption> get kiosks {
  if (_kiosks is EqualUnmodifiableListView) return _kiosks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_kiosks);
}

/// Roles the store allows (empty: all).
 final  List<DeviceType> _deviceTypes;
/// Roles the store allows (empty: all).
@override@JsonKey() List<DeviceType> get deviceTypes {
  if (_deviceTypes is EqualUnmodifiableListView) return _deviceTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deviceTypes);
}

/// The code re-pairs an existing terminal (same P-code): [deviceCode] / [deviceName].
@override@JsonKey() final  bool rePair;
@override final  String? deviceCode;
@override final  String? deviceName;

/// Create a copy of SetupPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetupPreviewCopyWith<_SetupPreview> get copyWith => __$SetupPreviewCopyWithImpl<_SetupPreview>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetupPreview&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeCode, storeCode) || other.storeCode == storeCode)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&const DeepCollectionEquality().equals(other.kiosks, _kiosks)&&const DeepCollectionEquality().equals(other.deviceTypes, _deviceTypes)&&(identical(other.rePair, rePair) || other.rePair == rePair)&&(identical(other.deviceCode, deviceCode) || other.deviceCode == deviceCode)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,storeId,storeCode,storeName,const DeepCollectionEquality().hash(_kiosks),const DeepCollectionEquality().hash(_deviceTypes),rePair,deviceCode,deviceName);
}

@override
String toString() {
    return 'SetupPreview(storeId: $storeId, storeCode: $storeCode, storeName: $storeName, kiosks: $kiosks, deviceTypes: $deviceTypes, rePair: $rePair, deviceCode: $deviceCode, deviceName: $deviceName)';
}


}

/// @nodoc
abstract mixin class _$SetupPreviewCopyWith<$Res> implements $SetupPreviewCopyWith<$Res> {
  factory _$SetupPreviewCopyWith(_SetupPreview value, $Res Function(_SetupPreview) _then) = __$SetupPreviewCopyWithImpl;
@override @useResult
$Res call({
 String storeId, String storeCode, String storeName, List<KioskOption> kiosks, List<DeviceType> deviceTypes, bool rePair, String? deviceCode, String? deviceName
});




}
/// @nodoc
class __$SetupPreviewCopyWithImpl<$Res>
    implements _$SetupPreviewCopyWith<$Res> {
  __$SetupPreviewCopyWithImpl(this._self, this._then);

  final _SetupPreview _self;
  final $Res Function(_SetupPreview) _then;

/// Create a copy of SetupPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeId = null,Object? storeCode = null,Object? storeName = null,Object? kiosks = null,Object? deviceTypes = null,Object? rePair = null,Object? deviceCode = freezed,Object? deviceName = freezed,}) {
  return _then(_SetupPreview(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,storeCode: null == storeCode ? _self.storeCode : storeCode // ignore: cast_nullable_to_non_nullable
as String,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,kiosks: null == kiosks ? _self._kiosks : kiosks // ignore: cast_nullable_to_non_nullable
as List<KioskOption>,deviceTypes: null == deviceTypes ? _self._deviceTypes : deviceTypes // ignore: cast_nullable_to_non_nullable
as List<DeviceType>,rePair: null == rePair ? _self.rePair : rePair // ignore: cast_nullable_to_non_nullable
as bool,deviceCode: freezed == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as String?,deviceName: freezed == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$DeviceSession {

 String get deviceId;/// Origin of every change this terminal writes (P1, P2 ...) and its bill-number prefix.
 String get deviceCode; String get tokenLetter; int get gatewayPriority; StoreInfo get store; String get accessToken; DateTime get accessTokenExpiresAt; String get refreshToken; DateTime get refreshTokenExpiresAt; String get signingSecret; DeviceProfile get profile;
/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSessionCopyWith<DeviceSession> get copyWith => _$DeviceSessionCopyWithImpl<DeviceSession>(this as DeviceSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSession&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.deviceCode, _this.deviceCode) || other.deviceCode == _this.deviceCode)&&(identical(other.tokenLetter, _this.tokenLetter) || other.tokenLetter == _this.tokenLetter)&&(identical(other.gatewayPriority, _this.gatewayPriority) || other.gatewayPriority == _this.gatewayPriority)&&(identical(other.store, _this.store) || other.store == _this.store)&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.accessTokenExpiresAt, _this.accessTokenExpiresAt) || other.accessTokenExpiresAt == _this.accessTokenExpiresAt)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.refreshTokenExpiresAt, _this.refreshTokenExpiresAt) || other.refreshTokenExpiresAt == _this.refreshTokenExpiresAt)&&(identical(other.signingSecret, _this.signingSecret) || other.signingSecret == _this.signingSecret)&&(identical(other.profile, _this.profile) || other.profile == _this.profile));
}


@override
int get hashCode {
  final _this = this as DeviceSession;
  return Object.hash(runtimeType,_this.deviceId,_this.deviceCode,_this.tokenLetter,_this.gatewayPriority,_this.store,_this.accessToken,_this.accessTokenExpiresAt,_this.refreshToken,_this.refreshTokenExpiresAt,_this.signingSecret,_this.profile);
}

@override
String toString() {
  final _this = this as DeviceSession;
  return 'DeviceSession(deviceId: ${_this.deviceId}, deviceCode: ${_this.deviceCode}, tokenLetter: ${_this.tokenLetter}, gatewayPriority: ${_this.gatewayPriority}, store: ${_this.store}, accessToken: ${_this.accessToken}, accessTokenExpiresAt: ${_this.accessTokenExpiresAt}, refreshToken: ${_this.refreshToken}, refreshTokenExpiresAt: ${_this.refreshTokenExpiresAt}, signingSecret: ${_this.signingSecret}, profile: ${_this.profile})';
}


}

/// @nodoc
abstract mixin class $DeviceSessionCopyWith<$Res>  {
  factory $DeviceSessionCopyWith(DeviceSession value, $Res Function(DeviceSession) _then) = _$DeviceSessionCopyWithImpl;
@useResult
$Res call({
 String deviceId, String deviceCode, String tokenLetter, int gatewayPriority, StoreInfo store, String accessToken, DateTime accessTokenExpiresAt, String refreshToken, DateTime refreshTokenExpiresAt, String signingSecret, DeviceProfile profile
});


$StoreInfoCopyWith<$Res> get store;$DeviceProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$DeviceSessionCopyWithImpl<$Res>
    implements $DeviceSessionCopyWith<$Res> {
  _$DeviceSessionCopyWithImpl(this._self, this._then);

  final DeviceSession _self;
  final $Res Function(DeviceSession) _then;

/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? deviceCode = null,Object? tokenLetter = null,Object? gatewayPriority = null,Object? store = null,Object? accessToken = null,Object? accessTokenExpiresAt = null,Object? refreshToken = null,Object? refreshTokenExpiresAt = null,Object? signingSecret = null,Object? profile = null,}) {
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
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as DeviceProfile,
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
}/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceProfileCopyWith<$Res> get profile {
  
  return $DeviceProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String deviceCode,  String tokenLetter,  int gatewayPriority,  StoreInfo store,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt,  String signingSecret,  DeviceProfile profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceSession() when $default != null:
return $default(_that.deviceId,_that.deviceCode,_that.tokenLetter,_that.gatewayPriority,_that.store,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt,_that.signingSecret,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String deviceCode,  String tokenLetter,  int gatewayPriority,  StoreInfo store,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt,  String signingSecret,  DeviceProfile profile)  $default,) {final _that = this;
switch (_that) {
case _DeviceSession():
return $default(_that.deviceId,_that.deviceCode,_that.tokenLetter,_that.gatewayPriority,_that.store,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt,_that.signingSecret,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String deviceCode,  String tokenLetter,  int gatewayPriority,  StoreInfo store,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt,  String signingSecret,  DeviceProfile profile)?  $default,) {final _that = this;
switch (_that) {
case _DeviceSession() when $default != null:
return $default(_that.deviceId,_that.deviceCode,_that.tokenLetter,_that.gatewayPriority,_that.store,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt,_that.signingSecret,_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceSession extends DeviceSession {
  const _DeviceSession({required this.deviceId, required this.deviceCode, required this.tokenLetter, required this.gatewayPriority, required this.store, required this.accessToken, required this.accessTokenExpiresAt, required this.refreshToken, required this.refreshTokenExpiresAt, required this.signingSecret, this.profile = const DeviceProfile()}): super._();
  

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
@override@JsonKey() final  DeviceProfile profile;

/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceSessionCopyWith<_DeviceSession> get copyWith => __$DeviceSessionCopyWithImpl<_DeviceSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceSession&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceCode, deviceCode) || other.deviceCode == deviceCode)&&(identical(other.tokenLetter, tokenLetter) || other.tokenLetter == tokenLetter)&&(identical(other.gatewayPriority, gatewayPriority) || other.gatewayPriority == gatewayPriority)&&(identical(other.store, store) || other.store == store)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.accessTokenExpiresAt, accessTokenExpiresAt) || other.accessTokenExpiresAt == accessTokenExpiresAt)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.refreshTokenExpiresAt, refreshTokenExpiresAt) || other.refreshTokenExpiresAt == refreshTokenExpiresAt)&&(identical(other.signingSecret, signingSecret) || other.signingSecret == signingSecret)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,deviceCode,tokenLetter,gatewayPriority,store,accessToken,accessTokenExpiresAt,refreshToken,refreshTokenExpiresAt,signingSecret,profile);
}

@override
String toString() {
    return 'DeviceSession(deviceId: $deviceId, deviceCode: $deviceCode, tokenLetter: $tokenLetter, gatewayPriority: $gatewayPriority, store: $store, accessToken: $accessToken, accessTokenExpiresAt: $accessTokenExpiresAt, refreshToken: $refreshToken, refreshTokenExpiresAt: $refreshTokenExpiresAt, signingSecret: $signingSecret, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$DeviceSessionCopyWith<$Res> implements $DeviceSessionCopyWith<$Res> {
  factory _$DeviceSessionCopyWith(_DeviceSession value, $Res Function(_DeviceSession) _then) = __$DeviceSessionCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String deviceCode, String tokenLetter, int gatewayPriority, StoreInfo store, String accessToken, DateTime accessTokenExpiresAt, String refreshToken, DateTime refreshTokenExpiresAt, String signingSecret, DeviceProfile profile
});


@override $StoreInfoCopyWith<$Res> get store;@override $DeviceProfileCopyWith<$Res> get profile;

}
/// @nodoc
class __$DeviceSessionCopyWithImpl<$Res>
    implements _$DeviceSessionCopyWith<$Res> {
  __$DeviceSessionCopyWithImpl(this._self, this._then);

  final _DeviceSession _self;
  final $Res Function(_DeviceSession) _then;

/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? deviceCode = null,Object? tokenLetter = null,Object? gatewayPriority = null,Object? store = null,Object? accessToken = null,Object? accessTokenExpiresAt = null,Object? refreshToken = null,Object? refreshTokenExpiresAt = null,Object? signingSecret = null,Object? profile = null,}) {
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
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as DeviceProfile,
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
}/// Create a copy of DeviceSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceProfileCopyWith<$Res> get profile {
  
  return $DeviceProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

/// @nodoc
mixin _$DeviceStatus {

 String get deviceCode; String get status; String get storeStatus; bool get canSell; bool get isGateway; String? get businessDate; DateTime? get serverTime; DeviceActivation? get activation;
/// Create a copy of DeviceStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceStatusCopyWith<DeviceStatus> get copyWith => _$DeviceStatusCopyWithImpl<DeviceStatus>(this as DeviceStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceStatus&&(identical(other.deviceCode, _this.deviceCode) || other.deviceCode == _this.deviceCode)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.storeStatus, _this.storeStatus) || other.storeStatus == _this.storeStatus)&&(identical(other.canSell, _this.canSell) || other.canSell == _this.canSell)&&(identical(other.isGateway, _this.isGateway) || other.isGateway == _this.isGateway)&&(identical(other.businessDate, _this.businessDate) || other.businessDate == _this.businessDate)&&(identical(other.serverTime, _this.serverTime) || other.serverTime == _this.serverTime)&&(identical(other.activation, _this.activation) || other.activation == _this.activation));
}


@override
int get hashCode {
  final _this = this as DeviceStatus;
  return Object.hash(runtimeType,_this.deviceCode,_this.status,_this.storeStatus,_this.canSell,_this.isGateway,_this.businessDate,_this.serverTime,_this.activation);
}

@override
String toString() {
  final _this = this as DeviceStatus;
  return 'DeviceStatus(deviceCode: ${_this.deviceCode}, status: ${_this.status}, storeStatus: ${_this.storeStatus}, canSell: ${_this.canSell}, isGateway: ${_this.isGateway}, businessDate: ${_this.businessDate}, serverTime: ${_this.serverTime}, activation: ${_this.activation})';
}


}

/// @nodoc
abstract mixin class $DeviceStatusCopyWith<$Res>  {
  factory $DeviceStatusCopyWith(DeviceStatus value, $Res Function(DeviceStatus) _then) = _$DeviceStatusCopyWithImpl;
@useResult
$Res call({
 String deviceCode, String status, String storeStatus, bool canSell, bool isGateway, String? businessDate, DateTime? serverTime, DeviceActivation? activation
});


$DeviceActivationCopyWith<$Res>? get activation;

}
/// @nodoc
class _$DeviceStatusCopyWithImpl<$Res>
    implements $DeviceStatusCopyWith<$Res> {
  _$DeviceStatusCopyWithImpl(this._self, this._then);

  final DeviceStatus _self;
  final $Res Function(DeviceStatus) _then;

/// Create a copy of DeviceStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceCode = null,Object? status = null,Object? storeStatus = null,Object? canSell = null,Object? isGateway = null,Object? businessDate = freezed,Object? serverTime = freezed,Object? activation = freezed,}) {
  return _then(DeviceStatus(
deviceCode: null == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,storeStatus: null == storeStatus ? _self.storeStatus : storeStatus // ignore: cast_nullable_to_non_nullable
as String,canSell: null == canSell ? _self.canSell : canSell // ignore: cast_nullable_to_non_nullable
as bool,isGateway: null == isGateway ? _self.isGateway : isGateway // ignore: cast_nullable_to_non_nullable
as bool,businessDate: freezed == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String?,serverTime: freezed == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime?,activation: freezed == activation ? _self.activation : activation // ignore: cast_nullable_to_non_nullable
as DeviceActivation?,
  ));
}
/// Create a copy of DeviceStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceActivationCopyWith<$Res>? get activation {
    if (_self.activation == null) {
    return null;
  }

  return $DeviceActivationCopyWith<$Res>(_self.activation!, (value) {
    return _then(_self.copyWith(activation: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceCode,  String status,  String storeStatus,  bool canSell,  bool isGateway,  String? businessDate,  DateTime? serverTime,  DeviceActivation? activation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceStatus() when $default != null:
return $default(_that.deviceCode,_that.status,_that.storeStatus,_that.canSell,_that.isGateway,_that.businessDate,_that.serverTime,_that.activation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceCode,  String status,  String storeStatus,  bool canSell,  bool isGateway,  String? businessDate,  DateTime? serverTime,  DeviceActivation? activation)  $default,) {final _that = this;
switch (_that) {
case _DeviceStatus():
return $default(_that.deviceCode,_that.status,_that.storeStatus,_that.canSell,_that.isGateway,_that.businessDate,_that.serverTime,_that.activation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceCode,  String status,  String storeStatus,  bool canSell,  bool isGateway,  String? businessDate,  DateTime? serverTime,  DeviceActivation? activation)?  $default,) {final _that = this;
switch (_that) {
case _DeviceStatus() when $default != null:
return $default(_that.deviceCode,_that.status,_that.storeStatus,_that.canSell,_that.isGateway,_that.businessDate,_that.serverTime,_that.activation);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceStatus implements DeviceStatus {
  const _DeviceStatus({required this.deviceCode, required this.status, required this.storeStatus, required this.canSell, required this.isGateway, this.businessDate, this.serverTime, this.activation});
  

@override final  String deviceCode;
@override final  String status;
@override final  String storeStatus;
@override final  bool canSell;
@override final  bool isGateway;
@override final  String? businessDate;
@override final  DateTime? serverTime;
@override final  DeviceActivation? activation;

/// Create a copy of DeviceStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceStatusCopyWith<_DeviceStatus> get copyWith => __$DeviceStatusCopyWithImpl<_DeviceStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceStatus&&(identical(other.deviceCode, deviceCode) || other.deviceCode == deviceCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.storeStatus, storeStatus) || other.storeStatus == storeStatus)&&(identical(other.canSell, canSell) || other.canSell == canSell)&&(identical(other.isGateway, isGateway) || other.isGateway == isGateway)&&(identical(other.businessDate, businessDate) || other.businessDate == businessDate)&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime)&&(identical(other.activation, activation) || other.activation == activation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceCode,status,storeStatus,canSell,isGateway,businessDate,serverTime,activation);
}

@override
String toString() {
    return 'DeviceStatus(deviceCode: $deviceCode, status: $status, storeStatus: $storeStatus, canSell: $canSell, isGateway: $isGateway, businessDate: $businessDate, serverTime: $serverTime, activation: $activation)';
}


}

/// @nodoc
abstract mixin class _$DeviceStatusCopyWith<$Res> implements $DeviceStatusCopyWith<$Res> {
  factory _$DeviceStatusCopyWith(_DeviceStatus value, $Res Function(_DeviceStatus) _then) = __$DeviceStatusCopyWithImpl;
@override @useResult
$Res call({
 String deviceCode, String status, String storeStatus, bool canSell, bool isGateway, String? businessDate, DateTime? serverTime, DeviceActivation? activation
});


@override $DeviceActivationCopyWith<$Res>? get activation;

}
/// @nodoc
class __$DeviceStatusCopyWithImpl<$Res>
    implements _$DeviceStatusCopyWith<$Res> {
  __$DeviceStatusCopyWithImpl(this._self, this._then);

  final _DeviceStatus _self;
  final $Res Function(_DeviceStatus) _then;

/// Create a copy of DeviceStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceCode = null,Object? status = null,Object? storeStatus = null,Object? canSell = null,Object? isGateway = null,Object? businessDate = freezed,Object? serverTime = freezed,Object? activation = freezed,}) {
  return _then(_DeviceStatus(
deviceCode: null == deviceCode ? _self.deviceCode : deviceCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,storeStatus: null == storeStatus ? _self.storeStatus : storeStatus // ignore: cast_nullable_to_non_nullable
as String,canSell: null == canSell ? _self.canSell : canSell // ignore: cast_nullable_to_non_nullable
as bool,isGateway: null == isGateway ? _self.isGateway : isGateway // ignore: cast_nullable_to_non_nullable
as bool,businessDate: freezed == businessDate ? _self.businessDate : businessDate // ignore: cast_nullable_to_non_nullable
as String?,serverTime: freezed == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime?,activation: freezed == activation ? _self.activation : activation // ignore: cast_nullable_to_non_nullable
as DeviceActivation?,
  ));
}

/// Create a copy of DeviceStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceActivationCopyWith<$Res>? get activation {
    if (_self.activation == null) {
    return null;
  }

  return $DeviceActivationCopyWith<$Res>(_self.activation!, (value) {
    return _then(_self.copyWith(activation: value));
  });
}
}

// dart format on
