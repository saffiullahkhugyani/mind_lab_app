import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';

import '../repositories/parent_child_repository.dart';

class GetStudentDetailsUsecase implements UseCase<StudentEntity, String> {
  final ParentChildRepository repository;
  GetStudentDetailsUsecase(this.repository);
  @override
  Future<Either<ServerFailure, StudentEntity>> call(String studentId) {
    return repository.getStudentDetails(studentId: studentId);
  }
}
