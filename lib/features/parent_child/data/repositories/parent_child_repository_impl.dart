import 'package:fpdart/fpdart.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/network/connection_checker.dart';
import 'package:mind_lab_app/features/parent_child/data/models/parent_child_relationship_model.dart';
import 'package:mind_lab_app/features/parent_child/data/models/student_model.dart';
import 'package:mind_lab_app/features/parent_child/domain/repositories/parent_child_repository.dart';

import '../datasource/local_data_source.dart';
import '../datasource/remote_data_source.dart';

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
  Future<Either<ServerFailure, ParentChildRelationshipModel>> addStudent({
    required String studentId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(ServerFailure(
            errorMessage:
                "Please check your internet connection, and try again later."));
      }

      final child = await remoteDataSource.addStudent(studentId: studentId);

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
  Future<Either<ServerFailure, List<StudentModel>>> getStudents({
    required String parentId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        final studentsList = localDataSource.loadStudentsData();
        return right(studentsList);
      }
      final studentsList =
          await remoteDataSource.getStudents(parentId: parentId);
      localDataSource.uploadStudentData(students: studentsList);
      return right(studentsList);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, StudentEntity>> getStudentDetails(
      {required String studentId}) async {
    try {
      final student =
          await remoteDataSource.getStudentDetails(studentId: studentId);
      return right(student);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }
}
