import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_upload_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_v2_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/player_rank_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/register_player_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_tag_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skills_type_entity.dart';
// import 'package:mind_lab_app/features/user_detail/domain/entities/user_detail_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_user_detail.dart';

import '../entities/update_profile_entity.dart';

abstract interface class UserDetailRepository {
  // fetching user details
  Future<Either<ServerFailure, StudentDetailResult>> getStudentDetails({
    required String parentId,
    required String studentId,
    required int roleId,
  });

  // fetching skill data
  Future<Either<ServerFailure, List<SkillTypeEntity>>> getSkillTypes();

  // fetching skill hashtags
  Future<Either<ServerFailure, List<SkillTagEntity>>> getSkillTags();

  // fetching skill categories
  Future<Either<ServerFailure, List<SkillCategoryEntity>>> getSkillCategories();

  // uploading certificate
  Future<Either<ServerFailure, UploadCertificateEntity>> uploadCertificate({
    required String studentId,
    required String certificateName,
    required File certificateImage,
    String? skillType,
    String? skillCategory,
    String? skillTag,
  });

  // updating user profile
  Future<Either<ServerFailure, UpdateProfileEntity>> updateProfile({
    String? userId,
    String? name,
    String? number,
    String? dateOfBirth,
    File? profileImageFile,
  });

  // deleting user account
  Future<Either<ServerFailure, String>> deleteAccount();

  // fetching data of certificate vertion 2
  Future<Either<ServerFailure, CertificateV1V2MappingEntity>>
      getCertificateMasterData();

  // registering player for up comming race
  Future<Either<ServerFailure, RegisterPlayerEntity>> registerPlayer({
    required String playerId,
    required String userId,
    required String city,
    required String country,
  });

  // fething player rank details
  Future<Either<ServerFailure, List<PlayerRankEntity>>> getPlayerRankDetails();
}
