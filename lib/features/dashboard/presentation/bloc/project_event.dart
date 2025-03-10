part of 'project_bloc.dart';

@immutable
sealed class ProjectEvent {}

final class ProjectFetchAllProjects extends ProjectEvent {}

final class UpdateStudentCubitEvent extends ProjectEvent {
  final String profileId;

  UpdateStudentCubitEvent({
    required this.profileId,
  });
}
