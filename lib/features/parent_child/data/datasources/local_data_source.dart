import 'package:hive/hive.dart';

import '../models/child_model.dart';

abstract interface class LocalDataSource {
  void uploadChildrenData({required List<ChildModel> children});
  List<ChildModel> loadChildrensData();
}

class LocalDataSrouceImpl implements LocalDataSource {
  final Box childrenBox;
  LocalDataSrouceImpl(this.childrenBox);

  @override
  List<ChildModel> loadChildrensData() {
    List<ChildModel> childrensList = [];
    childrenBox.read(() {
      for (int i = 0; i < childrenBox.length; i++) {
        final child = childrenBox.get('child_${i.toString()}');
        if (child != null) {
          childrensList.add(ChildModel.fromJson(child));
        }
      }
    });

    return childrensList;
  }

  @override
  void uploadChildrenData({required List<ChildModel> children}) {
    // clearing the data before inserting the data again
    childrenBox.clear();

    // storing the lattest childrens data for offline use
    childrenBox.write(() {
      for (int i = 0; i < children.length; i++) {
        childrenBox.put('child_${i.toString()}', children[i].toJson());
      }
    });
  }
}
