part of 'user_detail_bloc.dart';

abstract class UserDetailEvent {}

class UserDetailFetchUserDetail extends UserDetailEvent {}

class UserDeleteAccount extends UserDetailEvent {}
