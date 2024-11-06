part of 'player_rank_bloc.dart';

sealed class PlayerRankState extends Equatable {
  const PlayerRankState();

  @override
  List<Object> get props => [];
}

class PlayerRankInitial extends PlayerRankState {}

class PlayerRankLoading extends PlayerRankState {}

class PlayerRankSuccess extends PlayerRankState {
  final List<PlayerRankEntity> playerRankDetialList;

  const PlayerRankSuccess(this.playerRankDetialList);
}

class PlayerRankFailure extends PlayerRankState {
  final String error;
  PlayerRankFailure(this.error);
}
