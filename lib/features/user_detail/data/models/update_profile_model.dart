import 'package:mind_lab_app/features/user_detail/domain/entities/update_profile_entity.dart';

class UpdateProfileModel extends UpdateProfileEntity {
  UpdateProfileModel({
    super.userId,
    super.name,
    super.dateOfBirth,
    super.number,
    super.profileImageUrl,
  });

  UpdateProfileModel copyWith({
    String? userId,
    String? name,
    String? dateOfBirth,
    String? number,
    String? profileImageUrl,
  }) {
    return UpdateProfileModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      number: number ?? this.number,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      userId: json["id"],
      name: json["name"],
      dateOfBirth: json['age'],
      number: json["mobile"],
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": userId,
      "name": name,
      "age": dateOfBirth,
      "mobile": number,
      "profile_image_url": profileImageUrl,
    };
  }
}
