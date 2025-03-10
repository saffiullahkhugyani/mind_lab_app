import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/register_player_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class RegisterPlayerUsecase
    implements UseCase<RegisterPlayerEntity, RegisterPlayerParams> {
  final UserDetailRepository repository;

  RegisterPlayerUsecase(this.repository);

  @override
  Future<Either<ServerFailure, RegisterPlayerEntity>> call(
      RegisterPlayerParams params) async {
    return await repository.registerPlayer(
      studentId: params.studentId,
      playerId: params.playerId,
      city: params.city,
      country: params.country,
    );
  }
}

class RegisterPlayerParams {
  final String studentId;
  final String playerId;
  final String city;
  final String country;

  RegisterPlayerParams({
    required this.studentId,
    required this.playerId,
    required this.city,
    required this.country,
  });
}
