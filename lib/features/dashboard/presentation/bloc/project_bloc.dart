import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final subscribedProjects = await _getSubscribedProjects(event.childId);
    final allProjects = await _getAllProjects(event.childId);

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
}
