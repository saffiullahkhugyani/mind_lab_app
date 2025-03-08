import 'dart:developer';
import 'dart:io';

import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/parent_child/data/models/student_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RemoteDataSource {
  Future<List<StudentModel>> getStudents();
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
      }).select();

      log(StudentModel.fromJson(response.first).toString());

      return StudentModel.fromJson(response.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StudentModel>> getStudents() async {
    try {
      final response = await supabaseClient.from('students').select('*');

      final list =
          response.map((student) => StudentModel.fromJson(student)).toList();

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
      String? fileName = imageFile.path.split('/').last;
      final path = '${studentModel.id}/$fileName-image';

      await supabaseClient.storage
          .from('children-profile-images')
          .upload(path, imageFile);

      final imageUrl = supabaseClient.storage
          .from('children-profile-images')
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
