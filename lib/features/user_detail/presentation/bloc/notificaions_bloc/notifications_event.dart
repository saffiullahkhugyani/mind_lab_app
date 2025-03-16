part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
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
