part of 'app_child_cubit.dart';

sealed class AppChildState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AppChildInitial extends AppChildState {}

final class AppChildSelected extends AppChildState {
  final ChildEntity child;
  AppChildSelected(this.child);

  @override
  List<Object?> get props => [child];
}
