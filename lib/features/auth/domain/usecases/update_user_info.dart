import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_up.dart';

import '../repository/auth_repository.dart';

class UpdateUserInfoUseCase
    implements UseCase<AuthResult, UpdateUserInfoParams> {
  final AuthRepository authRepository;

  UpdateUserInfoUseCase({required this.authRepository});

  @override
  Future<Either<ServerFailure, AuthResult>> call(
      UpdateUserInfoParams params) async {
    return await authRepository.updateUserInfo(
      id: params.id,
      name: params.name,
      email: params.email,
      ageGroup: params.ageGroup,
      mobile: params.mobile,
      gender: params.gender,
      nationality: params.nationality,
      roleId: params.roleId,
    );
  }
}

class UpdateUserInfoParams {
  final String id;
  final String email;
  final String name;
  final String ageGroup;
  final String mobile;
  final String gender;
  final String nationality;
  final int roleId;

  UpdateUserInfoParams(
      {required this.id,
      required this.email,
      required this.name,
      required this.ageGroup,
      required this.mobile,
      required this.gender,
      required this.nationality,
      required this.roleId});
}
