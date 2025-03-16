part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {
  final ParentChildRelationshipEntity parentChildRelationship;

  const NotificationsSuccess(this.parentChildRelationship);
}

class NotificationsFailure extends NotificationsState {
  final String error;
  const NotificationsFailure(this.error);
}
