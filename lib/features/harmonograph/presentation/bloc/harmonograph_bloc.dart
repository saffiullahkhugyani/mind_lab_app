import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'harmonograph_event.dart';
part 'harmonograph_state.dart';

class HarmonographBloc extends Bloc<HarmonographEvent, HarmonographState> {
  HarmonographBloc() : super(HarmonographInitial()) {
    on<HarmonographEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
