import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/user_detail/data/models/user_detail_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class UserDetailRemoteDataSource {
  Future<List<UserDetailModel>> getUserDetails();
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
}
