import 'dart:developer';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/network/connection_checker.dart';
import 'package:mind_lab_app/features/parent_child/data/datasources/local_data_source.dart';
import 'package:mind_lab_app/features/parent_child/data/datasources/remote_data_source.dart';
import 'package:mind_lab_app/features/parent_child/data/models/child_model.dart';
import 'package:mind_lab_app/features/parent_child/domain/repositories/parent_child_repository.dart';

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
  Future<Either<ServerFailure, ChildModel>> addChild({
    required String name,
    required String email,
    required String ageGroup,
    required String gender,
    required String nationality,
    required File imageFile,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(ServerFailure(
            errorMessage:
                "Please check your internet connection, and try again later."));
      }

      final child = await remoteDataSource.addChild(
        name: name,
        email: email,
        ageGroup: ageGroup,
        gender: gender,
        nationality: nationality,
      );

      // uplad image to storage
      final imageUrl = await remoteDataSource.uploadChildImage(
          imageFile: imageFile, childModel: child);

      log(imageUrl);

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
  Future<Either<ServerFailure, List<ChildModel>>> getChildrens() async {
    try {
      if (!await connectionChecker.isConnected) {
        final childrensList = localDataSource.loadChildrensData();
        return right(childrensList);
      }
      final childrensList = await remoteDataSource.getChildren();
      localDataSource.uploadChildrenData(children: childrensList);
      return right(childrensList);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }
}
