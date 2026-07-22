import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:no_wait/core/routes/app_router.dart';
import 'package:no_wait/core/theme/controller/theme_cubit.dart';
import 'package:no_wait/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:no_wait/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:no_wait/features/auth/data/datasource/auth_remote_datasource_impl.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:no_wait/features/auth/repository/auth_repository.dart';
import 'package:no_wait/features/auth/repository/auth_repository_impl.dart';
import 'package:no_wait/features/home/data/datasource/home_remote_datasource.dart';
import 'package:no_wait/features/home/data/datasource/home_remote_datasource_impl.dart';
import 'package:no_wait/features/home/presentation/cubit/home_cubit.dart';
import 'package:no_wait/features/home/repository/home_repository.dart';
import 'package:no_wait/features/home/repository/home_repository_impl.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt()));

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));

  // Home
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt()),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  // Per feature, register in this order:
  // 1. Data source:  getIt.registerLazySingleton<XRemoteDataSource>(() => XRemoteDataSourceImpl());
  // 2. Repository:   getIt.registerLazySingleton<XRepository>(() => XRepositoryImpl(getIt()));
  // 3. Cubit:        getIt.registerFactory<XCubit>(() => XCubit(getIt()));
}
