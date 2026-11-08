// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_login_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinLoginState {

 List<StaffUser> get users; StaffUser? get selected; String get pin; bool get checking; bool get loggedIn; String? get error;
/// Create a copy of PinLoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinLoginStateCopyWith<PinLoginState> get copyWith => _$PinLoginStateCopyWithImpl<PinLoginState>(this as PinLoginState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PinLoginState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinLoginState&&const DeepCollectionEquality().equals(other.users, _this.users)&&(identical(other.selected, _this.selected) || other.selected == _this.selected)&&(identical(other.pin, _this.pin) || other.pin == _this.pin)&&(identical(other.checking, _this.checking) || other.checking == _this.checking)&&(identical(other.loggedIn, _this.loggedIn) || other.loggedIn == _this.loggedIn)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as PinLoginState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.users),_this.selected,_this.pin,_this.checking,_this.loggedIn,_this.error);
}

@override
String toString() {
  final _this = this as PinLoginState;
  return 'PinLoginState(users: ${_this.users}, selected: ${_this.selected}, pin: ${_this.pin}, checking: ${_this.checking}, loggedIn: ${_this.loggedIn}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $PinLoginStateCopyWith<$Res>  {
  factory $PinLoginStateCopyWith(PinLoginState value, $Res Function(PinLoginState) _then) = _$PinLoginStateCopyWithImpl;
@useResult
$Res call({
 List<StaffUser> users, StaffUser? selected, String pin, bool checking, bool loggedIn, String? error
});




}
/// @nodoc
class _$PinLoginStateCopyWithImpl<$Res>
    implements $PinLoginStateCopyWith<$Res> {
  _$PinLoginStateCopyWithImpl(this._self, this._then);

  final PinLoginState _self;
  final $Res Function(PinLoginState) _then;

/// Create a copy of PinLoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? selected = freezed,Object? pin = null,Object? checking = null,Object? loggedIn = null,Object? error = freezed,}) {
  return _then(PinLoginState(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<StaffUser>,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as StaffUser?,pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,checking: null == checking ? _self.checking : checking // ignore: cast_nullable_to_non_nullable
as bool,loggedIn: null == loggedIn ? _self.loggedIn : loggedIn // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PinLoginState].
extension PinLoginStatePatterns on PinLoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinLoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinLoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinLoginState value)  $default,){
final _that = this;
switch (_that) {
case _PinLoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinLoginState value)?  $default,){
final _that = this;
switch (_that) {
case _PinLoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StaffUser> users,  StaffUser? selected,  String pin,  bool checking,  bool loggedIn,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PinLoginState() when $default != null:
return $default(_that.users,_that.selected,_that.pin,_that.checking,_that.loggedIn,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StaffUser> users,  StaffUser? selected,  String pin,  bool checking,  bool loggedIn,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PinLoginState():
return $default(_that.users,_that.selected,_that.pin,_that.checking,_that.loggedIn,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StaffUser> users,  StaffUser? selected,  String pin,  bool checking,  bool loggedIn,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PinLoginState() when $default != null:
return $default(_that.users,_that.selected,_that.pin,_that.checking,_that.loggedIn,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PinLoginState implements PinLoginState {
  const _PinLoginState({ List<StaffUser> users = const <StaffUser>[], this.selected, this.pin = '', this.checking = false, this.loggedIn = false, this.error}): _users = users;
  

 final  List<StaffUser> _users;
@override@JsonKey() List<StaffUser> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

@override final  StaffUser? selected;
@override@JsonKey() final  String pin;
@override@JsonKey() final  bool checking;
@override@JsonKey() final  bool loggedIn;
@override final  String? error;

/// Create a copy of PinLoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinLoginStateCopyWith<_PinLoginState> get copyWith => __$PinLoginStateCopyWithImpl<_PinLoginState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinLoginState&&const DeepCollectionEquality().equals(other.users, _users)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.pin, pin) || other.pin == pin)&&(identical(other.checking, checking) || other.checking == checking)&&(identical(other.loggedIn, loggedIn) || other.loggedIn == loggedIn)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),selected,pin,checking,loggedIn,error);
}

@override
String toString() {
    return 'PinLoginState(users: $users, selected: $selected, pin: $pin, checking: $checking, loggedIn: $loggedIn, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PinLoginStateCopyWith<$Res> implements $PinLoginStateCopyWith<$Res> {
  factory _$PinLoginStateCopyWith(_PinLoginState value, $Res Function(_PinLoginState) _then) = __$PinLoginStateCopyWithImpl;
@override @useResult
$Res call({
 List<StaffUser> users, StaffUser? selected, String pin, bool checking, bool loggedIn, String? error
});




}
/// @nodoc
class __$PinLoginStateCopyWithImpl<$Res>
    implements _$PinLoginStateCopyWith<$Res> {
  __$PinLoginStateCopyWithImpl(this._self, this._then);

  final _PinLoginState _self;
  final $Res Function(_PinLoginState) _then;

/// Create a copy of PinLoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? selected = freezed,Object? pin = null,Object? checking = null,Object? loggedIn = null,Object? error = freezed,}) {
  return _then(_PinLoginState(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<StaffUser>,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as StaffUser?,pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,checking: null == checking ? _self.checking : checking // ignore: cast_nullable_to_non_nullable
as bool,loggedIn: null == loggedIn ? _self.loggedIn : loggedIn // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
