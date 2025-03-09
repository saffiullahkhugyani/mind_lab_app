import 'dart:developer';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/user_detail/data/datasources/user_detail_remote_data_source.dart';
import 'package:mind_lab_app/features/user_detail/data/models/player_rank_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/register_player_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/update_profile_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/upload_certificate_model.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_upload_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_v2_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_tag_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skills_type_entity.dart';
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
  Future<Either<ServerFailure, StudentDetailResult>> getStudentDetails({
    required String parentId,
    required String studentId,
    required int roleId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
            ServerFailure(errorMessage: "Check your internet connection"));
      }

      final studentDetail = await userDetailRemoteDataSource.getStudentDetails(
        parentId: parentId,
        studentId: studentId,
        roleId: roleId,
      );
      final userCertificate =
          await userDetailRemoteDataSource.getCertificates();
      final certificateMaster =
          await userDetailRemoteDataSource.getCertificateMasterData();
      final playerRegistration =
          await userDetailRemoteDataSource.getPlayerRegistration();

      return right(StudentDetailResult(
        studentDetails: studentDetail,
        certificates: userCertificate,
        certificateMasterList: certificateMaster,
        playerRegistration: playerRegistration,
      ));
    } on ServerException catch (e) {
      log(e.message);
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, List<SkillTypeEntity>>> getSkillTypes() async {
    try {
      final skillList = await userDetailRemoteDataSource.getSkillTypes();
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
  Future<Either<ServerFailure, List<SkillTagEntity>>> getSkillTags() async {
    try {
      final skillHashtagList = await userDetailRemoteDataSource.getSkillTags();
      return right(skillHashtagList);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, UploadCertificateEntity>> uploadCertificate({
    required String studentId,
    required String certificateName,
    required File certificateImage,
    String? skillType,
    String? skillCategory,
    String? skillTag,
  }) async {
    UploadCertificateModel certificateModel = UploadCertificateModel(
      studentId: studentId,
      certificateName: certificateName,
      certificateImageUrl: "",
      skillType: skillType,
      skillCategory: skillCategory,
      skillTag: skillCategory,
    );

    log(certificateModel.toJson().toString());
    try {
      // uploading certificate
      final uploadedCertificate =
          await userDetailRemoteDataSource.uploadCertificate(certificateModel);

      certificateModel = certificateModel.copyWith(id: uploadedCertificate.id);

      // uploading certificate image
      final url = await userDetailRemoteDataSource.uploadCertificateImage(
        imageFile: certificateImage,
        certificateModel: certificateModel,
      );

      certificateModel = certificateModel.copyWith(certificateImageUrl: url);

      return right(uploadedCertificate);
    } on ServerException catch (e) {
      log(e.message);
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

  @override
  Future<Either<ServerFailure, List<PlayerRankModel>>>
      getPlayerRankDetails() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
            ServerFailure(errorMessage: "Check your internet connection"));
      }

      final playerRankDetails =
          await userDetailRemoteDataSource.getPlayerRankDetails();

      return right(playerRankDetails);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }
}
