import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/dashboard/domain/repository/project_repository.dart';

class UpdateStudentCubit implements UseCase<StudentEntity, String> {
  final ProjectRepository repository;

  UpdateStudentCubit({required this.repository});

  @override
  Future<Either<ServerFailure, StudentEntity>> call(String profileId) async {
    return await repository.updateStudentCubit(profileId: profileId);
  }
}
