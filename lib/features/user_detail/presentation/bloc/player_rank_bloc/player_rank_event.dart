part of 'player_rank_bloc.dart';

sealed class PlayerRankEvent extends Equatable {
  const PlayerRankEvent();

  @override
  List<Object> get props => [];
}

class FetchPlayarRankDetails extends PlayerRankEvent {}
