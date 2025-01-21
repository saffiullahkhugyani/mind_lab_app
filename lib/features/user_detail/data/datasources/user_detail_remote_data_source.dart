import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/user_detail/data/models/certificate_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/certificate_v2_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/player_rank_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/register_player_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_category_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_tag_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_type_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/update_profile_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/user_detail_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';
import '../models/upload_certificate_model.dart';
import 'package:crypto/crypto.dart';

abstract interface class UserDetailRemoteDataSource {
  Future<List<UserDetailModel>> getUserDetails();
  Future<List<SkillTypeModel>> getSkillTypes();
  Future<List<SkillTagModel>> getSkillTags();
  Future<List<SkillCategoryModel>> getSkillCategories();
  Future<List<CertificateModel>> getCertificates();
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
  Future<String> deleteAccount();
  Future<void> signOut();
  Future<List<CertificateV1V2MappingModel>> getCertificateMasterData();
  Future<RegisterPlayerModel> registerPlayer(RegisterPlayerModel playerModel);
  Future<List<PlayerRankModel>> getPlayerRankDetails();
  Future<List<RegisterPlayerModel>> getPlayerRegistration();
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
  Future<List<CertificateModel>> getCertificates() async {
    try {
      // getting user UID
      final userUid = supabaseClient.auth.currentUser!.id;

      // fetching user certificates
      final userCertificates = await supabaseClient
          .from('upload_certificate')
          .select('id, user_id, skills(id,name), certificate_image_url')
          .match({'user_id': userUid});

      return userCertificates
          .map((json) => CertificateModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SkillTypeModel>> getSkillTypes() async {
    try {
      final skillList = await supabaseClient.from('skill_types').select();
      return skillList.map((json) => SkillTypeModel.fromJson(json)).toList();
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
  Future<List<SkillTagModel>> getSkillTags() async {
    try {
      final skillTags = await supabaseClient.from('skill_tags').select();

      return skillTags.map((json) => SkillTagModel.fromJson(json)).toList();
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
      final String fileName = basename(imageFile.path);
      final path =
          '${certificateModel.userId}/${certificateModel.skillId}/$fileName';
      await supabaseClient.storage
          .from('certificate_images')
          .upload(path, imageFile);

      return supabaseClient.storage
          .from('certificate_images')
          .getPublicUrl(path);
    } on StorageException catch (e) {
      throw ServerException(e.error!);
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
          .match({'id': profileModel.userId!});

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

  @override
  Future<String> deleteAccount() async {
    try {
      final user = supabaseClient.auth.currentUser;
      final response = await Supabase.instance.client.rpc('delete_user');

      if (user != null) {
        if (response != null) {
          log("Remote Data source: $response");

          return response.toString();
        }
      }
      throw ServerException(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
      await GoogleSignIn().signOut();
      log("data source: try");
    } on AuthException catch (e) {
      log("data source: AuthException  ${e.message}");
      throw ServerException(e.message);
    } catch (e) {
      log("data source: catch  $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CertificateV1V2MappingModel>> getCertificateMasterData() async {
    try {
      // getting user UID
      final userUid = supabaseClient.auth.currentUser!.id;

      // fetching user certificates
      final certificateMaster = await supabaseClient
          .from('certificate_v1_v2_mapping')
          .select('id, user_id, v1_certificate_id, certificate_master(*)')
          .match({'user_id': userUid})
          .not("certificate_master", "is", null)
          .eq("certificate_master.certificate_status", true);

      return certificateMaster
          .map((json) => CertificateV1V2MappingModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RegisterPlayerModel> registerPlayer(
    RegisterPlayerModel playerModel,
  ) async {
    try {
      // checking if user has already registered
      final registeredPlayer = await supabaseClient
          .from('register_player')
          .select('*')
          .match({'player_id': playerModel.playerId});

      if (registeredPlayer.isNotEmpty) {
        throw ServerException(
            "Player already exsits with id: ${RegisterPlayerModel.fromJson(registeredPlayer.first).playerId}");
      }

      final reg = await supabaseClient
          .from("register_player")
          .insert(
            playerModel.toJson(),
          )
          .select();

      return RegisterPlayerModel.fromJson(reg.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on ServerException catch (e) {
      print(e.message);
      throw ServerException(
        e.message,
      );
    }
  }

  // to get the player Id
  String generateShortUUID(String id) {
    var uuid = id; // Generate a standard UUID
    var bytes = utf8.encode(uuid); // Convert it to bytes
    var hash = sha256.convert(bytes); // Create a SHA-256 hash
    return hash.toString().substring(0, 5); // Return the first 8 characters
  }

  @override
  Future<List<PlayerRankModel>> getPlayerRankDetails() async {
    try {
      // getting current user Uid
      // getting current user Uid
      final userUid = supabaseClient.auth.currentUser!.id;
      final playerId = generateShortUUID(userUid);

      // fetching user details
      final response = await supabaseClient
          .from('player_race_stats')
          .select('*')
          .eq("player_id", playerId);

      log(response.toString());

      return response.map((json) => PlayerRankModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      log(e.message);
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RegisterPlayerModel>> getPlayerRegistration() async {
    try {
      // getting current user Uid
      final userUid = supabaseClient.auth.currentUser!.id;
      // fetchingall registered players
      final response = await supabaseClient
          .from('register_player')
          .select("*")
          .eq("user_id", userUid);

      return response
          .map((json) => RegisterPlayerModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      log(e.message);
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }
}
