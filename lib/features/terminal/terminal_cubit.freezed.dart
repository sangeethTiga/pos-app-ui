// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terminal_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TerminalState {

 bool get started; bool get syncing; SyncReport? get lastReport; int get pending; DateTime? get lastSyncAt;
/// Create a copy of TerminalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TerminalStateCopyWith<TerminalState> get copyWith => _$TerminalStateCopyWithImpl<TerminalState>(this as TerminalState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TerminalState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TerminalState&&(identical(other.started, _this.started) || other.started == _this.started)&&(identical(other.syncing, _this.syncing) || other.syncing == _this.syncing)&&(identical(other.lastReport, _this.lastReport) || other.lastReport == _this.lastReport)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.lastSyncAt, _this.lastSyncAt) || other.lastSyncAt == _this.lastSyncAt));
}


@override
int get hashCode {
  final _this = this as TerminalState;
  return Object.hash(runtimeType,_this.started,_this.syncing,_this.lastReport,_this.pending,_this.lastSyncAt);
}

@override
String toString() {
  final _this = this as TerminalState;
  return 'TerminalState(started: ${_this.started}, syncing: ${_this.syncing}, lastReport: ${_this.lastReport}, pending: ${_this.pending}, lastSyncAt: ${_this.lastSyncAt})';
}


}

/// @nodoc
abstract mixin class $TerminalStateCopyWith<$Res>  {
  factory $TerminalStateCopyWith(TerminalState value, $Res Function(TerminalState) _then) = _$TerminalStateCopyWithImpl;
@useResult
$Res call({
 bool started, bool syncing, SyncReport? lastReport, int pending, DateTime? lastSyncAt
});




}
/// @nodoc
class _$TerminalStateCopyWithImpl<$Res>
    implements $TerminalStateCopyWith<$Res> {
  _$TerminalStateCopyWithImpl(this._self, this._then);

  final TerminalState _self;
  final $Res Function(TerminalState) _then;

/// Create a copy of TerminalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? started = null,Object? syncing = null,Object? lastReport = freezed,Object? pending = null,Object? lastSyncAt = freezed,}) {
  return _then(TerminalState(
started: null == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as bool,syncing: null == syncing ? _self.syncing : syncing // ignore: cast_nullable_to_non_nullable
as bool,lastReport: freezed == lastReport ? _self.lastReport : lastReport // ignore: cast_nullable_to_non_nullable
as SyncReport?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,lastSyncAt: freezed == lastSyncAt ? _self.lastSyncAt : lastSyncAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TerminalState].
extension TerminalStatePatterns on TerminalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TerminalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TerminalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TerminalState value)  $default,){
final _that = this;
switch (_that) {
case _TerminalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TerminalState value)?  $default,){
final _that = this;
switch (_that) {
case _TerminalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool started,  bool syncing,  SyncReport? lastReport,  int pending,  DateTime? lastSyncAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TerminalState() when $default != null:
return $default(_that.started,_that.syncing,_that.lastReport,_that.pending,_that.lastSyncAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool started,  bool syncing,  SyncReport? lastReport,  int pending,  DateTime? lastSyncAt)  $default,) {final _that = this;
switch (_that) {
case _TerminalState():
return $default(_that.started,_that.syncing,_that.lastReport,_that.pending,_that.lastSyncAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool started,  bool syncing,  SyncReport? lastReport,  int pending,  DateTime? lastSyncAt)?  $default,) {final _that = this;
switch (_that) {
case _TerminalState() when $default != null:
return $default(_that.started,_that.syncing,_that.lastReport,_that.pending,_that.lastSyncAt);case _:
  return null;

}
}

}

/// @nodoc


class _TerminalState implements TerminalState {
  const _TerminalState({this.started = false, this.syncing = false, this.lastReport, this.pending = 0, this.lastSyncAt});
  

@override@JsonKey() final  bool started;
@override@JsonKey() final  bool syncing;
@override final  SyncReport? lastReport;
@override@JsonKey() final  int pending;
@override final  DateTime? lastSyncAt;

/// Create a copy of TerminalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TerminalStateCopyWith<_TerminalState> get copyWith => __$TerminalStateCopyWithImpl<_TerminalState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TerminalState&&(identical(other.started, started) || other.started == started)&&(identical(other.syncing, syncing) || other.syncing == syncing)&&(identical(other.lastReport, lastReport) || other.lastReport == lastReport)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.lastSyncAt, lastSyncAt) || other.lastSyncAt == lastSyncAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,started,syncing,lastReport,pending,lastSyncAt);
}

@override
String toString() {
    return 'TerminalState(started: $started, syncing: $syncing, lastReport: $lastReport, pending: $pending, lastSyncAt: $lastSyncAt)';
}


}

/// @nodoc
abstract mixin class _$TerminalStateCopyWith<$Res> implements $TerminalStateCopyWith<$Res> {
  factory _$TerminalStateCopyWith(_TerminalState value, $Res Function(_TerminalState) _then) = __$TerminalStateCopyWithImpl;
@override @useResult
$Res call({
 bool started, bool syncing, SyncReport? lastReport, int pending, DateTime? lastSyncAt
});




}
/// @nodoc
class __$TerminalStateCopyWithImpl<$Res>
    implements _$TerminalStateCopyWith<$Res> {
  __$TerminalStateCopyWithImpl(this._self, this._then);

  final _TerminalState _self;
  final $Res Function(_TerminalState) _then;

/// Create a copy of TerminalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? started = null,Object? syncing = null,Object? lastReport = freezed,Object? pending = null,Object? lastSyncAt = freezed,}) {
  return _then(_TerminalState(
started: null == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as bool,syncing: null == syncing ? _self.syncing : syncing // ignore: cast_nullable_to_non_nullable
as bool,lastReport: freezed == lastReport ? _self.lastReport : lastReport // ignore: cast_nullable_to_non_nullable
as SyncReport?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,lastSyncAt: freezed == lastSyncAt ? _self.lastSyncAt : lastSyncAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
