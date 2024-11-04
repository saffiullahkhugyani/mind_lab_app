import 'dart:developer';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/user_detail/data/datasources/user_detail_remote_data_source.dart';
import 'package:mind_lab_app/features/user_detail/data/models/register_player_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/update_profile_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/upload_certificate_model.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_upload_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_v2_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_hashtag_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skills_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/update_profile_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_user_detail.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/connection_checker.dart';

class UserDetailRepositoryImpl implements UserDetailRepository {
  final UserDetailRemoteDataSource userDetailRemoteDataSource;
  final ConnectionChecker connectionChecker;

  UserDetailRepositoryImpl(
      this.userDetailRemoteDataSource, this.connectionChecker);
  @override
  Future<Either<ServerFailure, UserDetailResult>> getUserDetails() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
            ServerFailure(errorMessage: "Check your internet connection"));
      }

      final userDetail = await userDetailRemoteDataSource.getUserDetails();
      final userCertificate =
          await userDetailRemoteDataSource.getCertificates();
      final certificateMaster =
          await userDetailRemoteDataSource.getCertificateMasterData();

      print(certificateMaster);

      return right(UserDetailResult(
        userDetails: userDetail,
        certificates: userCertificate,
        certificateMasterList: certificateMaster,
      ));
    } on ServerException catch (e) {
      log((e.message));
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

  @override
  Future<Either<ServerFailure, String>> deleteAccount() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(ServerFailure(
            errorMessage:
                "Please check your internet connection, and try again later."));
      }

      final message = await userDetailRemoteDataSource.deleteAccount();

      await userDetailRemoteDataSource.signOut();

      return right(message);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

// logic to be added
  @override
  Future<Either<ServerFailure, CertificateV1V2MappingEntity>>
      getCertificateMasterData() {
    // TODO: implement getCertificateMasterData
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerFailure, RegisterPlayerModel>> registerPlayer({
    required String playerId,
    required String userId,
    required String city,
    required String country,
  }) async {
    try {
      RegisterPlayerModel playerModel = RegisterPlayerModel(
        userId: userId,
        playerId: playerId,
        city: city,
        country: country,
      );

      final registeredPlayer =
          await userDetailRemoteDataSource.registerPlayer(playerModel);

      return right(registeredPlayer);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }
}
