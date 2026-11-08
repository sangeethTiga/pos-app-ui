// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_preview_model.dart';

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
mixin _$RegistrationPreviewModel {

 PreviewStoreModel get store; List<KioskModel> get kiosks; bool get rePair;
/// Create a copy of RegistrationPreviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationPreviewModelCopyWith<RegistrationPreviewModel> get copyWith => _$RegistrationPreviewModelCopyWithImpl<RegistrationPreviewModel>(this as RegistrationPreviewModel, _$identity);

  /// Serializes this RegistrationPreviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RegistrationPreviewModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationPreviewModel&&(identical(other.store, _this.store) || other.store == _this.store)&&const DeepCollectionEquality().equals(other.kiosks, _this.kiosks)&&(identical(other.rePair, _this.rePair) || other.rePair == _this.rePair));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RegistrationPreviewModel;
  return Object.hash(runtimeType,_this.store,const DeepCollectionEquality().hash(_this.kiosks),_this.rePair);
}

@override
String toString() {
  final _this = this as RegistrationPreviewModel;
  return 'RegistrationPreviewModel(store: ${_this.store}, kiosks: ${_this.kiosks}, rePair: ${_this.rePair})';
}


}

/// @nodoc
abstract mixin class $RegistrationPreviewModelCopyWith<$Res>  {
  factory $RegistrationPreviewModelCopyWith(RegistrationPreviewModel value, $Res Function(RegistrationPreviewModel) _then) = _$RegistrationPreviewModelCopyWithImpl;
@useResult
$Res call({
 PreviewStoreModel store, List<KioskModel> kiosks, bool rePair
});


$PreviewStoreModelCopyWith<$Res> get store;

}
/// @nodoc
class _$RegistrationPreviewModelCopyWithImpl<$Res>
    implements $RegistrationPreviewModelCopyWith<$Res> {
  _$RegistrationPreviewModelCopyWithImpl(this._self, this._then);

  final RegistrationPreviewModel _self;
  final $Res Function(RegistrationPreviewModel) _then;

/// Create a copy of RegistrationPreviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? store = null,Object? kiosks = null,Object? rePair = null,}) {
  return _then(RegistrationPreviewModel(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PreviewStoreModel,kiosks: null == kiosks ? _self.kiosks : kiosks // ignore: cast_nullable_to_non_nullable
as List<KioskModel>,rePair: null == rePair ? _self.rePair : rePair // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of RegistrationPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreviewStoreModelCopyWith<$Res> get store {
  
  return $PreviewStoreModelCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegistrationPreviewModel].
extension RegistrationPreviewModelPatterns on RegistrationPreviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationPreviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationPreviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationPreviewModel value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationPreviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationPreviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationPreviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PreviewStoreModel store,  List<KioskModel> kiosks,  bool rePair)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationPreviewModel() when $default != null:
return $default(_that.store,_that.kiosks,_that.rePair);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PreviewStoreModel store,  List<KioskModel> kiosks,  bool rePair)  $default,) {final _that = this;
switch (_that) {
case _RegistrationPreviewModel():
return $default(_that.store,_that.kiosks,_that.rePair);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PreviewStoreModel store,  List<KioskModel> kiosks,  bool rePair)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationPreviewModel() when $default != null:
return $default(_that.store,_that.kiosks,_that.rePair);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegistrationPreviewModel extends RegistrationPreviewModel {
  const _RegistrationPreviewModel({required this.store,  List<KioskModel> kiosks = const <KioskModel>[], this.rePair = false}): _kiosks = kiosks,super._();
  factory _RegistrationPreviewModel.fromJson(Map<String, dynamic> json) => _$RegistrationPreviewModelFromJson(json);

@override final  PreviewStoreModel store;
 final  List<KioskModel> _kiosks;
@override@JsonKey() List<KioskModel> get kiosks {
  if (_kiosks is EqualUnmodifiableListView) return _kiosks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_kiosks);
}

@override@JsonKey() final  bool rePair;

/// Create a copy of RegistrationPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationPreviewModelCopyWith<_RegistrationPreviewModel> get copyWith => __$RegistrationPreviewModelCopyWithImpl<_RegistrationPreviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationPreviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationPreviewModel&&(identical(other.store, store) || other.store == store)&&const DeepCollectionEquality().equals(other.kiosks, _kiosks)&&(identical(other.rePair, rePair) || other.rePair == rePair));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,store,const DeepCollectionEquality().hash(_kiosks),rePair);
}

@override
String toString() {
    return 'RegistrationPreviewModel(store: $store, kiosks: $kiosks, rePair: $rePair)';
}


}

/// @nodoc
abstract mixin class _$RegistrationPreviewModelCopyWith<$Res> implements $RegistrationPreviewModelCopyWith<$Res> {
  factory _$RegistrationPreviewModelCopyWith(_RegistrationPreviewModel value, $Res Function(_RegistrationPreviewModel) _then) = __$RegistrationPreviewModelCopyWithImpl;
@override @useResult
$Res call({
 PreviewStoreModel store, List<KioskModel> kiosks, bool rePair
});


@override $PreviewStoreModelCopyWith<$Res> get store;

}
/// @nodoc
class __$RegistrationPreviewModelCopyWithImpl<$Res>
    implements _$RegistrationPreviewModelCopyWith<$Res> {
  __$RegistrationPreviewModelCopyWithImpl(this._self, this._then);

  final _RegistrationPreviewModel _self;
  final $Res Function(_RegistrationPreviewModel) _then;

/// Create a copy of RegistrationPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? kiosks = null,Object? rePair = null,}) {
  return _then(_RegistrationPreviewModel(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PreviewStoreModel,kiosks: null == kiosks ? _self._kiosks : kiosks // ignore: cast_nullable_to_non_nullable
as List<KioskModel>,rePair: null == rePair ? _self.rePair : rePair // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of RegistrationPreviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreviewStoreModelCopyWith<$Res> get store {
  
  return $PreviewStoreModelCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

// dart format on
