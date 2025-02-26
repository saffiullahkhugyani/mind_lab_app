import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/core/common/entities/child_entity.dart';
import 'package:mind_lab_app/features/parent_child/domain/repositories/parent_child_repository.dart';

class GetChildrenUsecase implements UseCase<List<ChildEntity>, NoParams> {
  final ParentChildRepository repository;
  GetChildrenUsecase(this.repository);

  @override
  Future<Either<ServerFailure, List<ChildEntity>>> call(NoParams params) {
    return repository.getChildrens();
  }
}
