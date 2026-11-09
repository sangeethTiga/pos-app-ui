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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeviceSetupStarted value)?  started,TResult Function( DeviceSetupCodeChanged value)?  codeChanged,TResult Function( DeviceSetupActivateSubmitted value)?  activateSubmitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started(_that);case DeviceSetupCodeChanged() when codeChanged != null:
return codeChanged(_that);case DeviceSetupActivateSubmitted() when activateSubmitted != null:
return activateSubmitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeviceSetupStarted value)  started,required TResult Function( DeviceSetupCodeChanged value)  codeChanged,required TResult Function( DeviceSetupActivateSubmitted value)  activateSubmitted,}){
final _that = this;
switch (_that) {
case DeviceSetupStarted():
return started(_that);case DeviceSetupCodeChanged():
return codeChanged(_that);case DeviceSetupActivateSubmitted():
return activateSubmitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeviceSetupStarted value)?  started,TResult? Function( DeviceSetupCodeChanged value)?  codeChanged,TResult? Function( DeviceSetupActivateSubmitted value)?  activateSubmitted,}){
final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started(_that);case DeviceSetupCodeChanged() when codeChanged != null:
return codeChanged(_that);case DeviceSetupActivateSubmitted() when activateSubmitted != null:
return activateSubmitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String code)?  codeChanged,TResult Function( String code,  String deviceName,  DeviceProfile profile)?  activateSubmitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started();case DeviceSetupCodeChanged() when codeChanged != null:
return codeChanged(_that.code);case DeviceSetupActivateSubmitted() when activateSubmitted != null:
return activateSubmitted(_that.code,_that.deviceName,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String code)  codeChanged,required TResult Function( String code,  String deviceName,  DeviceProfile profile)  activateSubmitted,}) {final _that = this;
switch (_that) {
case DeviceSetupStarted():
return started();case DeviceSetupCodeChanged():
return codeChanged(_that.code);case DeviceSetupActivateSubmitted():
return activateSubmitted(_that.code,_that.deviceName,_that.profile);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String code)?  codeChanged,TResult? Function( String code,  String deviceName,  DeviceProfile profile)?  activateSubmitted,}) {final _that = this;
switch (_that) {
case DeviceSetupStarted() when started != null:
return started();case DeviceSetupCodeChanged() when codeChanged != null:
return codeChanged(_that.code);case DeviceSetupActivateSubmitted() when activateSubmitted != null:
return activateSubmitted(_that.code,_that.deviceName,_that.profile);case _:
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


class DeviceSetupCodeChanged implements DeviceSetupEvent {
  const DeviceSetupCodeChanged(this.code);
  

 final  String code;

/// Create a copy of DeviceSetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSetupCodeChangedCopyWith<DeviceSetupCodeChanged> get copyWith => _$DeviceSetupCodeChangedCopyWithImpl<DeviceSetupCodeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupCodeChanged&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code);
}

@override
String toString() {
    return 'DeviceSetupEvent.codeChanged(code: $code)';
}


}

/// @nodoc
abstract mixin class $DeviceSetupCodeChangedCopyWith<$Res> implements $DeviceSetupEventCopyWith<$Res> {
  factory $DeviceSetupCodeChangedCopyWith(DeviceSetupCodeChanged value, $Res Function(DeviceSetupCodeChanged) _then) = _$DeviceSetupCodeChangedCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class _$DeviceSetupCodeChangedCopyWithImpl<$Res>
    implements $DeviceSetupCodeChangedCopyWith<$Res> {
  _$DeviceSetupCodeChangedCopyWithImpl(this._self, this._then);

  final DeviceSetupCodeChanged _self;
  final $Res Function(DeviceSetupCodeChanged) _then;

/// Create a copy of DeviceSetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(DeviceSetupCodeChanged(
null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DeviceSetupActivateSubmitted implements DeviceSetupEvent {
  const DeviceSetupActivateSubmitted({required this.code, required this.deviceName, required this.profile});
  

 final  String code;
 final  String deviceName;
 final  DeviceProfile profile;

/// Create a copy of DeviceSetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSetupActivateSubmittedCopyWith<DeviceSetupActivateSubmitted> get copyWith => _$DeviceSetupActivateSubmittedCopyWithImpl<DeviceSetupActivateSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupActivateSubmitted&&(identical(other.code, code) || other.code == code)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,deviceName,profile);
}

@override
String toString() {
    return 'DeviceSetupEvent.activateSubmitted(code: $code, deviceName: $deviceName, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $DeviceSetupActivateSubmittedCopyWith<$Res> implements $DeviceSetupEventCopyWith<$Res> {
  factory $DeviceSetupActivateSubmittedCopyWith(DeviceSetupActivateSubmitted value, $Res Function(DeviceSetupActivateSubmitted) _then) = _$DeviceSetupActivateSubmittedCopyWithImpl;
@useResult
$Res call({
 String code, String deviceName, DeviceProfile profile
});


$DeviceProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$DeviceSetupActivateSubmittedCopyWithImpl<$Res>
    implements $DeviceSetupActivateSubmittedCopyWith<$Res> {
  _$DeviceSetupActivateSubmittedCopyWithImpl(this._self, this._then);

  final DeviceSetupActivateSubmitted _self;
  final $Res Function(DeviceSetupActivateSubmitted) _then;

/// Create a copy of DeviceSetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? deviceName = null,Object? profile = null,}) {
  return _then(DeviceSetupActivateSubmitted(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeviceSetupInitial value)?  initial,TResult Function( DeviceSetupUnpaired value)?  unpaired,TResult Function( DeviceSetupPaired value)?  paired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial(_that);case DeviceSetupUnpaired() when unpaired != null:
return unpaired(_that);case DeviceSetupPaired() when paired != null:
return paired(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeviceSetupInitial value)  initial,required TResult Function( DeviceSetupUnpaired value)  unpaired,required TResult Function( DeviceSetupPaired value)  paired,}){
final _that = this;
switch (_that) {
case DeviceSetupInitial():
return initial(_that);case DeviceSetupUnpaired():
return unpaired(_that);case DeviceSetupPaired():
return paired(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeviceSetupInitial value)?  initial,TResult? Function( DeviceSetupUnpaired value)?  unpaired,TResult? Function( DeviceSetupPaired value)?  paired,}){
final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial(_that);case DeviceSetupUnpaired() when unpaired != null:
return unpaired(_that);case DeviceSetupPaired() when paired != null:
return paired(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String? hardwareId,  String? code,  bool checking,  SetupPreview? preview,  Failure? previewFailure,  bool submitting,  Failure? failure)?  unpaired,TResult Function( DeviceSession session)?  paired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial();case DeviceSetupUnpaired() when unpaired != null:
return unpaired(_that.hardwareId,_that.code,_that.checking,_that.preview,_that.previewFailure,_that.submitting,_that.failure);case DeviceSetupPaired() when paired != null:
return paired(_that.session);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String? hardwareId,  String? code,  bool checking,  SetupPreview? preview,  Failure? previewFailure,  bool submitting,  Failure? failure)  unpaired,required TResult Function( DeviceSession session)  paired,}) {final _that = this;
switch (_that) {
case DeviceSetupInitial():
return initial();case DeviceSetupUnpaired():
return unpaired(_that.hardwareId,_that.code,_that.checking,_that.preview,_that.previewFailure,_that.submitting,_that.failure);case DeviceSetupPaired():
return paired(_that.session);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String? hardwareId,  String? code,  bool checking,  SetupPreview? preview,  Failure? previewFailure,  bool submitting,  Failure? failure)?  unpaired,TResult? Function( DeviceSession session)?  paired,}) {final _that = this;
switch (_that) {
case DeviceSetupInitial() when initial != null:
return initial();case DeviceSetupUnpaired() when unpaired != null:
return unpaired(_that.hardwareId,_that.code,_that.checking,_that.preview,_that.previewFailure,_that.submitting,_that.failure);case DeviceSetupPaired() when paired != null:
return paired(_that.session);case _:
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
  const DeviceSetupUnpaired({this.hardwareId, this.code, this.checking = false, this.preview, this.previewFailure, this.submitting = false, this.failure});
  

/// This terminal's own id (copy row).
 final  String? hardwareId;
/// Complete code (XXXX-XXXX-XXXX) that [checking] / [preview] / [previewFailure] belong to.
 final  String? code;
/// Checking [code].
@JsonKey() final  bool checking;
/// Store and kiosks behind [code].
 final  SetupPreview? preview;
/// Why [code] was refused (or could not be checked).
 final  Failure? previewFailure;
/// Pairing and activating.
@JsonKey() final  bool submitting;
/// Why the last "Activate" failed; the page stays filled in.
 final  Failure? failure;

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSetupUnpairedCopyWith<DeviceSetupUnpaired> get copyWith => _$DeviceSetupUnpairedCopyWithImpl<DeviceSetupUnpaired>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSetupUnpaired&&(identical(other.hardwareId, hardwareId) || other.hardwareId == hardwareId)&&(identical(other.code, code) || other.code == code)&&(identical(other.checking, checking) || other.checking == checking)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.previewFailure, previewFailure) || other.previewFailure == previewFailure)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hardwareId,code,checking,preview,previewFailure,submitting,failure);
}

@override
String toString() {
    return 'DeviceSetupState.unpaired(hardwareId: $hardwareId, code: $code, checking: $checking, preview: $preview, previewFailure: $previewFailure, submitting: $submitting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DeviceSetupUnpairedCopyWith<$Res> implements $DeviceSetupStateCopyWith<$Res> {
  factory $DeviceSetupUnpairedCopyWith(DeviceSetupUnpaired value, $Res Function(DeviceSetupUnpaired) _then) = _$DeviceSetupUnpairedCopyWithImpl;
@useResult
$Res call({
 String? hardwareId, String? code, bool checking, SetupPreview? preview, Failure? previewFailure, bool submitting, Failure? failure
});


$SetupPreviewCopyWith<$Res>? get preview;$FailureCopyWith<$Res>? get previewFailure;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$DeviceSetupUnpairedCopyWithImpl<$Res>
    implements $DeviceSetupUnpairedCopyWith<$Res> {
  _$DeviceSetupUnpairedCopyWithImpl(this._self, this._then);

  final DeviceSetupUnpaired _self;
  final $Res Function(DeviceSetupUnpaired) _then;

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? hardwareId = freezed,Object? code = freezed,Object? checking = null,Object? preview = freezed,Object? previewFailure = freezed,Object? submitting = null,Object? failure = freezed,}) {
  return _then(DeviceSetupUnpaired(
hardwareId: freezed == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,checking: null == checking ? _self.checking : checking // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as SetupPreview?,previewFailure: freezed == previewFailure ? _self.previewFailure : previewFailure // ignore: cast_nullable_to_non_nullable
as Failure?,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SetupPreviewCopyWith<$Res>? get preview {
    if (_self.preview == null) {
    return null;
  }

  return $SetupPreviewCopyWith<$Res>(_self.preview!, (value) {
    return _then(_self.copyWith(preview: value));
  });
}/// Create a copy of DeviceSetupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get previewFailure {
    if (_self.previewFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.previewFailure!, (value) {
    return _then(_self.copyWith(previewFailure: value));
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

// dart format on
