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
  final List<Subscription> projectList;

  ProjectDisplaySuccess(this.projectList);
}
