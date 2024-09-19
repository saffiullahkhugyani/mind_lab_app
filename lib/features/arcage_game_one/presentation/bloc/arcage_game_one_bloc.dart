import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'arcage_game_one_event.dart';
part 'arcage_game_one_state.dart';

class ArcageGameOneBloc extends Bloc<ArcageGameOneEvent, ArcageGameOneState> {
  ArcageGameOneBloc() : super(ArcageGameOneInitial()) {
    on<ArcageGameOneEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
