import 'package:mind_lab_app/features/dashboard/data/models/child_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/pro_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/user_model.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';

class SubscriptionModel extends Subscription {
  SubscriptionModel({
    required super.subscription,
    required super.project,
    required super.child,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'subscription': subscription,
      'children': child,
      'projects': project
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      subscription: json['subscription'],
      child: ChildModel.fromJson(json['children']),
      project: ProjectModel.fromJson(json['projects']),
    );
  }
}
