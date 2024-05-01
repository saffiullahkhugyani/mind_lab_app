class Subscription {
  final String userId;
  final int projectId;
  final int subscriptionStatus;

  Subscription(
      {required this.userId,
      required this.projectId,
      required this.subscriptionStatus});

  factory Subscription.formJson(Map<String, dynamic> json) {
    return Subscription(
      userId: json['user_id'],
      projectId: json['project_id'],
      subscriptionStatus: json['subscription'],
    );
  }
}
