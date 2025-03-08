part of 'app_student_cubit.dart';

sealed class AppStudentState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AppStudentInitial extends AppStudentState {}

final class AppStudentSelected extends AppStudentState {
  final StudentEntity student;
  AppStudentSelected(this.student);

  @override
  List<Object?> get props => [student];
}
