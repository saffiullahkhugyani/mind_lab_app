class User {
  final String id;
  final String email;
  final String name;
  final String ageGroup;
  final String mobile;
  final String gender;
  final String nationality;
  final int roleId;
  final String? imageUrl;
  final bool? isProfileComplete;
  final String? signupMethod;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.ageGroup,
    required this.mobile,
    required this.gender,
    required this.nationality,
    required this.roleId,
    this.imageUrl,
    this.isProfileComplete,
    this.signupMethod,
  });
}
