import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/current_user.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_up.dart';

import '../../../../core/common/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Initializations
  final UserSignUp _userSignUpUsecase;
  final UserLogin _userLoginUsecase;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  // Constructor
  AuthBloc(
      {required UserSignUp userSignUp,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUpUsecase = userSignUp,
        _userLoginUsecase = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _currentUser(NoParams());

    response.fold(
      (failure) {
        emit(AuthFailure(failure.errorMessage));
        emit(AuthInitial());
      },
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userLoginUsecase(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.errorMessage)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final response = await _userSignUpUsecase(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
        age: event.age,
        mobile: event.mobile,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.errorMessage)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
