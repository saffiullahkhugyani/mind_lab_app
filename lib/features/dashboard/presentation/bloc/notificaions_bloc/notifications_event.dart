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

class AllowParentAccess extends NotificationsEvent {
  final int notificaionId;
  final String parentId;
  final String studenId;
  final String studentProfileId;
  const AllowParentAccess(
    this.notificaionId,
    this.parentId,
    this.studenId,
    this.studentProfileId,
  );
}

class ReadNotificationEvent extends NotificationsEvent {
  final int notificationId;
  final String userId;
  const ReadNotificationEvent(
    this.notificationId,
    this.userId,
  );
}
