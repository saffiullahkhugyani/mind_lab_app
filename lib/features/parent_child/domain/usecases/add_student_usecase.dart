import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';

import '../repositories/parent_child_repository.dart';

class AddStudentUseCase implements UseCase<StudentEntity, AddChildParams> {
  final ParentChildRepository repository;
  AddStudentUseCase(this.repository);

  @override
  Future<Either<ServerFailure, StudentEntity>> call(
      AddChildParams params) async {
    return await repository.addStudent(
      name: params.name,
      email: params.email,
      ageGroup: params.ageGroup,
      gender: params.gender,
      imageFile: params.imageFile,
      nationality: params.nationality,
    );
  }
}

class AddChildParams {
  final String email;
  final String name;
  final String ageGroup;
  final String gender;
  final File imageFile;
  final String nationality;

  AddChildParams({
    required this.email,
    required this.name,
    required this.ageGroup,
    required this.gender,
    required this.imageFile,
    required this.nationality,
  });
}
