import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_upload_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class UploadCertificate
    implements UseCase<UploadCertificateEntity, UploadCertificateParms> {
  final UserDetailRepository repository;

  UploadCertificate(this.repository);

  @override
  Future<Either<ServerFailure, UploadCertificateEntity>> call(
      UploadCertificateParms params) async {
    return await repository.uploadCertificate(
      userId: params.userId,
      certificateImage: params.image,
      certificateName: params.certificateName,
      skillType: params.skillType,
      skillCategory: params.skillCategory,
      skillTag: params.skillTag,
    );
  }
}

class UploadCertificateParms {
  final String userId;
  final String certificateName;
  final File image;
  String? skillType;
  String? skillCategory;
  String? skillTag;

  UploadCertificateParms({
    required this.userId,
    required this.certificateName,
    required this.image,
    this.skillType,
    this.skillCategory,
    this.skillTag,
  });
}
