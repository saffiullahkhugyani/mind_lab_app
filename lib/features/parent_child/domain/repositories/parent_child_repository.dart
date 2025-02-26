import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/common/entities/child_entity.dart';

abstract interface class ParentChildRepository {
  Future<Either<ServerFailure, List<ChildEntity>>> getChildrens();

  Future<Either<ServerFailure, ChildEntity>> addChild({
    required String name,
    required String email,
    required String ageGroup,
    required String gender,
    required String nationality,
    required File imageFile,
  });
}
