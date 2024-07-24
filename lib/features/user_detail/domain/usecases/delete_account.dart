import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/repositories/user_detail_repository.dart';

class DeleteAccount implements UseCase<String, NoParams> {
  final UserDetailRepository repository;
  DeleteAccount(this.repository);

  @override
  Future<Either<ServerFailure, String>> call(NoParams params) async {
    return await repository.deleteAccount();
  }
}
