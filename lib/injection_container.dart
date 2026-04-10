import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'core/network/dio_interceptor.dart';
import 'core/storage/local_storage.dart';

import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';

// Repository
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';

// Usecase
import 'features/auth/domain/usecases/login_usecase.dart';

// Bloc
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! ------------------ EXTERNAL ------------------

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  //! ------------------ CORE ------------------

  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // Storage
  sl.registerLazySingleton(() => LocalStorage(sl()));

  // Interceptor
  sl.registerLazySingleton(() => AppInterceptor(sl()));

  // Dio Client (IMPORTANT)
  sl.registerLazySingleton(
    () => DioClient(dio: sl<Dio>(), interceptor: sl<AppInterceptor>()),
  );

  //! ------------------ DATA SOURCES ------------------

  // ✅ Use Dio from DioClient
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  //! ------------------ REPOSITORY ------------------

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<AuthLocalDataSource>(),
    ),
  );

  //! ------------------ USECASES ------------------

  sl.registerLazySingleton(() => LoginUsecase(sl()));

  //! ------------------ BLOC ------------------

  sl.registerFactory(() => AuthBloc(sl()));
}
