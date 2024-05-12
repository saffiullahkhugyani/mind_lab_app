class ProjectListEntity {
  final int id;
  final String name;
  final String description;
  final List<SubscriptionId> subscription;

  ProjectListEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.subscription,
  });
}

class SubscriptionId {
  int? subscription;
  SubscriptionId({required this.subscription});
}
