import 'dart:developer';
import 'dart:io';

import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/parent_child/data/models/child_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RemoteDataSource {
  Future<List<ChildModel>> getChildren();
  Future<ChildModel> addChild({
    required String name,
    required String email,
    required String ageGroup,
    required String gender,
    required String nationality,
  });
  Future<String> uploadChildImage({
    required File imageFile,
    required ChildModel childModel,
  });
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabaseClient;

  RemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<ChildModel> addChild({
    required String name,
    required String email,
    required String ageGroup,
    required String gender,
    required String nationality,
  }) async {
    try {
      final response = await supabaseClient.from('children').insert({
        'name': name,
        'email': email,
        'age_group': ageGroup,
        'gender': gender,
        'nationality': nationality,
      }).select();

      log(ChildModel.fromJson(response.first).toString());

      return ChildModel.fromJson(response.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ChildModel>> getChildren() async {
    try {
      final response = await supabaseClient.from('children').select('*');

      final list = response.map((child) => ChildModel.fromJson(child)).toList();

      return list;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadChildImage({
    required File imageFile,
    required ChildModel childModel,
  }) async {
    try {
      String? fileName = imageFile.path.split('/').last;
      final path = '${childModel.id}/${fileName}-image';

      await supabaseClient.storage
          .from('children-profile-images')
          .upload(path, imageFile);

      final imageUrl = supabaseClient.storage
          .from('children-profile-images')
          .getPublicUrl(path);

      await supabaseClient.from('children').update({
        'image_url': imageUrl,
      }).eq('id', childModel.id);

      return imageUrl;
    } on StorageException catch (e) {
      log(e.toString());
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
