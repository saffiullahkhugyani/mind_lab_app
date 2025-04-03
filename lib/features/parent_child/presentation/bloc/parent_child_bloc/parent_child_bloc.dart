import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/features/parent_child/domain/entities/parent_child_relationship_entity.dart';
import 'package:mind_lab_app/features/parent_child/domain/usecases/get_student_details_usecase.dart';

import '../../../domain/usecases/add_student_usecase.dart';
import '../../../domain/usecases/get_students_usecase.dart';

part 'parent_child_event.dart';
part 'parent_child_state.dart';

class ParentChildBloc extends Bloc<ParentChildEvent, ParentChildState> {
  // Initializations
  final AddStudentUseCase _addStudent;
  final GetStudentUsecase _getStudents;
  final GetStudentDetailsUsecase _getStudentDetails;

  // Constructor
  ParentChildBloc(
    AddStudentUseCase addStudent,
    GetStudentUsecase getStudents,
    GetStudentDetailsUsecase getStudentDetails,
  )   : _addStudent = addStudent,
        _getStudents = getStudents,
        _getStudentDetails = getStudentDetails,
        super(ParentChildInitial()) {
    on<ParentChildEvent>((_, emit) => emit(ParentChildLoading()));
    on<AddChildEvent>(_onAddStudent);
    on<GetChildrenEvent>(_onGetStudents);
    on<FetchStudentDetailsEvent>(_onFetchStudentDetails);
  }

  void _onAddStudent(
      AddChildEvent event, Emitter<ParentChildState> emit) async {
    final response = await _addStudent(event.childId);

    response.fold(
      (failure) {
        emit(ParentChildFailure(failure.errorMessage));
        emit(ParentChildInitial());
      },
      (child) {
        emit(ParentChildRequested(child));
      },
    );
  }

  void _onGetStudents(
      GetChildrenEvent event, Emitter<ParentChildState> emit) async {
    final response = await _getStudents(event.parentId);

    response.fold(
      (failure) => emit(ParentChildFailure(failure.errorMessage)),
      (children) => emit(ParentChildSuccess(children)),
    );
  }

  void _onFetchStudentDetails(
      FetchStudentDetailsEvent event, Emitter<ParentChildState> emit) async {
    final response = await _getStudentDetails(event.studentId);

    response.fold(
      (failure) => emit(ParentChildFailure(failure.errorMessage)),
      (student) => emit(
        StudentDetailsLoaded(studentEntity: student),
      ),
    );
  }
}
