import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/parent_child/domain/entities/parent_child_relationship_entity.dart';

import '../repositories/parent_child_repository.dart';

class AddStudentUseCase
    implements UseCase<ParentChildRelationshipEntity, String> {
  final ParentChildRepository repository;
  AddStudentUseCase(this.repository);

  @override
  Future<Either<ServerFailure, ParentChildRelationshipEntity>> call(
      String studentId) async {
    return await repository.addStudent(studentId: studentId);
  }
}
