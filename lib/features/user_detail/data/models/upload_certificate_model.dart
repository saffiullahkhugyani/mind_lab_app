import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_upload_entity.dart';

class UploadCertificateModel extends UploadCertificateEntity {
  UploadCertificateModel({
    super.id,
    required super.studentId,
    required super.certificateName,
    required super.certificateImageUrl,
    super.skillType,
    super.skillCategory,
    super.skillTag,
  });

  UploadCertificateModel copyWith({
    int? id,
    String? studentId,
    String? certificateName,
    String? certificateImageUrl,
    String? skillType,
    String? skillCategory,
    String? skillTag,
  }) {
    return UploadCertificateModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      certificateName: certificateName ?? this.certificateName,
      certificateImageUrl: certificateImageUrl ?? this.certificateImageUrl,
      skillType: skillType ?? this.skillType,
      skillCategory: skillCategory ?? this.skillCategory,
      skillTag: skillTag ?? this.skillTag,
    );
  }

  factory UploadCertificateModel.fromJson(Map<String, dynamic> json) {
    return UploadCertificateModel(
        id: json['id'] ?? 0,
        studentId: json['student_id'] ?? "",
        certificateName: json['certificate_name'] ?? "",
        certificateImageUrl: json['certificate_image_url'] ?? "",
        skillType: json['skill_type'] ?? "",
        skillCategory: json['skill_category'] ?? "",
        skillTag: json['skill_tag'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'student_id': studentId,
      'certificate_image_url': certificateImageUrl,
      'certificate_name': certificateName,
      'skill_type': skillType,
      'skill_category': skillCategory,
      'skill_tag': skillTag,
    };
  }
}
