import 'package:mind_lab_app/features/user_detail/domain/entities/player_rank_entity.dart';

class PlayerRankModel extends PlayerRankEntity {
  PlayerRankModel({
    required super.playerId,
    required super.typeOfRace,
    required super.country,
    required super.city,
    required super.raceTime,
    required super.reactionTime,
    required super.lapTime,
  });

  PlayerRankModel copyWith({
    String? playerId,
    String? typeOfRace,
    String? country,
    String? city,
    double? raceTime,
    double? reactionTime,
    double? lapTime,
  }) {
    return PlayerRankModel(
      playerId: playerId ?? this.playerId,
      typeOfRace: typeOfRace ?? this.typeOfRace,
      country: country ?? this.country,
      city: city ?? this.city,
      raceTime: raceTime ?? this.raceTime,
      reactionTime: reactionTime ?? this.reactionTime,
      lapTime: lapTime ?? this.lapTime,
    );
  }

  factory PlayerRankModel.fromJson(Map<String, dynamic> json) {
    return PlayerRankModel(
      playerId: json['player_id'],
      typeOfRace: json['type_of_race'],
      country: json['country'],
      city: json["city"],
      raceTime: (json['race_time'] as num).toDouble(),
      reactionTime: (json['reaction_time'] as num).toDouble(),
      lapTime: (json['lap_time'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "player_id": playerId,
      "type_of_race": typeOfRace,
      "country": country,
      "city": city,
      "race_time": raceTime,
      "reaction_time": reactionTime,
      "lap_time": lapTime,
    };
  }
}
