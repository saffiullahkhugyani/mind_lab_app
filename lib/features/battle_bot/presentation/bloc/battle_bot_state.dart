part of 'battle_bot_bloc.dart';

abstract class BattleBotState extends Equatable {
  const BattleBotState();  

  @override
  List<Object> get props => [];
}
class BattleBotInitial extends BattleBotState {}
