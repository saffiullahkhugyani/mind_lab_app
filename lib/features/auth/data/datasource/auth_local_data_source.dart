import 'dart:developer';

import 'package:hive/hive.dart';

import '../models/student_model.dart';
import '../models/user_model.dart';

abstract interface class AuthLocalDataSource {
  void cacheUser({required UserModel user});
  void cacheStudent({required StudentModel student});
  UserModel? getUser();
  StudentModel? getStudent();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box authBox;
  AuthLocalDataSourceImpl(this.authBox);

  @override
  void cacheUser({required UserModel user}) {
    authBox.put('user', user.toJson());
  }

  @override
  void cacheStudent({required StudentModel student}) {
    authBox.put('student', student.toJson());
  }

  @override
  UserModel? getUser() {
    log("All Hive keys: ${authBox.keys}");
    final user = authBox.get('user');
    if (user != null) {
      return UserModel.fromJson(user);
    }
    return null;
  }

  @override
  StudentModel? getStudent() {
    log("All Hive keys: ${authBox.keys}");
    final student = authBox.get('student');
    if (student != null) {
      return StudentModel.fromJson(student);
    }
    return null;
  }
}
