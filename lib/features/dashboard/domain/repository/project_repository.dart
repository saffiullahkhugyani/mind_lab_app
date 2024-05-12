import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/subscription.dart';

abstract interface class ProjectRepository {
  Future<Either<ServerFailure, List<Subscription>>> getAllProject();
}
