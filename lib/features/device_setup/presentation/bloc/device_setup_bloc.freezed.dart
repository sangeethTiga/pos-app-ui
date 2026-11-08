// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_setup_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceSetupEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceSetupEvent()';
}


}

/// @nodoc
class $DeviceSetupEventCopyWith<$Res>  {
$DeviceSetupEventCopyWith(DeviceSetupEvent _, $Res Function(DeviceSetupEvent) __);
}


/// Adds pattern-matching-related methods to [DeviceSetupEvent].
extension DeviceSetupEventPatterns on DeviceSetupEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeviceSetupStarted value)?  started,TResult Function( DeviceSetupSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started(_that);case DeviceSetupSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeviceSetupStarted value)  started,required TResult Function( DeviceSetupSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case DeviceSetupStarted():
return started(_that);case DeviceSetupSubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeviceSetupStarted value)?  started,TResult? Function( DeviceSetupSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started(_that);case DeviceSetupSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String storeCode,  String registrationCode,  String deviceName)?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started();case DeviceSetupSubmitted() when submitted != null:
return submitted(_that.storeCode,_that.registrationCode,_that.deviceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String storeCode,  String registrationCode,  String deviceName)  submitted,}) {final _that = this;
switch (_that) {
case DeviceSetupStarted():
return started();case DeviceSetupSubmitted():
return submitted(_that.storeCode,_that.registrationCode,_that.deviceName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String storeCode,  String registrationCode,  String deviceName)?  submitted,}) {final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started();case DeviceSetupSubmitted() when submitted != null:
return submitted(_that.storeCode,_that.registrationCode,_that.deviceName);case _:
  return null;

}
}

}

/// @nodoc


class DeviceSetupStarted implements DeviceSetupEvent {
  const DeviceSetupStarted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceSetupEvent.started()';
}


}




/// @nodoc


class DeviceSetupSubmitted implements DeviceSetupEvent {
  const DeviceSetupSubmitted({required this.storeCode, required this.registrationCode, required this.deviceName});
  

 final  String storeCode;
 final  String registrationCode;
 final  String deviceName;

/// Create a copy of DeviceSetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSetupSubmittedCopyWith<DeviceSetupSubmitted> get copyWith => _$DeviceSetupSubmittedCopyWithImpl<DeviceSetupSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupSubmitted&&(identical(other.storeCode, storeCode) || other.storeCode == storeCode)&&(identical(other.registrationCode, registrationCode) || other.registrationCode == registrationCode)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,storeCode,registrationCode,deviceName);
}

@override
String toString() {
    return 'DeviceSetupEvent.submitted(storeCode: $storeCode, registrationCode: $registrationCode, deviceName: $deviceName)';
}


}

/// @nodoc
abstract mixin class $DeviceSetupSubmittedCopyWith<$Res> implements $DeviceSetupEventCopyWith<$Res> {
  factory $DeviceSetupSubmittedCopyWith(DeviceSetupSubmitted value, $Res Function(DeviceSetupSubmitted) _then) = _$DeviceSetupSubmittedCopyWithImpl;
@useResult
$Res call({
 String storeCode, String registrationCode, String deviceName
});




}
/// @nodoc
class _$DeviceSetupSubmittedCopyWithImpl<$Res>
    implements $DeviceSetupSubmittedCopyWith<$Res> {
  _$DeviceSetupSubmittedCopyWithImpl(this._self, this._then);

  final DeviceSetupSubmitted _self;
  final $Res Function(DeviceSetupSubmitted) _then;

/// Create a copy of DeviceSetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeCode = null,Object? registrationCode = null,Object? deviceName = null,}) {
  return _then(DeviceSetupSubmitted(
storeCode: null == storeCode ? _self.storeCode : storeCode // ignore: cast_nullable_to_non_nullable
as String,registrationCode: null == registrationCode ? _self.registrationCode : registrationCode // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DeviceSetupState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceSetupState()';
}


}

/// @nodoc
class $DeviceSetupStateCopyWith<$Res>  {
$DeviceSetupStateCopyWith(DeviceSetupState _, $Res Function(DeviceSetupState) __);
}


/// Adds pattern-matching-related methods to [DeviceSetupState].
extension DeviceSetupStatePatterns on DeviceSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeviceSetupInitial value)?  initial,TResult Function( DeviceSetupUnpaired value)?  unpaired,TResult Function( DeviceSetupSubmitting value)?  submitting,TResult Function( DeviceSetupPaired value)?  paired,TResult Function( DeviceSetupFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial(_that);case DeviceSetupUnpaired() when unpaired != null:
return unpaired(_that);case DeviceSetupSubmitting() when submitting != null:
return submitting(_that);case DeviceSetupPaired() when paired != null:
return paired(_that);case DeviceSetupFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeviceSetupInitial value)  initial,required TResult Function( DeviceSetupUnpaired value)  unpaired,required TResult Function( DeviceSetupSubmitting value)  submitting,required TResult Function( DeviceSetupPaired value)  paired,required TResult Function( DeviceSetupFailure value)  failure,}){
final _that = this;
switch (_that) {
case DeviceSetupInitial():
return initial(_that);case DeviceSetupUnpaired():
return unpaired(_that);case DeviceSetupSubmitting():
return submitting(_that);case DeviceSetupPaired():
return paired(_that);case DeviceSetupFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeviceSetupInitial value)?  initial,TResult? Function( DeviceSetupUnpaired value)?  unpaired,TResult? Function( DeviceSetupSubmitting value)?  submitting,TResult? Function( DeviceSetupPaired value)?  paired,TResult? Function( DeviceSetupFailure value)?  failure,}){
final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial(_that);case DeviceSetupUnpaired() when unpaired != null:
return unpaired(_that);case DeviceSetupSubmitting() when submitting != null:
return submitting(_that);case DeviceSetupPaired() when paired != null:
return paired(_that);case DeviceSetupFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  unpaired,TResult Function()?  submitting,TResult Function( DeviceSession session)?  paired,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial();case DeviceSetupUnpaired() when unpaired != null:
return unpaired();case DeviceSetupSubmitting() when submitting != null:
return submitting();case DeviceSetupPaired() when paired != null:
return paired(_that.session);case DeviceSetupFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  unpaired,required TResult Function()  submitting,required TResult Function( DeviceSession session)  paired,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case DeviceSetupInitial():
return initial();case DeviceSetupUnpaired():
return unpaired();case DeviceSetupSubmitting():
return submitting();case DeviceSetupPaired():
return paired(_that.session);case DeviceSetupFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  unpaired,TResult? Function()?  submitting,TResult? Function( DeviceSession session)?  paired,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial();case DeviceSetupUnpaired() when unpaired != null:
return unpaired();case DeviceSetupSubmitting() when submitting != null:
return submitting();case DeviceSetupPaired() when paired != null:
return paired(_that.session);case DeviceSetupFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DeviceSetupInitial implements DeviceSetupState {
  const DeviceSetupInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceSetupState.initial()';
}


}




/// @nodoc


class DeviceSetupUnpaired implements DeviceSetupState {
  const DeviceSetupUnpaired();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupUnpaired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceSetupState.unpaired()';
}


}




/// @nodoc


class DeviceSetupSubmitting implements DeviceSetupState {
  const DeviceSetupSubmitting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceSetupState.submitting()';
}


}




/// @nodoc


class DeviceSetupPaired implements DeviceSetupState {
  const DeviceSetupPaired(this.session);
  

 final  DeviceSession session;

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSetupPairedCopyWith<DeviceSetupPaired> get copyWith => _$DeviceSetupPairedCopyWithImpl<DeviceSetupPaired>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupPaired&&(identical(other.session, session) || other.session == session));
}


@override
int get hashCode {
    return Object.hash(runtimeType,session);
}

@override
String toString() {
    return 'DeviceSetupState.paired(session: $session)';
}


}

/// @nodoc
abstract mixin class $DeviceSetupPairedCopyWith<$Res> implements $DeviceSetupStateCopyWith<$Res> {
  factory $DeviceSetupPairedCopyWith(DeviceSetupPaired value, $Res Function(DeviceSetupPaired) _then) = _$DeviceSetupPairedCopyWithImpl;
@useResult
$Res call({
 DeviceSession session
});


$DeviceSessionCopyWith<$Res> get session;

}
/// @nodoc
class _$DeviceSetupPairedCopyWithImpl<$Res>
    implements $DeviceSetupPairedCopyWith<$Res> {
  _$DeviceSetupPairedCopyWithImpl(this._self, this._then);

  final DeviceSetupPaired _self;
  final $Res Function(DeviceSetupPaired) _then;

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,}) {
  return _then(DeviceSetupPaired(
null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as DeviceSession,
  ));
}

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceSessionCopyWith<$Res> get session {
  
  return $DeviceSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

/// @nodoc


class DeviceSetupFailure implements DeviceSetupState {
  const DeviceSetupFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSetupFailureCopyWith<DeviceSetupFailure> get copyWith => _$DeviceSetupFailureCopyWithImpl<DeviceSetupFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'DeviceSetupState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DeviceSetupFailureCopyWith<$Res> implements $DeviceSetupStateCopyWith<$Res> {
  factory $DeviceSetupFailureCopyWith(DeviceSetupFailure value, $Res Function(DeviceSetupFailure) _then) = _$DeviceSetupFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$DeviceSetupFailureCopyWithImpl<$Res>
    implements $DeviceSetupFailureCopyWith<$Res> {
  _$DeviceSetupFailureCopyWithImpl(this._self, this._then);

  final DeviceSetupFailure _self;
  final $Res Function(DeviceSetupFailure) _then;

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DeviceSetupFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
