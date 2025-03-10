import 'dart:developer';
import 'dart:io';

import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/parent_child/data/models/student_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RemoteDataSource {
  Future<List<StudentModel>> getStudents({
    required String parentId,
  });
  Future<StudentModel> addStudent({
    required String name,
    required String email,
    required String ageGroup,
    required String gender,
    required String nationality,
  });
  Future<String> uploadStudentImage({
    required File imageFile,
    required StudentModel studentModel,
  });
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabaseClient;

  RemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<StudentModel> addStudent({
    required String name,
    required String email,
    required String ageGroup,
    required String gender,
    required String nationality,
  }) async {
    try {
      final response = await supabaseClient.from('students').insert({
        'name': name,
        'email': email,
        'age_group': ageGroup,
        'gender': gender,
        'nationality': nationality,
        'profile_id': null,
      }).select();

      final studentModel = StudentModel.fromJson(response.first);

      final parentChildRelationship = await supabaseClient
          .from('parent_child_relationship')
          .insert({'child_id': studentModel.id});

      log(parentChildRelationship.toString());

      return StudentModel.fromJson(response.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StudentModel>> getStudents({required String parentId}) async {
    try {
      final response = await supabaseClient
          .from('parent_child_relationship')
          .select('parent_id, students(*)')
          .eq('parent_id', parentId);

      final list = response
          .map<StudentModel>(
              (entry) => StudentModel.fromJson(entry['students']))
          .toList();

      return list;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadStudentImage({
    required File imageFile,
    required StudentModel studentModel,
  }) async {
    try {
      // String? fileName = imageFile.path.split('/').last;
      final path = '${studentModel.id}/${studentModel.id}-image';

      await supabaseClient.storage
          .from('student-profile-images')
          .upload(path, imageFile);

      final imageUrl = supabaseClient.storage
          .from('student-profile-images')
          .getPublicUrl(path);

      await supabaseClient.from('students').update({
        'image_url': imageUrl,
      }).eq('id', studentModel.id);

      return imageUrl;
    } on StorageException catch (e) {
      log(e.toString());
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
