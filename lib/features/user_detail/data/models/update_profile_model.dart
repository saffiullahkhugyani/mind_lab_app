import 'package:mind_lab_app/features/user_detail/domain/entities/update_profile_entity.dart';

class UpdateStudentModel extends UpdateStudentEntity {
  UpdateStudentModel({
    super.studentId,
    super.name,
    super.dateOfBirth,
    super.number,
    super.profileImageUrl,
    super.email,
  });

  UpdateStudentModel copyWith({
    String? studentId,
    String? name,
    String? dateOfBirth,
    String? number,
    String? profileImageUrl,
    String? email,
  }) {
    return UpdateStudentModel(
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      number: number ?? this.number,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      email: email ?? this.email,
    );
  }

  factory UpdateStudentModel.fromJson(Map<String, dynamic> json) {
    return UpdateStudentModel(
      studentId: json["id"],
      name: json["name"],
      dateOfBirth: json['age'],
      number: json["mobile"],
      profileImageUrl: json['profile_image_url'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": studentId,
      "name": name,
      "age": dateOfBirth,
      "mobile": number,
      "profile_image_url": profileImageUrl,
      "email": email,
    };
  }
}
