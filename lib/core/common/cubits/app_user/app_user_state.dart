part of 'app_user_cubit.dart';

sealed class AppUserState extends Equatable {
  const AppUserState();

  @override
  List<Object> get props => [];
}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;
  const AppUserLoggedIn(this.user);
}

final class AppUserLoggedOut extends AppUserState {
  final User user;
  const AppUserLoggedOut(this.user);
}

// Core Module of the application cannot depend on the other features of the app
// but other feature can depend on the core available in the application