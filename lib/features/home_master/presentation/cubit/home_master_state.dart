part of 'home_master_cubit.dart';

class HomeMasterState {
  final AppUserCubit appUserCubit;

  const HomeMasterState({
    required this.appUserCubit,
  });

  factory HomeMasterState.initial(
          {required HomeMasterInitialParams initialParams}) =>
      HomeMasterState(
        appUserCubit: AppUserCubit(),
      );

  HomeMasterState copyWith({AppUserCubit? appUserCubit}) =>
      HomeMasterState(appUserCubit: appUserCubit ?? this.appUserCubit);
}

class HomeMasterInitialParams {
  const HomeMasterInitialParams();
}
