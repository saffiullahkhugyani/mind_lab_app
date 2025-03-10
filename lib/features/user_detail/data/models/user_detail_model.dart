import 'package:mind_lab_app/core/common/entities/student.dart';

class UserDetailModel extends StudentEntity {
  UserDetailModel({
    required super.id,
    required super.name,
    required super.ageGroup,
    required super.imageUrl,
    required super.nationality,
    required super.email,
    required super.gender,
    required super.number,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'age_group': ageGroup,
      'number': number,
      'profile_image_url': imageUrl,
      'nationality': nationality,
      'gender': gender,
    };
  }

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      ageGroup: json['ageGroup'] ?? '',
      number: json['number'] ?? '',
      imageUrl: json['profile_image_url'] ?? '',
      nationality: json['nationality'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
