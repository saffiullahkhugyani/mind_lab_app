part of 'parent_child_bloc.dart';

abstract class ParentChildState extends Equatable {
  const ParentChildState();

  @override
  List<Object> get props => [];
}

class ParentChildInitial extends ParentChildState {}

class ParentChildLoading extends ParentChildState {}

class ParentChildSuccess extends ParentChildState {
  final List<StudentEntity> children;
  const ParentChildSuccess(this.children);
}

class ParentChildFailure extends ParentChildState {
  final String message;
  const ParentChildFailure(this.message);
}
