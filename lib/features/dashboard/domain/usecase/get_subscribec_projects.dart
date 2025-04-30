import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';
import 'package:mind_lab_app/features/dashboard/domain/repository/project_repository.dart';

class GetSubscribedProjects implements UseCase<List<Subscription>, String> {
  final ProjectRepository projectRepository;
  GetSubscribedProjects(this.projectRepository);

  @override
  Future<Either<ServerFailure, List<Subscription>>> call(
      String studentId) async {
    return await projectRepository.getSubscribedProjects(studentId: studentId);
  }
}
