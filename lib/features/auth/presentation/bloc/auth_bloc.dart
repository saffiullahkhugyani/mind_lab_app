import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_student/app_student_cubit.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/auth/domain/mapper/user_to_student_mapper.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/current_user.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_in_apple.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/user_sign_in_google.dart';
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
  final AppStudentCubit _appStudentCubit;
  final UserLoginWithGoogle _loginWithGoogle;
  final UserLoginWithApple _loginWithApple;

  // Constructor
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required AppStudentCubit appStudentCubit,
    required UserLoginWithGoogle loginWithGoogle,
    required UserLoginWithApple loginWithApple,
  })  : _userSignUpUsecase = userSignUp,
        _userLoginUsecase = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _appStudentCubit = appStudentCubit,
        _loginWithGoogle = loginWithGoogle,
        _loginWithApple = loginWithApple,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLoginWithGoogle>(_onAuthLoginWithGoogle);
    on<AuthLoginWithApple>(_onAuthLoginWithApple);
  }

  void _isUserLoggedIn(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _currentUser(NoParams());

    response.fold(
      (failure) {
        emit(AuthUserNotLoggedIn(failure.errorMessage));
      },
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  // login with google
  void _onAuthLoginWithGoogle(
      AuthLoginWithGoogle event, Emitter<AuthState> emit) async {
    final response = await _loginWithGoogle(NoParams());
    response.fold((failure) => emit(AuthFailure(failure.errorMessage)),
        (user) => _emitAuthSuccess(user, emit));
  }

  // logim with apple
  void _onAuthLoginWithApple(
      AuthLoginWithApple event, Emitter<AuthState> emit) async {
    final response = await _loginWithApple(NoParams());
    response.fold((failure) => emit(AuthFailure(failure.errorMessage)),
        (user) => _emitAuthSuccess(user, emit));
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
        ageGroup: event.ageGroup,
        mobile: event.mobile,
        gender: event.gender,
        imageFile: event.imageFile,
        nationality: event.nationality,
        roleId: event.roleId,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.errorMessage)),
      (signUpResult) {
        log(signUpResult.user.id);
        log(signUpResult.student!.id);
        _emitAuthSuccess(signUpResult, emit);
      },
    );
  }

  void _emitAuthSuccess(
    AuthResult signUpDetails,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(signUpDetails.user);

    //if auth success and role == student == 4 save the data into student cubit
    if (signUpDetails.user.roleId == 4) {
      _appStudentCubit.updateStudent(signUpDetails.student);
    }
    emit(AuthSuccess(signUpDetails.user));
  }
}
