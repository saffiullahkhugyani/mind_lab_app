part of 'mecanum_car_bloc.dart';

abstract class MecanumCarState extends Equatable {
  const MecanumCarState();  

  @override
  List<Object> get props => [];
}
class MecanumCarInitial extends MecanumCarState {}
