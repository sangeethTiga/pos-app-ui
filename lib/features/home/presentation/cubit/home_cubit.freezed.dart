// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HomeState()';
}


}

/// @nodoc
class $HomeStateCopyWith<$Res>  {
$HomeStateCopyWith(HomeState _, $Res Function(HomeState) __);
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HomeLoading value)?  loading,TResult Function( HomeReady value)?  ready,TResult Function( HomeUnpaired value)?  unpaired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading(_that);case HomeReady() when ready != null:
return ready(_that);case HomeUnpaired() when unpaired != null:
return unpaired(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HomeLoading value)  loading,required TResult Function( HomeReady value)  ready,required TResult Function( HomeUnpaired value)  unpaired,}){
final _that = this;
switch (_that) {
case HomeLoading():
return loading(_that);case HomeReady():
return ready(_that);case HomeUnpaired():
return unpaired(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HomeLoading value)?  loading,TResult? Function( HomeReady value)?  ready,TResult? Function( HomeUnpaired value)?  unpaired,}){
final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading(_that);case HomeReady() when ready != null:
return ready(_that);case HomeUnpaired() when unpaired != null:
return unpaired(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( DeviceSession session,  DeviceStatus? status,  Failure? failure,  bool checking)?  ready,TResult Function()?  unpaired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading();case HomeReady() when ready != null:
return ready(_that.session,_that.status,_that.failure,_that.checking);case HomeUnpaired() when unpaired != null:
return unpaired();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( DeviceSession session,  DeviceStatus? status,  Failure? failure,  bool checking)  ready,required TResult Function()  unpaired,}) {final _that = this;
switch (_that) {
case HomeLoading():
return loading();case HomeReady():
return ready(_that.session,_that.status,_that.failure,_that.checking);case HomeUnpaired():
return unpaired();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( DeviceSession session,  DeviceStatus? status,  Failure? failure,  bool checking)?  ready,TResult? Function()?  unpaired,}) {final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading();case HomeReady() when ready != null:
return ready(_that.session,_that.status,_that.failure,_that.checking);case HomeUnpaired() when unpaired != null:
return unpaired();case _:
  return null;

}
}

}

/// @nodoc


class HomeLoading implements HomeState {
  const HomeLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HomeState.loading()';
}


}




/// @nodoc


class HomeReady implements HomeState {
  const HomeReady({required this.session, this.status, this.failure, this.checking = false});
  

 final  DeviceSession session;
 final  DeviceStatus? status;
 final  Failure? failure;
@JsonKey() final  bool checking;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeReadyCopyWith<HomeReady> get copyWith => _$HomeReadyCopyWithImpl<HomeReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeReady&&(identical(other.session, session) || other.session == session)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.checking, checking) || other.checking == checking));
}


@override
int get hashCode {
    return Object.hash(runtimeType,session,status,failure,checking);
}

@override
String toString() {
    return 'HomeState.ready(session: $session, status: $status, failure: $failure, checking: $checking)';
}


}

/// @nodoc
abstract mixin class $HomeReadyCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $HomeReadyCopyWith(HomeReady value, $Res Function(HomeReady) _then) = _$HomeReadyCopyWithImpl;
@useResult
$Res call({
 DeviceSession session, DeviceStatus? status, Failure? failure, bool checking
});


$DeviceSessionCopyWith<$Res> get session;$DeviceStatusCopyWith<$Res>? get status;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$HomeReadyCopyWithImpl<$Res>
    implements $HomeReadyCopyWith<$Res> {
  _$HomeReadyCopyWithImpl(this._self, this._then);

  final HomeReady _self;
  final $Res Function(HomeReady) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,Object? status = freezed,Object? failure = freezed,Object? checking = null,}) {
  return _then(HomeReady(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as DeviceSession,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeviceStatus?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,checking: null == checking ? _self.checking : checking // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceSessionCopyWith<$Res> get session {
  
  return $DeviceSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceStatusCopyWith<$Res>? get status {
    if (_self.status == null) {
    return null;
  }

  return $DeviceStatusCopyWith<$Res>(_self.status!, (value) {
    return _then(_self.copyWith(status: value));
  });
}/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

/// @nodoc


class HomeUnpaired implements HomeState {
  const HomeUnpaired();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeUnpaired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HomeState.unpaired()';
}


}




// dart format on
