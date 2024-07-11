import 'package:equatable/equatable.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_hashtag_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skills_entity.dart';

abstract class AddCertificateState extends Equatable {
  const AddCertificateState();

  @override
  List<Object> get props => [];
}

class InitialState extends AddCertificateState {}

class SkillDataLoading extends AddCertificateState {}

class SkillDataSuccess extends AddCertificateState {
  final List<SkillEntity> skills;
  final List<SkillHashTagEntity> skillHashtags;
  final List<SkillCategoryEntity> skillCategories;

  const SkillDataSuccess({
    required this.skills,
    required this.skillHashtags,
    required this.skillCategories,
  });

  @override
  List<Object> get props => [
        skills,
        skillHashtags,
        skillCategories,
      ];
}

class SkillDataFailure extends AddCertificateState {
  final String error;
  const SkillDataFailure(this.error);
}

class UploadCertificateSuccess extends AddCertificateState {}
