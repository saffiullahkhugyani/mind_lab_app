import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/project_list/domain/entities/projet_list_entity.dart';
import 'package:mind_lab_app/features/project_list/domain/entities/subscription_entity.dart';

abstract interface class ProjectListRepository {
  Future<Either<ServerFailure, List<ProjectListEntity>>> getAvailableProjects();
  Future<Either<ServerFailure, List<SubscriptionEntity>>> getProjectData();
  Future<Either<ServerFailure, SubscriptionEntity>> subscriptionRequest({
    required String userId,
    required int projectId,
    required subscriptionStatus,
  });
}
