import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_student/app_student_cubit.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/current_user.dart';
import 'package:mind_lab_app/features/auth/domain/usecases/update_user_info.dart';
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
  final UpdateUserInfoUseCase _updateUserInfoUseCase;

  // Constructor
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required AppStudentCubit appStudentCubit,
    required UserLoginWithGoogle loginWithGoogle,
    required UserLoginWithApple loginWithApple,
    required UpdateUserInfoUseCase updateUserInfoUseCase,
  })  : _userSignUpUsecase = userSignUp,
        _userLoginUsecase = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _appStudentCubit = appStudentCubit,
        _loginWithGoogle = loginWithGoogle,
        _loginWithApple = loginWithApple,
        _updateUserInfoUseCase = updateUserInfoUseCase,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLoginWithGoogle>(_onAuthLoginWithGoogle);
    on<AuthLoginWithApple>(_onAuthLoginWithApple);
    on<AuthUpdateUserInfo>(_onAuthUpdateUserInfo);
  }

  void _isUserLoggedIn(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
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

    response.fold((failure) => emit(AuthFailure(failure.errorMessage)),
        (authResult) {
      _emitAuthSuccess(authResult, emit);
    });
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
      (authResult) {
        _emitAuthSuccess(authResult, emit);
      },
    );
  }

  void _onAuthUpdateUserInfo(
      AuthUpdateUserInfo event, Emitter<AuthState> emit) async {
    final response = await _updateUserInfoUseCase(
      UpdateUserInfoParams(
        id: event.id,
        email: event.email,
        name: event.name,
        ageGroup: event.ageGroup,
        mobile: event.mobile,
        gender: event.gender,
        nationality: event.nationality,
        roleId: event.roleId,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.errorMessage)),
      (authResult) {
        _emitAuthSuccess(authResult, emit);
      },
    );
  }

  // commom emitter function for auth success
  void _emitAuthSuccess(
    AuthResult signUpDetails,
    Emitter<AuthState> emit,
  ) {
    log("user role id: ${signUpDetails.user.roleId}");
    // log("user role id: ${signUpDetails.student!.id}");

    _appUserCubit.updateUser(signUpDetails.user);

    //if auth success and role == student == 4 save the data into student cubit
    if (signUpDetails.user.roleId == 4 || signUpDetails.user.roleId == 1) {
      _appStudentCubit.updateStudent(signUpDetails.student);
    }
    emit(AuthSuccess(signUpDetails.user));
  }
}
