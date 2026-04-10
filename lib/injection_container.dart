import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:omni_ledger/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:omni_ledger/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/storage/local_storage.dart';
import 'core/network/dio_client.dart';
import 'core/network/dio_interceptor.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton(() => LocalStorage(sl()));
  sl.registerLazySingleton(() => AppInterceptor(sl()));
  sl.registerLazySingleton(() => DioClient(sl(), sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => LoginUsecase(sl()));

  sl.registerFactory(() => AuthBloc(sl()));
}
