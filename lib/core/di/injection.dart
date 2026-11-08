import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/catalogue/data/catalogue_repository.dart';
import '../../features/device_setup/data/datasources/device_local_data_source.dart';
import '../../features/device_setup/data/datasources/device_remote_data_source.dart';
import '../../features/device_setup/data/repositories/device_repository_impl.dart';
import '../../features/device_setup/domain/repositories/device_repository.dart';
import '../../features/device_setup/domain/usecases/get_current_session.dart';
import '../../features/device_setup/domain/usecases/register_device.dart';
import '../../features/device_setup/presentation/bloc/device_setup_bloc.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/printing/data/printer_service.dart';
import '../../features/sales/domain/checkout_service.dart';
import '../../features/sales/presentation/cubit/sell_cubit.dart';
import '../../features/shift/domain/shift_service.dart';
import '../../features/staff/data/staff_repository.dart';
import '../../features/staff/presentation/pin_login_cubit.dart';
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
Future<void> configureDependencies({AppConfig? config, SecureStore? secureStore, AppDatabase? database}) async {
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
    ..registerLazySingleton<DeviceRepository>(
      () => DeviceRepositoryImpl(sl<DeviceRemoteDataSource>(), sl<DeviceLocalDataSource>(), sl<AppConfig>()),
    )
    ..registerFactory(() => RegisterDevice(sl<DeviceRepository>()))
    ..registerFactory(() => GetCurrentSession(sl<DeviceRepository>()))
    ..registerFactory(() => DeviceSetupBloc(sl<RegisterDevice>(), sl<GetCurrentSession>()));

  // ---- feature: home -------------------------------------------------------------------
  sl.registerFactory(() => HomeCubit(sl<DeviceRepository>()));

  // ---- terminal: local database, sync, POS features -------------------------------------
  sl
    ..registerLazySingleton<AppDatabase>(() => database ?? openAppDatabase())
    ..registerLazySingleton(() => LocalStore(sl<AppDatabase>()))
    ..registerLazySingleton(TerminalContextHolder.new)
    ..registerLazySingleton<SyncApi>(() => DioSyncApi(sl<Dio>()))
    ..registerLazySingleton(() => SyncEngine(sl<SyncApi>(), sl<LocalStore>()))
    ..registerLazySingleton(() => RealtimeClient(sl<SyncApi>()))
    ..registerLazySingleton(() => SyncScheduler(sl<SyncEngine>(), sl<LocalStore>(), sl<RealtimeClient>()))
    ..registerLazySingleton(
      () => TerminalCubit(sl<LocalStore>(), sl<TerminalContextHolder>(), sl<SyncScheduler>(), sl<AppConfig>()),
    )
    ..registerLazySingleton(() => CatalogueRepository(sl<LocalStore>()))
    ..registerLazySingleton(StaffSession.new)
    ..registerLazySingleton(() => StaffRepository(sl<LocalStore>(), sl<SecureStore>()))
    ..registerFactory(() => PinLoginCubit(sl<StaffRepository>(), sl<StaffSession>()))
    ..registerLazySingleton(() => ShiftService(sl<LocalStore>(), sl<TerminalContextHolder>(), _afterCommit))
    ..registerLazySingleton(
      () => CheckoutService(sl<LocalStore>(), sl<TerminalContextHolder>(), sl<ShiftService>(), _afterCommit),
    )
    ..registerFactory(
      () =>
          SellCubit(sl<CatalogueRepository>(), sl<CheckoutService>(), sl<ShiftService>(), sl<TerminalContextHolder>()),
    )
    ..registerLazySingleton(() => PrinterService(sl<LocalStore>()));
}

/// Every local commit: upload soon (CONTINUOUS) and refresh the pending counter.
void _afterCommit() {
  sl<SyncScheduler>().localChangeCommitted();
  sl<TerminalCubit>().refreshPending();
}
