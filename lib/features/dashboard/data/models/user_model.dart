import 'package:mind_lab_app/features/dashboard/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
