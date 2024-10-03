import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'arcade_game_two_event.dart';
part 'arcade_game_two_state.dart';

class ArcadeGameTwoBloc extends Bloc<ArcadeGameTwoEvent, ArcadeGameTwoState> {
  ArcadeGameTwoBloc() : super(ArcadeGameTwoInitial()) {
    on<ArcadeGameTwoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
