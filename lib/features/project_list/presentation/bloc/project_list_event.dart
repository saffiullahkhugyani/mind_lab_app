part of 'project_list_bloc.dart';

@immutable
sealed class ProjectListEvent {}

final class ProjectListFetechAllAvailableProjects extends ProjectListEvent {
  final String studentId;
  ProjectListFetechAllAvailableProjects({required this.studentId});
}

final class SubscriptionRequestEvent extends ProjectListEvent {
  final String studentId;
  final int projectId;
  final int subscriptionStatus;

  SubscriptionRequestEvent(
      {required this.studentId,
      required this.projectId,
      required this.subscriptionStatus});
}
