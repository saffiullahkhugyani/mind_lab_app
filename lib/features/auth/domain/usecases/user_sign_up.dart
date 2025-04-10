import 'dart:developer';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/common/entities/user.dart';

class UserSignUp implements UseCase<AuthResult, UserSignUpParams> {
  final AuthRepository authRepository;
  UserSignUp(this.authRepository);

  @override
  Future<Either<ServerFailure, AuthResult>> call(
      UserSignUpParams params) async {
    log("in use case ${params.email}");
    return await authRepository.signUpWithEmailPasword(
      name: params.name,
      email: params.email,
      password: params.password,
      ageGroup: params.ageGroup,
      mobile: params.mobile,
      gender: params.gender,
      imageFile: params.imageFile,
      nationality: params.nationality,
      roleId: params.roleId,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  final String ageGroup;
  final String mobile;
  final String gender;
  final File? imageFile;
  final String nationality;
  final int roleId;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
    required this.ageGroup,
    required this.mobile,
    required this.gender,
    required this.imageFile,
    required this.nationality,
    required this.roleId,
  });
}

class AuthResult {
  final User user;
  final StudentEntity? student;

  AuthResult({
    required this.user,
    this.student,
  });
}
