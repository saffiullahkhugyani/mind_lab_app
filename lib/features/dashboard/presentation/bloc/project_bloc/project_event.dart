part of 'project_bloc.dart';

@immutable
sealed class ProjectEvent {}

final class ProjectFetchAllProjects extends ProjectEvent {
  final String studentId;
  ProjectFetchAllProjects({required this.studentId});
}
