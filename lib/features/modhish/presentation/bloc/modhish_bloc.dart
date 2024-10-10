import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'modhish_event.dart';
part 'modhish_state.dart';

class ModhishBloc extends Bloc<ModhishEvent, ModhishState> {
  ModhishBloc() : super(ModhishInitial()) {
    on<ModhishEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
