import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/auth/domain/repository/auth_repository.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_up.dart';

class UserLoginWithApple implements UseCase<AuthResult, NoParams> {
  final AuthRepository repository;
  const UserLoginWithApple(this.repository);

  @override
  Future<Either<ServerFailure, AuthResult>> call(NoParams params) async {
    return await repository.signInWithApple();
  }
}
