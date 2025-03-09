import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
// import 'package:mind_lab_app/features/user_detail/data/models/upload_certificate_model.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_upload_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_v2_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/register_player_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

// import '../../data/models/certificate_model.dart';

class GetUserDetail
    implements UseCase<StudentDetailResult, StudentDetailParams> {
  final UserDetailRepository userDetailRepository;
  GetUserDetail(this.userDetailRepository);
  @override
  Future<Either<ServerFailure, StudentDetailResult>> call(
      StudentDetailParams params) async {
    return await userDetailRepository.getStudentDetails(
      parentId: params.parentId,
      studentId: params.studentId,
      roleId: params.roleId,
    );
  }
}

class StudentDetailParams {
  final String parentId;
  final String studentId;
  final int roleId;

  StudentDetailParams({
    required this.parentId,
    required this.studentId,
    required this.roleId,
  });
}

class StudentDetailResult {
  final List<StudentEntity> studentDetails;
  final List<UploadCertificateEntity> certificates;
  final List<CertificateV1V2MappingEntity> certificateMasterList;
  final List<RegisterPlayerEntity> playerRegistration;

  StudentDetailResult(
      {required this.studentDetails,
      required this.certificates,
      required this.certificateMasterList,
      required this.playerRegistration});
}
