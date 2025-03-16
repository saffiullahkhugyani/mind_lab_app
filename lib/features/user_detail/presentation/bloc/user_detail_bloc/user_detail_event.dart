part of 'user_detail_bloc.dart';

abstract class UserDetailEvent {}

class UserDetailFetchUserDetail extends UserDetailEvent {
  final String parentId;
  final String studentId;
  final String studentProfileId;
  final int roleId;

  UserDetailFetchUserDetail({
    required this.roleId,
    required this.parentId,
    required this.studentId,
    required this.studentProfileId,
  });
}

class UserDeleteAccount extends UserDetailEvent {}
