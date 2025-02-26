import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/entities/child_entity.dart';

part 'app_child_state.dart';

class AppChildCubit extends Cubit<AppChildState> {
  AppChildCubit() : super(AppChildInitial());

  void updateChild(ChildEntity? child) {
    if (child == null) {
      emit(AppChildInitial());
    } else {
      emit(AppChildSelected(child));
    }
  }
}
