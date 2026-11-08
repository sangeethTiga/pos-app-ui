import 'package:bloc/bloc.dart';

import '../../catalogue/data/catalogue_repository.dart';
import '../../sales/domain/checkout_service.dart';
import '../../sales/domain/order_manager.dart';

class OrderDetailState {
  const OrderDetailState({
    this.loading = true,
    this.detail,
    this.settings = const SalesSettings(),
    this.methods = const [],
    this.showDetails = true,
    this.busy = false,
    this.error,
    this.info,
  });
  final bool loading;
  final OrderDetail? detail;
  final SalesSettings settings;
  final List<PaymentMethod> methods;
  final bool showDetails, busy;
  final String? error, info;

  OrderDetailState copyWith({
    bool? loading,
    OrderDetail? detail,
    SalesSettings? settings,
    List<PaymentMethod>? methods,
    bool? showDetails,
    bool? busy,
    String? error,
    String? info,
  }) => OrderDetailState(
    loading: loading ?? this.loading,
    detail: detail ?? this.detail,
    settings: settings ?? this.settings,
    methods: methods ?? this.methods,
    showDetails: showDetails ?? this.showDetails,
    busy: busy ?? this.busy,
    error: error,
    info: info,
  );
}

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(this.orderId, this.orders, this.checkout, this._catalogue) : super(const OrderDetailState());

  final String orderId;
  final OrderManager orders;
  final CheckoutService checkout;
  final CatalogueRepository _catalogue;

  Future<void> load() async {
    final settings = await _catalogue.settings();
    emit(
      state.copyWith(
        loading: false,
        settings: settings,
        methods: await _catalogue.paymentMethods(),
        detail: await orders.detail(orderId, settings),
      ),
    );
  }

  void toggleDetails() => emit(state.copyWith(showDetails: !state.showDetails));

  /// Runs an action, reloads, and reports its message; returns false on failure.
  Future<bool> run(Future<Object?> Function() action, {String? done}) async {
    if (state.busy) return false;
    emit(state.copyWith(busy: true));
    try {
      await action();
      emit(state.copyWith(busy: false, detail: await orders.detail(orderId, state.settings), info: done));
      return true;
    } on SaleException catch (e) {
      emit(state.copyWith(busy: false, error: e.message));
      return false;
    }
  }
}
