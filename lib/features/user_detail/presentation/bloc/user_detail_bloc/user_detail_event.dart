part of 'user_detail_bloc.dart';

abstract class UserDetailEvent {}

class GetChildDetails extends UserDetailEvent {
  final int childId;

  GetChildDetails({required this.childId});
}

class UserDeleteAccount extends UserDetailEvent {}
