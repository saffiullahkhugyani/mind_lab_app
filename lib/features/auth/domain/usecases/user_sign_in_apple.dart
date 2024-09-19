import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/common/entities/user.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/auth/domain/repository/auth_repository.dart';

class UserLoginWithApple implements UseCase<User, NoParams> {
  final AuthRepository repository;
  const UserLoginWithApple(this.repository);

  @override
  Future<Either<ServerFailure, User>> call(NoParams params) async {
    return await repository.signInWithApple();
  }
}
