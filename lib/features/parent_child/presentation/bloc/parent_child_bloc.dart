import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';

import '../../domain/usecases/add_student_usecase.dart';
import '../../domain/usecases/get_students_usecase.dart';

part 'parent_child_event.dart';
part 'parent_child_state.dart';

class ParentChildBloc extends Bloc<ParentChildEvent, ParentChildState> {
  // Initializations
  final AddStudentUseCase _addStudent;
  final GetStudentUsecase _getStudents;

  // Constructor
  ParentChildBloc(
    AddStudentUseCase addStudent,
    GetStudentUsecase getStudents,
  )   : _addStudent = addStudent,
        _getStudents = getStudents,
        super(ParentChildInitial()) {
    on<ParentChildEvent>((_, emit) => emit(ParentChildLoading()));
    on<AddChildEvent>(_onAddStudent);
    on<GetChildrenEvent>(_onGetStudents);
  }

  void _onAddStudent(
      AddChildEvent event, Emitter<ParentChildState> emit) async {
    final response = await _addStudent(AddChildParams(
      name: event.name,
      email: event.email,
      ageGroup: event.ageGroup,
      gender: event.gender,
      imageFile: event.imageFile,
      nationality: event.nationality,
    ));

    response.fold(
      (failure) {
        emit(ParentChildFailure(failure.errorMessage));
        emit(ParentChildInitial());
      },
      (children) {
        emit(ParentChildSuccess(List.from([children])));
      },
    );
  }

  void _onGetStudents(
      GetChildrenEvent event, Emitter<ParentChildState> emit) async {
    final response = await _getStudents(NoParams());

    response.fold(
      (failure) => emit(ParentChildFailure(failure.errorMessage)),
      (children) => emit(ParentChildSuccess(children)),
    );
  }
}
