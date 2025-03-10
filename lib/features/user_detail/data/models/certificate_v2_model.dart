import 'package:mind_lab_app/features/user_detail/data/models/tag_model.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_v2_entity.dart';

class CertificateV1V2MappingModel extends CertificateV1V2MappingEntity {
  CertificateV1V2MappingModel({
    required super.id,
    required super.stuentId,
    required super.certificateV1Id,
    required super.certificateMaster,
  });

  factory CertificateV1V2MappingModel.fromJson(Map<String, dynamic> json) =>
      CertificateV1V2MappingModel(
        id: json["id"].toString(),
        stuentId: json["student_id"],
        certificateV1Id: json["v1_certificate_id"],
        certificateMaster:
            CertificateMasterFetch.fromJson(json["certificate_master"]),
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': stuentId,
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
  factory CertificateMasterFetch.fromJson(Map<String, dynamic> json) {
    // print('Raw JSON for CertificateMasterFetch: $json'); // Debug print

    try {
      // print('Parsing tags: ${json["tags"]}'); // Debug print

      return CertificateMasterFetch(
        id: json["id"]?.toString() ?? '',
        issueAuthority: json["issue_authority"]?.toString() ?? '',
        issueYear: json["issue_year"]?.toString() ?? '',
        numberOfHours: json["number_of_hours"] ?? 0,
        certificateNameArabic:
            json["certificate_name_arabic"]?.toString() ?? '',
        certificateNameEnglish:
            json["certificate_name_english"]?.toString() ?? '',
        certificateCountry: json["certificate_country"]?.toString() ?? '',
        skillLevel: json["skill_level"]?.toString() ?? '',
        skillType: json["skill_type"]?.toString() ?? '',
        tags: (json["tags"] as List<dynamic>?)?.map((x) {
              // print('Processing tag: $x'); // Debug print
              return TagModel.fromJson(x as Map<String, dynamic>);
            }).toList() ??
            [],
        insertedAt: json["inserted_at"]?.toString() ?? '',
      );
    } catch (e, stackTrace) {
      print('Error in CertificateMasterFetch.fromJson: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
