class UploadCertificateEntity {
  final String id;
  final String userId;
  final String certificateName;
  String? skillType;
  String? skillCategory;
  String? skillTag;
  final String certificateImageUrl;

  UploadCertificateEntity({
    required this.id,
    required this.userId,
    required this.certificateName,
    this.skillType,
    this.skillCategory,
    this.skillTag,
    required this.certificateImageUrl,
  });
}
