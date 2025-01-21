import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class SkillTypeEntity extends Equatable {
  SkillTypeEntity({this.id, this.name});

  int? id;
  String? name;

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
