import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/user_detail/data/datasources/user_detail_remote_data_source.dart';
import 'package:mind_lab_app/features/user_detail/data/models/update_profile_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/upload_certificate_model.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_upload_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_hashtag_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skills_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/update_profile_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/user_detail_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';
import 'package:uuid/uuid.dart';

class UserDetailRepositoryImpl implements UserDetailRepository {
  final UserDetailRemoteDataSource userDetailRemoteDataSource;
  UserDetailRepositoryImpl(this.userDetailRemoteDataSource);
  @override
  Future<Either<ServerFailure, List<UserDetailEntity>>> getUserDetails() async {
    try {
      final userDetail = await userDetailRemoteDataSource.getUserDetails();
      return right(userDetail);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, List<SkillEntity>>> getSkills() async {
    try {
      final skillList = await userDetailRemoteDataSource.getSkills();
      return right(skillList);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, List<SkillCategoryEntity>>>
      getSkillCategories() async {
    try {
      final skillCategories =
          await userDetailRemoteDataSource.getSkillCategories();
      return right(skillCategories);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, List<SkillHashTagEntity>>>
      getSkillHashtags() async {
    try {
      final skillHashtagList =
          await userDetailRemoteDataSource.getSkillsHashtag();
      return right(skillHashtagList);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, UploadCertificateEntity>> uploadCertificate({
    required String userId,
    required String skillId,
    required File certificateImage,
  }) async {
    try {
      UploadCertificateModel certificateModel = UploadCertificateModel(
        id: const Uuid().v1(),
        userId: userId,
        skillId: skillId,
        certificateImageUrl: "",
      );

      final url = await userDetailRemoteDataSource.uploadCertificateImage(
        imageFile: certificateImage,
        certificateModel: certificateModel,
      );

      certificateModel = certificateModel.copyWith(certificateImageUrl: url);

      final uploadedCertificate =
          await userDetailRemoteDataSource.uploadCertificate(certificateModel);

      return right(uploadedCertificate);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, UpdateProfileEntity>> updateProfile({
    String? userId,
    String? name,
    String? number,
    String? dateOfBirth,
    File? profileImageFile,
  }) async {
    try {
      UpdateProfileModel updateProfileModel = UpdateProfileModel(
        userId: userId,
        name: name,
        dateOfBirth: dateOfBirth,
        number: number,
        profileImageUrl: "",
      );
      final imageUrl = await userDetailRemoteDataSource.updateProfileImage(
          imageFile: profileImageFile, profileModel: updateProfileModel);

      updateProfileModel =
          updateProfileModel.copyWith(profileImageUrl: imageUrl);

      final updatedProfileData =
          await userDetailRemoteDataSource.updateProfile(updateProfileModel);

      return right(updatedProfileData);
    } on ServerException catch (e) {
      return left(
        ServerFailure(errorMessage: e.message),
      );
    }
  }
}
