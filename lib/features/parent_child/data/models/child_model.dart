import 'package:mind_lab_app/core/common/entities/child_entity.dart';

class ChildModel extends ChildEntity {
  ChildModel({
    required super.id,
    required super.name,
    required super.ageGroup,
    required super.email,
    required super.gender,
    required super.nationality,
    super.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'ageGroup': ageGroup,
      'email': email,
      'gender': gender,
      'nationality': nationality,
      'image_url': imageUrl,
    };
  }

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] ?? 0,
      ageGroup: json['ageGroup'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      nationality: json['nationality'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
