// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {

 List<StaffUser> get users;/// Synced staff who may not log in on this device type (managers, owners, the other role).
 int get otherStaff; StaffUser? get selected; List<String> get shiftNames; String? get shiftName;/// CASHIER or CAPTAIN: captains have no cash drawer, so no shift or drawer balance.
 String get deviceType;/// A shift is already open on this terminal: no shift / drawer fields.
 String? get openShiftName; bool get shiftAlreadyOpen; bool get loaded; bool get checking; bool get loggedIn; String? get error;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoginState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&const DeepCollectionEquality().equals(other.users, _this.users)&&(identical(other.otherStaff, _this.otherStaff) || other.otherStaff == _this.otherStaff)&&(identical(other.selected, _this.selected) || other.selected == _this.selected)&&const DeepCollectionEquality().equals(other.shiftNames, _this.shiftNames)&&(identical(other.shiftName, _this.shiftName) || other.shiftName == _this.shiftName)&&(identical(other.deviceType, _this.deviceType) || other.deviceType == _this.deviceType)&&(identical(other.openShiftName, _this.openShiftName) || other.openShiftName == _this.openShiftName)&&(identical(other.shiftAlreadyOpen, _this.shiftAlreadyOpen) || other.shiftAlreadyOpen == _this.shiftAlreadyOpen)&&(identical(other.loaded, _this.loaded) || other.loaded == _this.loaded)&&(identical(other.checking, _this.checking) || other.checking == _this.checking)&&(identical(other.loggedIn, _this.loggedIn) || other.loggedIn == _this.loggedIn)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as LoginState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.users),_this.otherStaff,_this.selected,const DeepCollectionEquality().hash(_this.shiftNames),_this.shiftName,_this.deviceType,_this.openShiftName,_this.shiftAlreadyOpen,_this.loaded,_this.checking,_this.loggedIn,_this.error);
}

@override
String toString() {
  final _this = this as LoginState;
  return 'LoginState(users: ${_this.users}, otherStaff: ${_this.otherStaff}, selected: ${_this.selected}, shiftNames: ${_this.shiftNames}, shiftName: ${_this.shiftName}, deviceType: ${_this.deviceType}, openShiftName: ${_this.openShiftName}, shiftAlreadyOpen: ${_this.shiftAlreadyOpen}, loaded: ${_this.loaded}, checking: ${_this.checking}, loggedIn: ${_this.loggedIn}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 List<StaffUser> users, int otherStaff, StaffUser? selected, List<String> shiftNames, String? shiftName, String deviceType, String? openShiftName, bool shiftAlreadyOpen, bool loaded, bool checking, bool loggedIn, String? error
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? otherStaff = null,Object? selected = freezed,Object? shiftNames = null,Object? shiftName = freezed,Object? deviceType = null,Object? openShiftName = freezed,Object? shiftAlreadyOpen = null,Object? loaded = null,Object? checking = null,Object? loggedIn = null,Object? error = freezed,}) {
  return _then(LoginState(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<StaffUser>,otherStaff: null == otherStaff ? _self.otherStaff : otherStaff // ignore: cast_nullable_to_non_nullable
as int,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as StaffUser?,shiftNames: null == shiftNames ? _self.shiftNames : shiftNames // ignore: cast_nullable_to_non_nullable
as List<String>,shiftName: freezed == shiftName ? _self.shiftName : shiftName // ignore: cast_nullable_to_non_nullable
as String?,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String,openShiftName: freezed == openShiftName ? _self.openShiftName : openShiftName // ignore: cast_nullable_to_non_nullable
as String?,shiftAlreadyOpen: null == shiftAlreadyOpen ? _self.shiftAlreadyOpen : shiftAlreadyOpen // ignore: cast_nullable_to_non_nullable
as bool,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,checking: null == checking ? _self.checking : checking // ignore: cast_nullable_to_non_nullable
as bool,loggedIn: null == loggedIn ? _self.loggedIn : loggedIn // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StaffUser> users,  int otherStaff,  StaffUser? selected,  List<String> shiftNames,  String? shiftName,  String deviceType,  String? openShiftName,  bool shiftAlreadyOpen,  bool loaded,  bool checking,  bool loggedIn,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.users,_that.otherStaff,_that.selected,_that.shiftNames,_that.shiftName,_that.deviceType,_that.openShiftName,_that.shiftAlreadyOpen,_that.loaded,_that.checking,_that.loggedIn,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StaffUser> users,  int otherStaff,  StaffUser? selected,  List<String> shiftNames,  String? shiftName,  String deviceType,  String? openShiftName,  bool shiftAlreadyOpen,  bool loaded,  bool checking,  bool loggedIn,  String? error)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.users,_that.otherStaff,_that.selected,_that.shiftNames,_that.shiftName,_that.deviceType,_that.openShiftName,_that.shiftAlreadyOpen,_that.loaded,_that.checking,_that.loggedIn,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StaffUser> users,  int otherStaff,  StaffUser? selected,  List<String> shiftNames,  String? shiftName,  String deviceType,  String? openShiftName,  bool shiftAlreadyOpen,  bool loaded,  bool checking,  bool loggedIn,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.users,_that.otherStaff,_that.selected,_that.shiftNames,_that.shiftName,_that.deviceType,_that.openShiftName,_that.shiftAlreadyOpen,_that.loaded,_that.checking,_that.loggedIn,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState extends LoginState {
  const _LoginState({ List<StaffUser> users = const <StaffUser>[], this.otherStaff = 0, this.selected,  List<String> shiftNames = const <String>[], this.shiftName, this.deviceType = 'CASHIER', this.openShiftName, this.shiftAlreadyOpen = false, this.loaded = false, this.checking = false, this.loggedIn = false, this.error}): _users = users,_shiftNames = shiftNames,super._();
  

 final  List<StaffUser> _users;
@override@JsonKey() List<StaffUser> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

/// Synced staff who may not log in on this device type (managers, owners, the other role).
@override@JsonKey() final  int otherStaff;
@override final  StaffUser? selected;
 final  List<String> _shiftNames;
@override@JsonKey() List<String> get shiftNames {
  if (_shiftNames is EqualUnmodifiableListView) return _shiftNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shiftNames);
}

@override final  String? shiftName;
/// CASHIER or CAPTAIN: captains have no cash drawer, so no shift or drawer balance.
@override@JsonKey() final  String deviceType;
/// A shift is already open on this terminal: no shift / drawer fields.
@override final  String? openShiftName;
@override@JsonKey() final  bool shiftAlreadyOpen;
@override@JsonKey() final  bool loaded;
@override@JsonKey() final  bool checking;
@override@JsonKey() final  bool loggedIn;
@override final  String? error;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&const DeepCollectionEquality().equals(other.users, _users)&&(identical(other.otherStaff, otherStaff) || other.otherStaff == otherStaff)&&(identical(other.selected, selected) || other.selected == selected)&&const DeepCollectionEquality().equals(other.shiftNames, _shiftNames)&&(identical(other.shiftName, shiftName) || other.shiftName == shiftName)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.openShiftName, openShiftName) || other.openShiftName == openShiftName)&&(identical(other.shiftAlreadyOpen, shiftAlreadyOpen) || other.shiftAlreadyOpen == shiftAlreadyOpen)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.checking, checking) || other.checking == checking)&&(identical(other.loggedIn, loggedIn) || other.loggedIn == loggedIn)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),otherStaff,selected,const DeepCollectionEquality().hash(_shiftNames),shiftName,deviceType,openShiftName,shiftAlreadyOpen,loaded,checking,loggedIn,error);
}

@override
String toString() {
    return 'LoginState(users: $users, otherStaff: $otherStaff, selected: $selected, shiftNames: $shiftNames, shiftName: $shiftName, deviceType: $deviceType, openShiftName: $openShiftName, shiftAlreadyOpen: $shiftAlreadyOpen, loaded: $loaded, checking: $checking, loggedIn: $loggedIn, error: $error)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 List<StaffUser> users, int otherStaff, StaffUser? selected, List<String> shiftNames, String? shiftName, String deviceType, String? openShiftName, bool shiftAlreadyOpen, bool loaded, bool checking, bool loggedIn, String? error
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? otherStaff = null,Object? selected = freezed,Object? shiftNames = null,Object? shiftName = freezed,Object? deviceType = null,Object? openShiftName = freezed,Object? shiftAlreadyOpen = null,Object? loaded = null,Object? checking = null,Object? loggedIn = null,Object? error = freezed,}) {
  return _then(_LoginState(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<StaffUser>,otherStaff: null == otherStaff ? _self.otherStaff : otherStaff // ignore: cast_nullable_to_non_nullable
as int,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as StaffUser?,shiftNames: null == shiftNames ? _self._shiftNames : shiftNames // ignore: cast_nullable_to_non_nullable
as List<String>,shiftName: freezed == shiftName ? _self.shiftName : shiftName // ignore: cast_nullable_to_non_nullable
as String?,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String,openShiftName: freezed == openShiftName ? _self.openShiftName : openShiftName // ignore: cast_nullable_to_non_nullable
as String?,shiftAlreadyOpen: null == shiftAlreadyOpen ? _self.shiftAlreadyOpen : shiftAlreadyOpen // ignore: cast_nullable_to_non_nullable
as bool,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,checking: null == checking ? _self.checking : checking // ignore: cast_nullable_to_non_nullable
as bool,loggedIn: null == loggedIn ? _self.loggedIn : loggedIn // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
