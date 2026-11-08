import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/device_setup/data/datasources/device_local_data_source.dart';
import '../../features/device_setup/data/datasources/device_remote_data_source.dart';
import '../../features/device_setup/data/repositories/device_repository_impl.dart';
import '../../features/device_setup/domain/repositories/device_repository.dart';
import '../../features/device_setup/domain/usecases/get_current_session.dart';
import '../../features/device_setup/domain/usecases/register_device.dart';
import '../../features/device_setup/presentation/bloc/device_setup_bloc.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';
import '../network/device_auth_interceptor.dart';
import '../network/device_credentials_provider.dart';
import '../network/request_signer.dart';
import '../storage/secure_store.dart';

final GetIt sl = GetIt.instance;

/// Registration order: core, then each feature (data -> domain -> presentation).
/// Singletons for stateless services, factories for blocs/cubits (one per screen).
Future<void> configureDependencies({AppConfig? config, SecureStore? secureStore}) async {
  // ---- core --------------------------------------------------------------------------
  sl
    ..registerSingleton<AppConfig>(config ?? AppConfig.fromEnvironment())
    ..registerLazySingleton<SecureStore>(() => secureStore ?? FlutterSecureStore())
    ..registerLazySingleton<RequestSigner>(RequestSigner.new)
    ..registerLazySingleton<Dio>(
      () => createDio(
        sl<AppConfig>(),
        interceptors: [DeviceAuthInterceptor(sl<DeviceCredentialsProvider>(), sl<RequestSigner>())],
      ),
    );

  // ---- feature: device_setup -----------------------------------------------------------
  sl
    ..registerLazySingleton(() => DeviceRemoteDataSource(sl<Dio>()))
    ..registerLazySingleton(() => DeviceLocalDataSource(sl<SecureStore>()))
    ..registerLazySingleton<DeviceCredentialsProvider>(() => sl<DeviceLocalDataSource>())
    ..registerLazySingleton<DeviceRepository>(
      () => DeviceRepositoryImpl(sl<DeviceRemoteDataSource>(), sl<DeviceLocalDataSource>(), sl<AppConfig>()),
    )
    ..registerFactory(() => RegisterDevice(sl<DeviceRepository>()))
    ..registerFactory(() => GetCurrentSession(sl<DeviceRepository>()))
    ..registerFactory(() => DeviceSetupBloc(sl<RegisterDevice>(), sl<GetCurrentSession>()));

  // ---- feature: home -------------------------------------------------------------------
  sl.registerFactory(() => HomeCubit(sl<DeviceRepository>()));
}
