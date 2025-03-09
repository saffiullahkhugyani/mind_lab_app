part of 'user_detail_bloc.dart';

abstract class UserDetailState {}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailFailure extends UserDetailState {
  final String error;
  UserDetailFailure(this.error);
}

class UserDetailDisplaySuccess extends UserDetailState {
  final StudentDetailResult userDetail;

  UserDetailDisplaySuccess(this.userDetail);
}

class UserDeleteAccountFailure extends UserDetailState {
  final String errorMessage;
  UserDeleteAccountFailure(this.errorMessage);
}

class UserDeleteAccountSuccess extends UserDetailState {
  final String successMessage;

  UserDeleteAccountSuccess(this.successMessage);
}
