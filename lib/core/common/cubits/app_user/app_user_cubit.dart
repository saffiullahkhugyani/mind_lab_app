import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/entities/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      log('in if because user is null');
      emit(AppUserInitial());
    } else {
      log('in else for app userLoggedIn');
      log(user.name);
      emit(AppUserLoggedIn(user));
    }
  }
}
