// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_setup_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PreviewStoreModel {

 String get id; String get code; String get name;
/// Create a copy of PreviewStoreModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreviewStoreModelCopyWith<PreviewStoreModel> get copyWith => _$PreviewStoreModelCopyWithImpl<PreviewStoreModel>(this as PreviewStoreModel, _$identity);

  /// Serializes this PreviewStoreModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PreviewStoreModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviewStoreModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PreviewStoreModel;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name);
}

@override
String toString() {
  final _this = this as PreviewStoreModel;
  return 'PreviewStoreModel(id: ${_this.id}, code: ${_this.code}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $PreviewStoreModelCopyWith<$Res>  {
  factory $PreviewStoreModelCopyWith(PreviewStoreModel value, $Res Function(PreviewStoreModel) _then) = _$PreviewStoreModelCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class _$PreviewStoreModelCopyWithImpl<$Res>
    implements $PreviewStoreModelCopyWith<$Res> {
  _$PreviewStoreModelCopyWithImpl(this._self, this._then);

  final PreviewStoreModel _self;
  final $Res Function(PreviewStoreModel) _then;

/// Create a copy of PreviewStoreModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(PreviewStoreModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PreviewStoreModel].
extension PreviewStoreModelPatterns on PreviewStoreModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreviewStoreModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreviewStoreModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreviewStoreModel value)  $default,){
final _that = this;
switch (_that) {
case _PreviewStoreModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreviewStoreModel value)?  $default,){
final _that = this;
switch (_that) {
case _PreviewStoreModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreviewStoreModel() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name)  $default,) {final _that = this;
switch (_that) {
case _PreviewStoreModel():
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name)?  $default,) {final _that = this;
switch (_that) {
case _PreviewStoreModel() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreviewStoreModel implements PreviewStoreModel {
  const _PreviewStoreModel({required this.id, required this.code, required this.name});
  factory _PreviewStoreModel.fromJson(Map<String, dynamic> json) => _$PreviewStoreModelFromJson(json);

@override final  String id;
@override final  String code;
@override final  String name;

/// Create a copy of PreviewStoreModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreviewStoreModelCopyWith<_PreviewStoreModel> get copyWith => __$PreviewStoreModelCopyWithImpl<_PreviewStoreModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreviewStoreModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviewStoreModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name);
}

@override
String toString() {
    return 'PreviewStoreModel(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PreviewStoreModelCopyWith<$Res> implements $PreviewStoreModelCopyWith<$Res> {
  factory _$PreviewStoreModelCopyWith(_PreviewStoreModel value, $Res Function(_PreviewStoreModel) _then) = __$PreviewStoreModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name
});




}
/// @nodoc
class __$PreviewStoreModelCopyWithImpl<$Res>
    implements _$PreviewStoreModelCopyWith<$Res> {
  __$PreviewStoreModelCopyWithImpl(this._self, this._then);

  final _PreviewStoreModel _self;
  final $Res Function(_PreviewStoreModel) _then;

/// Create a copy of PreviewStoreModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,}) {
  return _then(_PreviewStoreModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$KioskModel {

 String get id; String get name;
/// Create a copy of KioskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KioskModelCopyWith<KioskModel> get copyWith => _$KioskModelCopyWithImpl<KioskModel>(this as KioskModel, _$identity);

  /// Serializes this KioskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KioskModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KioskModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KioskModel;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as KioskModel;
  return 'KioskModel(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $KioskModelCopyWith<$Res>  {
  factory $KioskModelCopyWith(KioskModel value, $Res Function(KioskModel) _then) = _$KioskModelCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$KioskModelCopyWithImpl<$Res>
    implements $KioskModelCopyWith<$Res> {
  _$KioskModelCopyWithImpl(this._self, this._then);

  final KioskModel _self;
  final $Res Function(KioskModel) _then;

/// Create a copy of KioskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(KioskModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [KioskModel].
extension KioskModelPatterns on KioskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KioskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KioskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KioskModel value)  $default,){
final _that = this;
switch (_that) {
case _KioskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KioskModel value)?  $default,){
final _that = this;
switch (_that) {
case _KioskModel() when $default != null:
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
case _KioskModel() when $default != null:
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
case _KioskModel():
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
case _KioskModel() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KioskModel implements KioskModel {
  const _KioskModel({required this.id, required this.name});
  factory _KioskModel.fromJson(Map<String, dynamic> json) => _$KioskModelFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of KioskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KioskModelCopyWith<_KioskModel> get copyWith => __$KioskModelCopyWithImpl<_KioskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KioskModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KioskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'KioskModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$KioskModelCopyWith<$Res> implements $KioskModelCopyWith<$Res> {
  factory _$KioskModelCopyWith(_KioskModel value, $Res Function(_KioskModel) _then) = __$KioskModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$KioskModelCopyWithImpl<$Res>
    implements _$KioskModelCopyWith<$Res> {
  __$KioskModelCopyWithImpl(this._self, this._then);

  final _KioskModel _self;
  final $Res Function(_KioskModel) _then;

/// Create a copy of KioskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_KioskModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PreviewDeviceModel {

 String get id; String? get code; String? get name;
/// Create a copy of PreviewDeviceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreviewDeviceModelCopyWith<PreviewDeviceModel> get copyWith => _$PreviewDeviceModelCopyWithImpl<PreviewDeviceModel>(this as PreviewDeviceModel, _$identity);

  /// Serializes this PreviewDeviceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PreviewDeviceModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviewDeviceModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PreviewDeviceModel;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name);
}

@override
String toString() {
  final _this = this as PreviewDeviceModel;
  return 'PreviewDeviceModel(id: ${_this.id}, code: ${_this.code}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $PreviewDeviceModelCopyWith<$Res>  {
  factory $PreviewDeviceModelCopyWith(PreviewDeviceModel value, $Res Function(PreviewDeviceModel) _then) = _$PreviewDeviceModelCopyWithImpl;
@useResult
$Res call({
 String id, String? code, String? name
});




}
/// @nodoc
class _$PreviewDeviceModelCopyWithImpl<$Res>
    implements $PreviewDeviceModelCopyWith<$Res> {
  _$PreviewDeviceModelCopyWithImpl(this._self, this._then);

  final PreviewDeviceModel _self;
  final $Res Function(PreviewDeviceModel) _then;

/// Create a copy of PreviewDeviceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = freezed,Object? name = freezed,}) {
  return _then(PreviewDeviceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PreviewDeviceModel].
extension PreviewDeviceModelPatterns on PreviewDeviceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreviewDeviceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreviewDeviceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreviewDeviceModel value)  $default,){
final _that = this;
switch (_that) {
case _PreviewDeviceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreviewDeviceModel value)?  $default,){
final _that = this;
switch (_that) {
case _PreviewDeviceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? code,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreviewDeviceModel() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? code,  String? name)  $default,) {final _that = this;
switch (_that) {
case _PreviewDeviceModel():
return $default(_that.id,_that.code,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? code,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _PreviewDeviceModel() when $default != null:
return $default(_that.id,_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreviewDeviceModel implements PreviewDeviceModel {
  const _PreviewDeviceModel({required this.id, this.code, this.name});
  factory _PreviewDeviceModel.fromJson(Map<String, dynamic> json) => _$PreviewDeviceModelFromJson(json);

@override final  String id;
@override final  String? code;
@override final  String? name;

/// Create a copy of PreviewDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreviewDeviceModelCopyWith<_PreviewDeviceModel> get copyWith => __$PreviewDeviceModelCopyWithImpl<_PreviewDeviceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreviewDeviceModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviewDeviceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name);
}

@override
String toString() {
    return 'PreviewDeviceModel(id: $id, code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PreviewDeviceModelCopyWith<$Res> implements $PreviewDeviceModelCopyWith<$Res> {
  factory _$PreviewDeviceModelCopyWith(_PreviewDeviceModel value, $Res Function(_PreviewDeviceModel) _then) = __$PreviewDeviceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? code, String? name
});




}
/// @nodoc
class __$PreviewDeviceModelCopyWithImpl<$Res>
    implements _$PreviewDeviceModelCopyWith<$Res> {
  __$PreviewDeviceModelCopyWithImpl(this._self, this._then);

  final _PreviewDeviceModel _self;
  final $Res Function(_PreviewDeviceModel) _then;

/// Create a copy of PreviewDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = freezed,Object? name = freezed,}) {
  return _then(_PreviewDeviceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SetupPreviewModel {

 PreviewStoreModel get store; List<KioskModel> get kiosks; List<String> get deviceTypes; bool get rePair; PreviewDeviceModel? get device;
/// Create a copy of SetupPreviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupPreviewModelCopyWith<SetupPreviewModel> get copyWith => _$SetupPreviewModelCopyWithImpl<SetupPreviewModel>(this as SetupPreviewModel, _$identity);

  /// Serializes this SetupPreviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SetupPreviewModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupPreviewModel&&(identical(other.store, _this.store) || other.store == _this.store)&&const DeepCollectionEquality().equals(other.kiosks, _this.kiosks)&&const DeepCollectionEquality().equals(other.deviceTypes, _this.deviceTypes)&&(identical(other.rePair, _this.rePair) || other.rePair == _this.rePair)&&(identical(other.device, _this.device) || other.device == _this.device));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SetupPreviewModel;
  return Object.hash(runtimeType,_this.store,const DeepCollectionEquality().hash(_this.kiosks),const DeepCollectionEquality().hash(_this.deviceTypes),_this.rePair,_this.device);
}

@override
String toString() {
  final _this = this as SetupPreviewModel;
  return 'SetupPreviewModel(store: ${_this.store}, kiosks: ${_this.kiosks}, deviceTypes: ${_this.deviceTypes}, rePair: ${_this.rePair}, device: ${_this.device})';
}


}

/// @nodoc
abstract mixin class $SetupPreviewModelCopyWith<$Res>  {
  factory $SetupPreviewModelCopyWith(SetupPreviewModel value, $Res Function(SetupPreviewModel) _then) = _$SetupPreviewModelCopyWithImpl;
@useResult
$Res call({
 PreviewStoreModel store, List<KioskModel> kiosks, List<String> deviceTypes, bool rePair, PreviewDeviceModel? device
});


$PreviewStoreModelCopyWith<$Res> get store;$PreviewDeviceModelCopyWith<$Res>? get device;

}
/// @nodoc
class _$SetupPreviewModelCopyWithImpl<$Res>
    implements $SetupPreviewModelCopyWith<$Res> {
  _$SetupPreviewModelCopyWithImpl(this._self, this._then);

  final SetupPreviewModel _self;
  final $Res Function(SetupPreviewModel) _then;

/// Create a copy of SetupPreviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? store = null,Object? kiosks = null,Object? deviceTypes = null,Object? rePair = null,Object? device = freezed,}) {
  return _then(SetupPreviewModel(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PreviewStoreModel,kiosks: null == kiosks ? _self.kiosks : kiosks // ignore: cast_nullable_to_non_nullable
as List<KioskModel>,deviceTypes: null == deviceTypes ? _self.deviceTypes : deviceTypes // ignore: cast_nullable_to_non_nullable
as List<String>,rePair: null == rePair ? _self.rePair : rePair // ignore: cast_nullable_to_non_nullable
as bool,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PreviewDeviceModel?,
  ));
}
/// Create a copy of SetupPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreviewStoreModelCopyWith<$Res> get store {
  
  return $PreviewStoreModelCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}/// Create a copy of SetupPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreviewDeviceModelCopyWith<$Res>? get device {
    if (_self.device == null) {
    return null;
  }

  return $PreviewDeviceModelCopyWith<$Res>(_self.device!, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [SetupPreviewModel].
extension SetupPreviewModelPatterns on SetupPreviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetupPreviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetupPreviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetupPreviewModel value)  $default,){
final _that = this;
switch (_that) {
case _SetupPreviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetupPreviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _SetupPreviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PreviewStoreModel store,  List<KioskModel> kiosks,  List<String> deviceTypes,  bool rePair,  PreviewDeviceModel? device)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetupPreviewModel() when $default != null:
return $default(_that.store,_that.kiosks,_that.deviceTypes,_that.rePair,_that.device);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PreviewStoreModel store,  List<KioskModel> kiosks,  List<String> deviceTypes,  bool rePair,  PreviewDeviceModel? device)  $default,) {final _that = this;
switch (_that) {
case _SetupPreviewModel():
return $default(_that.store,_that.kiosks,_that.deviceTypes,_that.rePair,_that.device);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PreviewStoreModel store,  List<KioskModel> kiosks,  List<String> deviceTypes,  bool rePair,  PreviewDeviceModel? device)?  $default,) {final _that = this;
switch (_that) {
case _SetupPreviewModel() when $default != null:
return $default(_that.store,_that.kiosks,_that.deviceTypes,_that.rePair,_that.device);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetupPreviewModel extends SetupPreviewModel {
  const _SetupPreviewModel({required this.store,  List<KioskModel> kiosks = const <KioskModel>[],  List<String> deviceTypes = const <String>[], this.rePair = false, this.device}): _kiosks = kiosks,_deviceTypes = deviceTypes,super._();
  factory _SetupPreviewModel.fromJson(Map<String, dynamic> json) => _$SetupPreviewModelFromJson(json);

@override final  PreviewStoreModel store;
 final  List<KioskModel> _kiosks;
@override@JsonKey() List<KioskModel> get kiosks {
  if (_kiosks is EqualUnmodifiableListView) return _kiosks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_kiosks);
}

 final  List<String> _deviceTypes;
@override@JsonKey() List<String> get deviceTypes {
  if (_deviceTypes is EqualUnmodifiableListView) return _deviceTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deviceTypes);
}

@override@JsonKey() final  bool rePair;
@override final  PreviewDeviceModel? device;

/// Create a copy of SetupPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetupPreviewModelCopyWith<_SetupPreviewModel> get copyWith => __$SetupPreviewModelCopyWithImpl<_SetupPreviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetupPreviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetupPreviewModel&&(identical(other.store, store) || other.store == store)&&const DeepCollectionEquality().equals(other.kiosks, _kiosks)&&const DeepCollectionEquality().equals(other.deviceTypes, _deviceTypes)&&(identical(other.rePair, rePair) || other.rePair == rePair)&&(identical(other.device, device) || other.device == device));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,store,const DeepCollectionEquality().hash(_kiosks),const DeepCollectionEquality().hash(_deviceTypes),rePair,device);
}

@override
String toString() {
    return 'SetupPreviewModel(store: $store, kiosks: $kiosks, deviceTypes: $deviceTypes, rePair: $rePair, device: $device)';
}


}

/// @nodoc
abstract mixin class _$SetupPreviewModelCopyWith<$Res> implements $SetupPreviewModelCopyWith<$Res> {
  factory _$SetupPreviewModelCopyWith(_SetupPreviewModel value, $Res Function(_SetupPreviewModel) _then) = __$SetupPreviewModelCopyWithImpl;
@override @useResult
$Res call({
 PreviewStoreModel store, List<KioskModel> kiosks, List<String> deviceTypes, bool rePair, PreviewDeviceModel? device
});


@override $PreviewStoreModelCopyWith<$Res> get store;@override $PreviewDeviceModelCopyWith<$Res>? get device;

}
/// @nodoc
class __$SetupPreviewModelCopyWithImpl<$Res>
    implements _$SetupPreviewModelCopyWith<$Res> {
  __$SetupPreviewModelCopyWithImpl(this._self, this._then);

  final _SetupPreviewModel _self;
  final $Res Function(_SetupPreviewModel) _then;

/// Create a copy of SetupPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? kiosks = null,Object? deviceTypes = null,Object? rePair = null,Object? device = freezed,}) {
  return _then(_SetupPreviewModel(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PreviewStoreModel,kiosks: null == kiosks ? _self._kiosks : kiosks // ignore: cast_nullable_to_non_nullable
as List<KioskModel>,deviceTypes: null == deviceTypes ? _self._deviceTypes : deviceTypes // ignore: cast_nullable_to_non_nullable
as List<String>,rePair: null == rePair ? _self.rePair : rePair // ignore: cast_nullable_to_non_nullable
as bool,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as PreviewDeviceModel?,
  ));
}

/// Create a copy of SetupPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreviewStoreModelCopyWith<$Res> get store {
  
  return $PreviewStoreModelCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}/// Create a copy of SetupPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreviewDeviceModelCopyWith<$Res>? get device {
    if (_self.device == null) {
    return null;
  }

  return $PreviewDeviceModelCopyWith<$Res>(_self.device!, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// @nodoc
mixin _$SetupDeviceRequest {

/// Activation code, XXXX-XXXX-XXXX.
 String get code; String get deviceName;/// `windows` or `android`.
 String get platform; String get appVersion;/// `CASHIER` or `CAPTAIN`.
 String? get deviceType; String? get hardwareId; String? get kioskId;/// kiosk_wise_order_listing, delivery_manager_pos, settle_assigned_orders_only.
 Map<String, bool>? get settings;
/// Create a copy of SetupDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupDeviceRequestCopyWith<SetupDeviceRequest> get copyWith => _$SetupDeviceRequestCopyWithImpl<SetupDeviceRequest>(this as SetupDeviceRequest, _$identity);

  /// Serializes this SetupDeviceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SetupDeviceRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupDeviceRequest&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.deviceName, _this.deviceName) || other.deviceName == _this.deviceName)&&(identical(other.platform, _this.platform) || other.platform == _this.platform)&&(identical(other.appVersion, _this.appVersion) || other.appVersion == _this.appVersion)&&(identical(other.deviceType, _this.deviceType) || other.deviceType == _this.deviceType)&&(identical(other.hardwareId, _this.hardwareId) || other.hardwareId == _this.hardwareId)&&(identical(other.kioskId, _this.kioskId) || other.kioskId == _this.kioskId)&&const DeepCollectionEquality().equals(other.settings, _this.settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SetupDeviceRequest;
  return Object.hash(runtimeType,_this.code,_this.deviceName,_this.platform,_this.appVersion,_this.deviceType,_this.hardwareId,_this.kioskId,const DeepCollectionEquality().hash(_this.settings));
}

@override
String toString() {
  final _this = this as SetupDeviceRequest;
  return 'SetupDeviceRequest(code: ${_this.code}, deviceName: ${_this.deviceName}, platform: ${_this.platform}, appVersion: ${_this.appVersion}, deviceType: ${_this.deviceType}, hardwareId: ${_this.hardwareId}, kioskId: ${_this.kioskId}, settings: ${_this.settings})';
}


}

/// @nodoc
abstract mixin class $SetupDeviceRequestCopyWith<$Res>  {
  factory $SetupDeviceRequestCopyWith(SetupDeviceRequest value, $Res Function(SetupDeviceRequest) _then) = _$SetupDeviceRequestCopyWithImpl;
@useResult
$Res call({
 String code, String deviceName, String platform, String appVersion, String? deviceType, String? hardwareId, String? kioskId, Map<String, bool>? settings
});




}
/// @nodoc
class _$SetupDeviceRequestCopyWithImpl<$Res>
    implements $SetupDeviceRequestCopyWith<$Res> {
  _$SetupDeviceRequestCopyWithImpl(this._self, this._then);

  final SetupDeviceRequest _self;
  final $Res Function(SetupDeviceRequest) _then;

/// Create a copy of SetupDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? deviceName = null,Object? platform = null,Object? appVersion = null,Object? deviceType = freezed,Object? hardwareId = freezed,Object? kioskId = freezed,Object? settings = freezed,}) {
  return _then(SetupDeviceRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String?,hardwareId: freezed == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String?,kioskId: freezed == kioskId ? _self.kioskId : kioskId // ignore: cast_nullable_to_non_nullable
as String?,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetupDeviceRequest].
extension SetupDeviceRequestPatterns on SetupDeviceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetupDeviceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetupDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetupDeviceRequest value)  $default,){
final _that = this;
switch (_that) {
case _SetupDeviceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetupDeviceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SetupDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String deviceName,  String platform,  String appVersion,  String? deviceType,  String? hardwareId,  String? kioskId,  Map<String, bool>? settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetupDeviceRequest() when $default != null:
return $default(_that.code,_that.deviceName,_that.platform,_that.appVersion,_that.deviceType,_that.hardwareId,_that.kioskId,_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String deviceName,  String platform,  String appVersion,  String? deviceType,  String? hardwareId,  String? kioskId,  Map<String, bool>? settings)  $default,) {final _that = this;
switch (_that) {
case _SetupDeviceRequest():
return $default(_that.code,_that.deviceName,_that.platform,_that.appVersion,_that.deviceType,_that.hardwareId,_that.kioskId,_that.settings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String deviceName,  String platform,  String appVersion,  String? deviceType,  String? hardwareId,  String? kioskId,  Map<String, bool>? settings)?  $default,) {final _that = this;
switch (_that) {
case _SetupDeviceRequest() when $default != null:
return $default(_that.code,_that.deviceName,_that.platform,_that.appVersion,_that.deviceType,_that.hardwareId,_that.kioskId,_that.settings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetupDeviceRequest implements SetupDeviceRequest {
  const _SetupDeviceRequest({required this.code, required this.deviceName, required this.platform, required this.appVersion, this.deviceType, this.hardwareId, this.kioskId,  Map<String, bool>? settings}): _settings = settings;
  factory _SetupDeviceRequest.fromJson(Map<String, dynamic> json) => _$SetupDeviceRequestFromJson(json);

/// Activation code, XXXX-XXXX-XXXX.
@override final  String code;
@override final  String deviceName;
/// `windows` or `android`.
@override final  String platform;
@override final  String appVersion;
/// `CASHIER` or `CAPTAIN`.
@override final  String? deviceType;
@override final  String? hardwareId;
@override final  String? kioskId;
/// kiosk_wise_order_listing, delivery_manager_pos, settle_assigned_orders_only.
 final  Map<String, bool>? _settings;
/// kiosk_wise_order_listing, delivery_manager_pos, settle_assigned_orders_only.
@override Map<String, bool>? get settings {
  final value = _settings;
  if (value == null) return null;
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SetupDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetupDeviceRequestCopyWith<_SetupDeviceRequest> get copyWith => __$SetupDeviceRequestCopyWithImpl<_SetupDeviceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetupDeviceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetupDeviceRequest&&(identical(other.code, code) || other.code == code)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.hardwareId, hardwareId) || other.hardwareId == hardwareId)&&(identical(other.kioskId, kioskId) || other.kioskId == kioskId)&&const DeepCollectionEquality().equals(other.settings, _settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,deviceName,platform,appVersion,deviceType,hardwareId,kioskId,const DeepCollectionEquality().hash(_settings));
}

@override
String toString() {
    return 'SetupDeviceRequest(code: $code, deviceName: $deviceName, platform: $platform, appVersion: $appVersion, deviceType: $deviceType, hardwareId: $hardwareId, kioskId: $kioskId, settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$SetupDeviceRequestCopyWith<$Res> implements $SetupDeviceRequestCopyWith<$Res> {
  factory _$SetupDeviceRequestCopyWith(_SetupDeviceRequest value, $Res Function(_SetupDeviceRequest) _then) = __$SetupDeviceRequestCopyWithImpl;
@override @useResult
$Res call({
 String code, String deviceName, String platform, String appVersion, String? deviceType, String? hardwareId, String? kioskId, Map<String, bool>? settings
});




}
/// @nodoc
class __$SetupDeviceRequestCopyWithImpl<$Res>
    implements _$SetupDeviceRequestCopyWith<$Res> {
  __$SetupDeviceRequestCopyWithImpl(this._self, this._then);

  final _SetupDeviceRequest _self;
  final $Res Function(_SetupDeviceRequest) _then;

/// Create a copy of SetupDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? deviceName = null,Object? platform = null,Object? appVersion = null,Object? deviceType = freezed,Object? hardwareId = freezed,Object? kioskId = freezed,Object? settings = freezed,}) {
  return _then(_SetupDeviceRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String?,hardwareId: freezed == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String?,kioskId: freezed == kioskId ? _self.kioskId : kioskId // ignore: cast_nullable_to_non_nullable
as String?,settings: freezed == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,
  ));
}


}

// dart format on
