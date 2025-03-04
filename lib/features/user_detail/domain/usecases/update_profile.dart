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
      childId: params.childId,
      name: params.name,
      email: params.email,
      ageGroup: params.ageGroup,
      profileImageFile: params.profileImageFile,
    );
  }
}

class UpdateProfileParams {
  int? childId;
  String? name;
  String? ageGroup;
  String? email;
  File? profileImageFile;

  UpdateProfileParams({
    this.childId,
    this.name,
    this.ageGroup,
    this.email,
    this.profileImageFile,
  });
}
