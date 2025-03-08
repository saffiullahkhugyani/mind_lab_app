import 'package:hive/hive.dart';
import 'package:mind_lab_app/features/parent_child/data/models/student_model.dart';

abstract interface class LocalDataSource {
  void uploadStudentData({required List<StudentModel> students});
  List<StudentModel> loadStudentsData();
}

class LocalDataSrouceImpl implements LocalDataSource {
  final Box studentsBox;
  LocalDataSrouceImpl(this.studentsBox);

  @override
  List<StudentModel> loadStudentsData() {
    List<StudentModel> studentsList = [];
    studentsBox.read(() {
      for (int i = 0; i < studentsBox.length; i++) {
        final student = studentsBox.get('child_${i.toString()}');
        if (student != null) {
          studentsList.add(StudentModel.fromJson(student));
        }
      }
    });

    return studentsList;
  }

  @override
  void uploadStudentData({required List<StudentModel> students}) {
    // clearing the data before inserting the data again
    studentsBox.clear();

    // storing the lattest childrens data for offline use
    studentsBox.write(() {
      for (int i = 0; i < students.length; i++) {
        studentsBox.put('child_${i.toString()}', students[i].toJson());
      }
    });
  }
}
