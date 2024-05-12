import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';
import 'package:mind_lab_app/features/dashboard/domain/usecase/get_all_projects.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final GetAllProjects _getAllProjects;
  ProjectBloc({
    required GetAllProjects getAllProjects,
  })  : _getAllProjects = getAllProjects,
        super(ProjectInitial()) {
    on<ProjectEvent>((event, emit) => emit(ProjectLoading()));
    on<ProjectFetchAllProjects>(_onFetchAllProjects);
  }

  void _onFetchAllProjects(
    ProjectFetchAllProjects event,
    Emitter<ProjectState> emit,
  ) async {
    final res = await _getAllProjects(NoParams());

    res.fold(
      (failure) => emit(ProjectFailure(failure.errorMessage)),
      (projectList) => emit(ProjectDisplaySuccess(projectList)),
    );
  }
}
