import 'package:mind_lab_app/features/user_detail/domain/entities/skill_hashtag_entity.dart';

// ignore: must_be_immutable
class SkillHashtagModel extends SkillHashTagEntity {
  SkillHashtagModel({
    super.id,
    super.categoryId,
    super.hashtagName,
  });

  factory SkillHashtagModel.fromJson(Map<String, dynamic> json) {
    return SkillHashtagModel(
      id: json['id'],
      categoryId: json['skill_category_id'],
      hashtagName: json['skill_hashtag'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'categoryId': categoryId,
      'hashtagName': hashtagName,
    };
  }
}
