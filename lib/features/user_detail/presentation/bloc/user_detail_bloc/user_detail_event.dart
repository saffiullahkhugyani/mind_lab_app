part of 'user_detail_bloc.dart';

abstract class UserDetailEvent {}

class UserDetailFetchUserDetail extends UserDetailEvent {
  final String parentId;
  final String studentId;
  final int roleId;

  UserDetailFetchUserDetail({
    required this.roleId,
    required this.parentId,
    required this.studentId,
  });
}

class UserDeleteAccount extends UserDetailEvent {}
