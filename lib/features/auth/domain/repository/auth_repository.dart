import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/common/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<ServerFailure, User>> getCurrentUser();

  Future<Either<ServerFailure, User>> signUpWithEmailPasword({
    required String name,
    required String email,
    required String password,
    required String ageGroup,
    required String mobile,
    required String gender,
    required File imageFile,
    required String nationality,
  });

  Future<Either<ServerFailure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<ServerFailure, User>> signInWithGoogle();

  Future<Either<ServerFailure, User>> signInWithApple();
}
