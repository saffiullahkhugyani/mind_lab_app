import 'package:mind_lab_app/features/auth/data/models/student_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/pro_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/subscription_user_model.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';

class SubscriptionModel extends Subscription {
  SubscriptionModel({
    required super.subscription,
    required super.project,
    required super.student,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'subscription': subscription,
      'students': student,
      'projects': project
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      subscription: json['subscription'],
      student: StudentModel.fromJson(json['students']),
      project: ProjectModel.fromJson(json['projects']),
    );
  }
}
