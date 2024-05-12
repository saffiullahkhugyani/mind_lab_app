import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/network/connection_checker.dart';
import 'package:mind_lab_app/features/dashboard/data/datasource/project_local_data_source.dart';
import 'package:mind_lab_app/features/dashboard/data/datasource/project_remote_data_source.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';
import 'package:mind_lab_app/features/dashboard/domain/repository/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource projectRemoteDataSource;
  final ProjectLocalDataSource projectLocalDataSource;
  final ConnectionChecker connectionChecker;

  ProjectRepositoryImpl(
    this.projectRemoteDataSource,
    this.projectLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<ServerFailure, List<Subscription>>> getAllProject() async {
    try {
      if (!await connectionChecker.isConnected) {
        final projects = projectLocalDataSource.loadProjects();
        return right(projects);
      }

      final projects = await projectRemoteDataSource.getAllProjects();
      projectLocalDataSource.uploadLocalProjects(projects: projects);
      return right(projects);
    } on ServerException catch (e) {
      return left(
        ServerFailure(errorMessage: e.message),
      );
    }
  }
}
