
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_entity.dart';

class CertificateModel extends CertificateEntity {
  CertificateModel({
    required super.id,
    required super.userId,
    required super.skill,
    required super.certificateImageUrl,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
        id: json['id'],
        userId: json['user_id'],
        skill: SkillModelFetch.fromJson(json['skills']),
        certificateImageUrl: json['certificate_image_url']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'skills': skill,
      'certificate_image_url': certificateImageUrl,
    };
  }
}

class SkillModelFetch extends Skill {
  SkillModelFetch({
    required super.id,
    required super.name,
  });

  factory SkillModelFetch.fromJson(Map<String, dynamic> json) {
    return SkillModelFetch(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }
}
