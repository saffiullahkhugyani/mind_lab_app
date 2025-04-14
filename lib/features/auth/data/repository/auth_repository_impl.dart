import 'dart:developer';
import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/network/connection_checker.dart';
import 'package:mind_lab_app/core/utils/shourt_uuid_generator.dart';
import 'package:mind_lab_app/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:mind_lab_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:mind_lab_app/features/auth/data/models/user_model.dart';
import 'package:mind_lab_app/features/auth/domain/repository/auth_repository.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../models/student_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
    this.localDataSource,
  );

  @override
  Future<Either<ServerFailure, AuthResult>> getCurrentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;
        log(session.toString());
        if (session == null) {
          return left(ServerFailure(errorMessage: 'User not logged in.'));
        }

        UserModel? user = localDataSource.getUser();
        StudentModel? studentModel = localDataSource.getStudent();
        return right(AuthResult(user: user!, student: studentModel));
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(ServerFailure(errorMessage: "Please sign in!"));
      }

      // Step 2 Check if the user is a student (roleId == 4)
      StudentModel? studentModel;
      if ((user.roleId == 4 || user.roleId == 1) &&
          user.isProfileComplete == true) {
        // Fetch student data from the students table
        studentModel =
            await remoteDataSource.getStudentDetails(userId: user.id);
        localDataSource.cacheUser(user: user);
        localDataSource.cacheStudent(student: studentModel);
      } else if (user.roleId == 6) {
        localDataSource.cacheUser(user: user);
      }

      return right(AuthResult(user: user, student: studentModel));
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, AuthResult>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(ServerFailure(errorMessage: 'No internet connection!'));
      }

      // Step 1 Authenticate the user
      final user = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );

      // Step 2 Check if the user is a student (roleId == 4)
      StudentModel? studentModel;
      if (user.roleId == 4 || user.roleId == 1) {
        // Fetch student data from the students table
        studentModel =
            await remoteDataSource.getStudentDetails(userId: user.id);
        localDataSource.cacheUser(user: user);
        localDataSource.cacheStudent(student: studentModel);
      } else if (user.roleId == 6) {
        localDataSource.cacheUser(user: user);
      }

      return right(
        AuthResult(
          user: user,
          student: studentModel,
        ),
      );
    } on sb.AuthException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, AuthResult>> signUpWithEmailPasword({
    required String name,
    required String email,
    required String password,
    required String ageGroup,
    required String mobile,
    required String gender,
    required File? imageFile,
    required String nationality,
    required int roleId,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmailPassword(
          name: name,
          email: email,
          password: password,
          ageGroup: ageGroup,
          mobile: mobile,
          gender: gender,
          nationality: nationality,
          roleId: roleId);

      // upload user profile picture
      String? imageUrl;

      if (imageFile != null) {
        imageUrl = await remoteDataSource.uploadUserImage(
            imageFile: imageFile, userModel: user);
      }

      StudentModel? studentModel;
      // uploading data into stundents table if role type student selected
      if (roleId == 4) {
        studentModel = await remoteDataSource.uploadStudentDetails(
          id: generateShortUUID(user.id),
          profileId: user.id,
          name: name,
          email: email,
          ageGroup: ageGroup,
          mobile: mobile,
          gender: gender,
          nationality: nationality,
          imageUrl: imageUrl ?? "",
        );
      }

      return right(AuthResult(user: user, student: studentModel));
    } on sb.AuthException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    } on ServerException catch (e) {
      return left(
        ServerFailure(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<ServerFailure, AuthResult>> signInWithGoogle() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(ServerFailure(errorMessage: 'No internet connection!'));
      }

      // Step 1 Authenticate the user
      final user = await remoteDataSource.loginWithGoogle();

      // Step 2 Check if the user is a student (roleId == 4)
      StudentModel? studentModel;
      if ((user.roleId == 4 || user.roleId == 1) &&
          user.isProfileComplete == true) {
        // Fetch student data from the students table
        studentModel =
            await remoteDataSource.getStudentDetails(userId: user.id);
        localDataSource.cacheUser(user: user);
        localDataSource.cacheStudent(student: studentModel);
      } else if (user.roleId == 6) {
        localDataSource.cacheUser(user: user);
      }

      return right(AuthResult(user: user, student: studentModel));
    } on sb.AuthException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, AuthResult>> signInWithApple() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(ServerFailure(errorMessage: 'No internet connection!'));
      }

      // Step 1 Authenticate the user
      final user = await remoteDataSource.loginWithApple();

      // Step 2 Check if the user is a student (roleId == 4)

      StudentModel? studentModel;
      if (user.roleId == 4 || user.roleId == 1) {
        // Fetch student data from the students table
        studentModel =
            await remoteDataSource.getStudentDetails(userId: user.id);
        localDataSource.cacheUser(user: user);
        localDataSource.cacheStudent(student: studentModel);
      } else if (user.roleId == 6) {
        localDataSource.cacheUser(user: user);
      }

      return right(AuthResult(user: user, student: studentModel));
    } on sb.AuthException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, AuthResult>> updateUserInfo({
    required String id,
    required String name,
    required String email,
    required String ageGroup,
    required String mobile,
    required String gender,
    required String nationality,
    required int roleId,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(ServerFailure(errorMessage: 'No internet connection!'));
      }

      // step 1 update user information
      final user = await remoteDataSource.updateUserInfo(
          id: id,
          name: name,
          email: email,
          ageGroup: ageGroup,
          gender: gender,
          mobile: mobile,
          nationality: nationality,
          roleId: roleId);

      // update student information
      StudentModel? studentModel;
      // uploading data into stundents table if role type student selected
      if (roleId == 4) {
        studentModel = await remoteDataSource.uploadStudentDetails(
          id: generateShortUUID(user.id),
          profileId: user.id,
          name: user.name,
          email: user.email,
          ageGroup: user.ageGroup,
          mobile: user.mobile,
          gender: user.gender,
          nationality: user.nationality,
          imageUrl: user.imageUrl ?? "",
        );

        localDataSource.cacheUser(user: user);
        localDataSource.cacheStudent(student: studentModel);
      } else if (roleId == 6) {
        localDataSource.cacheUser(user: user);
      }

      return right(
        AuthResult(
          user: user,
          student: studentModel,
        ),
      );
    } on sb.AuthException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  // Future<Either<ServerFailure, User>> _getUser(
  //   Future<User> Function() fn,
  // ) async {
  //   try {
  //     if (!await (connectionChecker.isConnected)) {
  //       return left(ServerFailure(errorMessage: 'No internet connection!'));
  //     }
  //     final user = await fn();
  //     return right(user);
  //   } on sb.AuthException catch (e) {
  //     return left(ServerFailure(errorMessage: e.message));
  //   } on ServerException catch (e) {
  //     return left(ServerFailure(errorMessage: e.message));
  //   }
  // }
}
