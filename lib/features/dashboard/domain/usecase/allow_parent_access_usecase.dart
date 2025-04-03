import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/parent_child_relationship_entity.dart';
import 'package:mind_lab_app/features/dashboard/domain/repository/project_repository.dart';

class AllowParentAccessUsecase
    implements UseCase<ParentChildRelationshipEntity, NotificationParams> {
  final ProjectRepository repository;
  AllowParentAccessUsecase(this.repository);
  @override
  Future<Either<ServerFailure, ParentChildRelationshipEntity>> call(
      NotificationParams params) async {
    return await repository.allowParentAccess(
      notificationId: params.notificationid,
      parentId: params.senderId,
      studentId: params.studentId,
      studentProfileId: params.studentProfileId,
    );
  }
}

class NotificationParams {
  final int notificationid;
  final String senderId;
  final String studentId;
  final String studentProfileId;

  NotificationParams({
    required this.notificationid,
    required this.senderId,
    required this.studentId,
    required this.studentProfileId,
  });
}
