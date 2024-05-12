part of 'project_list_bloc.dart';

@immutable
sealed class ProjectListEvent {}

final class ProjectListFetechAllAvailableProjects extends ProjectListEvent {}

final class SubscriptionRequestEvent extends ProjectListEvent {
  final String userId;
  final int projectId;
  final int subscriptionStatus;

  SubscriptionRequestEvent(
      {required this.userId,
      required this.projectId,
      required this.subscriptionStatus});
}
