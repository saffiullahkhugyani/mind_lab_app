import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  List<PlayerRankEntity> filteredRaceData = []; // Filtered list to display

  @override
  void initState() {
    super.initState();
    context.read<PlayerRankBloc>().add(FetchPlayarRankDetails());
  }

  // Function to filter the race data based on selected race type
  void filterRaceData() {
    setState(() {
      filteredRaceData = listOfRaceData
          .where((player) => player.typeOfRace == selectedRaceType)
          .toList();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String formatTimestamp(String timestamp) {
    // Parse the timestamp string to a DateTime object
    DateTime dateTime = DateTime.parse(timestamp);

    // Define the output format
    DateFormat outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    // Return the formatted date and time as a string
    return outputFormat.format(dateTime);
  }

  // converting m/s to km/h
  double convertMetersPerSecondToKilometersPerHour(
      double speedInMetersPerSecond) {
    double speedInKilometersPerHour = speedInMetersPerSecond * 3.6;
    return double.parse(speedInKilometersPerHour.toStringAsFixed(2));
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

            // Populate the race types
            setState(() {
              raceTypes = state.playerRankDetialList
                  .map((player) => player.typeOfRace)
                  .toSet() // Use a Set to avoid duplicates
                  .toList();

              // Optionally set the initial selected race type
              selectedRaceType = raceTypes.isNotEmpty ? raceTypes[0] : null;
              filterRaceData();
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
                          filterRaceData(); // filter out the race data
                        });

                        // calling function to rank the races
                        // getPlayerRanking(
                        //     listOfRaceData,
                        //     generateShortUUID(argsUserDetails.id),
                        //     selectedRaceType!);
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
                  filteredRaceData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyTextbox(
                                text: filteredRaceData.first.countryRank
                                    .toString(),
                                sectionName: 'Country Rank:'),
                            MyTextbox(
                                text:
                                    filteredRaceData.first.cityRank.toString(),
                                sectionName: 'City Rank:'),
                            MyTextbox(
                                text:
                                    filteredRaceData.first.worldRank.toString(),
                                sectionName: 'World Rank:'),
                            MyTextbox(
                                text:
                                    "${filteredRaceData.first.bestReactionTime} Sec",
                                sectionName: 'Best Response Time:'),
                            MyTextbox(
                                text:
                                    "${convertMetersPerSecondToKilometersPerHour(filteredRaceData.first.topSpeed)} Km/h",
                                sectionName: 'Top Speed:'),
                            MyTextbox(
                                text: filteredRaceData.first.numOfRaces
                                    .toString(),
                                sectionName: 'Number of Races :'),
                            MyTextbox(
                                text: formatTimestamp(
                                        filteredRaceData.first.lastUpdated)
                                    .toString(),
                                sectionName: 'Last Updated:'),
                          ],
                        )
                      : Text("No data available for the selected race type",
                          style: TextStyle(color: Colors.red)),
                ],
              ),
            ],
          );
        }));
  }
}
