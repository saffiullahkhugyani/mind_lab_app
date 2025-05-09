import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/entities/student.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/project_list/presentation/widgets/text_box.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/register_player_bloc/register_player_bloc.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class PlayerRegistrationPage extends StatefulWidget {
  const PlayerRegistrationPage({super.key});

  @override
  State<PlayerRegistrationPage> createState() => _PlayerRegistrationPageState();
}

class _PlayerRegistrationPageState extends State<PlayerRegistrationPage> {
  final playerId = TextEditingController();
  final playerCity = TextEditingController();
  final playerCountry = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? selectedCountry;
  String? selectedCity;

  String generateShortUUID(String id) {
    var uuid = id; // Generate a standard UUID
    var bytes = utf8.encode(uuid); // Convert it to bytes
    var hash = sha256.convert(bytes); // Create a SHA-256 hash
    return hash.toString().substring(0, 5); // Return the first 8 characters
  }

  void registerUser(String studentId, String playerId) {
    if (selectedCountry != null && selectedCity != null) {
      context.read<RegisterPlayerBloc>().add(RegisterPlayer(
            studentId: studentId,
            playerId: playerId,
            city: selectedCity!,
            country: selectedCountry!,
          ));
    } else {
      String errorMessage = "Please select";
      if (selectedCountry == null) errorMessage += " a country";
      if (selectedCity == null) errorMessage += " a city";
      showFlashBar(context, errorMessage.trim(), FlashBarAction.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetailEntity =
        ModalRoute.of(context)!.settings.arguments as StudentEntity;

    final playerId = userDetailEntity.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Player Registration Page"),
      ),
      body: BlocConsumer<RegisterPlayerBloc, RegisterPlayerState>(
        listener: (context, state) {
          if (state is RegisterPlayerFailure) {
            showFlashBar(context, state.error, FlashBarAction.error);
          }

          if (state is RegisterPlayerSuccess) {
            showFlashBar(context, "You are registered for the event",
                FlashBarAction.success);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is RegisterPlayerLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyTextbox(text: playerId, sectionName: 'Player Id'),
                  const SizedBox(
                    height: 30,
                  ),
                  CSCPickerPlus(
                    layout: Layout.vertical,
                    flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                    showCities: false,
                    stateSearchPlaceholder: "City",
                    stateDropdownLabel: "City",
                    onCountryChanged: (country) {
                      setState(() {
                        selectedCountry = country;
                      });
                    },
                    onStateChanged: (state) {
                      setState(() {
                        selectedCity = state;
                      });
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        registerUser(
                          userDetailEntity.id,
                          playerId,
                        );
                      },
                      child: const Text("Register"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
