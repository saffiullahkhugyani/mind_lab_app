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
      childId: params.childId,
      projectId: params.projectId,
      subscriptionStatus: params.subscriptionStatus,
    );
  }
}

class SubscriptionRequestParams {
  final int childId;
  final int projectId;
  final int subscriptionStatus;

  SubscriptionRequestParams({
    required this.childId,
    required this.projectId,
    required this.subscriptionStatus,
  });
}
