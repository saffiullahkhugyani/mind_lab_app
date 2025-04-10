import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/network/connection_checker.dart';
import 'package:mind_lab_app/features/parent_child/data/models/parent_child_relationship_model.dart';
import 'package:mind_lab_app/features/parent_child/data/models/student_model.dart';
import 'package:mind_lab_app/features/parent_child/domain/entities/notification_entity.dart';
import 'package:mind_lab_app/features/parent_child/domain/repositories/parent_child_repository.dart';

import '../datasource/local_data_source.dart';
import '../datasource/remote_data_source.dart';

class ParentChildRepositoryImpl implements ParentChildRepository {
  final RemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  final LocalDataSource localDataSource;

  ParentChildRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
    this.localDataSource,
  );

  @override
  Future<Either<ServerFailure, ParentChildRelationshipModel>> addStudent({
    required String studentId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(ServerFailure(
            errorMessage:
                "Please check your internet connection, and try again later."));
      }

      final child = await remoteDataSource.addStudent(studentId: studentId);

      return right(child);
    } on ServerException catch (e) {
      return left(
        ServerFailure(
          errorMessage: e.message,
        ),
      );
    }
  }

  @override
  Future<Either<ServerFailure, List<StudentModel>>> getStudents({
    required String parentId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        final studentsList = localDataSource.loadStudentsData();
        return right(studentsList);
      }
      final studentsList =
          await remoteDataSource.getStudents(parentId: parentId);
      localDataSource.uploadStudentData(students: studentsList);
      return right(studentsList);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, StudentEntity>> getStudentDetails(
      {required String studentId}) async {
    try {
      final student =
          await remoteDataSource.getStudentDetails(studentId: studentId);
      return right(student);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, List<NotificationEntity>>> getNotifications(
      {required String studentProfileId}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(
            ServerFailure(errorMessage: "Check your internet connection"));
      }
      final notifications = await remoteDataSource.getNotifications(
          studentProfileId: studentProfileId);

      // Fetch sender details for notifications that have a sender
      for (var i = 0; i < notifications.length; i++) {
        if (notifications[i].senderId != null &&
            notifications[i].senderId!.isNotEmpty) {
          final senderDetails =
              await remoteDataSource.getNotificaionSenderDetails(
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

      final readNotification = await remoteDataSource.readNotification(
        notificationId: notificationId,
        userId: userId,
      );

      return right(readNotification);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }
}
