part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class GetNotifications extends NotificationsEvent {
  final String userId;

  const GetNotifications({required this.userId});
}

class ReadNotificationEvent extends NotificationsEvent {
  final int notificationId;
  final String userId;
  const ReadNotificationEvent(
    this.notificationId,
    this.userId,
  );
}
