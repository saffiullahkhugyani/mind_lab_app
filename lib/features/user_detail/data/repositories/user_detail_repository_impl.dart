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
import '../../../../core/network/connection_checker.dart';
import '../models/parent_child_relationship_model.dart';

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
    required String studentProfileId,
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
      final userCertificate = await userDetailRemoteDataSource.getCertificates(
          studentId: studentId);
      final certificateMaster =
          await userDetailRemoteDataSource.getCertificateMasterData(
        studentId: studentId,
      );
      final playerRegistration =
          await userDetailRemoteDataSource.getPlayerRegistration(
        studentId: studentId,
      );

      final notifications = await userDetailRemoteDataSource.getNotifications(
          studentProfileId: studentProfileId);

      // Fetch sender details for notifications that have a sender
      for (var i = 0; i < notifications.length; i++) {
        if (notifications[i].senderId != null &&
            notifications[i].senderId!.isNotEmpty) {
          final senderDetails =
              await userDetailRemoteDataSource.getNotificaionSenderDetails(
                  notificationSenderId: notifications[i].senderId!);

          // Assign the new updated object back to the list
          notifications[i] =
              notifications[i].copyWith(senderDetails: senderDetails);

          log('notification check ${senderDetails.id}');
          log('notification check ${notifications[i].senderDetails}'); // Now it will have a value
        }
      }

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
  Future<Either<ServerFailure, UpdateStudentEntity>> updateProfile({
    String? studentId,
    String? name,
    String? number,
    String? email,
    String? dateOfBirth,
    File? profileImageFile,
  }) async {
    log("here");
    log(studentId!);
    log(name!);
    try {
      UpdateStudentModel updateProfileModel = UpdateStudentModel(
        studentId: studentId,
        name: name,
        dateOfBirth: dateOfBirth,
        number: number,
        profileImageUrl: "",
      );
      final imageUrl = await userDetailRemoteDataSource.updateProfileImage(
          imageFile: profileImageFile, studentModel: updateProfileModel);

      updateProfileModel =
          updateProfileModel.copyWith(profileImageUrl: imageUrl);

      final updatedProfileData =
          await userDetailRemoteDataSource.updateProfile(updateProfileModel);

      return right(updatedProfileData);
    } on ServerException catch (e) {
      log(e.toString());
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
    required String studentId,
    required String city,
    required String country,
  }) async {
    try {
      RegisterPlayerModel playerModel = RegisterPlayerModel(
        studentId: studentId,
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
  Future<Either<ServerFailure, List<PlayerRankModel>>> getPlayerRankDetails({
    required String playerId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
            ServerFailure(errorMessage: "Check your internet connection"));
      }

      final playerRankDetails = await userDetailRemoteDataSource
          .getPlayerRankDetails(playerId: playerId);

      return right(playerRankDetails);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, ParentChildRelationshipModel>>
      allowParentAccess({
    required int notificationId,
    required String parentId,
    required String studentId,
    required String studentProfileId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
            ServerFailure(errorMessage: "Check your internet connection"));
      }

      final allowParentAccess =
          await userDetailRemoteDataSource.allowParentAccess(
        notificationId: notificationId,
        parentId: parentId,
        childId: studentId,
        studentProfileId: studentProfileId,
      );

      return right(allowParentAccess);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }
}
