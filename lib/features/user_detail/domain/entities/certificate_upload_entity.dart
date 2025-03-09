class UploadCertificateEntity {
  final int? id;
  final String studentId;
  final String certificateName;
  String? skillType;
  String? skillCategory;
  String? skillTag;
  final String certificateImageUrl;

  UploadCertificateEntity({
    this.id,
    required this.studentId,
    required this.certificateName,
    this.skillType,
    this.skillCategory,
    this.skillTag,
    required this.certificateImageUrl,
  });
}
