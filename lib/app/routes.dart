abstract final class Routes {
  static const splash = '/';
  static const setup = '/setup';
  static const home = '/home';
  static const lock = '/lock';
  static const sell = '/sell';
  static const printers = '/printers';
  static const orders = '/orders';

  /// Orders Dashboard opened on one channel tab (Channel.dineIn, Channel.takeaway, ...).
  static String ordersFor(String channel) => '$orders?channel=$channel';
  static String orderDetail(String id) => '/orders/$id';
}
