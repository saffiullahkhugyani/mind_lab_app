import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';

// ignore: must_be_immutable
class SkillCategoryModel extends SkillCategoryEntity {
  SkillCategoryModel({
    super.id,
    super.categoryName,
  });

  factory SkillCategoryModel.fromJson(Map<String, dynamic> json) =>
      SkillCategoryModel(
        id: json['id'],
        categoryName: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryName': categoryName,
      };
}
