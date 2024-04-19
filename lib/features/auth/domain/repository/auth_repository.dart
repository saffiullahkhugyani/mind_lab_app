import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/common/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<ServerFailure, User>> getCurrentUser();

  Future<Either<ServerFailure, User>> signUpWithEmailPasword({
    required String name,
    required String email,
    required String password,
    required String age,
    required String mobile,
  });

  Future<Either<ServerFailure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  });
}
