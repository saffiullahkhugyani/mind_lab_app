import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/project.dart';
import 'package:mind_lab_app/features/dashboard/domain/repository/project_repository.dart';

class GetAllProjects implements UseCase<List<Project>, int> {
  final ProjectRepository repository;
  GetAllProjects(this.repository);
  @override
  Future<Either<ServerFailure, List<Project>>> call(int childId) async {
    return await repository.getAllProjects(childId: childId);
  }
}
