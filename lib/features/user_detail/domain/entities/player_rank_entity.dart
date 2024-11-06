class PlayerRankEntity {
  final String playerId;
  final String typeOfRace;
  final String country;
  final String city;
  final double raceTime;
  final double reactionTime;
  final double lapTime;

  PlayerRankEntity({
    required this.playerId,
    required this.typeOfRace,
    required this.country,
    required this.city,
    required this.raceTime,
    required this.reactionTime,
    required this.lapTime,
  });
}
