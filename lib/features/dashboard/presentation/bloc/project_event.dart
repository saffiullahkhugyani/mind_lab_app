part of 'project_bloc.dart';

@immutable
sealed class ProjectEvent {}

final class ProjectFetchAllProjects extends ProjectEvent {
  final int childId;

  ProjectFetchAllProjects({required this.childId});
}
