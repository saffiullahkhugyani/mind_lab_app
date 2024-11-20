class PlayerRankEntity {
  final String playerId;
  final String typeOfRace;
  final int countryRank;
  final int cityRank;
  final int worldRank;
  final double topSpeed;
  final String lastUpdated;
  final int numOfRaces;
  final double bestReactionTime;

  PlayerRankEntity({
    required this.playerId,
    required this.typeOfRace,
    required this.countryRank,
    required this.cityRank,
    required this.worldRank,
    required this.topSpeed,
    required this.lastUpdated,
    required this.numOfRaces,
    required this.bestReactionTime,
  });
}
