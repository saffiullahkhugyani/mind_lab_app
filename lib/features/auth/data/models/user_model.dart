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
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '-',
      email: map['email'] ?? '-',
      name: map['name'] ?? '-',
      ageGroup: map['age'] ?? '-',
      mobile: map['mobile'] ?? '-',
      gender: map['gender'] ?? '-',
      nationality: map['nationality'] ?? '-',
      roleId: map['role_id'] ?? 0,
    );
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
    );
  }
}
