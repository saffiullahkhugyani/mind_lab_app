class ChildEntity {
  final int id;
  final String name;
  final String email;
  final String ageGroup;
  final String gender;
  final String nationality;
  final String? imageUrl;

  ChildEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.ageGroup,
    required this.gender,
    required this.nationality,
    this.imageUrl,
  });
}
