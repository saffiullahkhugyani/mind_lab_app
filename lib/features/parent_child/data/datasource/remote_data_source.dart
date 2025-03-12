import 'dart:developer';
import 'dart:io';

import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/parent_child/data/models/parent_child_relationship_model.dart';
import 'package:mind_lab_app/features/parent_child/data/models/student_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RemoteDataSource {
  Future<List<StudentModel>> getStudents({
    required String parentId,
  });
  Future<ParentChildRelationshipModel> addStudent({required String studentId});
  Future<String> uploadStudentImage({
    required File imageFile,
    required StudentModel studentModel,
  });

  Future<StudentModel> getStudentDetails({
    required String studentId,
  });
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabaseClient;

  RemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<ParentChildRelationshipModel> addStudent({
    required String studentId,
  }) async {
    try {
      // Get the current user's UID
      final userUid = supabaseClient.auth.currentUser!.id;

      final existingRelationship = await supabaseClient
          .from('parent_child_relationship')
          .select(('*'))
          .eq('parent_id', userUid)
          .eq('child_id', studentId);

      if (existingRelationship.isNotEmpty) {
        log('here');
        throw ServerException("Relationship already exists");
      }

      final response = await supabaseClient
          .from('parent_child_relationship')
          .insert({
        'parent_id': userUid,
        'child_id': studentId,
        'is_parent_request_approved': false
      }).select();

      return ParentChildRelationshipModel.fromJson(response.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<List<StudentModel>> getStudents({required String parentId}) async {
    try {
      final response = await supabaseClient
          .from('parent_child_relationship')
          .select('*, students(*)')
          .eq('parent_id', parentId)
          .eq('is_parent_request_approved', true);

      log(response.toString());

      final list = response
          .map<StudentModel>(
              (entry) => StudentModel.fromJson(entry['students']))
          .toList();

      return list;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on ServerException catch (e) {
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

  @override
  Future<StudentModel> getStudentDetails({required String studentId}) async {
    try {
      final response =
          await supabaseClient.from('students').select('*').eq('id', studentId);

      if (response.isEmpty) {
        throw ServerException("No students found with id $studentId");
      }

      return StudentModel.fromJson(response.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on ServerException catch (e) {
      log(e.message);
      throw ServerException(e.message);
    }
  }
}
