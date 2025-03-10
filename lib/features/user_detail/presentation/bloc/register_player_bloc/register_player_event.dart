part of 'register_player_bloc.dart';

sealed class RegisterPlayerEvent extends Equatable {
  const RegisterPlayerEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class RegisterPlayer extends RegisterPlayerEvent {
  String? studentId;
  String? playerId;
  String? city;
  String? country;

  RegisterPlayer({
    this.studentId,
    this.playerId,
    this.city,
    this.country,
  });
}
