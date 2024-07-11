import 'package:mind_lab_app/features/user_detail/domain/entities/skills_entity.dart';

// ignore: must_be_immutable
class SkillModel extends SkillEntity {
  SkillModel({
    super.id,
    super.hashtagId,
    super.name,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
        id: json["id"],
        hashtagId: json["skill_hashtag_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'hashtagId': hashtagId,
        'name': name,
      };
}
