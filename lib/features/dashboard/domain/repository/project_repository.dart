import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/project.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';

abstract interface class ProjectRepository {
  Future<Either<ServerFailure, List<Subscription>>> getSubscribedProjects();
  Future<Either<ServerFailure, List<Project>>> getAllProjects();
  Future<Either<ServerFailure, StudentEntity>> updateStudentCubit({
    required String profileId,
  });
}
