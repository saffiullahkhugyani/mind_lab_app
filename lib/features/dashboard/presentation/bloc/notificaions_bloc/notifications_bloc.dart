import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/features/dashboard/domain/usecase/get_notifications_usecase.dart';

import '../../../domain/entities/notification_entity.dart';
import '../../../domain/entities/parent_child_relationship_entity.dart';
import '../../../domain/usecase/allow_parent_access_usecase.dart';
import '../../../domain/usecase/read_notificaion_usecase.dart';

part "notifications_event.dart";
part "notifications_state.dart";

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final AllowParentAccessUsecase _allowParentAccess;
  final GetNotificationsUseCase _getNotifications;
  final ReadNotificaionUsecase _readNotification;
  NotificationsBloc({
    required AllowParentAccessUsecase allowParentUsecase,
    required GetNotificationsUseCase getNotifications,
    required ReadNotificaionUsecase readNotification,
  })  : _allowParentAccess = allowParentUsecase,
        _getNotifications = getNotifications,
        _readNotification = readNotification,
        super(NotificationsInitial()) {
    on<NotificationsEvent>((event, emit) => NotificationsLoading());
    on<GetNotifications>(_onGetNotifications);
    on<AllowParentAccess>(_onAllowParentAccess);
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

    final res = await _getNotifications(event.userId);

    res.fold((failure) => emit(NotificationsFailure(failure.errorMessage)),
        (notifications) => emit(NotificationsListSuccess(notifications)));
  }

  void _onAllowParentAccess(AllowParentAccess event, Emitter emit) async {
    emit(NotificationsLoading());

    final res = await _allowParentAccess(NotificationParams(
      notificationid: event.notificaionId,
      senderId: event.parentId,
      studentId: event.studenId,
      studentProfileId: event.studentProfileId,
    ));

    res.fold((failure) => emit(NotificationsFailure(failure.errorMessage)),
        (success) => emit(ParentChildAccessSuccess(success)));
  }
}
