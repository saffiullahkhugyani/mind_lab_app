import 'dart:developer';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/dashboard/data/models/notification_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/parent_child_relationship_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/pro_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/subs_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProjectRemoteDataSource {
  Future<List<SubscriptionModel>> getSubscribedProjects(
      {required String studentId});
  Future<List<ProjectModel>> getAllProjects();
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
  Future<NotificationModel> readNotification({
    required int notificationId,
    required String userId,
  });
}

class ProjectRemoteDatSourceImpl implements ProjectRemoteDataSource {
  final SupabaseClient supabaseClient;
  ProjectRemoteDatSourceImpl(this.supabaseClient);
  @override
  Future<List<SubscriptionModel>> getSubscribedProjects(
      {required String studentId}) async {
    try {
      final projectList = await supabaseClient
          .from('subscription')
          .select('*, students(id, name), projects(id, name)')
          .match({'student_id': studentId, 'subscription': 1});

      final data =
          projectList.map((json) => SubscriptionModel.fromJson(json)).toList();
      log('Subscribed projects: $data');

      return projectList
          .map((json) => SubscriptionModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      log('PostgrestException');
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProjectModel>> getAllProjects() async {
    try {
      final projectList = await supabaseClient.from('projects').select('*');

      // final data =
      //     projectList.map((project) => ProjectModel.fromJson(project)).toList();

      // log(data.toString());

      return projectList
          .map((project) => ProjectModel.fromJson(project))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ParentChildRelationshipModel> allowParentAccess(
      {required int notificationId,
      required String parentId,
      required String childId,
      required String studentProfileId}) async {
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

        await supabaseClient.from('notifications').insert({
          'sender_id': studentProfileId,
          'recipient_id': parentId,
          'message': 'Parent request accepted',
          'status': 'pending',
          'notification_type': 'parent_request_accepted',
        });
      }

      return relationshipModel;
    } on PostgrestException catch (e) {
      log(e.message);
      throw ServerException(e.message);
    } on ServerException catch (e) {
      log(e.message);
      throw ServerException(e.message);
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
  Future<NotificationModel> readNotification(
      {required int notificationId, required String userId}) async {
    try {
      final response = await supabaseClient
          .from('notifications')
          .update({'status': 'read'})
          .eq('id', notificationId)
          .eq('recipient_id', userId)
          .select();

      return NotificationModel.fromJson(response.first);
    } on PostgrestException catch (e) {
      log(e.message);
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }
}
