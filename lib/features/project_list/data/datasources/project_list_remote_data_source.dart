import 'dart:developer';

import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/project_list/data/models/project_list_model.dart';
import 'package:mind_lab_app/features/project_list/data/models/subscription_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProjectListRemoteDataSource {
  Future<List<ProjectListModel>> getAllAvailbleProjects(
      {required String studentId});
  Future<List<SubscriptionModel>> getSubscriptionData(
      String studentId, int projectId);
  Future<SubscriptionModel> subscriptionRequest(
      SubscriptionModel subscriptionModel);
}

class ProjectListRemoteDataSourceImpl implements ProjectListRemoteDataSource {
  final SupabaseClient supabaseClient;
  ProjectListRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<List<ProjectListModel>> getAllAvailbleProjects(
      {required String studentId}) async {
    log('here');
    try {
      // final projectList = await supabaseClient.from('projects').select('*');

      final projectListWithUserSubsInfo = await supabaseClient
          .from('projects')
          .select('id,name,description, subscription(subscription)')
          .match({'subscription.student_id': studentId});

      log(projectListWithUserSubsInfo.toString());

      subscriptionRequest(SubscriptionModel(
          studentId: studentId, projectId: 1, subscriptionStatus: 1));

      return projectListWithUserSubsInfo
          .map((json) => ProjectListModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      log(e.message.toString());
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SubscriptionModel>> getSubscriptionData(
      String studentId, int projectId) async {
    try {
      final subscriptionData =
          await supabaseClient.from('subscription').select('*').match({
        'student_id': studentId,
        'project_id': projectId,
      });
      return subscriptionData
          .map((json) => SubscriptionModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SubscriptionModel> subscriptionRequest(
      SubscriptionModel subscriptionModel) async {
    try {
      final subscriptionData = await getSubscriptionData(
          subscriptionModel.studentId, subscriptionModel.projectId);
      if (subscriptionData.isEmpty) {
        final result = await supabaseClient.from('subscription').insert({
          'student_id': subscriptionModel.studentId,
          'project_id': subscriptionModel.projectId,
          'subscription': subscriptionModel.subscriptionStatus,
        }).select();

        return SubscriptionModel.fromJson(result.first);
      } else {
        return subscriptionData.first;
      }
    } on PostgrestException catch (e) {
      log(e.message);
      throw ServerException(e.message);
    } catch (e) {
      log("error: $e");
      throw ServerException(e.toString());
    }
  }
}
