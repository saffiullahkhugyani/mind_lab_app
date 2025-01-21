import 'package:mind_lab_app/features/user_detail/domain/entities/skills_type_entity.dart';

// ignore: must_be_immutable
class SkillTypeModel extends SkillTypeEntity {
  SkillTypeModel({
    super.id,
    super.name,
  });

  factory SkillTypeModel.fromJson(Map<String, dynamic> json) => SkillTypeModel(
        id: json["id"],
        name: json["skill_type_name"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
