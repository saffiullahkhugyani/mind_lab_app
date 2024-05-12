import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/constants/constants.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/network/connection_checker.dart';
import 'package:mind_lab_app/features/project_list/data/datasources/project_list_local_data_source.dart';
import 'package:mind_lab_app/features/project_list/data/datasources/project_list_remote_data_source.dart';
import 'package:mind_lab_app/features/project_list/data/models/subscription_model.dart';
import 'package:mind_lab_app/features/project_list/domain/entities/projet_list_entity.dart';
import 'package:mind_lab_app/features/project_list/domain/entities/subscription_entity.dart';
import 'package:mind_lab_app/features/project_list/domain/repositories/project_list_repository.dart';

class ProjectListRepositoryImpl implements ProjectListRepository {
  final ProjectListRemoteDataSource projectListRemoteDataSource;
  final ProjectListLocalDataSource projectListLocalDataSource;
  final ConnectionChecker connectionChecker;

  ProjectListRepositoryImpl(
    this.projectListRemoteDataSource,
    this.projectListLocalDataSource,
    this.connectionChecker,
  );
  @override
  Future<Either<ServerFailure, List<ProjectListEntity>>>
      getAvailableProjects() async {
    try {
      //checking internet connection and if not connected then fetching data from hive box
      // if (!await connectionChecker.isConnected) {
      //   final projectList = projectListLocalDataSource.loadProjectList();
      //   return right(projectList);
      // }

      // fateching from remote data source and storing into hive box
      final projectList =
          await projectListRemoteDataSource.getAllAvailbleProjects();
      // projectListLocalDataSource.uploadLocalProjectList(
      //     projectList: projectList);

      return right(projectList);
    } on ServerException catch (e) {
      return left(
        ServerFailure(errorMessage: e.message),
      );
    }
  }

  @override
  Future<Either<ServerFailure, List<SubscriptionEntity>>>
      getProjectData() async {
    // TODO: implement getProjectData
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerFailure, SubscriptionEntity>> subscriptionRequest(
      {required String userId,
      required int projectId,
      required subscriptionStatus}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(ServerFailure(errorMessage: noConnectionErrorMessage));
      }
      SubscriptionModel subscriptionModel = SubscriptionModel(
        userId: userId,
        projectId: projectId,
        subscriptionStatus: subscriptionStatus,
      );
      final subscriptionReuest = await projectListRemoteDataSource
          .subscriptionRequest(subscriptionModel);

      return right(subscriptionReuest);
    } on ServerException catch (e) {
      return left(
        ServerFailure(errorMessage: e.message),
      );
    }
  }
}
