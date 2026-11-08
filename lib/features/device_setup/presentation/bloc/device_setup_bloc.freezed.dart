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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeviceSetupStarted value)?  started,TResult Function( DeviceSetupCodesSubmitted value)?  codesSubmitted,TResult Function( DeviceSetupRegisterSubmitted value)?  registerSubmitted,TResult Function( DeviceSetupBack value)?  back,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started(_that);case DeviceSetupCodesSubmitted() when codesSubmitted != null:
return codesSubmitted(_that);case DeviceSetupRegisterSubmitted() when registerSubmitted != null:
return registerSubmitted(_that);case DeviceSetupBack() when back != null:
return back(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeviceSetupStarted value)  started,required TResult Function( DeviceSetupCodesSubmitted value)  codesSubmitted,required TResult Function( DeviceSetupRegisterSubmitted value)  registerSubmitted,required TResult Function( DeviceSetupBack value)  back,}){
final _that = this;
switch (_that) {
case DeviceSetupStarted():
return started(_that);case DeviceSetupCodesSubmitted():
return codesSubmitted(_that);case DeviceSetupRegisterSubmitted():
return registerSubmitted(_that);case DeviceSetupBack():
return back(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeviceSetupStarted value)?  started,TResult? Function( DeviceSetupCodesSubmitted value)?  codesSubmitted,TResult? Function( DeviceSetupRegisterSubmitted value)?  registerSubmitted,TResult? Function( DeviceSetupBack value)?  back,}){
final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started(_that);case DeviceSetupCodesSubmitted() when codesSubmitted != null:
return codesSubmitted(_that);case DeviceSetupRegisterSubmitted() when registerSubmitted != null:
return registerSubmitted(_that);case DeviceSetupBack() when back != null:
return back(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String storeCode,  String registrationCode)?  codesSubmitted,TResult Function( String deviceName,  DeviceProfile profile)?  registerSubmitted,TResult Function()?  back,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started();case DeviceSetupCodesSubmitted() when codesSubmitted != null:
return codesSubmitted(_that.storeCode,_that.registrationCode);case DeviceSetupRegisterSubmitted() when registerSubmitted != null:
return registerSubmitted(_that.deviceName,_that.profile);case DeviceSetupBack() when back != null:
return back();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String storeCode,  String registrationCode)  codesSubmitted,required TResult Function( String deviceName,  DeviceProfile profile)  registerSubmitted,required TResult Function()  back,}) {final _that = this;
switch (_that) {
case DeviceSetupStarted():
return started();case DeviceSetupCodesSubmitted():
return codesSubmitted(_that.storeCode,_that.registrationCode);case DeviceSetupRegisterSubmitted():
return registerSubmitted(_that.deviceName,_that.profile);case DeviceSetupBack():
return back();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String storeCode,  String registrationCode)?  codesSubmitted,TResult? Function( String deviceName,  DeviceProfile profile)?  registerSubmitted,TResult? Function()?  back,}) {final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started();case DeviceSetupCodesSubmitted() when codesSubmitted != null:
return codesSubmitted(_that.storeCode,_that.registrationCode);case DeviceSetupRegisterSubmitted() when registerSubmitted != null:
return registerSubmitted(_that.deviceName,_that.profile);case DeviceSetupBack() when back != null:
return back();case _:
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


class DeviceSetupCodesSubmitted implements DeviceSetupEvent {
  const DeviceSetupCodesSubmitted({required this.storeCode, required this.registrationCode});
  

 final  String storeCode;
 final  String registrationCode;

/// Create a copy of DeviceSetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSetupCodesSubmittedCopyWith<DeviceSetupCodesSubmitted> get copyWith => _$DeviceSetupCodesSubmittedCopyWithImpl<DeviceSetupCodesSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupCodesSubmitted&&(identical(other.storeCode, storeCode) || other.storeCode == storeCode)&&(identical(other.registrationCode, registrationCode) || other.registrationCode == registrationCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,storeCode,registrationCode);
}

@override
String toString() {
    return 'DeviceSetupEvent.codesSubmitted(storeCode: $storeCode, registrationCode: $registrationCode)';
}


}

/// @nodoc
abstract mixin class $DeviceSetupCodesSubmittedCopyWith<$Res> implements $DeviceSetupEventCopyWith<$Res> {
  factory $DeviceSetupCodesSubmittedCopyWith(DeviceSetupCodesSubmitted value, $Res Function(DeviceSetupCodesSubmitted) _then) = _$DeviceSetupCodesSubmittedCopyWithImpl;
@useResult
$Res call({
 String storeCode, String registrationCode
});




}
/// @nodoc
class _$DeviceSetupCodesSubmittedCopyWithImpl<$Res>
    implements $DeviceSetupCodesSubmittedCopyWith<$Res> {
  _$DeviceSetupCodesSubmittedCopyWithImpl(this._self, this._then);

  final DeviceSetupCodesSubmitted _self;
  final $Res Function(DeviceSetupCodesSubmitted) _then;

/// Create a copy of DeviceSetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeCode = null,Object? registrationCode = null,}) {
  return _then(DeviceSetupCodesSubmitted(
storeCode: null == storeCode ? _self.storeCode : storeCode // ignore: cast_nullable_to_non_nullable
as String,registrationCode: null == registrationCode ? _self.registrationCode : registrationCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DeviceSetupRegisterSubmitted implements DeviceSetupEvent {
  const DeviceSetupRegisterSubmitted({required this.deviceName, required this.profile});
  

 final  String deviceName;
 final  DeviceProfile profile;

/// Create a copy of DeviceSetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSetupRegisterSubmittedCopyWith<DeviceSetupRegisterSubmitted> get copyWith => _$DeviceSetupRegisterSubmittedCopyWithImpl<DeviceSetupRegisterSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupRegisterSubmitted&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceName,profile);
}

@override
String toString() {
    return 'DeviceSetupEvent.registerSubmitted(deviceName: $deviceName, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $DeviceSetupRegisterSubmittedCopyWith<$Res> implements $DeviceSetupEventCopyWith<$Res> {
  factory $DeviceSetupRegisterSubmittedCopyWith(DeviceSetupRegisterSubmitted value, $Res Function(DeviceSetupRegisterSubmitted) _then) = _$DeviceSetupRegisterSubmittedCopyWithImpl;
@useResult
$Res call({
 String deviceName, DeviceProfile profile
});


$DeviceProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$DeviceSetupRegisterSubmittedCopyWithImpl<$Res>
    implements $DeviceSetupRegisterSubmittedCopyWith<$Res> {
  _$DeviceSetupRegisterSubmittedCopyWithImpl(this._self, this._then);

  final DeviceSetupRegisterSubmitted _self;
  final $Res Function(DeviceSetupRegisterSubmitted) _then;

/// Create a copy of DeviceSetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceName = null,Object? profile = null,}) {
  return _then(DeviceSetupRegisterSubmitted(
deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as DeviceProfile,
  ));
}

/// Create a copy of DeviceSetupEvent
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


class DeviceSetupBack implements DeviceSetupEvent {
  const DeviceSetupBack();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupBack);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceSetupEvent.back()';
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeviceSetupInitial value)?  initial,TResult Function( DeviceSetupUnpaired value)?  unpaired,TResult Function( DeviceSetupVerifying value)?  verifying,TResult Function( DeviceSetupReady value)?  ready,TResult Function( DeviceSetupPaired value)?  paired,TResult Function( DeviceSetupFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial(_that);case DeviceSetupUnpaired() when unpaired != null:
return unpaired(_that);case DeviceSetupVerifying() when verifying != null:
return verifying(_that);case DeviceSetupReady() when ready != null:
return ready(_that);case DeviceSetupPaired() when paired != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeviceSetupInitial value)  initial,required TResult Function( DeviceSetupUnpaired value)  unpaired,required TResult Function( DeviceSetupVerifying value)  verifying,required TResult Function( DeviceSetupReady value)  ready,required TResult Function( DeviceSetupPaired value)  paired,required TResult Function( DeviceSetupFailure value)  failure,}){
final _that = this;
switch (_that) {
case DeviceSetupInitial():
return initial(_that);case DeviceSetupUnpaired():
return unpaired(_that);case DeviceSetupVerifying():
return verifying(_that);case DeviceSetupReady():
return ready(_that);case DeviceSetupPaired():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeviceSetupInitial value)?  initial,TResult? Function( DeviceSetupUnpaired value)?  unpaired,TResult? Function( DeviceSetupVerifying value)?  verifying,TResult? Function( DeviceSetupReady value)?  ready,TResult? Function( DeviceSetupPaired value)?  paired,TResult? Function( DeviceSetupFailure value)?  failure,}){
final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial(_that);case DeviceSetupUnpaired() when unpaired != null:
return unpaired(_that);case DeviceSetupVerifying() when verifying != null:
return verifying(_that);case DeviceSetupReady() when ready != null:
return ready(_that);case DeviceSetupPaired() when paired != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  unpaired,TResult Function()?  verifying,TResult Function( RegistrationPreview preview,  bool submitting,  Failure? failure)?  ready,TResult Function( DeviceSession session)?  paired,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial();case DeviceSetupUnpaired() when unpaired != null:
return unpaired();case DeviceSetupVerifying() when verifying != null:
return verifying();case DeviceSetupReady() when ready != null:
return ready(_that.preview,_that.submitting,_that.failure);case DeviceSetupPaired() when paired != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  unpaired,required TResult Function()  verifying,required TResult Function( RegistrationPreview preview,  bool submitting,  Failure? failure)  ready,required TResult Function( DeviceSession session)  paired,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case DeviceSetupInitial():
return initial();case DeviceSetupUnpaired():
return unpaired();case DeviceSetupVerifying():
return verifying();case DeviceSetupReady():
return ready(_that.preview,_that.submitting,_that.failure);case DeviceSetupPaired():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  unpaired,TResult? Function()?  verifying,TResult? Function( RegistrationPreview preview,  bool submitting,  Failure? failure)?  ready,TResult? Function( DeviceSession session)?  paired,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial();case DeviceSetupUnpaired() when unpaired != null:
return unpaired();case DeviceSetupVerifying() when verifying != null:
return verifying();case DeviceSetupReady() when ready != null:
return ready(_that.preview,_that.submitting,_that.failure);case DeviceSetupPaired() when paired != null:
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


class DeviceSetupVerifying implements DeviceSetupState {
  const DeviceSetupVerifying();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupVerifying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeviceSetupState.verifying()';
}


}




/// @nodoc


class DeviceSetupReady implements DeviceSetupState {
  const DeviceSetupReady(this.preview, {this.submitting = false, this.failure});
  

 final  RegistrationPreview preview;
@JsonKey() final  bool submitting;
 final  Failure? failure;

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSetupReadyCopyWith<DeviceSetupReady> get copyWith => _$DeviceSetupReadyCopyWithImpl<DeviceSetupReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupReady&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,preview,submitting,failure);
}

@override
String toString() {
    return 'DeviceSetupState.ready(preview: $preview, submitting: $submitting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DeviceSetupReadyCopyWith<$Res> implements $DeviceSetupStateCopyWith<$Res> {
  factory $DeviceSetupReadyCopyWith(DeviceSetupReady value, $Res Function(DeviceSetupReady) _then) = _$DeviceSetupReadyCopyWithImpl;
@useResult
$Res call({
 RegistrationPreview preview, bool submitting, Failure? failure
});


$RegistrationPreviewCopyWith<$Res> get preview;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$DeviceSetupReadyCopyWithImpl<$Res>
    implements $DeviceSetupReadyCopyWith<$Res> {
  _$DeviceSetupReadyCopyWithImpl(this._self, this._then);

  final DeviceSetupReady _self;
  final $Res Function(DeviceSetupReady) _then;

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? preview = null,Object? submitting = null,Object? failure = freezed,}) {
  return _then(DeviceSetupReady(
null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as RegistrationPreview,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegistrationPreviewCopyWith<$Res> get preview {
  
  return $RegistrationPreviewCopyWith<$Res>(_self.preview, (value) {
    return _then(_self.copyWith(preview: value));
  });
}/// Create a copy of DeviceSetupState
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
