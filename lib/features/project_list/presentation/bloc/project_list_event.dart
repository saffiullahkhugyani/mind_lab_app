part of 'project_list_bloc.dart';

@immutable
sealed class ProjectListEvent {}

final class ProjectListFetechAllAvailableProjects extends ProjectListEvent {}

final class SubscriptionRequestEvent extends ProjectListEvent {
  final int childId;
  final int projectId;
  final int subscriptionStatus;

  SubscriptionRequestEvent(
      {required this.childId,
      required this.projectId,
      required this.subscriptionStatus});
}
