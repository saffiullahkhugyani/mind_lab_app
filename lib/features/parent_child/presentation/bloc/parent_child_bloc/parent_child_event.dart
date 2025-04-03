part of 'parent_child_bloc.dart';

abstract class ParentChildEvent extends Equatable {
  const ParentChildEvent();

  @override
  List<Object> get props => [];
}

final class AddChildEvent extends ParentChildEvent {
  final String childId;

  const AddChildEvent({
    required this.childId,
  });
}

final class GetChildrenEvent extends ParentChildEvent {
  final String parentId;
  const GetChildrenEvent({required this.parentId});
}

final class FetchStudentDetailsEvent extends ParentChildEvent {
  final String studentId;

  const FetchStudentDetailsEvent({
    required this.studentId,
  });
}
