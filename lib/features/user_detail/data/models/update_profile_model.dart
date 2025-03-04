import 'package:mind_lab_app/features/user_detail/domain/entities/update_profile_entity.dart';

class UpdateProfileModel extends UpdateProfileEntity {
  UpdateProfileModel({
    super.childId,
    super.name,
    super.ageGroup,
    super.email,
    super.profileImageUrl,
  });

  UpdateProfileModel copyWith({
    int? childId,
    String? name,
    String? ageGroup,
    String? email,
    String? profileImageUrl,
  }) {
    return UpdateProfileModel(
      childId: childId ?? this.childId,
      name: name ?? this.name,
      ageGroup: ageGroup ?? this.ageGroup,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      childId: json["id"],
      name: json["name"],
      ageGroup: json['age_group'],
      email: json["email"],
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": childId,
      "name": name,
      "age_group": ageGroup,
      "email": email,
      "profile_image_url": profileImageUrl,
    };
  }
}
