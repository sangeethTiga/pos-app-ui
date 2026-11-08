import 'package:uuid/uuid.dart';

import '../../../core/sync/local_store.dart';
import '../../staff/data/staff_repository.dart';

class DiningTableInfo {
  const DiningTableInfo({required this.id, required this.name, required this.area, required this.capacity});
  final String id, name;
  final String? area;
  final int capacity;
}

class CaptainInfo {
  const CaptainInfo(this.id, this.name);
  final String id, name;
}

class DeliveryPartnerInfo {
  const DeliveryPartnerInfo(this.id, this.name);
  final String id, name;
}

class CustomerAddress {
  const CustomerAddress({this.id, this.flat, this.building, this.street, this.city, this.area});
  final String? id, flat, building, street, city, area;

  String get oneLine => [flat, building, street, area, city].where((v) => v != null && v.trim().isNotEmpty).join(', ');
}

class CustomerInfo {
  const CustomerInfo({required this.id, required this.name, this.mobile, this.email, this.address});
  final String id, name;
  final String? mobile, email;
  final CustomerAddress? address;
}

/// Read and write side of the home screen's popups: tables, captains, delivery partners,
/// delivery areas and customers (all from the terminal's local replica).
class HomeRepository {
  HomeRepository(this._store, this._staff, [this._onCommit]);

  final LocalStore _store;
  final StaffRepository _staff;
  final void Function()? _onCommit;

  static bool _active(LocalRecord r) => r.data['active'] != false && r.data['active'] != 0;

  Future<List<DiningTableInfo>> tables() async {
    final areas = {for (final a in await _store.all('dining_area')) a.id: a.data['name'] as String?};
    final list = [
      for (final r in await _store.all('dining_table'))
        if (_active(r))
          DiningTableInfo(
            id: r.id,
            name: r.data['name'] as String? ?? '',
            area: areas[r.data['area_id']] ?? r.data['area'] as String?,
            capacity: (r.data['seats'] as num?)?.toInt() ?? 2,
          ),
    ];
    int tableNo(String s) => int.tryParse(RegExp(r'\d+').firstMatch(s)?.group(0) ?? '') ?? 0;
    return list..sort((a, b) {
      final byArea = (a.area ?? '').compareTo(b.area ?? '');
      return byArea != 0
          ? byArea
          : (tableNo(a.name) != tableNo(b.name) ? tableNo(a.name) - tableNo(b.name) : a.name.compareTo(b.name));
    });
  }

  /// Staff with the Captain role in this store.
  Future<List<CaptainInfo>> captains() async => [
    for (final u in await _staff.users())
      if (u.canLoginOn('CAPTAIN')) CaptainInfo(u.id, u.name),
  ];

  Future<List<DeliveryPartnerInfo>> deliveryPartners() async {
    final rows = (await _store.all('delivery_partner')).where(_active).toList()
      ..sort((a, b) => ((a.data['sort_order'] as num?) ?? 0).compareTo((b.data['sort_order'] as num?) ?? 0));
    return [for (final r in rows) DeliveryPartnerInfo(r.id, r.data['name'] as String? ?? '')];
  }

  /// Store setting `delivery_areas`.
  Future<List<String>> deliveryAreas() async {
    for (final r in await _store.all('store_setting')) {
      if (r.data['key'] != 'delivery_areas') continue;
      var v = r.data['value'];
      if (v is Map && v.containsKey('v')) v = v['v'];
      if (v is List) {
        return [
          for (final a in v)
            if (a is String) a,
        ];
      }
    }
    return const [];
  }

  Future<List<CustomerInfo>> customers({String query = ''}) async {
    final addresses = <String, CustomerAddress>{};
    for (final a in await _store.all('customer_address')) {
      addresses[a.data['customer_id'] as String? ?? ''] = CustomerAddress(
        id: a.id,
        flat: a.data['flat'] as String?,
        building: a.data['building'] as String?,
        street: a.data['street'] as String?,
        city: a.data['city'] as String?,
        area: a.data['area'] as String?,
      );
    }
    final q = query.trim().toLowerCase();
    final list = [
      for (final r in await _store.all('customer'))
        if (q.isEmpty ||
            (r.data['name'] as String? ?? '').toLowerCase().contains(q) ||
            (r.data['mobile'] as String? ?? '').replaceAll(' ', '').contains(q.replaceAll(' ', '')))
          CustomerInfo(
            id: r.id,
            name: r.data['name'] as String? ?? '',
            mobile: r.data['mobile'] as String?,
            email: r.data['email'] as String?,
            address: addresses[r.id],
          ),
    ];
    return list..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  /// Creates or updates the customer and their delivery address (one local transaction).
  Future<CustomerInfo> saveCustomer({
    String? id,
    required String name,
    required String mobile,
    String? email,
    required CustomerAddress address,
    required String userId,
  }) async {
    String? blank(String? v) => v == null || v.trim().isEmpty ? null : v.trim();
    final customerId = id ?? const Uuid().v7();
    final fields = {'name': name.trim(), 'mobile': mobile.trim(), 'email': blank(email)};
    final addressFields = {
      'customer_id': customerId,
      'flat': blank(address.flat),
      'building': blank(address.building),
      'street': blank(address.street),
      'city': blank(address.city),
      'area': blank(address.area),
    };
    final hasAddress = addressFields.entries.any((e) => e.key != 'customer_id' && e.value != null);
    final changes = [
      if (id == null)
        LocalChange.insert('customer', fields, id: customerId)
      else
        LocalChange.update('customer', id, fields),
      if (hasAddress)
        address.id == null
            ? LocalChange.insert('customer_address', addressFields)
            : LocalChange.update('customer_address', address.id!, addressFields),
    ];
    await _store.commit(changes, userId: userId);
    _onCommit?.call();
    return (await customers()).firstWhere((c) => c.id == customerId);
  }

  /// Product ids by quantity sold on this terminal, most first (the "Fast Moving" category).
  Future<List<String>> fastMovingProductIds({int limit = 24}) async {
    final qty = <String, int>{};
    for (final r in await _store.all('order_line')) {
      final p = r.data['product_id'] as String?;
      if (p != null) {
        qty[p] = (qty[p] ?? 0) + ((r.data['qty_milli'] as num?)?.toInt() ?? 0);
      }
    }
    final ids = qty.keys.toList()..sort((a, b) => qty[b]!.compareTo(qty[a]!));
    return ids.take(limit).toList();
  }

  /// Barcode -> product id, from product.barcode and product_barcode rows.
  Future<String?> productForBarcode(String code) async {
    final c = code.trim();
    if (c.isEmpty) return null;
    for (final r in await _store.all('product_barcode')) {
      if (r.data['barcode'] == c) return r.data['product_id'] as String?;
    }
    for (final r in await _store.all('product')) {
      if (r.data['barcode'] == c || r.data['sku'] == c) return r.id;
    }
    return null;
  }
}
