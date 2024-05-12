import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/features/user_detail/data/datasources/user_detail_remote_data_source.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/user_detail_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class UserDetailRepositoryImpl implements UserDetailRepository {
  final UserDetailRemoteDataSource userDetailRemoteDataSource;
  UserDetailRepositoryImpl(this.userDetailRemoteDataSource);
  @override
  Future<Either<ServerFailure, List<UserDetailEntity>>> getUserDetails() async {
    try {
      final userDetail = await userDetailRemoteDataSource.getUserDetails();
      return right(userDetail);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }
}
