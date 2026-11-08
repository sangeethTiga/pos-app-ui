import '../../../core/sync/local_store.dart';

class Category {
  const Category(this.id, this.name, this.sortOrder, this.color);
  final String id;
  final String name;
  final int sortOrder;
  final String? color;
}

class Product {
  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.priceMinor,
    required this.taxRateBp,
    required this.priceIncludesTax,
    required this.trackStock,
    required this.outOfStock,
    this.sku,
    this.barcode,
    this.kitchenStationId,
  });
  final String id;
  final String? categoryId;
  final String name;
  final int priceMinor;
  final int taxRateBp;
  final bool priceIncludesTax;
  final bool trackStock;
  final bool outOfStock;
  final String? sku;
  final String? barcode;
  final String? kitchenStationId;
}

class PaymentMethod {
  const PaymentMethod(this.id, this.name, this.kind, this.cashLike);
  final String id;
  final String name;
  final String kind;
  final bool cashLike;
}

/// Store settings that change the bill (from `store_setting` rows).
class SalesSettings {
  const SalesSettings({
    this.cashRoundingIncrementMinor = 1,
    this.serviceChargeBp = 0,
    this.serviceChargeTaxable = true,
    this.receiptHeader = '',
    this.receiptFooter = '',
  });
  final int cashRoundingIncrementMinor;
  final int serviceChargeBp;
  final bool serviceChargeTaxable;
  final String receiptHeader;
  final String receiptFooter;
}

bool _bool(Object? v, {bool fallback = false}) => switch (v) {
  null => fallback,
  final bool b => b,
  final num n => n != 0,
  final String s => s == '1' || s.toLowerCase() == 'true',
  _ => fallback,
};

int _int(Object? v, [int fallback = 0]) => switch (v) {
  final int i => i,
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? fallback,
  _ => fallback,
};

/// Read side of the catalogue downloaded by sync (records of entity product, category, tax ...).
class CatalogueRepository {
  const CatalogueRepository(this._store);
  final LocalStore _store;

  Future<List<Category>> categories() async {
    final rows = await _store.all('category');
    final list = [
      for (final r in rows)
        if (!_bool(r.data['hidden']))
          Category(r.id, r.data['name'] as String? ?? '', _int(r.data['sort_order']), r.data['color'] as String?),
    ];
    return list..sort((a, b) => a.sortOrder != b.sortOrder ? a.sortOrder - b.sortOrder : a.name.compareTo(b.name));
  }

  Future<List<Product>> products({required bool storePricesIncludeTax}) async {
    final taxes = {for (final t in await _store.all('tax')) t.id: t.data};
    final defaultRate = _int(
      taxes.values.firstWhere((t) => _bool(t['is_default']), orElse: () => const {'rate_bp': 0})['rate_bp'],
    );
    final rows = await _store.all('product');
    final list = [
      for (final r in rows)
        if (_bool(r.data['active'], fallback: true))
          Product(
            id: r.id,
            categoryId: r.data['category_id'] as String?,
            name: r.data['name'] as String? ?? '',
            priceMinor: _int(r.data['price_minor']),
            taxRateBp: r.data['tax_id'] != null ? _int(taxes[r.data['tax_id']]?['rate_bp'], defaultRate) : defaultRate,
            priceIncludesTax: _bool(r.data['price_includes_tax'], fallback: storePricesIncludeTax),
            trackStock: _bool(r.data['track_stock']),
            outOfStock: _bool(r.data['out_of_stock']),
            sku: r.data['sku'] as String?,
            barcode: r.data['barcode'] as String?,
            kitchenStationId: r.data['kitchen_station_id'] as String?,
          ),
    ];
    return list..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<List<PaymentMethod>> paymentMethods() async {
    final rows = (await _store.all('payment_method')).where((r) => _bool(r.data['active'], fallback: true)).toList()
      ..sort((a, b) => _int(a.data['sort_order']) - _int(b.data['sort_order']));
    return [
      for (final r in rows)
        PaymentMethod(
          r.id,
          r.data['name'] as String? ?? '',
          r.data['kind'] as String? ?? 'CUSTOM',
          _bool(r.data['is_cash_like'], fallback: r.data['kind'] == 'CASH'),
        ),
    ];
  }

  Future<SalesSettings> settings() async {
    final kv = {for (final r in await _store.all('store_setting')) r.data['key'] as String? ?? '': r.data['value']};
    return SalesSettings(
      cashRoundingIncrementMinor: _int(kv['cash_rounding_increment_minor'], 1),
      serviceChargeBp: _int(kv['service_charge_bp']),
      serviceChargeTaxable: _bool(kv['service_charge_taxable'], fallback: true),
      receiptHeader: kv['receipt_header']?.toString() ?? '',
      receiptFooter: kv['receipt_footer']?.toString() ?? '',
    );
  }
}
