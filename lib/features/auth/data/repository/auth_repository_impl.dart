import 'dart:developer';
import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/core/errors/failure.dart';
import 'package:mind_lab_app/core/network/connection_checker.dart';
import 'package:mind_lab_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:mind_lab_app/features/auth/data/models/suer_model.dart';
import 'package:mind_lab_app/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/common/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<ServerFailure, User>> getCurrentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;
        log(session.toString());
        if (session == null) {
          return left(ServerFailure(errorMessage: 'User not logged in.'));
        }

        return right(UserModel(
          id: session.user.id,
          email: session.user.email ?? '',
          name: '',
          ageGroup: '',
          mobile: '',
          gender: '',
        ));
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(ServerFailure(errorMessage: "Please sign in!"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
          email: email, password: password),
    );
  }

  @override
  Future<Either<ServerFailure, User>> signUpWithEmailPasword({
    required String name,
    required String email,
    required String password,
    required String ageGroup,
    required String mobile,
    required String gender,
    required File imageFile,
  }) async {
    return _getUser(() async {
      final user = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
        ageGroup: ageGroup,
        mobile: mobile,
        gender: gender,
      );

      // upload user profile picture
      final imageUrl = await remoteDataSource.uploadUserImage(
          imageFile: imageFile, userModel: user);

      log(imageUrl);

      return user;
    });
  }

  @override
  Future<Either<ServerFailure, User>> signInWithGoogle() async {
    try {
      return _getUser(
        () async => await remoteDataSource.loginWithGoogle(),
      );
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
  Future<Either<ServerFailure, User>> signInWithApple() async {
    try {
      return _getUser(() async => remoteDataSource.loginWithApple());
    } on sb.AuthException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(
        errorMessage: e.toString(),
      ));
    }
  }

  Future<Either<ServerFailure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(ServerFailure(errorMessage: 'No internet connection!'));
      }
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(errorMessage: e.message));
    }
  }
}
