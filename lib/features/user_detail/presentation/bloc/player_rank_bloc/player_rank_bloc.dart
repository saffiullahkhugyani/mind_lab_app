import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/player_rank_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_player_rank_detail_usecase.dart';

part "player_rank_event.dart";
part "player_rank_state.dart";

class PlayerRankBloc extends Bloc<PlayerRankEvent, PlayerRankState> {
  final GetPlayerRankDetailUsecase _playerRankDetails;
  PlayerRankBloc({required GetPlayerRankDetailUsecase playerRankDetails})
      : _playerRankDetails = playerRankDetails,
        super(PlayerRankInitial()) {
    on<PlayerRankEvent>(
      (event, emit) => emit(
        PlayerRankLoading(),
      ),
    );
    on<FetchPlayarRankDetails>(_onFetchPlayerRankDetails);
  }

  void _onFetchPlayerRankDetails(
      FetchPlayarRankDetails playerRank, Emitter emit) async {
    final res = await _playerRankDetails(NoParams());
    res.fold(
      (failure) => emit(
        PlayerRankFailure(
          failure.errorMessage,
        ),
      ),
      (playerDetails) => emit(
        PlayerRankSuccess(
          playerDetails,
        ),
      ),
    );
  }
}
