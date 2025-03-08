import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';

import '../repositories/parent_child_repository.dart';

class GetStudentUsecase implements UseCase<List<StudentEntity>, NoParams> {
  final ParentChildRepository repository;
  GetStudentUsecase(this.repository);

  @override
  Future<Either<ServerFailure, List<StudentEntity>>> call(NoParams params) {
    return repository.getStudents();
  }
}
