import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class SkillEntity extends Equatable {
  SkillEntity({this.id, this.hashtagId, this.name});

  int? id;
  int? hashtagId;
  String? name;

  @override
  List<Object?> get props => [
        id,
        hashtagId,
        name,
      ];
}
