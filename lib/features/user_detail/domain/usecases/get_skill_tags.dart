import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_tag_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class GetSkillHashtags implements UseCase<List<SkillTagEntity>, NoParams> {
  final UserDetailRepository userDetailRepository;
  const GetSkillHashtags(this.userDetailRepository);
  @override
  Future<Either<ServerFailure, List<SkillTagEntity>>> call(NoParams params) {
    return userDetailRepository.getSkillTags();
  }
}
