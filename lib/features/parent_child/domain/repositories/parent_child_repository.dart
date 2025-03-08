import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/failure.dart';

abstract interface class ParentChildRepository {
  Future<Either<ServerFailure, List<StudentEntity>>> getStudents();

  Future<Either<ServerFailure, StudentEntity>> addStudent({
    required String name,
    required String email,
    required String ageGroup,
    required String gender,
    required String nationality,
    required File imageFile,
  });
}
