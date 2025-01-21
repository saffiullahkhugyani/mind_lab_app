import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/network/connection_checker.dart';
import 'package:mind_lab_app/core/secrets/app_secrets.dart';
import 'package:mind_lab_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:mind_lab_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:mind_lab_app/features/auth/domain/repository/auth_repository.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/current_user.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_in_apple.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_in_google.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:mind_lab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mind_lab_app/features/dashboard/data/datasource/project_local_data_source.dart';
import 'package:mind_lab_app/features/dashboard/data/datasource/project_remote_data_source.dart';
import 'package:mind_lab_app/features/dashboard/data/repository/project_repository_impl.dart';
import 'package:mind_lab_app/features/dashboard/domain/repository/project_repository.dart';
import 'package:mind_lab_app/features/dashboard/domain/usecase/get_all_projects.dart';
import 'package:mind_lab_app/features/dashboard/domain/usecase/get_subscribec_projects.dart';
import 'package:mind_lab_app/features/dashboard/presentation/bloc/project_bloc.dart';
import 'package:mind_lab_app/features/project_list/data/datasources/project_list_local_data_source.dart';
import 'package:mind_lab_app/features/project_list/data/datasources/project_list_remote_data_source.dart';
import 'package:mind_lab_app/features/project_list/data/repositories/project_list_repository_impl.dart';
import 'package:mind_lab_app/features/project_list/domain/repositories/project_list_repository.dart';
import 'package:mind_lab_app/features/project_list/domain/usecases/get_available_project_list.dart';
import 'package:mind_lab_app/features/project_list/domain/usecases/subscription_request.dart';
import 'package:mind_lab_app/features/project_list/presentation/bloc/project_list_bloc.dart';
import 'package:mind_lab_app/features/user_detail/data/datasources/user_detail_remote_data_source.dart';
import 'package:mind_lab_app/features/user_detail/data/repositories/user_detail_repository_impl.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/delete_account.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_player_rank_detail_usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_skill_categories.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_skill_tags.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_skills.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_user_detail.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/register_player_usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/update_profile.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/upload_certificate.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/player_rank_bloc/player_rank_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/register_player_bloc/register_player_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/update_profile_bloc/update_profile_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/user_detail_bloc/user_detail_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/domain/usecases/user_sign_in.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.anonKey,
  );

  // hive directory
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  // registering the supabase client
  serviceLocator.registerLazySingleton(() => supabase.client);

  // registering hive
  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'projects'),
  );

  // registering internet connection checker
  serviceLocator.registerFactory(() => InternetConnection());

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
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

  serviceLocator.registerFactory(
    () => UserLoginWithGoogle(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginWithApple(
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
      loginWithGoogle: serviceLocator(),
      loginWithApple: serviceLocator(),
    ),
  );

  // init Subscribed projects
  serviceLocator.registerFactory<ProjectRemoteDataSource>(
    () => ProjectRemoteDatSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<ProjectLocalDataSource>(
    () => ProjectLocalDataSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<ProjectRepository>(
    () => ProjectRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetSubscribedProjects(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetAllProjects(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ProjectBloc(
      getAllProjects: serviceLocator(),
      getSubscribedProjects: serviceLocator(),
    ),
  );

  // init available projects
  serviceLocator.registerFactory<ProjectListRemoteDataSource>(
    () => ProjectListRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<ProjectListLocalDataSource>(
    () => ProjectListLocalDataSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<ProjectListRepository>(
    () => ProjectListRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetAvailableProjectList(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SubscriptionRequest(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ProjectListBloc(
      getAvailableProjectList: serviceLocator(),
      subscriptionRequest: serviceLocator(),
    ),
  );

  // dependencies for user detail
  // remote datasource
  serviceLocator.registerFactory<UserDetailRemoteDataSource>(
    () => UserDetailRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  // repository
  serviceLocator.registerFactory<UserDetailRepository>(
    () => UserDetailRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );

  // get user details use case
  serviceLocator.registerFactory(
    () => GetUserDetail(
      serviceLocator(),
    ),
  );

  // delete user account
  serviceLocator.registerFactory(
    () => DeleteAccount(
      serviceLocator(),
    ),
  );

  // user detail bloc
  serviceLocator.registerLazySingleton(
    () => UserDetailBloc(
      getUserDetail: serviceLocator(),
      deleteAccount: serviceLocator(),
    ),
  );

  // dependencies for add certificate bloc
  // get skills use case
  serviceLocator.registerFactory(
    () => GetSkills(
      serviceLocator(),
    ),
  );

  // get skill hashtags use case
  serviceLocator.registerFactory(
    () => GetSkillHashtags(
      serviceLocator(),
    ),
  );

  // get skill categories use case
  serviceLocator.registerFactory(
    () => GetSkillCategories(
      serviceLocator(),
    ),
  );

  // upload certificate use case
  serviceLocator.registerFactory(
    () => UploadCertificate(
      serviceLocator(),
    ),
  );

  //  add certificate bloc
  serviceLocator.registerLazySingleton(
    () => AddCertificateBloc(
      getSKillTypes: serviceLocator(),
      getSkillTags: serviceLocator(),
      getSkillCategories: serviceLocator(),
      uploadCertificate: serviceLocator(),
    ),
  );

  // dependencies for update profile
  // update user profile use case
  serviceLocator.registerFactory(
    () => UpdateProfile(
      serviceLocator(),
    ),
  );

  // update student profile bloc
  serviceLocator.registerLazySingleton(
    () => UpdateProfileBloc(
      updateProfile: serviceLocator(),
    ),
  );

  // dependencies for register player
  // register player use case
  serviceLocator.registerFactory(
    () => RegisterPlayerUsecase(
      serviceLocator(),
    ),
  );

  // register player bloc
  serviceLocator.registerLazySingleton(
    () => RegisterPlayerBloc(
      registerPlayer: serviceLocator(),
    ),
  );

  // dependencies for player rank details
  //  player rank use case
  serviceLocator.registerFactory(
    () => GetPlayerRankDetailUsecase(
      serviceLocator(),
    ),
  );

  // player rank bloc
  serviceLocator.registerLazySingleton(
    () => PlayerRankBloc(
      playerRankDetails: serviceLocator(),
    ),
  );
}
