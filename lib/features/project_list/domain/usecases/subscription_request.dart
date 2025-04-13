import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/project_list/domain/entities/subscription_entity.dart';
import 'package:mind_lab_app/features/project_list/domain/repositories/project_list_repository.dart';

class SubscriptionRequest
    implements UseCase<SubscriptionEntity, SubscriptionRequestParams> {
  final ProjectListRepository projectListRepository;
  SubscriptionRequest(this.projectListRepository);
  @override
  Future<Either<ServerFailure, SubscriptionEntity>> call(
      SubscriptionRequestParams params) async {
    return await projectListRepository.subscriptionRequest(
      studentId: params.studentId,
      projectId: params.projectId,
      subscriptionStatus: params.subscriptionStatus,
    );
  }
}

class SubscriptionRequestParams {
  final String studentId;
  final int projectId;
  final int subscriptionStatus;

  SubscriptionRequestParams({
    required this.studentId,
    required this.projectId,
    required this.subscriptionStatus,
  });
}
