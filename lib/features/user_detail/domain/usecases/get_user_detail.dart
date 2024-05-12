import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/user_detail_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class GetUserDetail implements UseCase<List<UserDetailEntity>, NoParams> {
  final UserDetailRepository userDetailRepository;
  GetUserDetail(this.userDetailRepository);
  @override
  Future<Either<ServerFailure, List<UserDetailEntity>>> call(
      NoParams params) async {
    return await userDetailRepository.getUserDetails();
  }
}
