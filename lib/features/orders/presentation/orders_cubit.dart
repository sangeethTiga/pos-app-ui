import 'package:bloc/bloc.dart';

import '../../catalogue/data/catalogue_repository.dart';
import '../../sales/domain/cart.dart';
import '../../sales/domain/checkout_service.dart';
import '../../sales/domain/order_manager.dart';

/// Status filter of the dashboard.
enum OrderFilter { ongoing, paid, cancelled, voided, all }

class OrdersState {
  const OrdersState({
    this.loading = true,
    this.orders = const [],
    this.channel = Channel.dineIn,
    this.filter = OrderFilter.ongoing,
    this.search = '',
    this.error,
    this.info,
  });
  final bool loading;
  final List<OrderSummary> orders;
  final String channel;
  final OrderFilter filter;
  final String search;
  final String? error, info;

  List<OrderSummary> get visible => orders.where((o) {
    if (o.channel != channel) return false;
    if (search.isNotEmpty && !o.orderNo.toLowerCase().contains(search.toLowerCase())) return false;
    return switch (filter) {
      OrderFilter.ongoing => o.ongoing,
      OrderFilter.paid => o.state == 'paid',
      OrderFilter.cancelled => o.state == 'cancelled',
      OrderFilter.voided => o.state == 'void',
      OrderFilter.all => true,
    };
  }).toList();

  int get ongoingCount => orders.where((o) => o.ongoing).length;

  OrdersState copyWith({
    bool? loading,
    List<OrderSummary>? orders,
    String? channel,
    OrderFilter? filter,
    String? search,
    String? error,
    String? info,
  }) => OrdersState(
    loading: loading ?? this.loading,
    orders: orders ?? this.orders,
    channel: channel ?? this.channel,
    filter: filter ?? this.filter,
    search: search ?? this.search,
    error: error,
    info: info,
  );
}

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._orders, this._catalogue) : super(const OrdersState());

  final OrderManager _orders;
  final CatalogueRepository _catalogue;

  Future<void> load() async => emit(state.copyWith(loading: false, orders: await _orders.summaries()));

  void channel(String c) => emit(state.copyWith(channel: c));

  /// Start on the tab of [channel] (e.g. the channel of the order just placed); unknown values keep Dine in.
  void open(String? channel) {
    const known = [Channel.dineIn, Channel.takeaway, Channel.homeDelivery, Channel.partner];
    if (known.contains(channel)) emit(state.copyWith(channel: channel, filter: OrderFilter.ongoing));
  }

  void filter(OrderFilter f) => emit(state.copyWith(filter: f));
  void search(String q) => emit(state.copyWith(search: q.trim()));

  Future<void> merge(OrderSummary source, OrderSummary target, String userId) async {
    try {
      await _orders.merge(
        sourceId: source.id,
        targetId: target.id,
        settings: await _catalogue.settings(),
        userId: userId,
      );
      emit(state.copyWith(orders: await _orders.summaries(), info: '${source.orderNo} merged into ${target.orderNo}'));
    } on SaleException catch (e) {
      emit(state.copyWith(error: e.message));
    }
  }
}
