import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/update_profile_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class UpdateProfile
    implements UseCase<UpdateStudentEntity, UpdateProfileParams> {
  final UserDetailRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<ServerFailure, UpdateStudentEntity>> call(
      UpdateProfileParams params) async {
    return await repository.updateProfile(
      studentId: params.studentId,
      name: params.name,
      number: params.number,
      dateOfBirth: params.dateOfBirth,
      profileImageFile: params.profileImageFile,
    );
  }
}

class UpdateProfileParams {
  String? studentId;
  String? name;
  String? dateOfBirth;
  String? number;
  File? profileImageFile;

  UpdateProfileParams({
    this.studentId,
    this.name,
    this.dateOfBirth,
    this.number,
    this.profileImageFile,
  });
}
