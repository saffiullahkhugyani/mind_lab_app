part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String ageGroup;
  final String mobile;
  final String gender;
  final File imageFile;

  AuthSignUp({
    required this.email,
    required this.password,
    required this.name,
    required this.ageGroup,
    required this.mobile,
    required this.gender,
    required this.imageFile,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthIsUserLoggedIn extends AuthEvent {}
