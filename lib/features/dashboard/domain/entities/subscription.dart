import 'package:mind_lab_app/features/dashboard/domain/entities/project.dart';

import 'child.dart';

class Subscription {
  final int subscription;
  final Project project;
  final Child child;

  Subscription({
    required this.subscription,
    required this.project,
    required this.child,
  });
}
