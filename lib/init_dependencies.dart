import 'package:get_it/get_it.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/secrets/app_secrets.dart';
import 'package:mind_lab_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:mind_lab_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:mind_lab_app/features/auth/domain/repository/auth_repository.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/current_user.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:mind_lab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mind_lab_app/features/home_master/presentation/cubit/home_master_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/domain/usecases/user_sign_in.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.anonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // registering data source
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  // registering repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );

  // registering usecase
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => CurrentUser(
      serviceLocator(),
    ),
  );

  // registering auth bloc
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );

  // home master cubit
  // serviceLocator
  //     .registerFactoryParam<HomeMasterCubit, HomeMasterInitialParams, dynamic>(
  //   (params, _) => HomeMasterCubit(
  //     params,
  //     serviceLocator(),
  //   ),
  // );
}
