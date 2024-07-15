class CertificateEntity {
  final String id;
  final String userId;
  final Skill skill;
  final String certificateImageUrl;

  CertificateEntity({
    required this.id,
    required this.userId,
    required this.skill,
    required this.certificateImageUrl,
  });
}

class Skill {
  final int id;
  final String name;

  Skill({
    required this.id,
    required this.name,
  });
}
