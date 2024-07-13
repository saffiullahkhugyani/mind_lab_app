import 'package:mind_lab_app/features/user_detail/domain/entities/user_detail_entity.dart';

class UserDetailModel extends UserDetailEntity {
  UserDetailModel({
    required super.id,
    required super.name,
    required super.age,
    required super.mobile,
    required super.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'mobile': mobile,
      "profile_image_url": imageUrl,
    };
  }

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      mobile: json['mobile'],
      imageUrl: json['profile_image_url'],
    );
  }
}
