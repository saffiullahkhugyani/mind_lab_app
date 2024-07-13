import 'dart:developer';
import 'dart:io';

import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_category_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_hashtag_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/update_profile_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/user_detail_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/upload_certificate_model.dart';

abstract interface class UserDetailRemoteDataSource {
  Future<List<UserDetailModel>> getUserDetails();
  Future<List<SkillModel>> getSkills();
  Future<List<SkillHashtagModel>> getSkillsHashtag();
  Future<List<SkillCategoryModel>> getSkillCategories();
  Future<UploadCertificateModel> uploadCertificate(
      UploadCertificateModel certificateModel);
  Future<String> uploadCertificateImage({
    required File imageFile,
    required UploadCertificateModel certificateModel,
  });
  Future<UpdateProfileModel> updateProfile(UpdateProfileModel profileModel);
  Future<String> updateProfileImage({
    File? imageFile,
    UpdateProfileModel? profileModel,
  });
}

class UserDetailRemoteDataSourceImpl implements UserDetailRemoteDataSource {
  final SupabaseClient supabaseClient;
  UserDetailRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<List<UserDetailModel>> getUserDetails() async {
    try {
      // getting current user Uid
      final userUid = supabaseClient.auth.currentUser!.id;

      // fetching user details
      final userDetail = await supabaseClient
          .from('profiles')
          .select('*')
          .match({'id': userUid});
      return userDetail.map((json) => UserDetailModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SkillModel>> getSkills() async {
    try {
      final skillList = await supabaseClient.from('skills').select();
      return skillList.map((json) => SkillModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SkillCategoryModel>> getSkillCategories() async {
    try {
      final skillCategoryList =
          await supabaseClient.from('skill_category').select();
      return skillCategoryList
          .map((json) => SkillCategoryModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SkillHashtagModel>> getSkillsHashtag() async {
    try {
      final skillHashtagList =
          await supabaseClient.from('skill_hashtags').select();
      return skillHashtagList
          .map((json) => SkillHashtagModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UploadCertificateModel> uploadCertificate(
      UploadCertificateModel certificateModel) async {
    try {
      final certificateData = await supabaseClient
          .from('upload_certificate')
          .insert(certificateModel.toJson())
          .select();

      return UploadCertificateModel.fromJson(certificateData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadCertificateImage({
    required File imageFile,
    required certificateModel,
  }) async {
    try {
      final path = '${certificateModel.userId}/${certificateModel.skillId}';
      supabaseClient.storage.from('certificate_images').upload(path, imageFile);

      return supabaseClient.storage
          .from('certificate_images')
          .getPublicUrl(path);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UpdateProfileModel> updateProfile(
    UpdateProfileModel profileModel,
  ) async {
    try {
      // existing user data
      final userDetail = await supabaseClient
          .from('profiles')
          .select('*')
          .match({'id': profileModel.userId});

      final UpdateProfileModel model =
          UpdateProfileModel.fromJson(userDetail.first);

      final profileData = await supabaseClient
          .from('profiles')
          .update({
            "name":
                profileModel.name!.isNotEmpty ? profileModel.name : model.name,
            "age": profileModel.dateOfBirth!.isNotEmpty
                ? profileModel.dateOfBirth
                : model.dateOfBirth,
            "mobile": profileModel.number!.isNotEmpty
                ? profileModel.number
                : model.number,
            "profile_image_url": profileModel.profileImageUrl!.isNotEmpty
                ? profileModel.profileImageUrl
                : model.profileImageUrl,
          })
          .eq('id', profileModel.userId!)
          .select();

      return UpdateProfileModel.fromJson(profileData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateProfileImage({
    File? imageFile,
    UpdateProfileModel? profileModel,
  }) async {
    try {
      final uploadPath = '${profileModel!.userId}/${profileModel.userId}-image';

      if (imageFile == null) {
        return supabaseClient.storage
            .from('profile-images')
            .getPublicUrl(uploadPath);
      }

      final path = '${profileModel.userId}/';
      final response =
          await supabaseClient.storage.from('profile-images').list(path: path);

// Check if the file exists
      bool fileExists = false;
      for (final file in response) {
        log(file.name);
        if (file.name == "${profileModel.userId}-image") {
          fileExists = true;
          break;
        }
      }

      if (fileExists) {
        log('File exists, updating...');
        await supabaseClient.storage
            .from('profile-images')
            .update(uploadPath, imageFile);

        log('File updated successfully.');
      } else {
        log('File does not exist, uploading...');
        await supabaseClient.storage
            .from('profile-images')
            .upload(uploadPath, imageFile);

        log('File uploaded successfully.');
      }

      // cashe busting url for lattest image upload
      final url = supabaseClient.storage
          .from('profile-images')
          .getPublicUrl(uploadPath);

      return '$url?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
