import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/project.dart';

class Subscription {
  final int subscription;
  final Project project;
  final StudentEntity student;

  Subscription({
    required this.subscription,
    required this.project,
    required this.student,
  });
}
