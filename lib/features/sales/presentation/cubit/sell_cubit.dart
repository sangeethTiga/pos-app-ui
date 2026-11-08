import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/terminal/terminal_context.dart';
import '../../../catalogue/data/catalogue_repository.dart';
import '../../../shift/domain/shift_service.dart';
import '../../domain/cart.dart';
import '../../domain/checkout_service.dart';
import '../../domain/pricing_engine.dart';

part 'sell_cubit.freezed.dart';

@freezed
abstract class SellState with _$SellState {
  const SellState._();

  const factory SellState({
    @Default(true) bool loading,
    @Default(<Category>[]) List<Category> categories,
    @Default(<Product>[]) List<Product> products,
    @Default(<PaymentMethod>[]) List<PaymentMethod> paymentMethods,
    @Default(SalesSettings()) SalesSettings settings,
    String? categoryId,
    @Default('') String search,
    @Default(Cart()) Cart cart,
    PricedOrder? priced,
    @Default(false) bool shiftOpen,
    CompletedSale? lastSale,
    String? error,
  }) = _SellState;

  List<Product> get visibleProducts => products
      .where((p) => categoryId == null || p.categoryId == categoryId)
      .where(
        (p) =>
            search.isEmpty ||
            p.name.toLowerCase().contains(search.toLowerCase()) ||
            p.barcode == search ||
            p.sku == search,
      )
      .toList();
}

class SellCubit extends Cubit<SellState> {
  SellCubit(this._catalogue, this._checkout, this._shifts, this._ctx) : super(const SellState());

  final CatalogueRepository _catalogue;
  final CheckoutService _checkout;
  final ShiftService _shifts;
  final TerminalContextHolder _ctx;

  Future<void> load() async {
    emit(
      state.copyWith(
        loading: false,
        categories: await _catalogue.categories(),
        products: await _catalogue.products(storePricesIncludeTax: _ctx.ctx.pricesIncludeTax),
        paymentMethods: await _catalogue.paymentMethods(),
        settings: await _catalogue.settings(),
        shiftOpen: await _shifts.openShift() != null,
      ),
    );
  }

  void category(String? id) => emit(state.copyWith(categoryId: id));
  void searchFor(String q) => emit(state.copyWith(search: q.trim()));

  void _setCart(Cart cart) {
    PricedOrder? priced;
    try {
      priced = cart.isEmpty ? null : _checkout.price(cart, state.settings);
    } on PricingException catch (e) {
      return emit(state.copyWith(error: e.message));
    }
    emit(state.copyWith(cart: cart, priced: priced, error: null));
  }

  void add(Product p) {
    if (p.outOfStock) return emit(state.copyWith(error: '${p.name} is out of stock'));
    final lines = [...state.cart.lines];
    final i = lines.indexWhere((l) => l.productId == p.id && l.note == null);
    if (i >= 0) {
      lines[i] = lines[i].copyWith(qtyMilli: lines[i].qtyMilli + 1000);
    } else {
      lines.add(
        CartLine(
          key: const Uuid().v4(),
          productId: p.id,
          name: p.name,
          unitPriceMinor: p.priceMinor,
          qtyMilli: 1000,
          taxRateBp: p.taxRateBp,
          priceIncludesTax: p.priceIncludesTax,
          trackStock: p.trackStock,
          kitchenStationId: p.kitchenStationId,
        ),
      );
    }
    _setCart(state.cart.copyWith(lines: lines));
  }

  void changeQty(String key, int deltaUnits) {
    final lines = [
      for (final l in state.cart.lines)
        if (l.key != key)
          l
        else if (l.qtyMilli + deltaUnits * 1000 > 0)
          l.copyWith(qtyMilli: l.qtyMilli + deltaUnits * 1000),
    ];
    _setCart(state.cart.copyWith(lines: lines));
  }

  void orderType(String type) => _setCart(state.cart.copyWith(orderType: type));

  void discount(int bp) => _setCart(state.cart.copyWith(discountBp: bp));

  void clear() => _setCart(const Cart());

  Future<CompletedSale?> pay({
    required List<({PaymentMethod method, int? amountMinor})> tenders,
    required String userId,
    required String cashierName,
    int? cashTenderedMinor,
  }) async {
    try {
      final sale = await _checkout.settle(
        cart: state.cart,
        settings: state.settings,
        tenders: tenders,
        userId: userId,
        cashierName: cashierName,
        cashTenderedMinor: cashTenderedMinor,
      );
      emit(state.copyWith(cart: const Cart(), priced: null, lastSale: sale, error: null));
      return sale;
    } on SaleException catch (e) {
      emit(state.copyWith(error: e.message));
      return null;
    }
  }

  Future<void> refreshShift() async => emit(state.copyWith(shiftOpen: await _shifts.openShift() != null));
}
