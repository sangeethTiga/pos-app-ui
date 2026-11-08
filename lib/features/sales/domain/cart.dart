import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';

@freezed
abstract class CartLine with _$CartLine {
  const factory CartLine({
    required String key,
    required String productId,
    required String name,
    required int unitPriceMinor,
    required int qtyMilli,
    required int taxRateBp,
    required bool priceIncludesTax,
    required bool trackStock,
    String? kitchenStationId,
    String? note,
  }) = _CartLine;
}

@freezed
abstract class Cart with _$Cart {
  const Cart._();

  const factory Cart({
    @Default(<CartLine>[]) List<CartLine> lines,
    @Default('TAKEAWAY') String orderType,
    String? tableId,
    String? tableName,

    /// Order discount in basis points (1000 = 10 %), 0 = none.
    @Default(0) int discountBp,
  }) = _Cart;

  bool get isEmpty => lines.isEmpty;
  int get itemCount => lines.fold(0, (s, l) => s + l.qtyMilli ~/ 1000);
}
