import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/dashboard/data/models/subs_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProjectRemoteDataSource {
  Future<List<SubscriptionModel>> getAllProjects();
}

class ProjectRemoteDatSourceImpl implements ProjectRemoteDataSource {
  final SupabaseClient supabaseClient;
  ProjectRemoteDatSourceImpl(this.supabaseClient);
  @override
  Future<List<SubscriptionModel>> getAllProjects() async {
    try {
      final projectList = await supabaseClient
          .from('subscription')
          .select('profiles(id, name), projects(id, name), subscription')
          .match({
        'user_id': supabaseClient.auth.currentUser!.id,
        'subscription': 1
      });
      return projectList
          .map((json) => SubscriptionModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
