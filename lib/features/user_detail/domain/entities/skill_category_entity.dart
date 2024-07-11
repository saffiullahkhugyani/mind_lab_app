import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
// ignore: must_be_immutable
class SkillCategoryEntity extends Equatable {
  SkillCategoryEntity({
    this.id,
    this.categoryName,
  });

  int? id;
  String? categoryName;

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        categoryName,
      ];
}
