import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/player_rank_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class GetPlayerRankDetailUsecase
    implements UseCase<List<PlayerRankEntity>, NoParams> {
  final UserDetailRepository userDetailRepository;

  GetPlayerRankDetailUsecase(this.userDetailRepository);
  @override
  Future<Either<ServerFailure, List<PlayerRankEntity>>> call(
      NoParams params) async {
    return await userDetailRepository.getPlayerRankDetails();
  }
}
