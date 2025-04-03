import 'package:mind_lab_app/features/dashboard/domain/entities/subscription_user.dart';

class SubscriptionUserModel extends SubscriptionUser {
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
