import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/network/connection_checker.dart';
import 'package:mind_lab_app/features/dashboard/data/datasource/project_local_data_source.dart';
import 'package:mind_lab_app/features/dashboard/data/datasource/project_remote_data_source.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/notification_entity.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/parent_child_relationship_entity.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/project.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';
import 'package:mind_lab_app/features/dashboard/domain/repository/project_repository.dart';

import '../models/notification_model.dart';

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
  Future<Either<ServerFailure, List<Subscription>>> getSubscribedProjects(
      {required String studentId}) async {
    try {
      if (!await connectionChecker.isConnected) {
        final projects = projectLocalDataSource.loadProjects();
        return right(projects);
      }

      final projects = await projectRemoteDataSource.getSubscribedProjects(
          studentId: studentId);
      projectLocalDataSource.uploadLocalProjects(projects: projects);
      return right(projects);
    } on ServerException catch (e) {
      return left(
        ServerFailure(errorMessage: e.message),
      );
    }
  }

  @override
  Future<Either<ServerFailure, List<Project>>> getAllProjects() async {
    try {
      if (!await connectionChecker.isConnected) {
        final projectList = projectLocalDataSource.loadAllProjects();
        return right(projectList);
      }
      final projectList = await projectRemoteDataSource.getAllProjects();
      projectLocalDataSource.uploadAllProjects(allProjects: projectList);

      return right(projectList);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, ParentChildRelationshipEntity>>
      allowParentAccess(
          {required int notificationId,
          required String parentId,
          required String studentId,
          required String studentProfileId}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
            ServerFailure(errorMessage: "Check your internet connection"));
      }

      final allowParentAccess = await projectRemoteDataSource.allowParentAccess(
        notificationId: notificationId,
        parentId: parentId,
        childId: studentId,
        studentProfileId: studentProfileId,
      );

      return right(allowParentAccess);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, List<NotificationModel>>> getNotifications(
      {required String studentProfileId}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
            ServerFailure(errorMessage: "Check your internet connection"));
      }
      final notifications = await projectRemoteDataSource.getNotifications(
          studentProfileId: studentProfileId);

      // Fetch sender details for notifications that have a sender
      for (var i = 0; i < notifications.length; i++) {
        if (notifications[i].senderId != null &&
            notifications[i].senderId!.isNotEmpty) {
          final senderDetails =
              await projectRemoteDataSource.getNotificaionSenderDetails(
                  notificationSenderId: notifications[i].senderId!);

          // Assign the new updated object back to the list
          notifications[i] =
              notifications[i].copyWith(senderDetails: senderDetails);
        }
      }

      return right(notifications);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, NotificationEntity>> readNotificaion(
      {required int notificationId, required String userId}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
            ServerFailure(errorMessage: "Check your internet connection"));
      }

      final readNotification = await projectRemoteDataSource.readNotification(
        notificationId: notificationId,
        userId: userId,
      );

      return right(readNotification);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }
}
