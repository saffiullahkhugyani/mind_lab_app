part of 'project_bloc.dart';

@immutable
sealed class ProjectState {}

final class ProjectInitial extends ProjectState {}

final class ProjectLoading extends ProjectState {}

final class ProjectFailure extends ProjectState {
  final String error;
  ProjectFailure(this.error);
}

final class ProjectDisplaySuccess extends ProjectState {
  final List<Subscription> subscribedProjectList;
  final List<Project> projectList;

  ProjectDisplaySuccess(
    this.subscribedProjectList,
    this.projectList,
  );
}

final class StudentCubitFailure extends ProjectState {
  final String error;
  StudentCubitFailure(this.error);
}

final class StudentCubitSuccess extends ProjectState {
  final StudentEntity student;

  StudentCubitSuccess({
    required this.student,
  });
}
