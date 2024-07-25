import 'package:hive/hive.dart';
import 'package:mind_lab_app/features/dashboard/data/models/pro_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/subs_model.dart';

abstract interface class ProjectLocalDataSource {
  void uploadLocalProjects({required List<SubscriptionModel> projects});
  List<SubscriptionModel> loadProjects();
  void uploadAllProjects({required List<ProjectModel> allProjects});
  List<ProjectModel> loadAllProjects();
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final Box box;
  ProjectLocalDataSourceImpl(this.box);

  @override
  List<SubscriptionModel> loadProjects() {
    List<SubscriptionModel> projects = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        final subscribedProjects = box.get('project_${i.toString()}');
        if (subscribedProjects != null) {
          projects.add(SubscriptionModel.fromJson(subscribedProjects));
        }
      }
    });

    return projects;
  }

  @override
  void uploadLocalProjects({required List<SubscriptionModel> projects}) {
    // clearing the data before inserting the data again
    box.clear();

    // storing the the lattest subscribed project for offline use
    box.write(() {
      for (int i = 0; i < projects.length; i++) {
        box.put('project_${i.toString()}', projects[i].toJson());
      }
    });
  }

  @override
  List<ProjectModel> loadAllProjects() {
    List<ProjectModel> allProjects = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        final ubsubscribedProject =
            box.get('unsubscribed_project_${i.toString()}');
        if (ubsubscribedProject != null) {
          allProjects.add(ProjectModel.fromJson(
              box.get('unsubscribed_project_${i.toString()}')));
        }
      }
    });
    return allProjects;
  }

  @override
  void uploadAllProjects({required List<ProjectModel> allProjects}) {
    // storing the the lattest subscribed project for offline use
    box.write(() {
      for (int i = 0; i < allProjects.length; i++) {
        box.put(
            'unsubscribed_project_${i.toString()}', allProjects[i].toJson());
      }
    });
  }
}
