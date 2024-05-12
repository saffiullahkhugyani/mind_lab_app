import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/project_list/data/models/project_list_model.dart';
import 'package:mind_lab_app/features/project_list/data/models/subscription_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProjectListRemoteDataSource {
  Future<List<ProjectListModel>> getAllAvailbleProjects();
  Future<List<SubscriptionModel>> getSubscriptionData(int projectId);
  Future<SubscriptionModel> subscriptionRequest(
      SubscriptionModel subscriptionModel);
}

class ProjectListRemoteDataSourceImpl implements ProjectListRemoteDataSource {
  final SupabaseClient supabaseClient;
  ProjectListRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<List<ProjectListModel>> getAllAvailbleProjects() async {
    try {
      // final projectList = await supabaseClient.from('projects').select('*');

      final projectListWithUserSubsInfo = await supabaseClient
          .from('projects')
          .select('id,name,description, subscription(subscription)')
          .match({'subscription.user_id': supabaseClient.auth.currentUser!.id});

      subscriptionRequest(SubscriptionModel(
          userId: 'userId', projectId: 1, subscriptionStatus: 1));

      return projectListWithUserSubsInfo
          .map((json) => ProjectListModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SubscriptionModel>> getSubscriptionData(int projectId) async {
    try {
      final subscriptionData =
          await supabaseClient.from('subscription').select('*').match({
        'user_id': supabaseClient.auth.currentUser!.id,
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
      final subscriptionData =
          await getSubscriptionData(subscriptionModel.projectId);
      if (subscriptionData.isEmpty) {
        final result = await supabaseClient.from('subscription').insert({
          'user_id': subscriptionModel.userId,
          'project_id': subscriptionModel.projectId,
          'subscription': subscriptionModel.subscriptionStatus,
        }).select();

        return SubscriptionModel.fromJson(result.first);
      } else {
        return subscriptionData.first;
      }
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
