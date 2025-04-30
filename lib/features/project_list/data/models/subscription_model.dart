import 'package:mind_lab_app/features/project_list/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  SubscriptionModel({
    required super.studentId,
    required super.projectId,
    required super.subscriptionStatus,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'student_id': studentId,
      'project_id': projectId,
      'subscription': subscriptionStatus
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      studentId: json['student_id'] as String? ?? '',
      projectId: json['project_id'] as int? ?? 0,
      subscriptionStatus: json['subscription'] as int? ?? -1,
    );
  }
}
