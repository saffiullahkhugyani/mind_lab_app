import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/user_detail_entity.dart';

abstract interface class UserDetailRepository {
  Future<Either<ServerFailure, List<UserDetailEntity>>> getUserDetails();
}
