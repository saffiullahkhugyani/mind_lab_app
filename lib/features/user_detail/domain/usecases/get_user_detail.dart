import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/common/entities/child_entity.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
// import 'package:mind_lab_app/features/user_detail/data/models/upload_certificate_model.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_upload_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_v2_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/register_player_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

// import '../../data/models/certificate_model.dart';

class GetUserDetail implements UseCase<UserDetailResult, int> {
  final UserDetailRepository userDetailRepository;
  GetUserDetail(this.userDetailRepository);
  @override
  Future<Either<ServerFailure, UserDetailResult>> call(int id) async {
    return await userDetailRepository.getUserDetails(childId: id);
  }
}

class UserDetailResult {
  final List<ChildEntity> childDetails;
  final List<UploadCertificateEntity> certificates;
  final List<CertificateV1V2MappingEntity> certificateMasterList;
  final List<RegisterPlayerEntity> playerRegistration;

  UserDetailResult(
      {required this.childDetails,
      required this.certificates,
      required this.certificateMasterList,
      required this.playerRegistration});
}
