import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/auth/domain/repository/auth_repository.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_up.dart';

class UserLoginWithGoogle implements UseCase<AuthResult, NoParams> {
  final AuthRepository repository;
  const UserLoginWithGoogle(this.repository);

  @override
  Future<Either<ServerFailure, AuthResult>> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}
