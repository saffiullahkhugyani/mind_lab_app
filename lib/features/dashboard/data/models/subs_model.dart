import 'package:mind_lab_app/features/dashboard/data/models/pro_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/user_model.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';

class SubscriptionModel extends Subscription {
  SubscriptionModel({
    required super.subscription,
    required super.project,
    required super.user,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'subscription': subscription,
      'profiles': user,
      'projects': project
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      subscription: json['subscription'],
      user: UserModel.fromJson(json['profiles']),
      project: ProjectModel.fromJson(json['projects']),
    );
  }
}
