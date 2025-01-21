import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
// ignore: must_be_immutable
class SkillTagEntity extends Equatable {
  SkillTagEntity({
    this.id,
    this.skillCategoryId,
    this.name,
  });

  int? id;
  int? skillCategoryId;
  String? name;

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        skillCategoryId,
        name,
      ];
}
