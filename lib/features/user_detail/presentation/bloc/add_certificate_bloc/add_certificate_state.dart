import 'package:equatable/equatable.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_tag_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skills_type_entity.dart';

abstract class AddCertificateState extends Equatable {
  const AddCertificateState();

  @override
  List<Object> get props => [];
}

class InitialState extends AddCertificateState {}

class SkillDataLoading extends AddCertificateState {}

class SkillDataSuccess extends AddCertificateState {
  final List<SkillTypeEntity> skillTypes;
  final List<SkillCategoryEntity> skillCategories;
  final List<SkillTagEntity> skillTags;

  const SkillDataSuccess({
    required this.skillTypes,
    required this.skillTags,
    required this.skillCategories,
  });

  @override
  List<Object> get props => [
        skillTypes,
        skillTags,
        skillCategories,
      ];
}

class SkillDataFailure extends AddCertificateState {
  final String error;
  const SkillDataFailure(this.error);
}

class UploadCertificateSuccess extends AddCertificateState {}
