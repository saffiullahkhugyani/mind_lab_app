part of 'user_detail_bloc.dart';

abstract class UserDetailState {}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailFailure extends UserDetailState {
  final String error;
  UserDetailFailure(this.error);
}

class UserDetailDisplaySuccess extends UserDetailState {
  final UserDetailResult userDetail;

  UserDetailDisplaySuccess(this.userDetail);
}
