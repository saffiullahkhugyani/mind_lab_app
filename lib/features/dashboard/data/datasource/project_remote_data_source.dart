import 'dart:developer';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/dashboard/data/models/pro_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/subs_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProjectRemoteDataSource {
  Future<List<SubscriptionModel>> getSubscribedProjects();
  Future<List<ProjectModel>> getAllProjects();
}

class ProjectRemoteDatSourceImpl implements ProjectRemoteDataSource {
  final SupabaseClient supabaseClient;
  ProjectRemoteDatSourceImpl(this.supabaseClient);
  @override
  Future<List<SubscriptionModel>> getSubscribedProjects() async {
    try {
      final projectList = await supabaseClient
          .from('subscription')
          .select('students(id, name), projects(id, name), subscription')
          .match({
        'student_id': supabaseClient.auth.currentUser!.id,
        'subscription': 1
      });

      final data =
          projectList.map((json) => SubscriptionModel.fromJson(json)).toList();
      log('Subscribed projects: ${data}');

      return projectList
          .map((json) => SubscriptionModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      log('PostgrestException');
      throw ServerException(e.message);
    } catch (e) {
      log('General Catch');
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
}
