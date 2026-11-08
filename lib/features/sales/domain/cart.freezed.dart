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

 String get key;/// null for an open-food item (typed name and price, FR-CAT-07).
 String? get productId; String get name; int get unitPriceMinor; int get qtyMilli; int get taxRateBp; bool get priceIncludesTax; bool get trackStock; String? get kitchenStationId; String? get note;
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
 String key, String? productId, String name, int unitPriceMinor, int qtyMilli, int taxRateBp, bool priceIncludesTax, bool trackStock, String? kitchenStationId, String? note
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
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? productId = freezed,Object? name = null,Object? unitPriceMinor = null,Object? qtyMilli = null,Object? taxRateBp = null,Object? priceIncludesTax = null,Object? trackStock = null,Object? kitchenStationId = freezed,Object? note = freezed,}) {
  return _then(CartLine(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String? productId,  String name,  int unitPriceMinor,  int qtyMilli,  int taxRateBp,  bool priceIncludesTax,  bool trackStock,  String? kitchenStationId,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String? productId,  String name,  int unitPriceMinor,  int qtyMilli,  int taxRateBp,  bool priceIncludesTax,  bool trackStock,  String? kitchenStationId,  String? note)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String? productId,  String name,  int unitPriceMinor,  int qtyMilli,  int taxRateBp,  bool priceIncludesTax,  bool trackStock,  String? kitchenStationId,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _CartLine() when $default != null:
return $default(_that.key,_that.productId,_that.name,_that.unitPriceMinor,_that.qtyMilli,_that.taxRateBp,_that.priceIncludesTax,_that.trackStock,_that.kitchenStationId,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _CartLine extends CartLine {
  const _CartLine({required this.key, this.productId, required this.name, required this.unitPriceMinor, required this.qtyMilli, required this.taxRateBp, required this.priceIncludesTax, required this.trackStock, this.kitchenStationId, this.note}): super._();
  

@override final  String key;
/// null for an open-food item (typed name and price, FR-CAT-07).
@override final  String? productId;
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
 String key, String? productId, String name, int unitPriceMinor, int qtyMilli, int taxRateBp, bool priceIncludesTax, bool trackStock, String? kitchenStationId, String? note
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
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? productId = freezed,Object? name = null,Object? unitPriceMinor = null,Object? qtyMilli = null,Object? taxRateBp = null,Object? priceIncludesTax = null,Object? trackStock = null,Object? kitchenStationId = freezed,Object? note = freezed,}) {
  return _then(_CartLine(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
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

 List<CartLine> get lines;/// Wire order type: DINE_IN | TAKEAWAY | DELIVERY | PICKUP.
 String get orderType; String? get tableId; String? get tableName;/// PAX (guests) for dine-in.
 int? get guests;/// Items go to this running order (occupied table) instead of a new one.
 String? get existingOrderId; String? get existingOrderNo; String? get captainId; String? get captainName; String? get customerId; String? get customerName; String? get customerMobile; bool get carhop; String? get carNo; String? get deliveryPartnerId; String? get deliveryPartnerName; String? get partnerOrderNo; String? get kitchenNote;/// Order discount in basis points (1000 = 10 %), 0 = none.
 int get discountBp;/// Recalled from Held Orders.
 String? get heldCartId;
/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartCopyWith<Cart> get copyWith => _$CartCopyWithImpl<Cart>(this as Cart, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Cart;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cart&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.orderType, _this.orderType) || other.orderType == _this.orderType)&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&(identical(other.tableName, _this.tableName) || other.tableName == _this.tableName)&&(identical(other.guests, _this.guests) || other.guests == _this.guests)&&(identical(other.existingOrderId, _this.existingOrderId) || other.existingOrderId == _this.existingOrderId)&&(identical(other.existingOrderNo, _this.existingOrderNo) || other.existingOrderNo == _this.existingOrderNo)&&(identical(other.captainId, _this.captainId) || other.captainId == _this.captainId)&&(identical(other.captainName, _this.captainName) || other.captainName == _this.captainName)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&(identical(other.customerMobile, _this.customerMobile) || other.customerMobile == _this.customerMobile)&&(identical(other.carhop, _this.carhop) || other.carhop == _this.carhop)&&(identical(other.carNo, _this.carNo) || other.carNo == _this.carNo)&&(identical(other.deliveryPartnerId, _this.deliveryPartnerId) || other.deliveryPartnerId == _this.deliveryPartnerId)&&(identical(other.deliveryPartnerName, _this.deliveryPartnerName) || other.deliveryPartnerName == _this.deliveryPartnerName)&&(identical(other.partnerOrderNo, _this.partnerOrderNo) || other.partnerOrderNo == _this.partnerOrderNo)&&(identical(other.kitchenNote, _this.kitchenNote) || other.kitchenNote == _this.kitchenNote)&&(identical(other.discountBp, _this.discountBp) || other.discountBp == _this.discountBp)&&(identical(other.heldCartId, _this.heldCartId) || other.heldCartId == _this.heldCartId));
}


@override
int get hashCode {
  final _this = this as Cart;
  return Object.hashAll([runtimeType,const DeepCollectionEquality().hash(_this.lines),_this.orderType,_this.tableId,_this.tableName,_this.guests,_this.existingOrderId,_this.existingOrderNo,_this.captainId,_this.captainName,_this.customerId,_this.customerName,_this.customerMobile,_this.carhop,_this.carNo,_this.deliveryPartnerId,_this.deliveryPartnerName,_this.partnerOrderNo,_this.kitchenNote,_this.discountBp,_this.heldCartId]);
}

@override
String toString() {
  final _this = this as Cart;
  return 'Cart(lines: ${_this.lines}, orderType: ${_this.orderType}, tableId: ${_this.tableId}, tableName: ${_this.tableName}, guests: ${_this.guests}, existingOrderId: ${_this.existingOrderId}, existingOrderNo: ${_this.existingOrderNo}, captainId: ${_this.captainId}, captainName: ${_this.captainName}, customerId: ${_this.customerId}, customerName: ${_this.customerName}, customerMobile: ${_this.customerMobile}, carhop: ${_this.carhop}, carNo: ${_this.carNo}, deliveryPartnerId: ${_this.deliveryPartnerId}, deliveryPartnerName: ${_this.deliveryPartnerName}, partnerOrderNo: ${_this.partnerOrderNo}, kitchenNote: ${_this.kitchenNote}, discountBp: ${_this.discountBp}, heldCartId: ${_this.heldCartId})';
}


}

/// @nodoc
abstract mixin class $CartCopyWith<$Res>  {
  factory $CartCopyWith(Cart value, $Res Function(Cart) _then) = _$CartCopyWithImpl;
@useResult
$Res call({
 List<CartLine> lines, String orderType, String? tableId, String? tableName, int? guests, String? existingOrderId, String? existingOrderNo, String? captainId, String? captainName, String? customerId, String? customerName, String? customerMobile, bool carhop, String? carNo, String? deliveryPartnerId, String? deliveryPartnerName, String? partnerOrderNo, String? kitchenNote, int discountBp, String? heldCartId
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
@pragma('vm:prefer-inline') @override $Res call({Object? lines = null,Object? orderType = null,Object? tableId = freezed,Object? tableName = freezed,Object? guests = freezed,Object? existingOrderId = freezed,Object? existingOrderNo = freezed,Object? captainId = freezed,Object? captainName = freezed,Object? customerId = freezed,Object? customerName = freezed,Object? customerMobile = freezed,Object? carhop = null,Object? carNo = freezed,Object? deliveryPartnerId = freezed,Object? deliveryPartnerName = freezed,Object? partnerOrderNo = freezed,Object? kitchenNote = freezed,Object? discountBp = null,Object? heldCartId = freezed,}) {
  return _then(Cart(
lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<CartLine>,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,tableName: freezed == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String?,guests: freezed == guests ? _self.guests : guests // ignore: cast_nullable_to_non_nullable
as int?,existingOrderId: freezed == existingOrderId ? _self.existingOrderId : existingOrderId // ignore: cast_nullable_to_non_nullable
as String?,existingOrderNo: freezed == existingOrderNo ? _self.existingOrderNo : existingOrderNo // ignore: cast_nullable_to_non_nullable
as String?,captainId: freezed == captainId ? _self.captainId : captainId // ignore: cast_nullable_to_non_nullable
as String?,captainName: freezed == captainName ? _self.captainName : captainName // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerMobile: freezed == customerMobile ? _self.customerMobile : customerMobile // ignore: cast_nullable_to_non_nullable
as String?,carhop: null == carhop ? _self.carhop : carhop // ignore: cast_nullable_to_non_nullable
as bool,carNo: freezed == carNo ? _self.carNo : carNo // ignore: cast_nullable_to_non_nullable
as String?,deliveryPartnerId: freezed == deliveryPartnerId ? _self.deliveryPartnerId : deliveryPartnerId // ignore: cast_nullable_to_non_nullable
as String?,deliveryPartnerName: freezed == deliveryPartnerName ? _self.deliveryPartnerName : deliveryPartnerName // ignore: cast_nullable_to_non_nullable
as String?,partnerOrderNo: freezed == partnerOrderNo ? _self.partnerOrderNo : partnerOrderNo // ignore: cast_nullable_to_non_nullable
as String?,kitchenNote: freezed == kitchenNote ? _self.kitchenNote : kitchenNote // ignore: cast_nullable_to_non_nullable
as String?,discountBp: null == discountBp ? _self.discountBp : discountBp // ignore: cast_nullable_to_non_nullable
as int,heldCartId: freezed == heldCartId ? _self.heldCartId : heldCartId // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CartLine> lines,  String orderType,  String? tableId,  String? tableName,  int? guests,  String? existingOrderId,  String? existingOrderNo,  String? captainId,  String? captainName,  String? customerId,  String? customerName,  String? customerMobile,  bool carhop,  String? carNo,  String? deliveryPartnerId,  String? deliveryPartnerName,  String? partnerOrderNo,  String? kitchenNote,  int discountBp,  String? heldCartId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cart() when $default != null:
return $default(_that.lines,_that.orderType,_that.tableId,_that.tableName,_that.guests,_that.existingOrderId,_that.existingOrderNo,_that.captainId,_that.captainName,_that.customerId,_that.customerName,_that.customerMobile,_that.carhop,_that.carNo,_that.deliveryPartnerId,_that.deliveryPartnerName,_that.partnerOrderNo,_that.kitchenNote,_that.discountBp,_that.heldCartId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CartLine> lines,  String orderType,  String? tableId,  String? tableName,  int? guests,  String? existingOrderId,  String? existingOrderNo,  String? captainId,  String? captainName,  String? customerId,  String? customerName,  String? customerMobile,  bool carhop,  String? carNo,  String? deliveryPartnerId,  String? deliveryPartnerName,  String? partnerOrderNo,  String? kitchenNote,  int discountBp,  String? heldCartId)  $default,) {final _that = this;
switch (_that) {
case _Cart():
return $default(_that.lines,_that.orderType,_that.tableId,_that.tableName,_that.guests,_that.existingOrderId,_that.existingOrderNo,_that.captainId,_that.captainName,_that.customerId,_that.customerName,_that.customerMobile,_that.carhop,_that.carNo,_that.deliveryPartnerId,_that.deliveryPartnerName,_that.partnerOrderNo,_that.kitchenNote,_that.discountBp,_that.heldCartId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CartLine> lines,  String orderType,  String? tableId,  String? tableName,  int? guests,  String? existingOrderId,  String? existingOrderNo,  String? captainId,  String? captainName,  String? customerId,  String? customerName,  String? customerMobile,  bool carhop,  String? carNo,  String? deliveryPartnerId,  String? deliveryPartnerName,  String? partnerOrderNo,  String? kitchenNote,  int discountBp,  String? heldCartId)?  $default,) {final _that = this;
switch (_that) {
case _Cart() when $default != null:
return $default(_that.lines,_that.orderType,_that.tableId,_that.tableName,_that.guests,_that.existingOrderId,_that.existingOrderNo,_that.captainId,_that.captainName,_that.customerId,_that.customerName,_that.customerMobile,_that.carhop,_that.carNo,_that.deliveryPartnerId,_that.deliveryPartnerName,_that.partnerOrderNo,_that.kitchenNote,_that.discountBp,_that.heldCartId);case _:
  return null;

}
}

}

/// @nodoc


class _Cart extends Cart {
  const _Cart({ List<CartLine> lines = const <CartLine>[], this.orderType = 'TAKEAWAY', this.tableId, this.tableName, this.guests, this.existingOrderId, this.existingOrderNo, this.captainId, this.captainName, this.customerId, this.customerName, this.customerMobile, this.carhop = false, this.carNo, this.deliveryPartnerId, this.deliveryPartnerName, this.partnerOrderNo, this.kitchenNote, this.discountBp = 0, this.heldCartId}): _lines = lines,super._();
  

 final  List<CartLine> _lines;
@override@JsonKey() List<CartLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

/// Wire order type: DINE_IN | TAKEAWAY | DELIVERY | PICKUP.
@override@JsonKey() final  String orderType;
@override final  String? tableId;
@override final  String? tableName;
/// PAX (guests) for dine-in.
@override final  int? guests;
/// Items go to this running order (occupied table) instead of a new one.
@override final  String? existingOrderId;
@override final  String? existingOrderNo;
@override final  String? captainId;
@override final  String? captainName;
@override final  String? customerId;
@override final  String? customerName;
@override final  String? customerMobile;
@override@JsonKey() final  bool carhop;
@override final  String? carNo;
@override final  String? deliveryPartnerId;
@override final  String? deliveryPartnerName;
@override final  String? partnerOrderNo;
@override final  String? kitchenNote;
/// Order discount in basis points (1000 = 10 %), 0 = none.
@override@JsonKey() final  int discountBp;
/// Recalled from Held Orders.
@override final  String? heldCartId;

/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartCopyWith<_Cart> get copyWith => __$CartCopyWithImpl<_Cart>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cart&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.guests, guests) || other.guests == guests)&&(identical(other.existingOrderId, existingOrderId) || other.existingOrderId == existingOrderId)&&(identical(other.existingOrderNo, existingOrderNo) || other.existingOrderNo == existingOrderNo)&&(identical(other.captainId, captainId) || other.captainId == captainId)&&(identical(other.captainName, captainName) || other.captainName == captainName)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerMobile, customerMobile) || other.customerMobile == customerMobile)&&(identical(other.carhop, carhop) || other.carhop == carhop)&&(identical(other.carNo, carNo) || other.carNo == carNo)&&(identical(other.deliveryPartnerId, deliveryPartnerId) || other.deliveryPartnerId == deliveryPartnerId)&&(identical(other.deliveryPartnerName, deliveryPartnerName) || other.deliveryPartnerName == deliveryPartnerName)&&(identical(other.partnerOrderNo, partnerOrderNo) || other.partnerOrderNo == partnerOrderNo)&&(identical(other.kitchenNote, kitchenNote) || other.kitchenNote == kitchenNote)&&(identical(other.discountBp, discountBp) || other.discountBp == discountBp)&&(identical(other.heldCartId, heldCartId) || other.heldCartId == heldCartId));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,const DeepCollectionEquality().hash(_lines),orderType,tableId,tableName,guests,existingOrderId,existingOrderNo,captainId,captainName,customerId,customerName,customerMobile,carhop,carNo,deliveryPartnerId,deliveryPartnerName,partnerOrderNo,kitchenNote,discountBp,heldCartId]);
}

@override
String toString() {
    return 'Cart(lines: $lines, orderType: $orderType, tableId: $tableId, tableName: $tableName, guests: $guests, existingOrderId: $existingOrderId, existingOrderNo: $existingOrderNo, captainId: $captainId, captainName: $captainName, customerId: $customerId, customerName: $customerName, customerMobile: $customerMobile, carhop: $carhop, carNo: $carNo, deliveryPartnerId: $deliveryPartnerId, deliveryPartnerName: $deliveryPartnerName, partnerOrderNo: $partnerOrderNo, kitchenNote: $kitchenNote, discountBp: $discountBp, heldCartId: $heldCartId)';
}


}

/// @nodoc
abstract mixin class _$CartCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$CartCopyWith(_Cart value, $Res Function(_Cart) _then) = __$CartCopyWithImpl;
@override @useResult
$Res call({
 List<CartLine> lines, String orderType, String? tableId, String? tableName, int? guests, String? existingOrderId, String? existingOrderNo, String? captainId, String? captainName, String? customerId, String? customerName, String? customerMobile, bool carhop, String? carNo, String? deliveryPartnerId, String? deliveryPartnerName, String? partnerOrderNo, String? kitchenNote, int discountBp, String? heldCartId
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
@override @pragma('vm:prefer-inline') $Res call({Object? lines = null,Object? orderType = null,Object? tableId = freezed,Object? tableName = freezed,Object? guests = freezed,Object? existingOrderId = freezed,Object? existingOrderNo = freezed,Object? captainId = freezed,Object? captainName = freezed,Object? customerId = freezed,Object? customerName = freezed,Object? customerMobile = freezed,Object? carhop = null,Object? carNo = freezed,Object? deliveryPartnerId = freezed,Object? deliveryPartnerName = freezed,Object? partnerOrderNo = freezed,Object? kitchenNote = freezed,Object? discountBp = null,Object? heldCartId = freezed,}) {
  return _then(_Cart(
lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<CartLine>,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,tableId: freezed == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String?,tableName: freezed == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String?,guests: freezed == guests ? _self.guests : guests // ignore: cast_nullable_to_non_nullable
as int?,existingOrderId: freezed == existingOrderId ? _self.existingOrderId : existingOrderId // ignore: cast_nullable_to_non_nullable
as String?,existingOrderNo: freezed == existingOrderNo ? _self.existingOrderNo : existingOrderNo // ignore: cast_nullable_to_non_nullable
as String?,captainId: freezed == captainId ? _self.captainId : captainId // ignore: cast_nullable_to_non_nullable
as String?,captainName: freezed == captainName ? _self.captainName : captainName // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerMobile: freezed == customerMobile ? _self.customerMobile : customerMobile // ignore: cast_nullable_to_non_nullable
as String?,carhop: null == carhop ? _self.carhop : carhop // ignore: cast_nullable_to_non_nullable
as bool,carNo: freezed == carNo ? _self.carNo : carNo // ignore: cast_nullable_to_non_nullable
as String?,deliveryPartnerId: freezed == deliveryPartnerId ? _self.deliveryPartnerId : deliveryPartnerId // ignore: cast_nullable_to_non_nullable
as String?,deliveryPartnerName: freezed == deliveryPartnerName ? _self.deliveryPartnerName : deliveryPartnerName // ignore: cast_nullable_to_non_nullable
as String?,partnerOrderNo: freezed == partnerOrderNo ? _self.partnerOrderNo : partnerOrderNo // ignore: cast_nullable_to_non_nullable
as String?,kitchenNote: freezed == kitchenNote ? _self.kitchenNote : kitchenNote // ignore: cast_nullable_to_non_nullable
as String?,discountBp: null == discountBp ? _self.discountBp : discountBp // ignore: cast_nullable_to_non_nullable
as int,heldCartId: freezed == heldCartId ? _self.heldCartId : heldCartId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
