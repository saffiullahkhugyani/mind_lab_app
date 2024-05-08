import 'package:bloc/bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';

part 'home_master_state.dart';

class HomeMasterCubit extends Cubit<HomeMasterState> {
  final HomeMasterInitialParams initialParams;
  final AppUserCubit _appUserCubit;
  HomeMasterCubit(this.initialParams, this._appUserCubit)
      : super(HomeMasterState.initial(initialParams: initialParams));

  onInit() {
    emit(state.copyWith(appUserCubit: _appUserCubit));
  }
}
