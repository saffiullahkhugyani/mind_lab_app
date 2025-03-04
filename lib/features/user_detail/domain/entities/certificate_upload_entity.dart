class UploadCertificateEntity {
  final int? id;
  final int childId;
  final String certificateName;
  String? skillType;
  String? skillCategory;
  String? skillTag;
  final String certificateImageUrl;

  UploadCertificateEntity({
    this.id,
    required this.childId,
    required this.certificateName,
    this.skillType,
    this.skillCategory,
    this.skillTag,
    required this.certificateImageUrl,
  });
}
