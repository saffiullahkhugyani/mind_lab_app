part of 'project_list_bloc.dart';

sealed class ProjectListState {}

final class ProjectListInitial extends ProjectListState {}

final class ProjectListLoading extends ProjectListState {}

final class ProjectListFailure extends ProjectListState {
  final String error;
  ProjectListFailure(this.error);
}

final class ProjectSubscriptionSuccess extends ProjectListState {}

final class ProjectListDisplaySuccess extends ProjectListState {
  final List<ProjectListEntity> projectList;

  ProjectListDisplaySuccess(this.projectList);
}
