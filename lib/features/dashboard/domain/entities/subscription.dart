import 'package:mind_lab_app/features/dashboard/domain/entities/project.dart';
import 'package:mind_lab_app/features/dashboard/domain/entities/user.dart';

class Subscription {
  final int subscription;
  final Project project;
  final User user;

  Subscription({
    required this.subscription,
    required this.project,
    required this.user,
  });
}
