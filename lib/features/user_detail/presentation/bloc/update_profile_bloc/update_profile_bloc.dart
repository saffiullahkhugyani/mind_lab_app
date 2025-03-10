import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/update_profile.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final UpdateProfile _updateProfile;

  UpdateProfileBloc({required UpdateProfile updateProfile})
      : _updateProfile = updateProfile,
        super(UpdateProfileInitial()) {
    on<UpdateProfileEvent>(
      (event, emit) => emit(
        UpdateProfileLoading(),
      ),
    );
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  void _onUpdateUserProfile(UpdateUserProfileEvent event, Emitter emit) async {
    final res = await _updateProfile(UpdateProfileParams(
      studentId: event.studentId ?? "",
      name: event.name ?? "",
      dateOfBirth: event.dateOfBirth ?? "",
      number: event.number ?? "",
      profileImageFile: event.imageFile,
    ));

    res.fold(
      (failure) => emit(
        UpdateProfileFailure(
          failure.errorMessage,
        ),
      ),
      (success) => emit(
        UpdateProfileSuccess(),
      ),
    );
  }
}
