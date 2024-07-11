import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_upload_entity.dart';

class UploadCertificateModel extends UploadCertificateEntity {
  UploadCertificateModel({
    required super.id,
    required super.userId,
    required super.skillId,
    required super.certificateImageUrl,
  });

  UploadCertificateModel copyWith({
    String? id,
    String? userId,
    String? skillId,
    String? certificateImageUrl,
  }) {
    return UploadCertificateModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      skillId: skillId ?? this.skillId,
      certificateImageUrl: certificateImageUrl ?? this.certificateImageUrl,
    );
  }

  factory UploadCertificateModel.fromJson(Map<String, dynamic> json) {
    return UploadCertificateModel(
      id: json['id'],
      userId: json['user_id'],
      skillId: json['skill_id'].toString(),
      certificateImageUrl: json['certificate_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'skill_id': int.parse(skillId),
      'certificate_image_url': certificateImageUrl
    };
  }
}
