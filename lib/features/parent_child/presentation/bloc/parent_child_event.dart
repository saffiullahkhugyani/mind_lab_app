part of 'parent_child_bloc.dart';

abstract class ParentChildEvent extends Equatable {
  const ParentChildEvent();

  @override
  List<Object> get props => [];
}

final class AddChildEvent extends ParentChildEvent {
  final String email;
  final String name;
  final String ageGroup;
  final String gender;
  final String nationality;
  final File imageFile;

  const AddChildEvent({
    required this.email,
    required this.name,
    required this.ageGroup,
    required this.gender,
    required this.nationality,
    required this.imageFile,
  });
}

final class GetChildrenEvent extends ParentChildEvent {}
