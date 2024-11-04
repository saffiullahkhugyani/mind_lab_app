part of 'register_player_bloc.dart';

sealed class RegisterPlayerState extends Equatable {
  const RegisterPlayerState();

  @override
  List<Object> get props => [];
}

final class RegisterPlayerInitial extends RegisterPlayerState {}

final class RegisterPlayerLoading extends RegisterPlayerState {}

final class RegisterPlayerFailure extends RegisterPlayerState {
  final String error;
  RegisterPlayerFailure(this.error);
}

final class RegisterPlayerSuccess extends RegisterPlayerState {}
