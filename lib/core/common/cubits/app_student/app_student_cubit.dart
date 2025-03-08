import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';

part 'app_student_state.dart';

class AppStudentCubit extends Cubit<AppStudentState> {
  AppStudentCubit() : super(AppStudentInitial());

  void updateStudent(StudentEntity? student) {
    if (student == null) {
      emit(AppStudentInitial());
    } else {
      emit(AppStudentSelected(student));
    }
  }
}
