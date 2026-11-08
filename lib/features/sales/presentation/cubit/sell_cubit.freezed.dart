// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sell_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SellState {

 bool get loading; List<Category> get categories; List<Product> get products; List<PaymentMethod> get paymentMethods; SalesSettings get settings; String? get categoryId; String get search; Cart get cart; PricedOrder? get priced; bool get shiftOpen; CompletedSale? get lastSale; String? get error;
/// Create a copy of SellState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SellStateCopyWith<SellState> get copyWith => _$SellStateCopyWithImpl<SellState>(this as SellState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SellState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SellState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.products, _this.products)&&const DeepCollectionEquality().equals(other.paymentMethods, _this.paymentMethods)&&(identical(other.settings, _this.settings) || other.settings == _this.settings)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.search, _this.search) || other.search == _this.search)&&(identical(other.cart, _this.cart) || other.cart == _this.cart)&&(identical(other.priced, _this.priced) || other.priced == _this.priced)&&(identical(other.shiftOpen, _this.shiftOpen) || other.shiftOpen == _this.shiftOpen)&&(identical(other.lastSale, _this.lastSale) || other.lastSale == _this.lastSale)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as SellState;
  return Object.hash(runtimeType,_this.loading,const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.products),const DeepCollectionEquality().hash(_this.paymentMethods),_this.settings,_this.categoryId,_this.search,_this.cart,_this.priced,_this.shiftOpen,_this.lastSale,_this.error);
}

@override
String toString() {
  final _this = this as SellState;
  return 'SellState(loading: ${_this.loading}, categories: ${_this.categories}, products: ${_this.products}, paymentMethods: ${_this.paymentMethods}, settings: ${_this.settings}, categoryId: ${_this.categoryId}, search: ${_this.search}, cart: ${_this.cart}, priced: ${_this.priced}, shiftOpen: ${_this.shiftOpen}, lastSale: ${_this.lastSale}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $SellStateCopyWith<$Res>  {
  factory $SellStateCopyWith(SellState value, $Res Function(SellState) _then) = _$SellStateCopyWithImpl;
@useResult
$Res call({
 bool loading, List<Category> categories, List<Product> products, List<PaymentMethod> paymentMethods, SalesSettings settings, String? categoryId, String search, Cart cart, PricedOrder? priced, bool shiftOpen, CompletedSale? lastSale, String? error
});


$CartCopyWith<$Res> get cart;

}
/// @nodoc
class _$SellStateCopyWithImpl<$Res>
    implements $SellStateCopyWith<$Res> {
  _$SellStateCopyWithImpl(this._self, this._then);

  final SellState _self;
  final $Res Function(SellState) _then;

/// Create a copy of SellState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? categories = null,Object? products = null,Object? paymentMethods = null,Object? settings = null,Object? categoryId = freezed,Object? search = null,Object? cart = null,Object? priced = freezed,Object? shiftOpen = null,Object? lastSale = freezed,Object? error = freezed,}) {
  return _then(SellState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,paymentMethods: null == paymentMethods ? _self.paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<PaymentMethod>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as SalesSettings,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,cart: null == cart ? _self.cart : cart // ignore: cast_nullable_to_non_nullable
as Cart,priced: freezed == priced ? _self.priced : priced // ignore: cast_nullable_to_non_nullable
as PricedOrder?,shiftOpen: null == shiftOpen ? _self.shiftOpen : shiftOpen // ignore: cast_nullable_to_non_nullable
as bool,lastSale: freezed == lastSale ? _self.lastSale : lastSale // ignore: cast_nullable_to_non_nullable
as CompletedSale?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SellState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CartCopyWith<$Res> get cart {
  
  return $CartCopyWith<$Res>(_self.cart, (value) {
    return _then(_self.copyWith(cart: value));
  });
}
}


/// Adds pattern-matching-related methods to [SellState].
extension SellStatePatterns on SellState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SellState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SellState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SellState value)  $default,){
final _that = this;
switch (_that) {
case _SellState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SellState value)?  $default,){
final _that = this;
switch (_that) {
case _SellState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  List<Category> categories,  List<Product> products,  List<PaymentMethod> paymentMethods,  SalesSettings settings,  String? categoryId,  String search,  Cart cart,  PricedOrder? priced,  bool shiftOpen,  CompletedSale? lastSale,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SellState() when $default != null:
return $default(_that.loading,_that.categories,_that.products,_that.paymentMethods,_that.settings,_that.categoryId,_that.search,_that.cart,_that.priced,_that.shiftOpen,_that.lastSale,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  List<Category> categories,  List<Product> products,  List<PaymentMethod> paymentMethods,  SalesSettings settings,  String? categoryId,  String search,  Cart cart,  PricedOrder? priced,  bool shiftOpen,  CompletedSale? lastSale,  String? error)  $default,) {final _that = this;
switch (_that) {
case _SellState():
return $default(_that.loading,_that.categories,_that.products,_that.paymentMethods,_that.settings,_that.categoryId,_that.search,_that.cart,_that.priced,_that.shiftOpen,_that.lastSale,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  List<Category> categories,  List<Product> products,  List<PaymentMethod> paymentMethods,  SalesSettings settings,  String? categoryId,  String search,  Cart cart,  PricedOrder? priced,  bool shiftOpen,  CompletedSale? lastSale,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _SellState() when $default != null:
return $default(_that.loading,_that.categories,_that.products,_that.paymentMethods,_that.settings,_that.categoryId,_that.search,_that.cart,_that.priced,_that.shiftOpen,_that.lastSale,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SellState extends SellState {
  const _SellState({this.loading = true,  List<Category> categories = const <Category>[],  List<Product> products = const <Product>[],  List<PaymentMethod> paymentMethods = const <PaymentMethod>[], this.settings = const SalesSettings(), this.categoryId, this.search = '', this.cart = const Cart(), this.priced, this.shiftOpen = false, this.lastSale, this.error}): _categories = categories,_products = products,_paymentMethods = paymentMethods,super._();
  

@override@JsonKey() final  bool loading;
 final  List<Category> _categories;
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<Product> _products;
@override@JsonKey() List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<PaymentMethod> _paymentMethods;
@override@JsonKey() List<PaymentMethod> get paymentMethods {
  if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentMethods);
}

@override@JsonKey() final  SalesSettings settings;
@override final  String? categoryId;
@override@JsonKey() final  String search;
@override@JsonKey() final  Cart cart;
@override final  PricedOrder? priced;
@override@JsonKey() final  bool shiftOpen;
@override final  CompletedSale? lastSale;
@override final  String? error;

/// Create a copy of SellState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SellStateCopyWith<_SellState> get copyWith => __$SellStateCopyWithImpl<_SellState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SellState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.products, _products)&&const DeepCollectionEquality().equals(other.paymentMethods, _paymentMethods)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.search, search) || other.search == search)&&(identical(other.cart, cart) || other.cart == cart)&&(identical(other.priced, priced) || other.priced == priced)&&(identical(other.shiftOpen, shiftOpen) || other.shiftOpen == shiftOpen)&&(identical(other.lastSale, lastSale) || other.lastSale == lastSale)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_paymentMethods),settings,categoryId,search,cart,priced,shiftOpen,lastSale,error);
}

@override
String toString() {
    return 'SellState(loading: $loading, categories: $categories, products: $products, paymentMethods: $paymentMethods, settings: $settings, categoryId: $categoryId, search: $search, cart: $cart, priced: $priced, shiftOpen: $shiftOpen, lastSale: $lastSale, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SellStateCopyWith<$Res> implements $SellStateCopyWith<$Res> {
  factory _$SellStateCopyWith(_SellState value, $Res Function(_SellState) _then) = __$SellStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, List<Category> categories, List<Product> products, List<PaymentMethod> paymentMethods, SalesSettings settings, String? categoryId, String search, Cart cart, PricedOrder? priced, bool shiftOpen, CompletedSale? lastSale, String? error
});


@override $CartCopyWith<$Res> get cart;

}
/// @nodoc
class __$SellStateCopyWithImpl<$Res>
    implements _$SellStateCopyWith<$Res> {
  __$SellStateCopyWithImpl(this._self, this._then);

  final _SellState _self;
  final $Res Function(_SellState) _then;

/// Create a copy of SellState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? categories = null,Object? products = null,Object? paymentMethods = null,Object? settings = null,Object? categoryId = freezed,Object? search = null,Object? cart = null,Object? priced = freezed,Object? shiftOpen = null,Object? lastSale = freezed,Object? error = freezed,}) {
  return _then(_SellState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,paymentMethods: null == paymentMethods ? _self._paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<PaymentMethod>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as SalesSettings,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,cart: null == cart ? _self.cart : cart // ignore: cast_nullable_to_non_nullable
as Cart,priced: freezed == priced ? _self.priced : priced // ignore: cast_nullable_to_non_nullable
as PricedOrder?,shiftOpen: null == shiftOpen ? _self.shiftOpen : shiftOpen // ignore: cast_nullable_to_non_nullable
as bool,lastSale: freezed == lastSale ? _self.lastSale : lastSale // ignore: cast_nullable_to_non_nullable
as CompletedSale?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SellState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CartCopyWith<$Res> get cart {
  
  return $CartCopyWith<$Res>(_self.cart, (value) {
    return _then(_self.copyWith(cart: value));
  });
}
}

// dart format on
