import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/failure.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<ServerFailure, SuccessType>> call(Params params);
}

class NoParams {}
