import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/update_profile_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class UpdateProfile
    implements UseCase<UpdateProfileEntity, UpdateProfileParams> {
  final UserDetailRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<ServerFailure, UpdateProfileEntity>> call(
      UpdateProfileParams params) async {
    return await repository.updateProfile(
      userId: params.userId,
      name: params.name,
      number: params.number,
      dateOfBirth: params.dateOfBirth,
      profileImageFile: params.profileImageFile,
    );
  }
}

class UpdateProfileParams {
  String? userId;
  String? name;
  String? dateOfBirth;
  String? number;
  File? profileImageFile;

  UpdateProfileParams({
    this.userId,
    this.name,
    this.dateOfBirth,
    this.number,
    this.profileImageFile,
  });
}
