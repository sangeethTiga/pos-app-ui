// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartLine {

 String get key; String get productId; String get name; int get unitPriceMinor; int get qtyMilli; int get taxRateBp; bool get priceIncludesTax; bool get trackStock; String? get kitchenStationId; String? get note;
/// Create a copy of CartLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartLineCopyWith<CartLine> get copyWith => _$CartLineCopyWithImpl<CartLine>(this as CartLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CartLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartLine&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.unitPriceMinor, _this.unitPriceMinor) || other.unitPriceMinor == _this.unitPriceMinor)&&(identical(other.qtyMilli, _this.qtyMilli) || other.qtyMilli == _this.qtyMilli)&&(identical(other.taxRateBp, _this.taxRateBp) || other.taxRateBp == _this.taxRateBp)&&(identical(other.priceIncludesTax, _this.priceIncludesTax) || other.priceIncludesTax == _this.priceIncludesTax)&&(identical(other.trackStock, _this.trackStock) || other.trackStock == _this.trackStock)&&(identical(other.kitchenStationId, _this.kitchenStationId) || other.kitchenStationId == _this.kitchenStationId)&&(identical(other.note, _this.note) || other.note == _this.note));
}


@override
int get hashCode {
  final _this = this as CartLine;
  return Object.hash(runtimeType,_this.key,_this.productId,_this.name,_this.unitPriceMinor,_this.qtyMilli,_this.taxRateBp,_this.priceIncludesTax,_this.trackStock,_this.kitchenStationId,_this.note);
}

@override
String toString() {
  final _this = this as CartLine;
  return 'CartLine(key: ${_this.key}, productId: ${_this.productId}, name: ${_this.name}, unitPriceMinor: ${_this.unitPriceMinor}, qtyMilli: ${_this.qtyMilli}, taxRateBp: ${_this.taxRateBp}, priceIncludesTax: ${_this.priceIncludesTax}, trackStock: ${_this.trackStock}, kitchenStationId: ${_this.kitchenStationId}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $CartLineCopyWith<$Res>  {
  factory $CartLineCopyWith(CartLine value, $Res Function(CartLine) _then) = _$CartLineCopyWithImpl;
@useResult
$Res call({
 String key, String productId, String name, int unitPriceMinor, int qtyMilli, int taxRateBp, bool priceIncludesTax, bool trackStock, String? kitchenStationId, String? note
});




}
/// @nodoc
class _$CartLineCopyWithImpl<$Res>
    implements $CartLineCopyWith<$Res> {
  _$CartLineCopyWithImpl(this._self, this._then);

  final CartLine _self;
  final $Res Function(CartLine) _then;

/// Create a copy of CartLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? productId = null,Object? name = null,Object? unitPriceMinor = null,Object? qtyMilli = null,Object? taxRateBp = null,Object? priceIncludesTax = null,Object? trackStock = null,Object? kitchenStationId = freezed,Object? note = freezed,}) {
  return _then(CartLine(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,qtyMilli: null == qtyMilli ? _self.qtyMilli : qtyMilli // ignore: cast_nullable_to_non_nullable
as int,taxRateBp: null == taxRateBp ? _self.taxRateBp : taxRateBp // ignore: cast_nullable_to_non_nullable
as int,priceIncludesTax: null == priceIncludesTax ? _self.priceIncludesTax : priceIncludesTax // ignore: cast_nullable_to_non_nullable
as bool,trackStock: null == trackStock ? _self.trackStock : trackStock // ignore: cast_nullable_to_non_nullable
as bool,kitchenStationId: freezed == kitchenStationId ? _self.kitchenStationId : kitchenStationId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CartLine].
extension CartLinePatterns on CartLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartLine value)  $default,){
final _that = this;
switch (_that) {
case _CartLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartLine value)?  $default,){
final _that = this;
switch (_that) {
case _CartLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String productId,  String name,  int unitPriceMinor,  int qtyMilli,  int taxRateBp,  bool priceIncludesTax,  bool trackStock,  String? kitchenStationId,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartLine() when $default != null:
return $default(_that.key,_that.productId,_that.name,_that.unitPriceMinor,_that.qtyMilli,_that.taxRateBp,_that.priceIncludesTax,_that.trackStock,_that.kitchenStationId,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String productId,  String name,  int unitPriceMinor,  int qtyMilli,  int taxRateBp,  bool priceIncludesTax,  bool trackStock,  String? kitchenStationId,  String? note)  $default,) {final _that = this;
switch (_that) {
case _CartLine():
return $default(_that.key,_that.productId,_that.name,_that.unitPriceMinor,_that.qtyMilli,_that.taxRateBp,_that.priceIncludesTax,_that.trackStock,_that.kitchenStationId,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String productId,  String name,  int unitPriceMinor,  int qtyMilli,  int taxRateBp,  bool priceIncludesTax,  bool trackStock,  String? kitchenStationId,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _CartLine() when $default != null:
return $default(_that.key,_that.productId,_that.name,_that.unitPriceMinor,_that.qtyMilli,_that.taxRateBp,_that.priceIncludesTax,_that.trackStock,_that.kitchenStationId,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _CartLine implements CartLine {
  const _CartLine({required this.key, required this.productId, required this.name, required this.unitPriceMinor, required this.qtyMilli, required this.taxRateBp, required this.priceIncludesTax, required this.trackStock, this.kitchenStationId, this.note});
  

@override final  String key;
@override final  String productId;
@override final  String name;
@override final  int unitPriceMinor;
@override final  int qtyMilli;
@override final  int taxRateBp;
@override final  bool priceIncludesTax;
@override final  bool trackStock;
@override final  String? kitchenStationId;
@override final  String? note;

/// Create a copy of CartLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartLineCopyWith<_CartLine> get copyWith => __$CartLineCopyWithImpl<_CartLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartLine&&(identical(other.key, key) || other.key == key)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.qtyMilli, qtyMilli) || other.qtyMilli == qtyMilli)&&(identical(other.taxRateBp, taxRateBp) || other.taxRateBp == taxRateBp)&&(identical(other.priceIncludesTax, priceIncludesTax) || other.priceIncludesTax == priceIncludesTax)&&(identical(other.trackStock, trackStock) || other.trackStock == trackStock)&&(identical(other.kitchenStationId, kitchenStationId) || other.kitchenStationId == kitchenStationId)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,key,productId,name,unitPriceMinor,qtyMilli,taxRateBp,priceIncludesTax,trackStock,kitchenStationId,note);
}

@override
String toString() {
    return 'CartLine(key: $key, productId: $productId, name: $name, unitPriceMinor: $unitPriceMinor, qtyMilli: $qtyMilli, taxRateBp: $taxRateBp, priceIncludesTax: $priceIncludesTax, trackStock: $trackStock, kitchenStationId: $kitchenStationId, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CartLineCopyWith<$Res> implements $CartLineCopyWith<$Res> {
  factory _$CartLineCopyWith(_CartLine value, $Res Function(_CartLine) _then) = __$CartLineCopyWithImpl;
@override @useResult
$Res call({
 String key, String productId, String name, int unitPriceMinor, int qtyMilli, int taxRateBp, bool priceIncludesTax, bool trackStock, String? kitchenStationId, String? note
});




}
/// @nodoc
class __$CartLineCopyWithImpl<$Res>
    implements _$CartLineCopyWith<$Res> {
  __$CartLineCopyWithImpl(this._self, this._then);

  final _CartLine _self;
  final $Res Function(_CartLine) _then;

/// Create a copy of CartLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? productId = null,Object? name = null,Object? unitPriceMinor = null,Object? qtyMilli = null,Object? taxRateBp = null,Object? priceIncludesTax = null,Object? trackStock = null,Object? kitchenStationId = freezed,Object? note = freezed,}) {
  return _then(_CartLine(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,qtyMilli: null == qtyMilli ? _self.qtyMilli : qtyMilli // ignore: cast_nullable_to_non_nullable
as int,taxRateBp: null == taxRateBp ? _self.taxRateBp : taxRateBp // ignore: cast_nullable_to_non_nullable
as int,priceIncludesTax: null == priceIncludesTax ? _self.priceIncludesTax : priceIncludesTax // ignore: cast_nullable_to_non_nullable
as bool,trackStock: null == trackStock ? _self.trackStock : trackStock // ignore: cast_nullable_to_non_nullable
as bool,kitchenStationId: freezed == kitchenStationId ? _self.kitchenStationId : kitchenStationId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$Cart {

 List<CartLine> get lines; String get orderType; String? get tableId; String? get tableName;/// Order discount in basis points (1000 = 10 %), 0 = none.
 int get discountBp;
/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartCopyWith<Cart> get copyWith => _$CartCopyWithImpl<Cart>(this as Cart, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Cart;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cart&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.orderType, _this.orderType) || other.orderType == _this.orderType)&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&(identical(other.tableName, _this.tableName) || other.tableName == _this.tableName)&&(identical(other.discountBp, _this.discountBp) || other.discountBp == _this.discountBp));
}


@override
int get hashCode {
  final _this = this as Cart;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.lines),_this.orderType,_this.tableId,_this.tableName,_this.discountBp);
}

@override
String toString() {
  final _this = this as Cart;
  return 'Cart(lines: ${_this.lines}, orderType: ${_this.orderType}, tableId: ${_this.tableId}, tableName: ${_this.tableName}, discountBp: ${_this.discountBp})';
}


}

/// @nodoc
abstract mixin class $CartCopyWith<$Res>  {
  factory $CartCopyWith(Cart value, $Res Function(Cart) _then) = _$CartCopyWithImpl;
@useResult
$Res call({
 List<CartLine> lines, String orderType, String? tableId, String? tableName, int discountBp
});




}
/// @nodoc
class _$CartCopyWithImpl<$Res>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._self, this._then);

  final Cart _self;
  final $Res Function(Cart) _then;

/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lines = null,Object? orderType = null,Object? tableId = freezed,Object? tableName = freezed,Object? discountBp = null,}) {
  return _then(Cart(
lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<CartLine>,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,tableName: freezed == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String?,discountBp: null == discountBp ? _self.discountBp : discountBp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Cart].
extension CartPatterns on Cart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cart value)  $default,){
final _that = this;
switch (_that) {
case _Cart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cart value)?  $default,){
final _that = this;
switch (_that) {
case _Cart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CartLine> lines,  String orderType,  String? tableId,  String? tableName,  int discountBp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cart() when $default != null:
return $default(_that.lines,_that.orderType,_that.tableId,_that.tableName,_that.discountBp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CartLine> lines,  String orderType,  String? tableId,  String? tableName,  int discountBp)  $default,) {final _that = this;
switch (_that) {
case _Cart():
return $default(_that.lines,_that.orderType,_that.tableId,_that.tableName,_that.discountBp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CartLine> lines,  String orderType,  String? tableId,  String? tableName,  int discountBp)?  $default,) {final _that = this;
switch (_that) {
case _Cart() when $default != null:
return $default(_that.lines,_that.orderType,_that.tableId,_that.tableName,_that.discountBp);case _:
  return null;

}
}

}

/// @nodoc


class _Cart extends Cart {
  const _Cart({ List<CartLine> lines = const <CartLine>[], this.orderType = 'TAKEAWAY', this.tableId, this.tableName, this.discountBp = 0}): _lines = lines,super._();
  

 final  List<CartLine> _lines;
@override@JsonKey() List<CartLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey() final  String orderType;
@override final  String? tableId;
@override final  String? tableName;
/// Order discount in basis points (1000 = 10 %), 0 = none.
@override@JsonKey() final  int discountBp;

/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartCopyWith<_Cart> get copyWith => __$CartCopyWithImpl<_Cart>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cart&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.discountBp, discountBp) || other.discountBp == discountBp));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_lines),orderType,tableId,tableName,discountBp);
}

@override
String toString() {
    return 'Cart(lines: $lines, orderType: $orderType, tableId: $tableId, tableName: $tableName, discountBp: $discountBp)';
}


}

/// @nodoc
abstract mixin class _$CartCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$CartCopyWith(_Cart value, $Res Function(_Cart) _then) = __$CartCopyWithImpl;
@override @useResult
$Res call({
 List<CartLine> lines, String orderType, String? tableId, String? tableName, int discountBp
});




}
/// @nodoc
class __$CartCopyWithImpl<$Res>
    implements _$CartCopyWith<$Res> {
  __$CartCopyWithImpl(this._self, this._then);

  final _Cart _self;
  final $Res Function(_Cart) _then;

/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lines = null,Object? orderType = null,Object? tableId = freezed,Object? tableName = freezed,Object? discountBp = null,}) {
  return _then(_Cart(
lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<CartLine>,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,tableName: freezed == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String?,discountBp: null == discountBp ? _self.discountBp : discountBp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
