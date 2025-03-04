import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
// import 'package:mind_lab_app/features/user_detail/data/models/certificate_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/certificate_v2_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/child_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/player_rank_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/register_player_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_category_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_tag_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_type_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/update_profile_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/user_detail_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:path/path.dart';
import '../models/upload_certificate_model.dart';
import 'package:crypto/crypto.dart';

abstract interface class UserDetailRemoteDataSource {
  Future<List<ChildModel>> getUserDetails({
    required int childId,
  });
  Future<List<SkillTypeModel>> getSkillTypes();
  Future<List<SkillTagModel>> getSkillTags();
  Future<List<SkillCategoryModel>> getSkillCategories();
  Future<List<UploadCertificateModel>> getCertificates({
    required int childId,
  });
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
  Future<List<CertificateV1V2MappingModel>> getCertificateMasterData(
      {required int childId});
  Future<RegisterPlayerModel> registerPlayer(RegisterPlayerModel playerModel);
  Future<List<PlayerRankModel>> getPlayerRankDetails();
  Future<List<RegisterPlayerModel>> getPlayerRegistration(
      {required int childId});
}

class UserDetailRemoteDataSourceImpl implements UserDetailRemoteDataSource {
  final SupabaseClient supabaseClient;
  UserDetailRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<List<ChildModel>> getUserDetails({required int childId}) async {
    try {
      // getting current user Uid
      // final userUid = supabaseClient.auth.currentUser!.id;

      // fetching user details
      final childDetail = await supabaseClient
          .from('children')
          .select('*')
          .match({'id': childId});

      return childDetail.map((json) => ChildModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UploadCertificateModel>> getCertificates({
    required int childId,
  }) async {
    try {
      // getting user UID
      // final userUid = supabaseClient.auth.currentUser!.id;

      // fetching user certificates
      final userCertificates = await supabaseClient
          .from('upload_certificate')
          .select('*')
          .match({'student_id': childId});

      return userCertificates
          .map((json) => UploadCertificateModel.fromJson(json))
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
      final data = certificateModel.toJson();
      data.remove('id');
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
      // final String fileName = basename(imageFile.path);
      final path =
          '${certificateModel.childId}/${certificateModel.id}/${certificateModel.certificateName}';
      await supabaseClient.storage
          .from('certificate_images')
          .upload(path, imageFile);

      final certificateUrl =
          supabaseClient.storage.from('certificate_images').getPublicUrl(path);

      await supabaseClient
          .from("upload_certificate")
          .update({"certificate_image_url": certificateUrl}).eq(
              "id", certificateModel.id!);

      return certificateUrl;
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
          .from('children')
          .select('*')
          .match({'id': profileModel.childId!});

      final UpdateProfileModel model =
          UpdateProfileModel.fromJson(userDetail.first);

      final profileData = await supabaseClient
          .from('children')
          .update({
            "name":
                profileModel.name!.isNotEmpty ? profileModel.name : model.name,
            "age_group": profileModel.ageGroup!.isNotEmpty
                ? profileModel.ageGroup
                : model.ageGroup,
            "email": profileModel.email!.isNotEmpty
                ? profileModel.email
                : model.email,
            "image_url": profileModel.profileImageUrl!.isNotEmpty
                ? profileModel.profileImageUrl
                : model.profileImageUrl,
          })
          .eq('id', profileModel.childId!)
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
      String? fileName = imageFile?.path.split('/').last;
      final uploadPath = '${profileModel!.childId}/${fileName}-image';

      if (imageFile == null) {
        return supabaseClient.storage
            .from('children-profile-images')
            .getPublicUrl(uploadPath);
      }

      final path = '${profileModel.childId}/';
      final response = await supabaseClient.storage
          .from('children-profile-images')
          .list(path: path);

// Check if the file exists
      bool fileExists = false;
      for (final file in response) {
        if (file.name == "${profileModel.name}-image") {
          fileExists = true;
          break;
        }
      }

      if (fileExists) {
        log('File exists, updating...');
        await supabaseClient.storage
            .from('children-profile-images')
            .update(uploadPath, imageFile);

        log('File updated successfully.');
      } else {
        log('File does not exist, uploading...');
        await supabaseClient.storage
            .from('children-profile-images')
            .upload(uploadPath, imageFile);

        log('File uploaded successfully.');
      }

      // cashe busting url for lattest image upload
      final url = supabaseClient.storage
          .from('children-profile-images')
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
  Future<List<CertificateV1V2MappingModel>> getCertificateMasterData({
    required int childId,
  }) async {
    try {
      // // getting user UID
      // final userUid = supabaseClient.auth.currentUser!.id;

      // fetching user certificates
      final certificateMaster = await supabaseClient
          .from('certificate_v1_v2_mapping')
          .select('id, student_id, v1_certificate_id, certificate_master(*)')
          .match({'student_id': childId})
          .not("certificate_master", "is", null)
          .eq("certificate_master.certificate_status", true);

      log("certificate master data fetched: ${certificateMaster.toString()}");

      return certificateMaster
          .map((json) => CertificateV1V2MappingModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      log(e.message);
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
  Future<List<RegisterPlayerModel>> getPlayerRegistration(
      {required int childId}) async {
    try {
      // getting current user Uid
      // final userUid = supabaseClient.auth.currentUser!.id;
      // fetchingall registered players
      final response = await supabaseClient
          .from('register_player')
          .select("*")
          .eq("student_id", childId);

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
