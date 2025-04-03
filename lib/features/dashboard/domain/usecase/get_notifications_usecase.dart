import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/notification_entity.dart';

import '../repository/project_repository.dart';

class GetNotificationsUseCase
    implements UseCase<List<NotificationEntity>, String> {
  final ProjectRepository repository;
  GetNotificationsUseCase(this.repository);
  @override
  Future<Either<ServerFailure, List<NotificationEntity>>> call(
      String profileId) async {
    return await repository.getNotifications(studentProfileId: profileId);
  }
}
