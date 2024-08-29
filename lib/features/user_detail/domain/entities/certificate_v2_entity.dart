class CertificateV1V2MappingEntity {
  final String id;
  final String userId;
  final String certificateV1Id;
  final CertificateMaster certificateMaster;

  CertificateV1V2MappingEntity({
    required this.id,
    required this.userId,
    required this.certificateV1Id,
    required this.certificateMaster,
  });
}

class CertificateMaster {
  final String id;
  final String issueAuthority;
  final String issueYear;
  final String numberOfHours;
  final String certificateNameArabic;
  final String certificateNameEnglish;
  final String certificateCountry;
  final String skillLevel;
  final String skillType;
  final List<String> tags;
  final String insertedAt;

  CertificateMaster({
    required this.id,
    required this.issueAuthority,
    required this.issueYear,
    required this.numberOfHours,
    required this.certificateNameArabic,
    required this.certificateNameEnglish,
    required this.certificateCountry,
    required this.skillLevel,
    required this.skillType,
    required this.tags,
    required this.insertedAt,
  });
}
