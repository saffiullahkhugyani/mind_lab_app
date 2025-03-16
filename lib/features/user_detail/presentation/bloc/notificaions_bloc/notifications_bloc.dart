import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/allow_parent_usecase.dart';

import '../../../domain/entities/parent_child_relationship_entity.dart';

part "notifications_event.dart";
part "notifications_state.dart";

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final AllowParentUseCase _allowParentUseCase;
  NotificationsBloc({required AllowParentUseCase allowParentUsecase})
      : _allowParentUseCase = allowParentUsecase,
        super(NotificationsInitial()) {
    on<NotificationsEvent>((event, emit) => NotificationsLoading());
    on<AllowParentAccess>(_onAllowParentAccess);
  }

  void _onAllowParentAccess(AllowParentAccess event, Emitter emit) async {
    emit(NotificationsLoading());

    final res = await _allowParentUseCase(NotificationParams(
      notificationid: event.notificaionId,
      senderId: event.parentId,
      studentId: event.studenId,
      studentProfileId: event.studentProfileId,
    ));

    res.fold((failure) => emit(NotificationsFailure(failure.errorMessage)),
        (success) => emit(NotificationsSuccess(success)));
  }
}
