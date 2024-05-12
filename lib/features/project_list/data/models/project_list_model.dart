import 'package:mind_lab_app/features/project_list/domain/entities/projet_list_entity.dart';

class ProjectListModel extends ProjectListEntity {
  ProjectListModel({
    required super.id,
    required super.name,
    required super.description,
    required super.subscription,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description
    };
  }

  factory ProjectListModel.fromJson(Map<String, dynamic> json) {
    var subscription = <SubscriptionIdModel>[];
    if (json['subscription'] != null) {
      json['subscription'].forEach((v) {
        subscription.add(SubscriptionIdModel.fromJson(v));
      });
    }
    return ProjectListModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      subscription: subscription,
    );
  }
}

class SubscriptionIdModel extends SubscriptionId {
  SubscriptionIdModel({required super.subscription});

  factory SubscriptionIdModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionIdModel(subscription: json['subscription']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['subscription'] = subscription;
    return data;
  }
}
