import 'package:bloc/bloc.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/delete_account.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_user_detail.dart';

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final GetUserDetail _getUserDetail;
  final DeleteAccount _deleteAccount;
  UserDetailBloc({
    required GetUserDetail getUserDetail,
    required DeleteAccount deleteAccount,
  })  : _getUserDetail = getUserDetail,
        _deleteAccount = deleteAccount,
        super(UserDetailInitial()) {
    on<UserDetailEvent>((event, emit) => emit(UserDetailLoading()));
    on<UserDetailFetchUserDetail>(_onFetchUserDetail);
    on<UserDeleteAccount>(_onUserDeleteAccount);
  }

  void _onUserDeleteAccount(UserDeleteAccount event, Emitter emit) async {
    final res = await _deleteAccount(NoParams());

    res.fold(
      (failure) => emit(UserDeleteAccountFailure(failure.errorMessage)),
      (success) => emit(UserDeleteAccountSuccess(success)),
    );
  }

  void _onFetchUserDetail(
    UserDetailFetchUserDetail event,
    Emitter emit,
  ) async {
    final res = await _getUserDetail(
      StudentDetailParams(
        parentId: event.parentId,
        studentId: event.studentId,
        roleId: event.roleId,
        studentProfileId: event.studentProfileId,
      ),
    );

    res.fold(
      (failure) => emit(UserDetailFailure(failure.errorMessage)),
      (userDetail) => emit(UserDetailDisplaySuccess(userDetail)),
    );
  }
}
