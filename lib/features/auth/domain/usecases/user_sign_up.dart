import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/common/entities/user.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  UserSignUp(this.authRepository);

  @override
  Future<Either<ServerFailure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPasword(
      name: params.name,
      email: params.email,
      password: params.password,
      ageGroup: params.ageGroup,
      mobile: params.mobile,
      gender: params.gender,
      imageFile: params.imageFile,
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
  final File imageFile;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
    required this.ageGroup,
    required this.mobile,
    required this.gender,
    required this.imageFile,
  });
}
