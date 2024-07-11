import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
// ignore: must_be_immutable
class SkillHashTagEntity extends Equatable {
  SkillHashTagEntity({
    this.id,
    this.categoryId,
    this.hashtagName,
  });

  int? id;
  int? categoryId;
  String? hashtagName;

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        categoryId,
        hashtagName,
      ];
}
