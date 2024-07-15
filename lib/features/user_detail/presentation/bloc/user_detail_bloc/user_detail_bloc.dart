import 'package:bloc/bloc.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_user_detail.dart';

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final GetUserDetail _getUserDetail;
  UserDetailBloc({required GetUserDetail getUserDetail})
      : _getUserDetail = getUserDetail,
        super(UserDetailInitial()) {
    on<UserDetailEvent>((event, emit) => emit(UserDetailLoading()));
    on<UserDetailFetchUserDetail>(_onFetchUserDetail);
  }

  void _onFetchUserDetail(
    UserDetailFetchUserDetail event,
    Emitter emit,
  ) async {
    final res = await _getUserDetail(NoParams());

    res.fold(
      (failure) => emit(UserDetailFailure(failure.errorMessage)),
      (userDetail) => emit(UserDetailDisplaySuccess(userDetail)),
    );
  }
}
