import 'package:mind_lab_app/features/dashboard/domain/entities/subscription_student.dart';

class SubscriptionUserModel extends SubscriptionStudent {
  SubscriptionUserModel({
    required super.id,
    required super.name,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory SubscriptionUserModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionUserModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
