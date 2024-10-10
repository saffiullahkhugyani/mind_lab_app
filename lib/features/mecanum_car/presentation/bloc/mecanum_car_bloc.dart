import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mecanum_car_event.dart';
part 'mecanum_car_state.dart';

class MecanumCarBloc extends Bloc<MecanumCarEvent, MecanumCarState> {
  MecanumCarBloc() : super(MecanumCarInitial()) {
    on<MecanumCarEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
