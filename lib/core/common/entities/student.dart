class StudentEntity {
  final String id;
  final String name;
  final String email;
  final String ageGroup;
  final String gender;
  final String nationality;
  final String number;
  final String? imageUrl;
  final String? profileId;

  StudentEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.ageGroup,
    required this.gender,
    required this.number,
    required this.nationality,
    this.profileId,
    this.imageUrl,
  });
}
