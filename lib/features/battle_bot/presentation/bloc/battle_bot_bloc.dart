import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'battle_bot_event.dart';
part 'battle_bot_state.dart';

class BattleBotBloc extends Bloc<BattleBotEvent, BattleBotState> {
  BattleBotBloc() : super(BattleBotInitial()) {
    on<BattleBotEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
