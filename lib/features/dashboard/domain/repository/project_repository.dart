import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/project.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';

import '../entities/notification_entity.dart';
import '../entities/parent_child_relationship_entity.dart';

abstract interface class ProjectRepository {
  Future<Either<ServerFailure, List<Subscription>>> getSubscribedProjects();
  Future<Either<ServerFailure, List<Project>>> getAllProjects();
  Future<Either<ServerFailure, List<NotificationEntity>>> getNotifications(
      {required String studentProfileId});
  Future<Either<ServerFailure, ParentChildRelationshipEntity>>
      allowParentAccess({
    required int notificationId,
    required String parentId,
    required String studentId,
    required String studentProfileId,
  });
  Future<Either<ServerFailure, NotificationEntity>> readNotificaion({
    required int notificationId,
    required String userId,
  });
}
