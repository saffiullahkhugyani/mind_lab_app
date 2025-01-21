import 'package:mind_lab_app/features/user_detail/domain/entities/skill_tag_entity.dart';

// ignore: must_be_immutable
class SkillTagModel extends SkillTagEntity {
  SkillTagModel({
    super.id,
    super.skillCategoryId,
    super.name,
  });

  factory SkillTagModel.fromJson(Map<String, dynamic> json) {
    return SkillTagModel(
      id: json['id'],
      skillCategoryId: json['skill_category_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'categoryId': skillCategoryId,
      'hashtagName': name,
    };
  }
}
