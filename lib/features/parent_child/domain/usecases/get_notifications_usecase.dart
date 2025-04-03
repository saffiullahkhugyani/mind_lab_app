import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/parent_child/domain/repositories/parent_child_repository.dart';

import '../entities/notification_entity.dart';

class GetParentsNotificationsUseCase
    implements UseCase<List<NotificationEntity>, String> {
  final ParentChildRepository repository;
  GetParentsNotificationsUseCase(this.repository);
  @override
  Future<Either<ServerFailure, List<NotificationEntity>>> call(
      String profileId) async {
    return await repository.getNotifications(studentProfileId: profileId);
  }
}
