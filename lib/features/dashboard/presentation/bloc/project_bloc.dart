import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_student/app_student_cubit.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/project.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';
import 'package:mind_lab_app/features/dashboard/domain/usecase/get_all_projects.dart';
import 'package:mind_lab_app/features/dashboard/domain/usecase/get_subscribec_projects.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final GetSubscribedProjects _getSubscribedProjects;
  final GetAllProjects _getAllProjects;

  ProjectBloc({
    required GetSubscribedProjects getSubscribedProjects,
    required GetAllProjects getAllProjects,
    required AppStudentCubit appStudentCubit,
  })  : _getSubscribedProjects = getSubscribedProjects,
        _getAllProjects = getAllProjects,
        super(ProjectInitial()) {
    on<ProjectEvent>((event, emit) => emit(ProjectLoading()));
    on<ProjectFetchAllProjects>(_onFetchAllProjects);
  }

  void _onFetchAllProjects(
    ProjectFetchAllProjects event,
    Emitter<ProjectState> emit,
  ) async {
    final subscribedProjects = await _getSubscribedProjects(NoParams());
    final allProjects = await _getAllProjects(NoParams());

    subscribedProjects.fold(
      (failure) => emit(ProjectFailure(failure.errorMessage)),
      (subscribedProjects) => allProjects.fold(
        (failure) => emit(ProjectFailure(failure.errorMessage)),
        (allProjects) => emit(
          ProjectDisplaySuccess(subscribedProjects, allProjects),
        ),
      ),
    );
  }

  // void _onUpdateStudentCubit(
  //     UpdateStudentCubitEvent event, Emitter<ProjectState> emit) async {
  //   emit(ProjectLoading());
  //   final student = await _updateStudentCubit(event.profileId);

  //   student.fold(
  //     (failure) => emit(StudentCubitFailure(failure.errorMessage)),
  //     (student) => _emitStudentCubitSuccess(student, emit),
  //   );
  // }

  // void _emitStudentCubitSuccess(
  //   StudentEntity student,
  //   Emitter<ProjectState> emit,
  // ) {
  //   _appStudentCubit.updateStudent(student);

  //   //if auth success and role == student == 4 save the data into student cubit
  //   // if (user.roleId == 4) {
  //   //   final student = mapUserToStudent(user);
  //   //   _appStudentCubit.updateStudent(student);
  //   // }
  //   emit(StudentCubitSuccess(student: student));
  // }
}
