import 'package:hive/hive.dart';
import 'package:mind_lab_app/features/dashboard/data/models/subs_model.dart';

abstract interface class ProjectLocalDataSource {
  void uploadLocalProjects({required List<SubscriptionModel> projects});
  List<SubscriptionModel> loadProjects();
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final Box box;
  ProjectLocalDataSourceImpl(this.box);

  @override
  List<SubscriptionModel> loadProjects() {
    List<SubscriptionModel> projects = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        projects.add(
            SubscriptionModel.fromJson(box.get('project_${i.toString()}')));
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
}
