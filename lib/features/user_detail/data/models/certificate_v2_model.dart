import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_v2_entity.dart';

class CertificateV1V2MappingModel extends CertificateV1V2MappingEntity {
  CertificateV1V2MappingModel({
    required super.id,
    required super.userId,
    required super.certificateV1Id,
    required super.certificateMaster,
  });

  factory CertificateV1V2MappingModel.fromJson(Map<String, dynamic> json) =>
      CertificateV1V2MappingModel(
        id: json["id"].toString(),
        userId: json["user_id"],
        certificateV1Id: json["v1_certificate_id"],
        certificateMaster:
            CertificateMasterFetch.fromJson(json["certificate_master"]),
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'v1_certificate_id': certificateV1Id,
      'certificate_master': certificateMaster,
    };
  }
}

class CertificateMasterFetch extends CertificateMaster {
  CertificateMasterFetch({
    required super.id,
    required super.issueAuthority,
    required super.issueYear,
    required super.numberOfHours,
    required super.certificateNameArabic,
    required super.certificateNameEnglish,
    required super.certificateCountry,
    required super.skillLevel,
    required super.skillType,
    required super.tags,
    required super.insertedAt,
  });

  factory CertificateMasterFetch.fromJson(Map<String, dynamic> json) =>
      CertificateMasterFetch(
        id: json["id"].toString(),
        issueAuthority: json["issue_authority"],
        issueYear: json["issue_year"],
        numberOfHours: json["number_of_hours"],
        certificateNameArabic: json["certificate_name_arabic"],
        certificateNameEnglish: json["certificate_name_english"],
        certificateCountry: json["certificate_country"],
        skillLevel: json["skill_level"],
        skillType: json["skill_type"],
        tags: List<String>.from(json["tags"]),
        insertedAt: json["inserted_at"],
      );
}
