part of 'update_profile_bloc.dart';

sealed class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class UpdateUserProfileEvent extends UpdateProfileEvent {
  int? childId;
  String? name;
  String? email;
  String? ageGroup;
  File? imageFile;

  UpdateUserProfileEvent({
    this.childId,
    this.name,
    this.email,
    this.ageGroup,
    this.imageFile,
  });
}
