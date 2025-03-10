import 'package:mind_lab_app/features/user_detail/data/models/tag_model.dart';

class CertificateV1V2MappingEntity {
  final String id;
  final String stuentId;
  final int certificateV1Id;
  final CertificateMaster certificateMaster;

  CertificateV1V2MappingEntity({
    required this.id,
    required this.stuentId,
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
  final List<TagModel> tags; // adjusted to handle JSONB data
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

  factory CertificateMaster.fromJson(Map<String, dynamic> json) {
    return CertificateMaster(
      id: json['id'] as String,
      issueAuthority: json['issueAuthority'] as String,
      issueYear: json['issueYear'] as String,
      numberOfHours: json['numberOfHours'] as String,
      certificateNameArabic: json['certificateNameArabic'] as String,
      certificateNameEnglish: json['certificateNameEnglish'] as String,
      certificateCountry: json['certificateCountry'] as String,
      skillLevel: json['skillLevel'] as String,
      skillType: json['skillType'] as String,
      tags: json['tags'] as List<TagModel>, // Parsing as JSON
      insertedAt: json['insertedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issueAuthority': issueAuthority,
      'issueYear': issueYear,
      'numberOfHours': numberOfHours,
      'certificateNameArabic': certificateNameArabic,
      'certificateNameEnglish': certificateNameEnglish,
      'certificateCountry': certificateCountry,
      'skillLevel': skillLevel,
      'skillType': skillType,
      'tags': tags, // Serialize JSON
      'insertedAt': insertedAt,
    };
  }
}
