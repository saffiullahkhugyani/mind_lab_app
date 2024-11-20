import 'package:mind_lab_app/features/user_detail/domain/entities/player_rank_entity.dart';

class PlayerRankModel extends PlayerRankEntity {
  PlayerRankModel({
    required super.playerId,
    required super.typeOfRace,
    required super.countryRank,
    required super.cityRank,
    required super.worldRank,
    required super.topSpeed,
    required super.lastUpdated,
    required super.numOfRaces,
    required super.bestReactionTime,
  });

  PlayerRankModel copyWith({
    String? playerId,
    String? typeOfRace,
    int? countryRank,
    int? cityRank,
    int? worldRank,
    double? topSpeed,
    String? lastUpdated,
    int? numOfRaces,
    double? bestReactionTime,
  }) {
    return PlayerRankModel(
      playerId: playerId ?? this.playerId,
      typeOfRace: typeOfRace ?? this.typeOfRace,
      countryRank: countryRank ?? this.countryRank,
      cityRank: cityRank ?? this.cityRank,
      worldRank: worldRank ?? this.worldRank,
      topSpeed: topSpeed ?? this.topSpeed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      numOfRaces: numOfRaces ?? this.numOfRaces,
      bestReactionTime: bestReactionTime ?? this.bestReactionTime,
    );
  }

  factory PlayerRankModel.fromJson(Map<String, dynamic> json) {
    return PlayerRankModel(
      playerId: json['player_id'],
      typeOfRace: json['race_type'],
      countryRank: json['country_rank'],
      cityRank: json["city_rank"],
      worldRank: json["world_rank"],
      topSpeed: (json['top_speed'] as num).toDouble(),
      lastUpdated: json['last_updated'],
      numOfRaces: json['num_races'],
      bestReactionTime: json['best_reaction_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "player_id": playerId,
      "type_of_race": typeOfRace,
      "country_rank": countryRank,
      "city_rank": cityRank,
      "world_rank": worldRank,
      "top_speed": topSpeed,
      "last_updated": lastUpdated,
      "num_races": numOfRaces,
      "best_reaction_time": bestReactionTime,
    };
  }
}
