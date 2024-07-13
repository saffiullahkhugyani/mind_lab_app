part of 'update_profile_bloc.dart';

sealed class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class UpdateUserProfileEvent extends UpdateProfileEvent {
  String? userId;
  String? name;
  String? number;
  String? dateOfBirth;
  File? imageFile;

  UpdateUserProfileEvent({
    this.userId,
    this.name,
    this.number,
    this.dateOfBirth,
    this.imageFile,
  });
}
