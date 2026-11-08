import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';

@freezed
abstract class CartLine with _$CartLine {
  const CartLine._();

  const factory CartLine({
    required String key,

    /// null for an open-food item (typed name and price, FR-CAT-07).
    String? productId,
    required String name,
    required int unitPriceMinor,
    required int qtyMilli,
    required int taxRateBp,
    required bool priceIncludesTax,
    required bool trackStock,
    String? kitchenStationId,
    String? note,
  }) = _CartLine;

  bool get isOpenFood => productId == null;

  Map<String, dynamic> toMap() => {
    'key': key,
    'product_id': productId,
    'name': name,
    'unit_price_minor': unitPriceMinor,
    'qty_milli': qtyMilli,
    'tax_rate_bp': taxRateBp,
    'price_includes_tax': priceIncludesTax,
    'track_stock': trackStock,
    'kitchen_station_id': kitchenStationId,
    'note': note,
  };

  factory CartLine.fromMap(Map<String, dynamic> j) => CartLine(
    key: j['key'] as String,
    productId: j['product_id'] as String?,
    name: j['name'] as String? ?? '',
    unitPriceMinor: (j['unit_price_minor'] as num).toInt(),
    qtyMilli: (j['qty_milli'] as num).toInt(),
    taxRateBp: (j['tax_rate_bp'] as num?)?.toInt() ?? 0,
    priceIncludesTax: j['price_includes_tax'] as bool? ?? true,
    trackStock: j['track_stock'] as bool? ?? false,
    kitchenStationId: j['kitchen_station_id'] as String?,
    note: j['note'] as String?,
  );
}

/// Home-screen order channels (the four tabs above the cart).
abstract final class Channel {
  static const dineIn = 'DINE_IN';
  static const takeaway = 'TAKEAWAY';
  static const homeDelivery = 'DELIVERY';

  /// Aggregator order: stored as order_type DELIVERY with a delivery partner.
  static const partner = 'PARTNER';
}

@freezed
abstract class Cart with _$Cart {
  const Cart._();

  const factory Cart({
    @Default(<CartLine>[]) List<CartLine> lines,

    /// Wire order type: DINE_IN | TAKEAWAY | DELIVERY | PICKUP.
    @Default('TAKEAWAY') String orderType,
    String? tableId,
    String? tableName,

    /// PAX (guests) for dine-in.
    int? guests,

    /// Items go to this running order (occupied table) instead of a new one.
    String? existingOrderId,
    String? existingOrderNo,
    String? captainId,
    String? captainName,
    String? customerId,
    String? customerName,
    String? customerMobile,
    @Default(false) bool carhop,
    String? carNo,
    String? deliveryPartnerId,
    String? deliveryPartnerName,
    String? partnerOrderNo,
    String? kitchenNote,

    /// Order discount in basis points (1000 = 10 %), 0 = none.
    @Default(0) int discountBp,

    /// Recalled from Held Orders.
    String? heldCartId,
  }) = _Cart;

  bool get isEmpty => lines.isEmpty;
  int get itemCount => lines.fold(0, (s, l) => s + l.qtyMilli ~/ 1000);

  String get channel => deliveryPartnerId != null && orderType == 'DELIVERY' ? Channel.partner : orderType;

  /// Order columns shared by placed and settled orders.
  Map<String, dynamic> orderFields() => {
    'order_type': orderType,
    'table_id': ?tableId,
    'guests': ?guests,
    'captain_id': ?captainId,
    'customer_id': ?customerId,
    if (carhop) 'carhop': true,
    'car_no': ?carNo,
    'delivery_partner_id': ?deliveryPartnerId,
    'partner_order_no': ?partnerOrderNo,
    'note': ?kitchenNote,
  };

  /// Held-cart JSON (everything needed to recall the cart on this terminal).
  Map<String, dynamic> toMap() => {
    'lines': [for (final l in lines) l.toMap()],
    'order_type': orderType,
    'table_id': tableId,
    'table_name': tableName,
    'guests': guests,
    'existing_order_id': existingOrderId,
    'existing_order_no': existingOrderNo,
    'captain_id': captainId,
    'captain_name': captainName,
    'customer_id': customerId,
    'customer_name': customerName,
    'customer_mobile': customerMobile,
    'carhop': carhop,
    'car_no': carNo,
    'delivery_partner_id': deliveryPartnerId,
    'delivery_partner_name': deliveryPartnerName,
    'partner_order_no': partnerOrderNo,
    'kitchen_note': kitchenNote,
    'discount_bp': discountBp,
  };

  factory Cart.fromMap(Map<String, dynamic> j) => Cart(
    lines: [for (final l in (j['lines'] as List? ?? const [])) CartLine.fromMap(Map<String, dynamic>.from(l as Map))],
    orderType: j['order_type'] as String? ?? 'TAKEAWAY',
    tableId: j['table_id'] as String?,
    tableName: j['table_name'] as String?,
    guests: (j['guests'] as num?)?.toInt(),
    existingOrderId: j['existing_order_id'] as String?,
    existingOrderNo: j['existing_order_no'] as String?,
    captainId: j['captain_id'] as String?,
    captainName: j['captain_name'] as String?,
    customerId: j['customer_id'] as String?,
    customerName: j['customer_name'] as String?,
    customerMobile: j['customer_mobile'] as String?,
    carhop: j['carhop'] as bool? ?? false,
    carNo: j['car_no'] as String?,
    deliveryPartnerId: j['delivery_partner_id'] as String?,
    deliveryPartnerName: j['delivery_partner_name'] as String?,
    partnerOrderNo: j['partner_order_no'] as String?,
    kitchenNote: j['kitchen_note'] as String?,
    discountBp: (j['discount_bp'] as num?)?.toInt() ?? 0,
  );
}
