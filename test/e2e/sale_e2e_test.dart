@Tags(['e2e'])
library;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/network/api_client.dart';
import 'package:pos_app_ui/core/network/device_auth_interceptor.dart';
import 'package:pos_app_ui/core/network/request_signer.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/terminal/terminal_context.dart';
import 'package:pos_app_ui/core/utils/result.dart';
import 'package:pos_app_ui/features/catalogue/data/catalogue_repository.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_local_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_remote_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/repositories/device_repository_impl.dart';
import 'package:pos_app_ui/features/sales/domain/cart.dart';
import 'package:pos_app_ui/features/sales/domain/checkout_service.dart';
import 'package:pos_app_ui/features/shift/domain/shift_service.dart';
import 'package:pos_app_ui/features/staff/data/staff_repository.dart';
import 'package:pos_app_ui/features/sync/data/sync_api.dart';
import 'package:pos_app_ui/features/sync/domain/sync_engine.dart';

/// Whole terminal flow against a real backend:
/// pair -> sync catalogue + users -> PIN login -> open shift -> sell (card + cash with rounding)
/// -> push -> server applied everything (no rejection) -> close shift -> day close -> push.
///
/// E2E_BASE_URL=... E2E_ACTIVATION_CODE=... E2E_PIN=1234 flutter test --tags e2e test/e2e/sale_e2e_test.dart
void main() {
  final env = Platform.environment;
  final base = env['E2E_BASE_URL'];

  test(
    'full sale cycle is accepted by the backend',
    () async {
      final config = AppConfig(apiBaseUrl: base!, appVersion: '1.0.0');
      final secure = MemorySecureStore();
      final local = DeviceLocalDataSource(secure);
      final plain = createDio(config);
      local.refreshCall = (c) => DeviceRemoteDataSource.refreshTokens(
        plain,
        RequestSigner(),
        deviceId: c.deviceId,
        refreshToken: c.refreshToken,
        signingSecret: c.signingSecret,
      );
      final dio = createDio(config, interceptors: [DeviceAuthInterceptor(local, RequestSigner(), retryClient: plain)]);
      final devices = DeviceRepositoryImpl(DeviceRemoteDataSource(dio), local, config, platform: 'windows');

      final session = switch (await devices.setup(code: env['E2E_ACTIVATION_CODE']!, deviceName: 'E2E till')) {
        Success(:final value) => value,
        Err(:final failure) => fail('setup: $failure'),
      };

      // forced refresh works against the real server
      expect(await local.refreshTokens(), isTrue);

      final store = LocalStore(openTestDatabase(NativeDatabase.memory()));
      await store.open(session.deviceCode);
      final ctx = TerminalContextHolder()
        ..ctx = TerminalContext(
          deviceId: session.deviceId,
          deviceCode: session.deviceCode,
          tokenLetter: session.tokenLetter,
          storeId: session.store.id,
          storeName: session.store.name,
          currency: session.store.currency,
          currencyDecimals: session.store.currencyDecimals,
          timezone: session.store.timezone,
          businessDayCutoff: session.store.businessDayCutoff,
          pricesIncludeTax: session.store.pricesIncludeTax,
        );
      final engine = SyncEngine(DioSyncApi(dio), store);

      final first = await engine.sync();
      expect(first.result, SyncResult.synced, reason: '$first');
      expect(first.pulled, greaterThan(0));

      final catalogue = CatalogueRepository(store);
      final products = await catalogue.products(storePricesIncludeTax: session.store.pricesIncludeTax);
      final methods = await catalogue.paymentMethods();
      expect(products, isNotEmpty);

      final staff = StaffRepository(store, secure);
      final cashier = (await staff.users()).firstWhere(
        (u) => u.can('order.create') && u.can('payment.take') && u.can('shift.open_close') && u.can('day.close'),
      );
      expect(await staff.verifyPin(cashier, env['E2E_PIN'] ?? '1234'), isTrue);
      expect(await staff.verifyPin(cashier, '0000'), isFalse);

      final shifts = ShiftService(store, ctx);
      await shifts.startShift(userId: cashier.id, openingFloatMinor: 20000);
      await shifts.cashMovement(userId: cashier.id, direction: 'IN', amountMinor: 5000, reason: 'Change float');

      final p = products.first;
      final cart = Cart(
        lines: [
          CartLine(
            key: '1',
            productId: p.id,
            name: p.name,
            unitPriceMinor: p.priceMinor,
            qtyMilli: 3000,
            taxRateBp: p.taxRateBp,
            priceIncludesTax: p.priceIncludesTax,
            trackStock: p.trackStock,
          ),
        ],
        discountBp: 1000,
      );
      final checkout = CheckoutService(store, ctx, shifts);
      final settings = await catalogue.settings();
      final card = methods.firstWhere((m) => m.kind == 'CARD');
      final cash = methods.firstWhere((m) => m.kind == 'CASH');
      final sale = await checkout.settle(
        cart: cart,
        settings: settings,
        tenders: [(method: card, amountMinor: 100), (method: cash, amountMinor: null)],
        userId: cashier.id,
        cashierName: cashier.name,
        cashTenderedMinor: 100000,
      );
      expect(sale.orderNo, '${session.deviceCode}-000001');

      final pushed = await engine.sync();
      expect(pushed.result, SyncResult.synced, reason: '$pushed');
      expect(pushed.rejected, 0, reason: '$pushed');
      expect(await store.pendingCount(), 0);

      final summary = await shifts.closeShift(userId: cashier.id, countedCashMinor: 20000 + 5000);
      expect(summary.cashInMinor, 5000);
      final afterShift = await engine.sync();
      expect(afterShift.rejected, 0, reason: '$afterShift');

      // Day close: the server allows one per store business day. On a database where an earlier
      // run already closed today, the server rejects it (UNIQUE_VIOLATION) and the terminal keeps
      // the transaction as REJECTED: never resent, never lost.
      final totals = await shifts.closeDay(userId: cashier.id);
      expect(totals['orders'], 1);
      final last = await engine.sync();
      expect(last.result, SyncResult.synced, reason: '$last');
      expect(await store.pendingCount(), 0);
      if (last.rejected > 0) {
        final rejected = await (store.db.select(store.db.changeLog)..where((c) => c.status.equals('REJECTED'))).get();
        expect(rejected.map((r) => r.rejectCode).toSet(), {'UNIQUE_VIOLATION'});
        expect(rejected.map((r) => r.entity).toSet(), containsAll(['day_close', 'business_day']));
      }
      // ignore: avoid_print
      print('E2E: $first | $pushed | $afterShift | $last | order ${sale.orderNo} total ${sale.priced.totalMinor}');
    },
    skip: base == null ? 'set E2E_BASE_URL to run against a backend' : false,
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
