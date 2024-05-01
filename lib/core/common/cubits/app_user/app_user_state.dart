part of 'app_user_cubit.dart';

sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;
  AppUserLoggedIn(this.user);
}

final class AppUserLoggedOut extends AppUserState {
  final User user;
  AppUserLoggedOut(this.user);
}

// Core Module of the application cannot depend on the other features of the app
// but other feature can depend on the core available in the application