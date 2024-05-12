import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/project_list/domain/entities/projet_list_entity.dart';
import 'package:mind_lab_app/features/project_list/domain/repositories/project_list_repository.dart';

class GetAvailableProjectList
    implements UseCase<List<ProjectListEntity>, NoParams> {
  final ProjectListRepository projectListRepository;
  GetAvailableProjectList(this.projectListRepository);

  @override
  Future<Either<ServerFailure, List<ProjectListEntity>>> call(
      NoParams params) async {
    return await projectListRepository.getAvailableProjects();
  }
}
