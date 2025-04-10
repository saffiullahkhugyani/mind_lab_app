import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_up.dart';

abstract interface class AuthRepository {
  Future<Either<ServerFailure, AuthResult>> getCurrentUser();

  Future<Either<ServerFailure, AuthResult>> signUpWithEmailPasword({
    required String name,
    required String email,
    required String password,
    required String ageGroup,
    required String mobile,
    required String gender,
    required File? imageFile,
    required String nationality,
    required int roleId,
  });

  Future<Either<ServerFailure, AuthResult>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<ServerFailure, AuthResult>> signInWithGoogle();

  Future<Either<ServerFailure, AuthResult>> signInWithApple();

  Future<Either<ServerFailure, AuthResult>> updateUserInfo({
    required String id,
    required String name,
    required String email,
    required String ageGroup,
    required String mobile,
    required String gender,
    required String nationality,
    required int roleId,
  });
}
