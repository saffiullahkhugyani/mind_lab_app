import '../../../../core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.ageGroup,
    required super.mobile,
    required super.gender,
    required super.nationality,
    required super.roleId,
    super.imageUrl,
    super.isProfileComplete,
    super.signupMethod,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': ageGroup,
      'email': email,
      'gender': gender,
      'nationality': nationality,
      'profile_image_url': imageUrl,
      'mobile': mobile,
      'role_id': roleId,
      'is_profile_complete': isProfileComplete,
      'signup_method': signupMethod,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] ?? '-',
        email: map['email'] ?? '-',
        name: map['name'] ?? '-',
        ageGroup: map['age'] ?? '-', // 'age' from API, maps to ageGroup
        mobile: map['mobile'] ?? '-',
        gender: map['gender'] ?? '-',
        nationality: map['nationality'] ?? '-',
        roleId: map['role_id'] ?? 0,
        imageUrl: map['profile_image_url'] ?? '-',
        isProfileComplete: map['is_profile_complete'] ?? false,
        signupMethod: map['signup_method'] ?? '-');
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? ageGroup,
    String? mobile,
    String? gender,
    String? nationality,
    int? roleId,
    String? imageUrl,
    bool? isProfileComplete,
    String? signupMethod,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      ageGroup: ageGroup ?? this.ageGroup,
      mobile: mobile ?? this.mobile,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      roleId: roleId ?? this.roleId,
      imageUrl: imageUrl ?? this.imageUrl,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      signupMethod: signupMethod ?? this.signupMethod,
    );
  }
}
