part of 'update_profile_bloc.dart';

sealed class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object> get props => [];
}

final class UpdateProfileInitial extends UpdateProfileState {}

final class UpdateProfileLoading extends UpdateProfileState {}

final class UpdateProfileFailure extends UpdateProfileState {
  final String error;
  UpdateProfileFailure(this.error);
}

final class UpdateProfileSuccess extends UpdateProfileState {}
