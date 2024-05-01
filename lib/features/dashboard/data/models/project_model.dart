import 'package:mind_lab_app/features/dashboard/data/models/base_model.dart';

class Projects implements BaseModel {
  @override
  final int id;
  final String name;
  final String description;

  Projects({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Projects.formJson(Map<String, dynamic> json) {
    return Projects(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map toMap() {
    return {'id': id, 'name': name, 'description': description};
  }

  @override
  String value() {
    return name;
  }
}
