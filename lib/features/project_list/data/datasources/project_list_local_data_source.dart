import 'package:hive/hive.dart';
import 'package:mind_lab_app/features/project_list/data/models/project_list_model.dart';

abstract interface class ProjectListLocalDataSource {
  void uploadLocalProjectList({required List<ProjectListModel> projectList});
  List<ProjectListModel> loadProjectList();
}

class ProjectListLocalDataSourceImpl implements ProjectListLocalDataSource {
  final Box box;
  ProjectListLocalDataSourceImpl(this.box);

  @override
  List<ProjectListModel> loadProjectList() {
    List<ProjectListModel> projectList = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        print(box.get(i.toString()));
        projectList.add(ProjectListModel.fromJson(box.get(i.toString())));
      }
    });
    return projectList;
  }

  @override
  void uploadLocalProjectList({required List<ProjectListModel> projectList}) {
    // clearing the data before inserting the data
    box.clear();

    // inserting data
    box.write(() {
      for (int i = 0; i < projectList.length; i++) {
        box.put('project_list_${i.toString()}', projectList[i].toJson());
      }
    });
  }
}
