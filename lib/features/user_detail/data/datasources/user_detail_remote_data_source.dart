import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/parent_child/data/models/student_model.dart';
// import 'package:mind_lab_app/features/user_detail/data/models/certificate_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/certificate_v2_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/notification_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/parent_child_relationship_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/player_rank_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/register_player_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_category_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_tag_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/skill_type_model.dart';
import 'package:mind_lab_app/features/user_detail/data/models/update_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:path/path.dart';
import '../models/upload_certificate_model.dart';
import 'package:crypto/crypto.dart';

import '../models/user_model.dart';

abstract interface class UserDetailRemoteDataSource {
  Future<List<StudentModel>> getStudentDetails({
    required String parentId,
    required String studentId,
    required int roleId,
  });
  Future<List<SkillTypeModel>> getSkillTypes();
  Future<List<SkillTagModel>> getSkillTags();
  Future<List<SkillCategoryModel>> getSkillCategories();
  Future<List<UploadCertificateModel>> getCertificates({
    required String studentId,
  });
  Future<UploadCertificateModel> uploadCertificate(
      UploadCertificateModel certificateModel);
  Future<String> uploadCertificateImage({
    required File imageFile,
    required UploadCertificateModel certificateModel,
  });
  Future<UpdateStudentModel> updateProfile(UpdateStudentModel studentModel);
  Future<String> updateProfileImage({
    File? imageFile,
    UpdateStudentModel? studentModel,
  });
  Future<String> deleteAccount();
  Future<void> signOut();
  Future<List<CertificateV1V2MappingModel>> getCertificateMasterData({
    required String studentId,
  });
  Future<RegisterPlayerModel> registerPlayer(RegisterPlayerModel playerModel);
  Future<List<PlayerRankModel>> getPlayerRankDetails(
      {required String playerId});
  Future<List<RegisterPlayerModel>> getPlayerRegistration({
    required String studentId,
  });
  Future<List<NotificationModel>> getNotifications(
      {required String studentProfileId});
  Future<UserModel> getNotificaionSenderDetails(
      {required String notificationSenderId});
  Future<ParentChildRelationshipModel> allowParentAccess({
    required int notificationId,
    required String parentId,
    required String childId,
    required String studentProfileId,
  });
}

class UserDetailRemoteDataSourceImpl implements UserDetailRemoteDataSource {
  final SupabaseClient supabaseClient;
  UserDetailRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<List<StudentModel>> getStudentDetails({
    required String parentId,
    required String studentId,
    required int roleId,
  }) async {
    try {
      // Get the current user's UID
      final userUid = supabaseClient.auth.currentUser!.id;

      List<Map<String, dynamic>> studentData;

      if (roleId == 6) {
        // Fetch student details for parent role
        final response = await supabaseClient
            .from('parent_child_relationship')
            .select('parent_id, students(*)')
            .eq('parent_id', parentId)
            .eq('child_id', studentId);

        // Extract student details from the response
        studentData = (response as List).map((item) {
          return item['students'] as Map<String, dynamic>;
        }).toList();
      } else if (roleId == 4 || roleId == 1) {
        // Fetch student details for student role
        final response = await supabaseClient
            .from('students')
            .select('*')
            .eq('profile_id', userUid);

        studentData = response;
      } else {
        throw ServerException('Invalid role ID');
      }

      // Check if student data is empty
      if (studentData.isEmpty) {
        throw ServerException('No student data found');
      }

      // Convert the data to a list of StudentModel
      return studentData.map((json) => StudentModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      log('$e');
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<UploadCertificateModel>> getCertificates(
      {required String studentId}) async {
    try {
      // fetching user certificates
      final userCertificates = await supabaseClient
          .from('upload_certificate')
          .select('*')
          .match({'student_id': studentId});

      return userCertificates
          .map((json) => UploadCertificateModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      log('get certificate: $e');
      throw ServerException(e.message);
    } catch (e) {
      log('get certificate: $e');
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
      final certificateData =
          await supabaseClient.from('upload_certificate').insert(data).select();

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
          '${certificateModel.studentId}/${certificateModel.id}/${certificateModel.certificateName}';
      await supabaseClient.storage
          .from('certificate_images')
          .upload(path, imageFile);

      final certificateUrl =
          supabaseClient.storage.from('certificate_images').getPublicUrl(path);

      await supabaseClient
          .from('upload_certificate')
          .update({'certificate_image_url': certificateUrl}).eq(
              'id', certificateModel.id!);

      return certificateUrl;
    } on StorageException catch (e) {
      throw ServerException(e.error!);
    }
  }

  @override
  Future<UpdateStudentModel> updateProfile(
    UpdateStudentModel studentModel,
  ) async {
    log("In update profile: ${studentModel.studentId}");
    try {
      // existing user data
      final userDetail = await supabaseClient
          .from('students')
          .select('*')
          .match({'id': studentModel.studentId!});

      final UpdateStudentModel model =
          UpdateStudentModel.fromJson(userDetail.first);

      final profileData = await supabaseClient
          .from('students')
          .update({
            "name":
                studentModel.name!.isNotEmpty ? studentModel.name : model.name,
            "age_group": studentModel.dateOfBirth!.isNotEmpty
                ? studentModel.dateOfBirth
                : model.dateOfBirth,
            "mobile": studentModel.number!.isNotEmpty
                ? studentModel.number
                : model.number,
            "image_url": studentModel.profileImageUrl!.isNotEmpty
                ? studentModel.profileImageUrl
                : model.profileImageUrl,
          })
          .eq('id', studentModel.studentId!)
          .select();

      return UpdateStudentModel.fromJson(profileData.first);
    } catch (e) {
      log("in update student: $e.toString()");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateProfileImage({
    File? imageFile,
    UpdateStudentModel? studentModel,
  }) async {
    try {
      // String? fileName = imageFile?.path.split('/').last;
      final uploadPath =
          '${studentModel!.studentId}/${studentModel.studentId}-image';

      if (imageFile == null) {
        return supabaseClient.storage
            .from('student-profile-images')
            .getPublicUrl(uploadPath);
      }

      final path = '${studentModel.studentId}/';
      final response = await supabaseClient.storage
          .from('student-profile-images')
          .list(path: path);

// Check if the file exists
      bool fileExists = false;
      for (final file in response) {
        log(file.name);
        if (file.name == "${studentModel.studentId}-image") {
          fileExists = true;
          break;
        }
      }

      if (fileExists) {
        log('File exists, updating...');
        await supabaseClient.storage
            .from('student-profile-images')
            .update(uploadPath, imageFile);

        log('File updated successfully.');
      } else {
        log('File does not exist, uploading...');
        await supabaseClient.storage
            .from('student-profile-images')
            .upload(uploadPath, imageFile);

        log('File uploaded successfully.');
      }

      // cashe busting url for lattest image upload
      final url = supabaseClient.storage
          .from('student-profile-images')
          .getPublicUrl(uploadPath);

      return '$url?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      log("in update student image: $e.toString()");
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
    required String studentId,
  }) async {
    try {
      // getting user UID
      // final userUid = supabaseClient.auth.currentUser!.id;

      // fetching user certificates
      final certificateMaster = await supabaseClient
          .from('certificate_v1_v2_mapping')
          .select('id, student_id, v1_certificate_id, certificate_master(*)')
          .match({'student_id': studentId})
          .not("certificate_master", "is", null)
          .eq("certificate_master.certificate_status", true);

      // log(certificateMaster
      //     .map((json) => CertificateV1V2MappingModel.fromJson(json))
      //     .toList()
      //     .toString());

      return certificateMaster
          .map((json) => CertificateV1V2MappingModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      log(e.toString());
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
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
  Future<List<PlayerRankModel>> getPlayerRankDetails({
    required String playerId,
  }) async {
    log(playerId);
    try {
      // getting current user Uid
      // getting current user Uid
      // final userUid = supabaseClient.auth.currentUser!.id;
      // final playerId = generateShortUUID(userUid);

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
  Future<List<RegisterPlayerModel>> getPlayerRegistration({
    required String studentId,
  }) async {
    try {
      // getting current user Uid
      // final userUid = supabaseClient.auth.currentUser!.id;
      // fetchingall registered players
      final response = await supabaseClient
          .from('register_player')
          .select("*")
          .eq("student_id", studentId);

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

  @override
  Future<List<NotificationModel>> getNotifications(
      {required String studentProfileId}) async {
    try {
      final response = await supabaseClient
          .from('notifications')
          .select('*')
          .eq('recipient_id', studentProfileId);

      final List<NotificationModel> notifications = response
          .map((notification) => NotificationModel.fromJson(notification))
          .toList();

      log("notification response: $response");

      return notifications;
    } on PostgrestException catch (e) {
      log(e.message);
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getNotificaionSenderDetails(
      {required String notificationSenderId}) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select('*')
          .eq('id', notificationSenderId);

      log("notificaion sender details: $response");

      return UserModel.fromJson(response.first);
    } on PostgrestException catch (e) {
      log(e.message);
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ParentChildRelationshipModel> allowParentAccess({
    required int notificationId,
    required String parentId,
    required String childId,
    required String studentProfileId,
  }) async {
    try {
      final checkExistingData = await supabaseClient
          .from('parent_child_relationship')
          .select('*')
          .eq('parent_id', parentId)
          .eq('child_id', childId);

      if (checkExistingData.isEmpty) {
        throw ServerException("Request not completed");
      }

      final existingData =
          ParentChildRelationshipModel.fromJson(checkExistingData.first);

      if (checkExistingData.isNotEmpty &&
          existingData.isParentRequestApproved) {
        throw ServerException("Permission already granted");
      }

      ParentChildRelationshipModel relationshipModel = existingData;
      if (checkExistingData.isNotEmpty &&
          !existingData.isParentRequestApproved) {
        final response = await supabaseClient
            .from('parent_child_relationship')
            .update({'is_parent_request_approved': true})
            .eq('parent_id', parentId)
            .eq('child_id', childId)
            .select();

        relationshipModel =
            ParentChildRelationshipModel.fromJson(response.first);

        await supabaseClient
            .from('notifications')
            .update({'status': 'accepted'})
            .eq('sender_id', parentId)
            .eq(
              'recipient_id',
              studentProfileId,
            );
      }

      return relationshipModel;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    }
  }
}
