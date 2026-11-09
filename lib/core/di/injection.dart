import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/catalogue/data/catalogue_repository.dart';
import '../../features/device_setup/data/datasources/device_local_data_source.dart';
import '../../features/device_setup/data/datasources/device_remote_data_source.dart';
import '../../features/device_setup/data/repositories/activation_repository_impl.dart';
import '../../features/device_setup/data/repositories/device_repository_impl.dart';
import '../../features/device_setup/domain/repositories/activation_repository.dart';
import '../../features/device_setup/domain/repositories/device_repository.dart';
import '../../features/device_setup/domain/usecases/get_current_session.dart';
import '../../features/device_setup/domain/usecases/get_hardware_id.dart';
import '../../features/device_setup/domain/usecases/preview_setup.dart';
import '../../features/device_setup/domain/usecases/setup_device.dart';
import '../../features/device_setup/presentation/bloc/device_setup_bloc.dart';
import '../../features/device_setup/presentation/cubit/activation_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/orders/presentation/order_detail_cubit.dart';
import '../../features/orders/presentation/orders_cubit.dart';
import '../../features/printing/data/print_center.dart';
import '../../features/printing/data/printer_service.dart';
import '../../features/printing/data/printer_transport.dart';
import '../../features/sales/data/home_repository.dart';
import '../../features/sales/domain/checkout_service.dart';
import '../../features/sales/domain/order_manager.dart';
import '../../features/sales/domain/order_service.dart';
import '../../features/sales/presentation/cubit/sell_cubit.dart';
import '../../features/shift/domain/shift_service.dart';
import '../../features/staff/data/staff_repository.dart';
import '../../features/staff/presentation/login_cubit.dart';
import '../../features/sync/data/realtime_client.dart';
import '../../features/sync/data/sync_api.dart';
import '../../features/sync/domain/sync_engine.dart';
import '../../features/sync/domain/sync_scheduler.dart';
import '../../features/terminal/terminal_cubit.dart';
import '../config/app_config.dart';
import '../database/app_database.dart';
import '../database/connection.dart';
import '../network/api_client.dart';
import '../network/device_auth_interceptor.dart';
import '../network/device_credentials_provider.dart';
import '../network/request_signer.dart';
import '../storage/secure_store.dart';
import '../sync/local_store.dart';
import '../terminal/terminal_context.dart';

final GetIt sl = GetIt.instance;

/// Registration order: core, then each feature (data -> domain -> presentation).
/// Singletons for stateless services, factories for blocs/cubits (one per screen).
Future<void> configureDependencies({
  AppConfig? config,
  SecureStore? secureStore,
  AppDatabase? database,
  PrinterTransport? printerTransport,
}) async {
  // ---- core --------------------------------------------------------------------------
  sl
    ..registerSingleton<AppConfig>(config ?? AppConfig.fromEnvironment())
    ..registerLazySingleton<SecureStore>(() => secureStore ?? FlutterSecureStore())
    ..registerLazySingleton<RequestSigner>(RequestSigner.new)
    // Plain client (no auth interceptor): token refresh and retries after a refresh.
    ..registerLazySingleton<Dio>(() => createDio(sl<AppConfig>()), instanceName: 'plain')
    ..registerLazySingleton<Dio>(
      () => createDio(
        sl<AppConfig>(),
        interceptors: [
          DeviceAuthInterceptor(
            sl<DeviceCredentialsProvider>(),
            sl<RequestSigner>(),
            retryClient: sl<Dio>(instanceName: 'plain'),
          ),
        ],
      ),
    );

  // ---- feature: device_setup -----------------------------------------------------------
  sl
    ..registerLazySingleton(() => DeviceRemoteDataSource(sl<Dio>()))
    ..registerLazySingleton(
      () => DeviceLocalDataSource(sl<SecureStore>())
        ..refreshCall = (current) => DeviceRemoteDataSource.refreshTokens(
          sl<Dio>(instanceName: 'plain'),
          sl<RequestSigner>(),
          deviceId: current.deviceId,
          refreshToken: current.refreshToken,
          signingSecret: current.signingSecret,
        ),
    )
    ..registerLazySingleton<DeviceCredentialsProvider>(() => sl<DeviceLocalDataSource>())
    ..registerLazySingleton<ActivationRepository>(
      () => ActivationRepositoryImpl(
        sl<DeviceRemoteDataSource>(),
        sl<DeviceLocalDataSource>(),
        sl<AppConfig>(),
        signer: sl<RequestSigner>(),
      ),
    )
    ..registerLazySingleton<DeviceRepository>(
      () => DeviceRepositoryImpl(
        sl<DeviceRemoteDataSource>(),
        sl<DeviceLocalDataSource>(),
        sl<AppConfig>(),
        activations: sl<ActivationRepository>(),
      ),
    )
    ..registerFactory(() => SetupDevice(sl<DeviceRepository>()))
    ..registerFactory(() => GetCurrentSession(sl<DeviceRepository>()))
    ..registerFactory(() => PreviewSetup(sl<DeviceRepository>()))
    ..registerFactory(() => GetHardwareId(sl<DeviceRepository>()))
    ..registerFactory(
      () => DeviceSetupBloc(sl<SetupDevice>(), sl<GetCurrentSession>(), sl<PreviewSetup>(), sl<GetHardwareId>()),
    );

  // ---- feature: home -------------------------------------------------------------------
  sl.registerFactory(() => HomeCubit(sl<DeviceRepository>()));

  // ---- terminal: local database, sync, POS features -------------------------------------
  sl
    ..registerLazySingleton<AppDatabase>(() => database ?? openAppDatabase())
    ..registerLazySingleton(() => LocalStore(sl<AppDatabase>()))
    // New orders follow the platform activation (enforced locally, also offline).
    ..registerLazySingleton(() => TerminalContextHolder()..newOrdersAllowed = () => sl<ActivationCubit>().state.canSell)
    ..registerLazySingleton<SyncApi>(() => DioSyncApi(sl<Dio>()))
    ..registerLazySingleton(() => SyncEngine(sl<SyncApi>(), sl<LocalStore>()))
    ..registerLazySingleton(() => RealtimeClient(sl<SyncApi>()))
    ..registerLazySingleton(() => SyncScheduler(sl<SyncEngine>(), sl<LocalStore>(), sl<RealtimeClient>()))
    // App-wide: the sell gate, the expiry banner and the activation screen share one state.
    ..registerLazySingleton(
      () => ActivationCubit(
        sl<ActivationRepository>(),
        realtime: sl<RealtimeClient>().messages,
        syncReports: sl<SyncScheduler>().reports,
      ),
    )
    ..registerLazySingleton(
      () => TerminalCubit(sl<LocalStore>(), sl<TerminalContextHolder>(), sl<SyncScheduler>(), sl<AppConfig>()),
    )
    ..registerLazySingleton(() => CatalogueRepository(sl<LocalStore>()))
    ..registerLazySingleton(StaffSession.new)
    ..registerLazySingleton(() => StaffRepository(sl<LocalStore>(), sl<SecureStore>()))
    ..registerFactory(
      () => LoginCubit(
        sl<StaffRepository>(),
        sl<StaffSession>(),
        sl<ShiftService>(),
        sl<LocalStore>(),
        sl<TerminalContextHolder>(),
      ),
    )
    ..registerLazySingleton(() => ShiftService(sl<LocalStore>(), sl<TerminalContextHolder>(), _afterCommit))
    ..registerLazySingleton(
      () => CheckoutService(sl<LocalStore>(), sl<TerminalContextHolder>(), sl<ShiftService>(), _afterCommit),
    )
    ..registerLazySingleton(
      () => OrderService(
        sl<LocalStore>(),
        sl<TerminalContextHolder>(),
        sl<ShiftService>(),
        sl<CheckoutService>(),
        _afterCommit,
      ),
    )
    ..registerLazySingleton(() => HomeRepository(sl<LocalStore>(), sl<StaffRepository>(), _afterCommit))
    ..registerLazySingleton(
      () => OrderManager(
        sl<LocalStore>(),
        sl<TerminalContextHolder>(),
        sl<CheckoutService>(),
        sl<StaffRepository>(),
        _afterCommit,
      ),
    )
    ..registerFactory(() => OrdersCubit(sl<OrderManager>(), sl<CatalogueRepository>()))
    ..registerFactoryParam<OrderDetailCubit, String, void>(
      (id, _) => OrderDetailCubit(id, sl<OrderManager>(), sl<CheckoutService>(), sl<CatalogueRepository>()),
    )
    ..registerFactory(
      () => SellCubit(
        sl<CatalogueRepository>(),
        sl<CheckoutService>(),
        sl<ShiftService>(),
        sl<TerminalContextHolder>(),
        sl<OrderService>(),
        sl<HomeRepository>(),
        sl<OrderManager>(),
      ),
    )
    ..registerLazySingleton(() => PrinterService(sl<LocalStore>(), transport: printerTransport))
    ..registerLazySingleton(() => PrintCenter(sl<PrinterService>(), sl<LocalStore>(), sl<TerminalContextHolder>()));
}

/// Every local commit: upload soon (CONTINUOUS) and refresh the pending counter.
void _afterCommit() {
  sl<SyncScheduler>().localChangeCommitted();
  sl<TerminalCubit>().refreshPending();
}
