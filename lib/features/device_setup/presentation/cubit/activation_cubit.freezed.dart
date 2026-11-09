// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivationState {

/// The stored activation has been read (until then the terminal counts as not activated).
 bool get loaded; ActivationSnapshot? get snapshot; ActivationVerdict get verdict; bool get refreshing; bool get activating;/// Why the last code was refused (shown under the code field).
 String? get activationError;/// Why the last status refresh failed (offline ...); the stored state still applies.
 String? get refreshError;
/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivationStateCopyWith<ActivationState> get copyWith => _$ActivationStateCopyWithImpl<ActivationState>(this as ActivationState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ActivationState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivationState&&(identical(other.loaded, _this.loaded) || other.loaded == _this.loaded)&&(identical(other.snapshot, _this.snapshot) || other.snapshot == _this.snapshot)&&(identical(other.verdict, _this.verdict) || other.verdict == _this.verdict)&&(identical(other.refreshing, _this.refreshing) || other.refreshing == _this.refreshing)&&(identical(other.activating, _this.activating) || other.activating == _this.activating)&&(identical(other.activationError, _this.activationError) || other.activationError == _this.activationError)&&(identical(other.refreshError, _this.refreshError) || other.refreshError == _this.refreshError));
}


@override
int get hashCode {
  final _this = this as ActivationState;
  return Object.hash(runtimeType,_this.loaded,_this.snapshot,_this.verdict,_this.refreshing,_this.activating,_this.activationError,_this.refreshError);
}

@override
String toString() {
  final _this = this as ActivationState;
  return 'ActivationState(loaded: ${_this.loaded}, snapshot: ${_this.snapshot}, verdict: ${_this.verdict}, refreshing: ${_this.refreshing}, activating: ${_this.activating}, activationError: ${_this.activationError}, refreshError: ${_this.refreshError})';
}


}

/// @nodoc
abstract mixin class $ActivationStateCopyWith<$Res>  {
  factory $ActivationStateCopyWith(ActivationState value, $Res Function(ActivationState) _then) = _$ActivationStateCopyWithImpl;
@useResult
$Res call({
 bool loaded, ActivationSnapshot? snapshot, ActivationVerdict verdict, bool refreshing, bool activating, String? activationError, String? refreshError
});


$ActivationSnapshotCopyWith<$Res>? get snapshot;$ActivationVerdictCopyWith<$Res> get verdict;

}
/// @nodoc
class _$ActivationStateCopyWithImpl<$Res>
    implements $ActivationStateCopyWith<$Res> {
  _$ActivationStateCopyWithImpl(this._self, this._then);

  final ActivationState _self;
  final $Res Function(ActivationState) _then;

/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loaded = null,Object? snapshot = freezed,Object? verdict = null,Object? refreshing = null,Object? activating = null,Object? activationError = freezed,Object? refreshError = freezed,}) {
  return _then(ActivationState(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as ActivationSnapshot?,verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as ActivationVerdict,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,activating: null == activating ? _self.activating : activating // ignore: cast_nullable_to_non_nullable
as bool,activationError: freezed == activationError ? _self.activationError : activationError // ignore: cast_nullable_to_non_nullable
as String?,refreshError: freezed == refreshError ? _self.refreshError : refreshError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationSnapshotCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
    return null;
  }

  return $ActivationSnapshotCopyWith<$Res>(_self.snapshot!, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationVerdictCopyWith<$Res> get verdict {
  
  return $ActivationVerdictCopyWith<$Res>(_self.verdict, (value) {
    return _then(_self.copyWith(verdict: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivationState].
extension ActivationStatePatterns on ActivationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivationState value)  $default,){
final _that = this;
switch (_that) {
case _ActivationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivationState value)?  $default,){
final _that = this;
switch (_that) {
case _ActivationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loaded,  ActivationSnapshot? snapshot,  ActivationVerdict verdict,  bool refreshing,  bool activating,  String? activationError,  String? refreshError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivationState() when $default != null:
return $default(_that.loaded,_that.snapshot,_that.verdict,_that.refreshing,_that.activating,_that.activationError,_that.refreshError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loaded,  ActivationSnapshot? snapshot,  ActivationVerdict verdict,  bool refreshing,  bool activating,  String? activationError,  String? refreshError)  $default,) {final _that = this;
switch (_that) {
case _ActivationState():
return $default(_that.loaded,_that.snapshot,_that.verdict,_that.refreshing,_that.activating,_that.activationError,_that.refreshError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loaded,  ActivationSnapshot? snapshot,  ActivationVerdict verdict,  bool refreshing,  bool activating,  String? activationError,  String? refreshError)?  $default,) {final _that = this;
switch (_that) {
case _ActivationState() when $default != null:
return $default(_that.loaded,_that.snapshot,_that.verdict,_that.refreshing,_that.activating,_that.activationError,_that.refreshError);case _:
  return null;

}
}

}

/// @nodoc


class _ActivationState extends ActivationState {
  const _ActivationState({this.loaded = false, this.snapshot, this.verdict = ActivationVerdict.unknown, this.refreshing = false, this.activating = false, this.activationError, this.refreshError}): super._();
  

/// The stored activation has been read (until then the terminal counts as not activated).
@override@JsonKey() final  bool loaded;
@override final  ActivationSnapshot? snapshot;
@override@JsonKey() final  ActivationVerdict verdict;
@override@JsonKey() final  bool refreshing;
@override@JsonKey() final  bool activating;
/// Why the last code was refused (shown under the code field).
@override final  String? activationError;
/// Why the last status refresh failed (offline ...); the stored state still applies.
@override final  String? refreshError;

/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivationStateCopyWith<_ActivationState> get copyWith => __$ActivationStateCopyWithImpl<_ActivationState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivationState&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing)&&(identical(other.activating, activating) || other.activating == activating)&&(identical(other.activationError, activationError) || other.activationError == activationError)&&(identical(other.refreshError, refreshError) || other.refreshError == refreshError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loaded,snapshot,verdict,refreshing,activating,activationError,refreshError);
}

@override
String toString() {
    return 'ActivationState(loaded: $loaded, snapshot: $snapshot, verdict: $verdict, refreshing: $refreshing, activating: $activating, activationError: $activationError, refreshError: $refreshError)';
}


}

/// @nodoc
abstract mixin class _$ActivationStateCopyWith<$Res> implements $ActivationStateCopyWith<$Res> {
  factory _$ActivationStateCopyWith(_ActivationState value, $Res Function(_ActivationState) _then) = __$ActivationStateCopyWithImpl;
@override @useResult
$Res call({
 bool loaded, ActivationSnapshot? snapshot, ActivationVerdict verdict, bool refreshing, bool activating, String? activationError, String? refreshError
});


@override $ActivationSnapshotCopyWith<$Res>? get snapshot;@override $ActivationVerdictCopyWith<$Res> get verdict;

}
/// @nodoc
class __$ActivationStateCopyWithImpl<$Res>
    implements _$ActivationStateCopyWith<$Res> {
  __$ActivationStateCopyWithImpl(this._self, this._then);

  final _ActivationState _self;
  final $Res Function(_ActivationState) _then;

/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loaded = null,Object? snapshot = freezed,Object? verdict = null,Object? refreshing = null,Object? activating = null,Object? activationError = freezed,Object? refreshError = freezed,}) {
  return _then(_ActivationState(
loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as ActivationSnapshot?,verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as ActivationVerdict,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,activating: null == activating ? _self.activating : activating // ignore: cast_nullable_to_non_nullable
as bool,activationError: freezed == activationError ? _self.activationError : activationError // ignore: cast_nullable_to_non_nullable
as String?,refreshError: freezed == refreshError ? _self.refreshError : refreshError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationSnapshotCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
    return null;
  }

  return $ActivationSnapshotCopyWith<$Res>(_self.snapshot!, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}/// Create a copy of ActivationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivationVerdictCopyWith<$Res> get verdict {
  
  return $ActivationVerdictCopyWith<$Res>(_self.verdict, (value) {
    return _then(_self.copyWith(verdict: value));
  });
}
}

// dart format on
