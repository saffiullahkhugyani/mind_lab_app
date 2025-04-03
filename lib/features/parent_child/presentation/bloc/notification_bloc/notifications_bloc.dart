import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/features/parent_child/domain/usecases/read_notificaion_usecase.dart';

import '../../../domain/entities/notification_entity.dart';
import '../../../domain/usecases/get_notifications_usecase.dart';
part "notifications_event.dart";
part "notifications_state.dart";

class ParentsNotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  final GetParentsNotificationsUseCase _getNotifications;
  final ReadParentsNotificaionUsecase _readNotification;
  ParentsNotificationsBloc({
    required GetParentsNotificationsUseCase getNotifications,
    required ReadParentsNotificaionUsecase readNotification,
  })  : _getNotifications = getNotifications,
        _readNotification = readNotification,
        super(NotificationsInitial()) {
    on<NotificationsEvent>((event, emit) => NotificationsLoading());
    on<GetNotifications>(_onGetNotifications);
    on<ReadNotificationEvent>(_onReadNotification);
  }

  void _onReadNotification(ReadNotificationEvent event, Emitter emit) async {
    emit(NotificationsLoading());

    final res = await _readNotification(ReadNotificationParams(
      notificationId: event.notificationId,
      userId: event.userId,
    ));

    res.fold((failure) => emit(NotificationsFailure(failure.errorMessage)),
        (notification) => emit(ReadNotificationSuccess(notification)));
  }

  void _onGetNotifications(GetNotifications event, Emitter emit) async {
    emit(NotificationsLoading());
//
    final res = await _getNotifications(event.userId);

    res.fold((failure) => emit(NotificationsFailure(failure.errorMessage)),
        (notifications) => emit(NotificationsListSuccess(notifications)));
  }
}
