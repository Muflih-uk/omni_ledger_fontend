import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'core/network/dio_interceptor.dart';
import 'core/storage/local_storage.dart';

import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/inventory/data/data_sources/item_remote_data_source.dart';
import 'features/bill/data/data_source/billing_remote_data_source.dart';

// Repository
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/inventory/data/repositories/item_repository_impl.dart';
import 'features/inventory/domain/repositories/item_repositories.dart';
import 'features/bill/data/repositories/bill_repository_impl.dart';
import 'features/bill/domain/repositories/bill_repository.dart';

// Usecase
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/inventory/domain/usecases/items_usecases.dart';
import 'features/bill/domain/usecases/bill_usecases.dart';

// Bloc
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/inventory/presentation/bloc/item_bloc.dart';
import 'features/bill/presentation/bill_bloc/bill_bloc.dart';

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

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ItemRemoteDataSource>(
    () => ItemRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<BillingRemoteDataSource>(
    () => BillingRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  //! ------------------ REPOSITORY ------------------

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<AuthLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<ItemRepositories>(
    () => ItemRepositoryImpl(sl<ItemRemoteDataSource>()),
  );

  sl.registerLazySingleton<BillRepository>(
    () => BillRepositoryImpl(sl<BillingRemoteDataSource>()),
  );

  //! ------------------ USECASES ------------------

  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => ItemsUsecases(sl()));
  sl.registerLazySingleton(() => BillUsecases(sl()));

  //! ------------------ BLOC ------------------

  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => ItemBloc(sl()));
  sl.registerFactory(() => BillingBloc(sl()));
  sl.registerFactory(() => HistoryBloc(sl()));
}
