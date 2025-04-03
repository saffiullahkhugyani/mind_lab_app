part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsListSuccess extends NotificationsState {
  final List<NotificationEntity> notifications;

  const NotificationsListSuccess(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class ReadNotificationSuccess extends NotificationsState {
  final NotificationEntity notification;

  const ReadNotificationSuccess(this.notification);

  @override
  List<Object> get props => [notification];
}

class NotificationsFailure extends NotificationsState {
  final String error;
  const NotificationsFailure(this.error);
}
