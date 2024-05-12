class SubscriptionEntity {
  final String userId;
  final int projectId;
  final int subscriptionStatus;

  SubscriptionEntity({
    required this.userId,
    required this.projectId,
    required this.subscriptionStatus,
  });
}
