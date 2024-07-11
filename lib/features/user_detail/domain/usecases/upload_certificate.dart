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
        skillId: params.skillId,
        certificateImage: params.image);
  }
}

class UploadCertificateParms {
  final String userId;
  final String skillId;
  final File image;

  UploadCertificateParms({
    required this.userId,
    required this.skillId,
    required this.image,
  });
}
