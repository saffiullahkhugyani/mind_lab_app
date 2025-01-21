import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skills_type_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class GetSkills implements UseCase<List<SkillTypeEntity>, NoParams> {
  final UserDetailRepository userDetailRepository;
  GetSkills(this.userDetailRepository);

  @override
  Future<Either<ServerFailure, List<SkillTypeEntity>>> call(NoParams params) {
    return userDetailRepository.getSkillTypes();
  }
}
