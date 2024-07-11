import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class GetSkillCategories
    implements UseCase<List<SkillCategoryEntity>, NoParams> {
  final UserDetailRepository userDetailRepository;
  const GetSkillCategories(this.userDetailRepository);
  @override
  Future<Either<ServerFailure, List<SkillCategoryEntity>>> call(
      NoParams params) {
    return userDetailRepository.getSkillCategories();
  }
}
