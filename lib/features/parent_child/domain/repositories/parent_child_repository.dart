import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/parent_child/domain/entities/parent_child_relationship_entity.dart';

import '../entities/notification_entity.dart';

abstract interface class ParentChildRepository {
  Future<Either<ServerFailure, List<StudentEntity>>> getStudents({
    required String parentId,
  });

  Future<Either<ServerFailure, ParentChildRelationshipEntity>> addStudent({
    required String studentId,
  });

  Future<Either<ServerFailure, StudentEntity>> getStudentDetails({
    required String studentId,
  });

  Future<Either<ServerFailure, List<NotificationEntity>>> getNotifications({
    required String studentProfileId,
  });

  Future<Either<ServerFailure, NotificationEntity>> readNotificaion({
    required int notificationId,
    required String userId,
  });
}
