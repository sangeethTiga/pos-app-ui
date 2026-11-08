import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/terminal/terminal_context.dart';
import '../../../catalogue/data/catalogue_repository.dart';
import '../../../shift/domain/shift_service.dart';
import '../../data/home_repository.dart';
import '../../domain/cart.dart';
import '../../domain/checkout_service.dart';
import '../../domain/order_manager.dart';
import '../../domain/order_service.dart';
import '../../domain/pricing_engine.dart';

part 'sell_cubit.freezed.dart';

/// Category id of the "Fast Moving" tile (best sellers on this terminal).
const fastMovingId = '__fast_moving';

@freezed
abstract class SellState with _$SellState {
  const SellState._();

  const factory SellState({
    @Default(true) bool loading,
    @Default(<Category>[]) List<Category> categories,
    @Default(<Product>[]) List<Product> products,
    @Default(<PaymentMethod>[]) List<PaymentMethod> paymentMethods,
    @Default(SalesSettings()) SalesSettings settings,
    @Default(<String>[]) List<String> fastMovingIds,

    /// null = all products; [fastMovingId] = best sellers.
    String? categoryId,
    @Default('') String search,
    @Default(0) int page,
    @Default(Cart()) Cart cart,

    /// Cart line last added or changed (highlighted while editing an order).
    String? selectedKey,
    PricedOrder? priced,
    @Default(false) bool shiftOpen,
    @Default(<HeldCart>[]) List<HeldCart> held,
    @Default(true) bool showPrices,
    @Default(false) bool busy,
    CompletedSale? lastSale,
    PlacedOrder? lastPlaced,
    String? error,

    /// Short confirmation for a snackbar ("Order P1-000004 placed").
    String? info,
  }) = _SellState;

  List<Product> get visibleProducts {
    final q = search.toLowerCase();
    if (q.isNotEmpty) {
      return products.where((p) => p.name.toLowerCase().contains(q) || p.barcode == search || p.sku == search).toList();
    }
    if (categoryId == fastMovingId) {
      final byId = {for (final p in products) p.id: p};
      final fast = [for (final id in fastMovingIds) ?byId[id]];
      return fast.isNotEmpty ? fast : products;
    }
    return products.where((p) => categoryId == null || p.categoryId == categoryId).toList();
  }
}

class SellCubit extends Cubit<SellState> {
  SellCubit(this._catalogue, this._checkout, this._shifts, this._ctx, this._orders, this._home, this._manager)
    : super(const SellState()) {
    _intentSub = _manager.intents.listen((_) => _takeIntent());
  }

  late final StreamSubscription<void> _intentSub;

  final CatalogueRepository _catalogue;
  final CheckoutService _checkout;
  final ShiftService _shifts;
  final TerminalContextHolder _ctx;
  final OrderService _orders;
  final HomeRepository _home;
  final OrderManager _manager;

  bool get isCaptainDevice => _ctx.ctx.isCaptain;

  Future<void> load() async {
    final categories = await _catalogue.categories();
    emit(
      state.copyWith(
        loading: false,
        categories: categories,
        products: await _catalogue.products(storePricesIncludeTax: _ctx.ctx.pricesIncludeTax),
        paymentMethods: await _catalogue.paymentMethods(),
        settings: await _catalogue.settings(),
        fastMovingIds: await _home.fastMovingProductIds(),
        shiftOpen: await _shifts.openShift() != null,
        held: await _orders.heldCarts(),
        categoryId: state.categoryId ?? fastMovingId,
      ),
    );
    _takeIntent();
  }

  /// An order opened with Edit Order replaces the cart.
  void _takeIntent() {
    final intent = _manager.homeIntent;
    if (intent == null || isClosed) return;
    _manager.homeIntent = null;
    _setCart(intent);
    emit(state.copyWith(selectedKey: null, info: 'Editing ${intent.existingOrderNo}'));
  }

  @override
  Future<void> close() async {
    await _intentSub.cancel();
    return super.close();
  }

  void category(String? id) => emit(state.copyWith(categoryId: id, page: 0, search: ''));
  void searchFor(String q) => emit(state.copyWith(search: q.trim(), page: 0));
  void setPage(int page) => emit(state.copyWith(page: page < 0 ? 0 : page));
  void togglePrices() => emit(state.copyWith(showPrices: !state.showPrices));

  void _setCart(Cart cart) {
    PricedOrder? priced;
    try {
      priced = cart.isEmpty ? null : _checkout.price(cart, state.settings);
    } on PricingException catch (e) {
      return emit(state.copyWith(error: e.message));
    }
    emit(state.copyWith(cart: cart, priced: priced, error: null, info: null));
  }

  void _err(String m) => emit(state.copyWith(error: m, info: null));

  // ---- lines ------------------------------------------------------------------------------

  /// Each tap is a new line on top of the cart and becomes the selected line (same for a new order
  /// and for Edit Order); + / - on a line changes its quantity.
  void add(Product p) {
    if (p.outOfStock) return _err('${p.name} is out of stock');
    final key = const Uuid().v4();
    emit(state.copyWith(selectedKey: key));
    _setCart(
      state.cart.copyWith(
        lines: [
          CartLine(
            key: key,
            productId: p.id,
            name: p.name,
            unitPriceMinor: p.priceMinor,
            qtyMilli: 1000,
            taxRateBp: p.taxRateBp,
            priceIncludesTax: p.priceIncludesTax,
            trackStock: p.trackStock,
            kitchenStationId: p.kitchenStationId,
          ),
          ...state.cart.lines,
        ],
      ),
    );
  }

  /// Barcode field + Enter.
  Future<bool> addBarcode(String code) async {
    final id = await _home.productForBarcode(code);
    final p = state.products.where((p) => p.id == id).firstOrNull;
    if (p == null) {
      _err('No product with barcode $code');
      return false;
    }
    add(p);
    return true;
  }

  void changeQty(String key, int deltaUnits) {
    emit(state.copyWith(selectedKey: key));
    final lines = [
      for (final l in state.cart.lines)
        if (l.key != key)
          l
        else if (l.qtyMilli + deltaUnits * 1000 > 0)
          l.copyWith(qtyMilli: l.qtyMilli + deltaUnits * 1000),
    ];
    _setCart(state.cart.copyWith(lines: lines));
  }

  void updateLine(String key, {required int qtyMilli, String? note}) => _setCart(
    state.cart.copyWith(
      lines: [
        for (final l in state.cart.lines)
          if (l.key != key)
            l
          else if (qtyMilli > 0)
            l.copyWith(qtyMilli: qtyMilli, note: note == null || note.trim().isEmpty ? null : note.trim()),
      ],
    ),
  );

  /// Open Food: an item typed at the till (no product).
  void openFood({required String name, required int priceMinor, int qtyUnits = 1}) {
    final defaultTax = state.products.firstOrNull?.taxRateBp ?? 0;
    _setCart(
      state.cart.copyWith(
        lines: [
          ...state.cart.lines,
          CartLine(
            key: const Uuid().v4(),
            name: name.trim(),
            unitPriceMinor: priceMinor,
            qtyMilli: qtyUnits * 1000,
            taxRateBp: defaultTax,
            priceIncludesTax: _ctx.ctx.pricesIncludeTax,
            trackStock: false,
          ),
        ],
      ),
    );
  }

  void kitchenNote(String note) => _setCart(state.cart.copyWith(kitchenNote: note.trim().isEmpty ? null : note.trim()));

  void discount(int bp) => _setCart(state.cart.copyWith(discountBp: bp));

  /// Delivery charge as the guest pays it (minor units), 0 removes it.
  void deliveryCharge(int minor) => _setCart(state.cart.copyWith(deliveryChargeMinor: minor < 0 ? 0 : minor));

  // ---- order type ---------------------------------------------------------------------------

  Cart get _base => state.cart.copyWith(
    tableId: null,
    tableName: null,
    guests: null,
    existingOrderId: null,
    existingOrderNo: null,
    customerId: null,
    customerName: null,
    customerMobile: null,
    carhop: false,
    carNo: null,
    deliveryPartnerId: null,
    deliveryPartnerName: null,
    partnerOrderNo: null,
  );

  void takeaway() => _setCart(_base.copyWith(orderType: Channel.takeaway));

  /// Dine in on [table]. A table with a running order opens that order for editing, with any items
  /// already in the cart added to it.
  Future<void> dineIn({
    required DiningTableInfo table,
    required int guests,
    OpenOrder? running,
    CaptainInfo? captain,
  }) async {
    if (running != null && running.id != state.cart.existingOrderId) {
      try {
        final order = await _manager.editCart(running.id);
        final fresh = state.cart.existingOrderId == null ? state.cart.lines : const <CartLine>[];
        return _setCart(order.copyWith(lines: [...order.lines, ...fresh], heldCartId: state.cart.heldCartId));
      } on SaleException catch (e) {
        return _err(e.message);
      }
    }
    _setCart(
      _base.copyWith(
        orderType: Channel.dineIn,
        tableId: table.id,
        tableName: table.name,
        guests: guests,
        existingOrderId: running?.id,
        existingOrderNo: running?.orderNo,
        captainId: captain?.id ?? state.cart.captainId,
        captainName: captain?.name ?? state.cart.captainName,
      ),
    );
  }

  void homeDelivery({required CustomerInfo customer, bool carhop = false, String? carNo}) => _setCart(
    _base.copyWith(
      orderType: Channel.homeDelivery,
      customerId: customer.id,
      customerName: customer.name,
      customerMobile: customer.mobile,
      carhop: carhop,
      carNo: carhop ? carNo : null,
    ),
  );

  void partner({required DeliveryPartnerInfo partner, String? orderNo}) => _setCart(
    _base.copyWith(
      orderType: Channel.homeDelivery,
      deliveryPartnerId: partner.id,
      deliveryPartnerName: partner.name,
      partnerOrderNo: orderNo == null || orderNo.trim().isEmpty ? null : orderNo.trim(),
    ),
  );

  void newOrder() => _setCart(const Cart());

  // ---- actions --------------------------------------------------------------------------------

  Future<void> refresh() async {
    await load();
    emit(state.copyWith(info: 'Menu and settings reloaded'));
  }

  Future<void> hold(String userId) async {
    if (state.busy) return;
    emit(state.copyWith(busy: true));
    try {
      final label = await _orders.hold(cart: state.cart, settings: state.settings, userId: userId);
      emit(
        state.copyWith(
          busy: false,
          cart: const Cart(),
          priced: null,
          held: await _orders.heldCarts(),
          info: 'Held: $label',
          error: null,
        ),
      );
    } on SaleException catch (e) {
      emit(state.copyWith(busy: false, error: e.message));
    }
  }

  Future<void> recall(HeldCart h) async {
    if (!state.cart.isEmpty) return _err('Finish or hold the current order first.');
    _setCart(_orders.recall(h));
  }

  Future<void> discardHeld(HeldCart h, String userId) async {
    await _orders.discardHeld(h.id, userId);
    emit(state.copyWith(held: await _orders.heldCarts()));
  }

  /// Place Order (KOT to the kitchen, paid later from Orders), or Update Order for an order opened
  /// with Edit Order. [canReduce]: the user may lower items already sent to the kitchen.
  Future<PlacedOrder?> place(String userId, {bool canReduce = true}) async {
    if (state.busy) return null;
    if (state.cart.orderType == Channel.dineIn && state.cart.tableId == null) {
      _err('Choose a table for dine-in.');
      return null;
    }
    emit(state.copyWith(busy: true));
    try {
      final placed = state.cart.existingOrderId != null
          ? await _orders.update(cart: state.cart, settings: state.settings, userId: userId, canReduce: canReduce)
          : await _orders.place(cart: state.cart, settings: state.settings, userId: userId);
      emit(
        state.copyWith(
          busy: false,
          cart: const Cart(),
          priced: null,
          lastPlaced: placed,
          held: await _orders.heldCarts(),
          info: placed.kind == 'NEW'
              ? 'Order ${placed.orderNo} placed · KOT ${placed.tokenNo}'
              : 'Order ${placed.orderNo} updated',
          error: null,
        ),
      );
      return placed;
    } on SaleException catch (e) {
      emit(state.copyWith(busy: false, error: e.message));
      return null;
    }
  }

  /// Quick Update Order: save the edited order without a KOT and settle it now.
  Future<CompletedSale?> quickUpdate({
    required List<({PaymentMethod method, int? amountMinor})> tenders,
    required String userId,
    required String cashierName,
    int? cashTenderedMinor,
    bool canReduce = true,
  }) async {
    if (state.busy) return null;
    emit(state.copyWith(busy: true));
    try {
      final placed = await _orders.update(
        cart: state.cart,
        settings: state.settings,
        userId: userId,
        sendKot: false,
        canReduce: canReduce,
      );
      final sale = await _checkout.settleOrder(
        orderId: placed.orderId,
        settings: state.settings,
        tenders: tenders,
        userId: userId,
        cashierName: cashierName,
        cashTenderedMinor: cashTenderedMinor,
      );
      emit(
        state.copyWith(
          busy: false,
          cart: const Cart(),
          priced: null,
          lastSale: sale,
          held: await _orders.heldCarts(),
          fastMovingIds: await _home.fastMovingProductIds(),
          error: null,
        ),
      );
      return sale;
    } on SaleException catch (e) {
      emit(state.copyWith(busy: false, error: e.message));
      return null;
    }
  }

  /// Quick Order (No KOT): paid now, nothing printed for the kitchen.
  Future<CompletedSale?> pay({
    required List<({PaymentMethod method, int? amountMinor})> tenders,
    required String userId,
    required String cashierName,
    int? cashTenderedMinor,
    bool sendKot = false,
  }) async {
    try {
      final heldId = state.cart.heldCartId;
      final sale = await _checkout.settle(
        cart: state.cart,
        settings: state.settings,
        tenders: tenders,
        userId: userId,
        cashierName: cashierName,
        cashTenderedMinor: cashTenderedMinor,
        sendKot: sendKot,
      );
      if (heldId != null) await _orders.closeHeld(heldId, userId);
      emit(
        state.copyWith(
          cart: const Cart(),
          priced: null,
          lastSale: sale,
          held: await _orders.heldCarts(),
          fastMovingIds: await _home.fastMovingProductIds(),
          error: null,
        ),
      );
      return sale;
    } on SaleException catch (e) {
      emit(state.copyWith(error: e.message));
      return null;
    }
  }

  Future<void> refreshShift() async => emit(state.copyWith(shiftOpen: await _shifts.openShift() != null));
}
