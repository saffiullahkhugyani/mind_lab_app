import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/core/common/entities/child_entity.dart';
import 'package:mind_lab_app/features/parent_child/domain/repositories/parent_child_repository.dart';

class AddChildUseCase implements UseCase<ChildEntity, AddChildParams> {
  final ParentChildRepository repository;
  AddChildUseCase(this.repository);

  @override
  Future<Either<ServerFailure, ChildEntity>> call(AddChildParams params) async {
    return await repository.addChild(
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
