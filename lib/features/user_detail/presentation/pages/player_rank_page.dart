import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/project_list/presentation/widgets/text_box.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/player_rank_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/user_detail_entity.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/player_rank_bloc/player_rank_bloc.dart';
import 'package:crypto/crypto.dart';

class PlayerRankPage extends StatefulWidget {
  const PlayerRankPage({super.key});

  @override
  State<PlayerRankPage> createState() => _PlayerRankPageState();
}

class _PlayerRankPageState extends State<PlayerRankPage> {
  String? selectedRaceType; // Variable to hold the selected race type
  List<String> raceTypes = []; // List to hold race types
  List<PlayerRankEntity> listOfRaceData = []; // to hold in coming data

  double bestRaceTime = 0.0;
  int countryRank = 0;
  int cityRank = 0;
  int totalRaceCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<PlayerRankBloc>().add(FetchPlayarRankDetails());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getPlayerRanking(List<PlayerRankEntity> playerRankModelList,
      String currentPlayerId, String raceType) {
    // Step 1: Filter the data to get the specific player
    List<PlayerRankEntity> playerDataForCurrentPlayer = playerRankModelList
        .where((player) => player.playerId.trim() == currentPlayerId.trim())
        .toList();

    // Step 2: Filter the data by selected race type (e.g., "Plane")
    List<PlayerRankEntity> filteredPlayerData = playerDataForCurrentPlayer
        .where((player) => player.typeOfRace == selectedRaceType)
        .toList();

    // Step 3: Find the best (lowest) race time for the selected race type
    bestRaceTime = 0.0;

    for (var race in filteredPlayerData) {
      if (bestRaceTime == 0 || race.raceTime < bestRaceTime) {
        bestRaceTime = race.raceTime;
      }
    }

    // Output the best race time for the current player in the selected race type
    log("Best race time for player $currentPlayerId in $selectedRaceType: $bestRaceTime");

    // step 3-2 calclate the total num of races for the selected race type for the player
    totalRaceCount = filteredPlayerData.length;

    // Step 4: Filter all players by the selected race type and their country
    List<PlayerRankEntity> filteredByCountryAndRace = playerRankModelList
        .where((player) => player.typeOfRace == selectedRaceType)
        .toList();

    // Step 5: Create a map to store the best race times for each player in the same country and race type
    Map<String, double> bestRaceTimesForCountry = {};

    for (var player in filteredByCountryAndRace) {
      if (!bestRaceTimesForCountry.containsKey(player.playerId) ||
          player.raceTime < bestRaceTimesForCountry[player.playerId]!) {
        bestRaceTimesForCountry[player.playerId] = player.raceTime;
      }
    }

    // Step 6: Sort players by their best race time (ascending)
    var sortedByBestTime = bestRaceTimesForCountry.entries.toList()
      ..sort((a, b) => a.value
          .compareTo(b.value)); // Sorting by race time in ascending order

    // Step 7: Find the rank of the current player in their country (ranked by race time)
    countryRank = 0;
    for (int i = 0; i < sortedByBestTime.length; i++) {
      if (sortedByBestTime[i].key.trim() == currentPlayerId.trim()) {
        countryRank = i + 1; // 1-based ranking
        break;
      }
    }
    log("Country rank for player $currentPlayerId: $countryRank");

    // Step 8: Filter players by city and race type
    List<PlayerRankEntity> filteredByCityAndRace = playerRankModelList
        .where((player) =>
            player.typeOfRace == selectedRaceType &&
            player.city == playerDataForCurrentPlayer.first.city)
        .toList();

    // Step 9: Create a map to store the best race times for each player in the same city and race type
    Map<String, double> bestRaceTimesForCity = {};

    for (var player in filteredByCityAndRace) {
      if (!bestRaceTimesForCity.containsKey(player.playerId) ||
          player.raceTime < bestRaceTimesForCity[player.playerId]!) {
        bestRaceTimesForCity[player.playerId] = player.raceTime;
      }
    }

    // Step 10: Sort players by their best race time (ascending)
    var sortedByBestTimeCity = bestRaceTimesForCity.entries.toList()
      ..sort((a, b) => a.value
          .compareTo(b.value)); // Sorting by race time in ascending order

    // Step 11: Find the rank of the current player in their city (ranked by race time)
    cityRank = 0;
    for (int i = 0; i < sortedByBestTimeCity.length; i++) {
      if (sortedByBestTimeCity[i].key.trim() == currentPlayerId.trim()) {
        cityRank = i + 1; // 1-based ranking
        break;
      }
    }

    log("City rank for player $currentPlayerId: $cityRank");
  }

  // to get the player Id
  String generateShortUUID(String id) {
    var uuid = id; // Generate a standard UUID
    var bytes = utf8.encode(uuid); // Convert it to bytes
    var hash = sha256.convert(bytes); // Create a SHA-256 hash
    return hash.toString().substring(0, 5); // Return the first 8 characters
  }

  @override
  Widget build(BuildContext context) {
    final argsUserDetails =
        ModalRoute.of(context)!.settings.arguments as UserDetailEntity;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Ranking"),
        ),
        body: BlocConsumer<PlayerRankBloc, PlayerRankState>(
            listener: (context, state) {
          if (state is PlayerRankFailure) {
            showFlashBar(context, state.error, FlashBarAction.error);
          }
          if (state is PlayerRankSuccess) {
            if (state.playerRankDetialList.isNotEmpty) {
              listOfRaceData = state.playerRankDetialList;
            }
            showFlashBar(context, "Details fetched", FlashBarAction.success);
            // Populate the race types from the fetched data
            setState(() {
              raceTypes = state.playerRankDetialList
                  .map((player) => player.typeOfRace)
                  .toSet() // Use a Set to avoid duplicates
                  .toList();

              // Optionally set the initial selected race type
              selectedRaceType = raceTypes.isNotEmpty ? raceTypes[0] : null;

              // Automatically call the ranking function with the first race type
              if (selectedRaceType != null) {
                getPlayerRanking(listOfRaceData,
                    generateShortUUID(argsUserDetails.id), selectedRaceType!);
              }
            });
          }
        }, builder: (context, state) {
          if (state is PlayerRankLoading) {
            return const Loader();
          }

          return ListView(
            padding: EdgeInsets.only(bottom: 10),
            children: [
              //profile picture

              const SizedBox(height: 50),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    argsUserDetails.imageUrl.isNotEmpty
                        ? Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(argsUserDetails.imageUrl),
                            ),
                          )
                        : Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(
                                      'lib/assets/images/no-user-image.png')),
                            ),
                          ),
                  ],
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
                argsUserDetails.name,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Ranking Details',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Dropdown for selecting the type of race
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10),
                    child: DropdownButtonFormField<String>(
                      value: selectedRaceType,
                      isExpanded: true,
                      hint: Text("Select Race Type"),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRaceType = newValue;
                        });

                        // calling function to rank the races
                        getPlayerRanking(
                            listOfRaceData,
                            generateShortUUID(argsUserDetails.id),
                            selectedRaceType!);
                      },
                      items: raceTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  MyTextbox(
                      text: generateShortUUID(argsUserDetails.id),
                      sectionName: 'Player Id:'),
                  MyTextbox(
                      text: argsUserDetails.age, sectionName: 'Age Group:'),
                  MyTextbox(
                      text: countryRank.toString(),
                      sectionName: 'Country Rank:'),
                  MyTextbox(
                      text: cityRank.toString(), sectionName: 'City Rank:'),
                  MyTextbox(
                      text: bestRaceTime.toString(), sectionName: 'Best Time:'),
                  MyTextbox(
                      text: "To be finalized", sectionName: 'Top Speed :'),
                  MyTextbox(
                      text: totalRaceCount.toString(),
                      sectionName: 'Number of Races:'),
                ],
              ),
            ],
          );
        }));
  }
}
