import 'package:mind_lab_app/core/common/entities/student.dart';

class StudentModel extends StudentEntity {
  StudentModel({
    required super.id,
    required super.name,
    required super.email,
    required super.ageGroup,
    required super.gender,
    required super.nationality,
    required super.number,
    super.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age_group': ageGroup,
      'email': email,
      'gender': gender,
      'nationality': nationality,
      'image_url': imageUrl,
      'mobile': number,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? '',
      ageGroup: json['age_group'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      nationality: json['nationality'] ?? '',
      imageUrl: json['image_url'] ?? '',
      number: json['mobile'] ?? '',
    );
  }
}
