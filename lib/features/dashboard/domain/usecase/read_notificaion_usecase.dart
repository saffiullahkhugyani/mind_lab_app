import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/notification_entity.dart';

import '../repository/project_repository.dart';

class ReadNotificaionUsecase
    implements UseCase<NotificationEntity, ReadNotificationParams> {
  final ProjectRepository repository;

  ReadNotificaionUsecase({required this.repository});

  @override
  Future<Either<ServerFailure, NotificationEntity>> call(
      ReadNotificationParams params) async {
    return await repository.readNotificaion(
      notificationId: params.notificationId,
      userId: params.userId,
    );
  }
}

class ReadNotificationParams {
  final int notificationId;
  final String userId;

  ReadNotificationParams({required this.notificationId, required this.userId});
}
