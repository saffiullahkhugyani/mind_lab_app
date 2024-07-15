import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/certificate_upload_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_hashtag_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skills_entity.dart';
// import 'package:mind_lab_app/features/user_detail/domain/entities/user_detail_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_user_detail.dart';

import '../entities/update_profile_entity.dart';

abstract interface class UserDetailRepository {
  Future<Either<ServerFailure, UserDetailResult>> getUserDetails();
  Future<Either<ServerFailure, List<SkillEntity>>> getSkills();
  Future<Either<ServerFailure, List<SkillHashTagEntity>>> getSkillHashtags();
  Future<Either<ServerFailure, List<SkillCategoryEntity>>> getSkillCategories();
  Future<Either<ServerFailure, UploadCertificateEntity>> uploadCertificate({
    required String userId,
    required String skillId,
    required File certificateImage,
  });
  Future<Either<ServerFailure, UpdateProfileEntity>> updateProfile({
    String? userId,
    String? name,
    String? number,
    String? dateOfBirth,
    File? profileImageFile,
  });
}
