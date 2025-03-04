import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/register_player_usecase.dart';

part 'register_player_event.dart';
part 'register_player_state.dart';

class RegisterPlayerBloc
    extends Bloc<RegisterPlayerEvent, RegisterPlayerState> {
  RegisterPlayerUsecase _registerPlayerUsecase;

  RegisterPlayerBloc({required RegisterPlayerUsecase registerPlayer})
      : _registerPlayerUsecase = registerPlayer,
        super(RegisterPlayerInitial()) {
    on<RegisterPlayerEvent>(
      (event, emit) => emit(
        RegisterPlayerLoading(),
      ),
    );
    on<RegisterPlayer>(_onRegisterPlayer);
  }

  void _onRegisterPlayer(RegisterPlayer event, Emitter emit) async {
    final res = await _registerPlayerUsecase(
      RegisterPlayerParams(
          childId: event.childId!,
          playerId: event.playerId!,
          city: event.city!,
          country: event.country!),
    );

    res.fold(
      (failure) => emit(
        RegisterPlayerFailure(failure.errorMessage),
      ),
      (success) => emit(
        RegisterPlayerSuccess(),
      ),
    );
  }
}
